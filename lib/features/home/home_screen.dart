import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_clone/features/home/drawers/community_list_drawer.dart';
import 'package:reddit_clone/features/home/drawers/profile_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    // print('user in home screen: $user');
    return Scaffold(
      appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => displayDrawer(context),
            ),
          ),
          title: const Text('Home'),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: SearchCommunityDelegate(ref: ref));
              },
              icon: const Icon(Icons.search),
            ),
            Builder(
              builder: (context) => IconButton(
                onPressed: () => displayEndDrawer(context),
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(
                      user.profilePic ?? 'https://i.imgur.com/BoN9kdC.png'),
                ),
              ),
            )
          ]),
      body: Center(
        child: Text(user.email ?? 'no email'),
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
    );
  }
}
