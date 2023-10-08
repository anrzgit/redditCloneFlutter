import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/providers/storage_repo_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/post/repository/add_post_repo.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

///
///
final postContollerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepo = ref.watch(postRepoProvider);
  final storageRepo = ref.watch(storageRepoProvider);
  return PostController(postRepo: postRepo, ref: ref, storageRepo: storageRepo);
});

///
class PostController extends StateNotifier<bool> {
  ///
  final PostRepo _postRepo;
  final Ref _ref;
  final StorageRepo _storageRepo;

  PostController(
      {required PostRepo postRepo,
      required Ref ref,
      required StorageRepo storageRepo})
      : _postRepo = postRepo,
        _ref = ref,
        _storageRepo = storageRepo,
        //initially loading is false
        super(false);

  ///
  ///
  void sharePostText({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required String description,
  }) async {
    state = true;
    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name!,
      uid: user.uid!,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );
    //add post to firestore
    final res = await _postRepo.addPosts(post);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Post added');
        print('post added');
        Navigator.pop(context);
      },
    );
  }

  ///Link
  void shareLinkPost({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name!,
      uid: user.uid!,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final res = await _postRepo.addPosts(post);

    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted successfully!');
      Routemaster.of(context).pop();
    });
  }

  ///IMAGE
  void shareImagePost({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required File? file,
  }) async {
    state = true;
    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;
    final imageResult = await _storageRepo.storeFile(
        path: 'posts/${selectedCommunity.name}', id: postId, file: file!);

    imageResult.fold((l) => showSnackBar(context, l.message), (r) async {
      //r is the url of the image
      final Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name!,
        uid: user.uid!,
        type: 'text',
        createdAt: DateTime.now(),
        awards: [],
        link: r,
      );
      //add image to firestore
      final res = await _postRepo.addPosts(post);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Post added');
        print('Image added');
        Navigator.pop(context);
      });
    });
  }
}
