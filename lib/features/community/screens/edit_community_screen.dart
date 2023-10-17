import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/theme/pallette.dart';

class EditCommunity extends ConsumerStatefulWidget {
  final String communityName;
  const EditCommunity({required this.communityName, super.key});

  @override
  ConsumerState<EditCommunity> createState() => _EditCommunityState();
}

///
File? banerfile;
File? avatarfile;

class _EditCommunityState extends ConsumerState<EditCommunity> {
  ///
  ///
  void selectBannerImage(BuildContext context) async {
    final result = await pickImage();
    setState(() {
      banerfile = File(result!.files.first.path!);
    });
  }

  void selectAvatarImage(BuildContext context) async {
    final result = await pickImage();
    setState(() {
      avatarfile = File(result!.files.first.path!);
    });
  }

  void saveCommunity(CommunityModel community, BuildContext context) {
    ref.read(communityContollerProvider.notifier).editcommunity(
        profileFile: avatarfile,
        bannerFile: banerfile,
        community: community,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final _isLoading = ref.watch(communityContollerProvider);
    return ref.watch(getCommunityByNameProvider(widget.communityName)).when(
          data: (data) => Scaffold(
            appBar: AppBar(
              title: Text('Edit ${widget.communityName}'),
              actions: [
                TextButton(
                  child: const Text('Save'),
                  onPressed: () => saveCommunity(data, context),
                )
              ],
            ),
            body: _isLoading
                ? const Loader()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () => selectBannerImage(context),
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [8, 4],
                                  strokeCap: StrokeCap.round,
                                  color: Pallete.darkModeAppTheme.textTheme
                                      .bodyMedium!.color!,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: banerfile == null
                                          ? Image.network(data.bannerImage,
                                              fit: BoxFit.cover)
                                          : Image.file(
                                              banerfile!,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 20,
                                bottom: 5,
                                child: GestureDetector(
                                  onTap: () => selectAvatarImage(context),
                                  child: CircleAvatar(
                                    backgroundImage: (avatarfile == null)
                                        ? NetworkImage(data.avatar)
                                        : FileImage(avatarfile!)
                                            as ImageProvider,
                                    radius: 40,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          error: (error, stackTrace) => const Text('something went wrong'),
          loading: () => const Loader(),
        );
  }
}
