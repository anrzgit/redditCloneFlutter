import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/test/pay.dart';
import 'package:reddit_clone/theme/pallette.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///
    final user = ref.watch(userProvider)!;

    void navigateToUserProfile(BuildContext context, UserModel user) {
      Routemaster.of(context).push('u/${user.uid}');
    }

    void toggleTheme(WidgetRef ref) {
      print(2222222);
      ref.read(themeNotifierProvider.notifier).toggleTheme();
    }

    void signOut(WidgetRef ref) {
      print("sign out");
      ref.read(authContollerProvider.notifier).logout();
    }

    ///
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              backgroundImage: NetworkImage(
                user.profilePic ?? 'https://i.imgur.com/BoN9kdC.png',
              ),
              radius: 70,
            ),
            const SizedBox(height: 10),
            Text(
              'u/${user.name}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              height: 30,
            ),
            const Spacer(
              flex: 2,
            ),
            ListTile(
              leading: const Icon(Icons.person_2_outlined),
              title: const Text('My Profile'),
              onTap: () => navigateToUserProfile(context, user),
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined, color: Colors.red),
              title: const Text('Logout'),
              onTap: () => signOut(ref),
            ),
            Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).mode ==
                  ThemeMode.dark,
              onChanged: (value) => toggleTheme(ref),
            ),
            ListTile(
              leading: const Icon(Icons.payments_outlined),
              title: const Text('Navigate To Pay'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PayScreeen(),
                  ),
                );
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
