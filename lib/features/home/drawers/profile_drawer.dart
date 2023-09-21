import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///
    final user = ref.watch(userProvider)!;

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
            'u/${user.email}'.split('@')[0],
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
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {},
          ),
          Switch.adaptive(value: true, onChanged: (value) {}),
          const Spacer(),
        ],
      )),
    );
  }
}
