import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/type_def.dart';
import 'package:reddit_clone/models/post_model.dart';

final postRepoProvider = Provider((ref) {
  return PostRepo(firestore: ref.watch(fireStoreProvider));
});

class PostRepo {
  final FirebaseFirestore _firestore;
  PostRepo({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPosts(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
