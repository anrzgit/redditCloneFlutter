import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/models/community_model.dart';

final CommunityRepoProvider =
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

  CollectionReference get _communityCollection =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
