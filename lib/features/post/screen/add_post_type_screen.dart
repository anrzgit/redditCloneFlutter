import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/models/community_model.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<AddPostTypeScreen> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  ///
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  File? profileFile;
  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;
  List<CommunityModel> communities = [];
  CommunityModel? selectedCommunity;

  ///
  final kIsWeb = false;

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titleController.text.isNotEmpty) {
      ref.read(postContollerProvider.notifier).shareImagePost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          file: bannerFile!);
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postContollerProvider.notifier).sharePostText(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          description: descriptionController.text.trim());
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postContollerProvider.notifier).shareLinkPost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          link: linkController.text.trim());
    } else {
      showSnackBar(context, 'Please fill all the fields');
    }
  }

  ///
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    ///
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final isLoading = ref.watch(postContollerProvider);

    ///
    return Scaffold(
      appBar: AppBar(
        title: Text('Post your ${widget.type}'),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text('Post'),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Enter a title',
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(18),
                    ),
                    maxLength: 30,
                  ),
                  const SizedBox(height: 18),
                  if (isTypeImage)
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: bannerWebFile != null
                              ? Image.memory(bannerWebFile!)
                              : bannerFile != null
                                  ? Image.file(bannerFile!)
                                  : const Center(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 40,
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  if (isTypeText)
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter description here',
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(18),
                      ),
                      maxLines: 6,
                    ),
                  if (isTypeLink)
                    TextField(
                      controller: linkController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter link here',
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(18),
                      ),
                    ),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Select Community'),
                  ),
                  ref.watch(userCommunitiesProvider).when(
                        data: (data) {
                          communities = data;
                          if (data.isEmpty) {
                            return const SizedBox();
                          }
                          return DropdownButton(
                              value: selectedCommunity ?? data[0],
                              items: data
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedCommunity = val;
                                });
                              });
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      )
                ],
              ),
            ),
    );
  }
}
