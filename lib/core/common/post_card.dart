import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/theme/pallette.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider);

    void deletePost(WidgetRef ref, BuildContext context) async {
      ref.read(postContollerProvider.notifier).deletePost(post, context);
    }

    ///
    void upVotePost(WidgetRef ref) async {
      ref.read(postContollerProvider.notifier).upVote(post);
    }

    ///
    void downVotePost(WidgetRef ref) async {
      ref.read(postContollerProvider.notifier).downVote(post);
    }

    void navigateToUser(BuildContext context) {
      Routemaster.of(context).push('/u/${post.uid}');
    }

    void navigateToCommunity(BuildContext context) {
      Routemaster.of(context).push('/r/${post.communityName}');
    }

    void navigateToComments(BuildContext context) {
      Routemaster.of(context).push('/post/${post.id}/comments');
    }

    ///
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(vertical: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 4, horizontal: 6)
                              .copyWith(right: 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => navigateToCommunity(context),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(post.communityProfilePic),
                                  radius: 16,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'r/${post.communityName}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () => navigateToUser(context),
                                      child: Text(
                                        'u/${post.username}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              if (post.uid == user!.uid)
                                IconButton(
                                  onPressed: () => deletePost(ref, context),
                                  icon: Icon(
                                    Icons.delete,
                                    color: Pallete.redColor,
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        post.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (isTypeImage)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: Image.network(
                          post.link!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (isTypeLink)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: AnyLinkPreview(
                            bodyTextOverflow: TextOverflow.ellipsis,
                            displayDirection: UIDirection.uiDirectionVertical,
                            link: post.link!),
                      ),
                    if (isTypeText)
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          post.description!,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    Row(
                      children: [
                        SizedBox(
                          //Uovotes Box
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => upVotePost(ref),
                                icon: Icon(
                                  Constants.up,
                                  size: 30,
                                  color: post.upvotes.contains(user.uid)
                                      ? Colors.red
                                      : null,
                                ),
                              ),
                              Text(
                                '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                onPressed: () => downVotePost(ref),
                                icon: Icon(
                                  Constants.down,
                                  size: 30,
                                  color: post.downvotes.contains(user.uid)
                                      ? Colors.blue
                                      : null,
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => navigateToComments(context),
                          child: SizedBox(
                            //comment sizedBox
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => navigateToComments(context),
                                  icon: const Icon(Icons.comment),
                                ),
                                Text(
                                  '${post.commentCount - post.commentCount == 0 ? 'Comment' : post.commentCount - post.commentCount}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ref
                            .watch(
                                getCommunityByNameProvider(post.communityName))
                            .when(
                          data: (data) {
                            if (data.moderators.contains(user.uid)) {
                              return SizedBox(
                                //Mods sizedBox
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.admin_panel_settings_outlined),
                                    ),
                                    const Text(
                                      'Admin',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                          loading: () {
                            return const CircularProgressIndicator();
                          },
                          error: (e, s) {
                            return const Text('Error');
                          },
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
