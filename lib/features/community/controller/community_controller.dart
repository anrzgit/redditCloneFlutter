import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/providers/storage_repo_provider.dart';
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
  final communityRepo = ref.watch(communityRepoProvider);
  final storageRepo = ref.watch(storageRepoProvider);
  return CommunityContoller(
      communityRepo: communityRepo, ref: ref, storageRepo: storageRepo);
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityContollerProvider.notifier)
      .getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityContollerProvider.notifier).searchCommunity(query);
});

class CommunityContoller extends StateNotifier<bool> {
  ///
  final CommunityRepo _communityRepo;
  final Ref _ref;
  final StorageRepo _storageRepo;

  CommunityContoller(
      {required CommunityRepo communityRepo,
      required Ref ref,
      required StorageRepo storageRepo})
      : _communityRepo = communityRepo,
        _ref = ref,
        _storageRepo = storageRepo,
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

  void editcommunity({
    required File? profileFile,
    required File? bannerFile,
    required CommunityModel community,
    required BuildContext context,
  }) async {
    //
    state = true;

    ///if profile file is not null then upload it
    if (profileFile != null) {
      final res = await _storageRepo.storeFile(
          path: 'communities/profile', id: community.name, file: profileFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(avatar: r));
    }
    //upload banner
    if (bannerFile != null) {
      final res = await _storageRepo.storeFile(
          path: 'communities/banner', id: community.name, file: bannerFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(bannerImage: r));
    }
    //if no file is uploaded then just update the community
    final res = await _communityRepo.editCommunity(community);

    ///
    state = false;

    ///
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community updated successfully');
      Navigator.of(context).pop();
    });
  }

  Stream<List<CommunityModel>> searchCommunity(String query) {
    return _communityRepo.searchCommunity(query);
  }
}
