//logged Out routes
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screen/login_screen.dart';
import 'package:reddit_clone/features/community/screens/add_mods_screen.dart';
import 'package:reddit_clone/features/community/screens/community_screen.dart';
import 'package:reddit_clone/features/community/screens/create_community_screen.dart';
import 'package:reddit_clone/features/community/screens/edit_community_screen.dart';
import 'package:reddit_clone/features/community/screens/mod_tools_screen.dart';
import 'package:reddit_clone/features/home/home_screen.dart';
import 'package:reddit_clone/features/post/screen/add_post_type_screen.dart';
import 'package:reddit_clone/features/post/screen/comments_screen.dart';
import 'package:reddit_clone/features/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit_clone/features/user_profile/screens/user_profile.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoutes = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
  },
);

//logged In routes
final loggedInRoutes = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create/community': (_) =>
        const MaterialPage(child: CreateCommunityWidget()),
    '/r/:communityName': (route) => MaterialPage(
          child: CommunityScreen(
              //route parameters
              communityName: route.pathParameters['communityName']!),
        ),
    '/mod/tools/:communityName': (route) => MaterialPage(
          child: ModToolsScreen(
              communityName: route.pathParameters['communityName']!),
        ),
    '/mod/tools/:communityName/edit': (route) => MaterialPage(
          child: EditCommunity(
              communityName: route.pathParameters['communityName']!),
        ),
    '/mod/tools/:communityName/addMods': (route) => MaterialPage(
          child: AddModsScreen(
              communityName: route.pathParameters['communityName']!),
        ),
    '/u/:uid': (route) => MaterialPage(
          child: UserProfile(uid: route.pathParameters['uid']!),
        ),
    '/u/edit/profile/:uid': (route) => MaterialPage(
          child: EditProfile(uid: route.pathParameters['uid']!),
        ),
    '/add/post/:type': (route) => MaterialPage(
          child: AddPostTypeScreen(type: route.pathParameters['type']!),
        ),
    '/post/:postId/comments': (route) => MaterialPage(
        child: CommentsScreen(postId: route.pathParameters['postId']!))
  },
);
