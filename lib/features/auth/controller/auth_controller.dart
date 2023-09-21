import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repositery/auth_repo.dart';
import 'package:reddit_clone/models/user_model.dart';

///
///
//using provider to enable cashing
//so that we don't have to sign in again and again for every screen
//state provider is used instead of provider beacuse we want to change the value of user
final userProvider = StateProvider<UserModel?>((ref) => null);

final authContollerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepo: ref.watch(authRepoProvider),
    ref: ref,
  ),
);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authController = ref.watch(authContollerProvider.notifier);
  return authController.authStateChanges;
});

///
final getUserDataProvider =
    StreamProvider.family<UserModel?, String>((ref, String uid) {
  final authController = ref.watch(authContollerProvider.notifier);
  return authController.getUserData(uid);
});

///

class AuthController extends StateNotifier<bool> {
  final AuthRepo _authRepo;
  final Ref _ref;
  AuthController({required AuthRepo authRepo, required Ref ref})
      : _authRepo = authRepo,
        _ref = ref,
        super(false);

  ///
  Stream<User?> get authStateChanges => _authRepo.authStateChanges;

  ///
  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepo.signInWithGoogle();
    state = false;
    user.fold((l) {
      ///failure
      showSnackBar(context, l.message);
    }, (userModel) {
      ///success
      _ref.read(userProvider.notifier).update((state) => userModel);
    });
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepo.getUserData(uid);
  }

  void logout() {
    _authRepo.logout();
  }

  ///
}
