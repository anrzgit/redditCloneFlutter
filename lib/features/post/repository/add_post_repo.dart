import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/type_def.dart';
import 'package:reddit_clone/models/comment_model.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';

final postRepoProvider = Provider((ref) {
  return PostRepo(firestore: ref.watch(fireStoreProvider));
});

class PostRepo {
  final FirebaseFirestore _firestore;
  PostRepo({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  FutureVoid addPosts(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<CommunityModel> community) {
    try {
      return _posts
          .where('communityName',
              whereIn: community.map((e) => e.name).toList())
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (event) => event.docs
                .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
                .toList(),
          );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      print(e.toString());
      return const Stream.empty();
    }
  }

  //for Guest user
  Stream<List<Post>> fetchGuestPosts() {
    try {
      return _posts
          .orderBy('createdAt', descending: true)
          .limit(10)
          .snapshots()
          .map(
            (event) => event.docs
                .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
                .toList(),
          );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      print(e.toString());
      return const Stream.empty();
    }
  }

  FutureVoid deletePost(Post post) async {
    try {
      ///
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      print(e.toString());
      return left(Failure(message: e.toString()));
    }
  }

  void upVote(Post post, String userId) async {
    try {
      ///
      if (post.downvotes.contains(userId)) {
        _posts.doc(post.id).update({
          'downvotes': FieldValue.arrayRemove([userId]),
        });
      }
      if (post.upvotes.contains(userId)) {
        _posts.doc(post.id).update({
          'upvotes': FieldValue.arrayRemove([userId]),
        });
      } else {
        _posts.doc(post.id).update({
          'upvotes': FieldValue.arrayUnion([userId]),
        });
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      print(e.toString());
    }
  }

  ///downvote
  void downVote(Post post, String userId) async {
    try {
      ///
      if (post.upvotes.contains(userId)) {
        _posts.doc(post.id).update({
          'upvotes': FieldValue.arrayRemove([userId]),
        });
      }

      if (post.downvotes.contains(userId)) {
        _posts.doc(post.id).update({
          'downvotes': FieldValue.arrayRemove([userId]),
        });
      } else {
        _posts.doc(post.id).update({
          'downvotes': FieldValue.arrayUnion([userId]),
        });
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<Post> getPostById(String postId) {
    return _posts
        .doc(postId)
        .snapshots()
        .map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());

      return right(_posts.doc(comment.postId).update({
        'commentCount': FieldValue.increment(1),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<List<Comment>> getCommentsOfPost(String postId) {
    try {
      return _comments
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (event) => event.docs
                .map(
                  (e) => Comment.fromMap(
                    e.data() as Map<String, dynamic>,
                  ),
                )
                .toList(),
          );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      print(e.toString());
      return const Stream.empty();
    }
  }
}
