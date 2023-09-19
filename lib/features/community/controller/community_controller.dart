import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repositery/commuity_repo.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/core/utils.dart';

///
final userCommunitiesProvider = StreamProvider((ref) {
  final communityContoller = ref.watch(communityContollerProvider.notifier);
  return communityContoller.getUserCommunities();
});

///
final communityContollerProvider =
    StateNotifierProvider<CommunityContoller, bool>((ref) {
  final communityRepo = ref.watch(CommunityRepoProvider);
  return CommunityContoller(communityRepo: communityRepo, ref: ref);
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityContollerProvider.notifier)
      .getCommunityByName(name);
});

class CommunityContoller extends StateNotifier<bool> {
  final CommunityRepo _communityRepo;
  final Ref _ref;
  CommunityContoller({required CommunityRepo communityRepo, required Ref ref})
      : _communityRepo = communityRepo,
        _ref = ref,
        //initially loading is false
        super(false);

  ///
  void createCommunity(String communityName, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)!.uid;
    CommunityModel community = CommunityModel(
      id: communityName,
      name: communityName,
      bannerImage: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      description: '',
      moderators: [uid!],
      members: [uid],
    );
    final result = await _communityRepo.createCommunity(community);

    ///if community is created successfully then pop the dialog
    state = false;
    result.fold(
      (failure) => showSnackBar(context, failure.message),
      (success) {
        Navigator.of(context).pop();
        return showSnackBar(context, '$communityName created successfully !');
      },
    );
  }

  Stream<List<CommunityModel>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepo.getUserCommunities(uid!);
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communityRepo.getCommunityByName(name);
  }
}
