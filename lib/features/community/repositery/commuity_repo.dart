import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/type_def.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';

///
final communityRepoProvider =
    Provider((ref) => CommunityRepo(firestore: ref.watch(fireStoreProvider)));

class CommunityRepo {
  final FirebaseFirestore _firestore;

  CommunityRepo({required FirebaseFirestore firestore})
      : _firestore = firestore;

  ///
  Future<Either<Failure, dynamic>> createCommunity(
      CommunityModel community) async {
    try {
      ///check if community already exists
      var communityDoc = await _communityCollection.doc(community.name).get();
      if (communityDoc.exists) {
        return left(Failure(message: 'Community already exists'));
      }
      //create community
      return right(
          _communityCollection.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  //to get all communities
  Stream<List<CommunityModel>> getUserCommunities(String uid) {
    return _communityCollection
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<CommunityModel> communityList = [];
      for (var doc in event.docs) {
        communityList
            .add(CommunityModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return communityList;
    });
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communityCollection.doc(name).snapshots().map((event) =>
        CommunityModel.fromMap(event.data() as Map<String, dynamic>));
  }

  ///
  FutureVoid editCommunity(CommunityModel community) async {
    try {
      return right(
          _communityCollection.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<List<CommunityModel>> searchCommunity(String query) {
    return _communityCollection
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<CommunityModel> communities = [];
      for (var community in event.docs) {
        communities.add(
            CommunityModel.fromMap(community.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  FutureVoid joinCommunity(String communityName, String userId) async {
    try {
      return right(_communityCollection.doc(communityName).update({
        'members': FieldValue.arrayUnion([userId]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String userId) async {
    try {
      return right(_communityCollection.doc(communityName).update({
        'members': FieldValue.arrayRemove([userId]),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureVoid addMods(String communityName, List<String> uids) async {
    try {
      return right(_communityCollection.doc(communityName).update({
        'moderators': uids,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  ///
  Stream<List<Post>> getCommunityPosts(String name) {
    return _posts
        .where('communityName', isEqualTo: name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => Post.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  ///

  CollectionReference get _communityCollection =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
}
