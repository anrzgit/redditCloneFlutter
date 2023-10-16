import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/post_card.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/features/post/widget/comment_card.dart';
import 'package:reddit_clone/models/post_model.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postContollerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (data) {
              return SafeArea(
                child: Stack(
                  children: [
                    NestedScrollView(
                      floatHeaderSlivers: true,
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            title: const Text('Comments'),
                            floating: true,
                            expandedHeight: 490,
                            forceElevated: innerBoxIsScrolled,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: PostCard(
                                  post: data,
                                  key: GlobalKey(),
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                      body: ref
                          .watch(getPostCommentsProvider(widget.postId))
                          .when(
                            data: (data) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final comment = data[index];
                                    return CommentCard(comment: comment);
                                  },
                                ),
                              );
                            },
                            error: (error, stackTrace) {
                              return ErrorText(
                                error: error.toString(),
                              );
                            },
                            loading: () => const Loader(),
                          ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black,
                        child: TextField(
                          onSubmitted: (val) => addComment(data),
                          controller: commentController,
                          decoration: const InputDecoration(
                            hintText: 'What are your thoughts?',
                            filled: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
