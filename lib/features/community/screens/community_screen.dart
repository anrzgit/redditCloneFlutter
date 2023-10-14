import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/post_card.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String communityName;
  const CommunityScreen({super.key, required this.communityName});

  ///
  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod/tools/$communityName');
  }

  void joinCommunity(
      BuildContext context, WidgetRef ref, CommunityModel community) {
    ref
        .read(communityContollerProvider.notifier)
        .joinCommunity(community, context);
  }

  ///

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(communityName)).when(
            data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    pinned: true,
                    title: Text('r/${community.name}'),
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            community.bannerImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Text(community.description),
                          Align(
                            alignment: Alignment.topLeft,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                community.avatar,
                              ),
                              radius: 30,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${community.members.length} members'),
                              community.moderators.contains(user!.uid)
                                  ? OutlinedButton(
                                      onPressed: () =>
                                          navigateToModTools(context),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      child: const Text('Mod Tools'),
                                    )
                                  : OutlinedButton(
                                      onPressed: () => joinCommunity(
                                          context, ref, community),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                          community.members.contains(user.uid)
                                              ? 'Joined'
                                              : 'Join'),
                                    )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: ref.watch(getCommunityPostsProvider(communityName)).when(
                    data: (posts) {
                      return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = posts[index];
                          return PostCard(post: post);
                        },
                      );
                    },
                    loading: () => const Loader(),
                    error: (error, stackTrace) {
                      print(error.toString());
                      return ErrorText(error: error.toString());
                    },
                  ),
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
