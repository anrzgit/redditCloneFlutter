import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/type_def.dart';
import 'package:reddit_clone/models/user_model.dart';

///
///
final authRepoProvider = Provider(
  (ref) => AuthRepo(
    googleSignIn: ref.read(googleSignInProvider),
    firestore: ref.read(fireStoreProvider),
    firebaseAuth: ref.read(firebaseAuthProvider),
  ),
);

class AuthRepo {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepo(
      {required GoogleSignIn googleSignIn,
      required FirebaseFirestore firestore,
      required FirebaseAuth firebaseAuth})
      : _googleSignIn = googleSignIn,
        _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  ///
  // ignore: prefer_final_fields
  CollectionReference _users =
      FirebaseFirestore.instance.collection(FirebaseConstants.usersCollection);

  //if there is any change in auth state then it will return the user
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  ///
  //get data from firebase
  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) {
      // print(event.data() as Map<String, dynamic>);
      return UserModel.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  ///

  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      UserCredential userCredential;

      ///web
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        ///mobile
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        if (isFromLogin) {
          userCredential = await _firebaseAuth.signInWithCredential(credential);
        } else {
          userCredential =
              await _firebaseAuth.currentUser!.linkWithCredential(credential);
        }
      }

      ///
      UserModel userModel;

      ///check if user exists
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No Name',
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: [
            'awesomeAns',
            'gold',
            'platinum',
            'helpful',
            'plusone',
            'rocket',
            'thankyou',
            'til',
          ],
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      print(e.toString());
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither<UserModel> signInAsGuest() async {
    try {
      var userCredential = await _firebaseAuth.signInAnonymously();

      UserModel userModel = UserModel(
        name: 'Guest',
        profilePic: Constants.avatarDefault,
        banner: Constants.bannerDefault,
        uid: userCredential.user!.uid,
        isAuthenticated: false,
        karma: 0,
        awards: [],
      );

      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  void logout() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  ///
}
