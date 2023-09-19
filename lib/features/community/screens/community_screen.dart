import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

class CommunityScreen extends ConsumerWidget {
  final String communityName;
  const CommunityScreen({super.key, required this.communityName});

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
                      padding: const EdgeInsets.all(8.0),
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
                                        onPressed: () {},
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
                                        onPressed: () {},
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
                body: const Text('data'),
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}