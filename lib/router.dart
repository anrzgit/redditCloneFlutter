//logged Out routes
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screen/login_screen.dart';
import 'package:reddit_clone/features/community/screens/community_screen.dart';
import 'package:reddit_clone/features/community/screens/create_community_screen.dart';
import 'package:reddit_clone/features/home/home_screen.dart';
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
            communityName: route.pathParameters['communityName']!,
          ),
        ),
  },
);