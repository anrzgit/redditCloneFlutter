import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

class CreateCommunityWidget extends ConsumerStatefulWidget {
  const CreateCommunityWidget({super.key});

  @override
  ConsumerState<CreateCommunityWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<CreateCommunityWidget> {
  ///
  ///
  final communityNameController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref
        .read(communityContollerProvider.notifier)
        .createCommunity(communityNameController.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityContollerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Community'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text('Community Name :'),
            ),
            const SizedBox(height: 10.0),
            TextField(
              maxLength: 21,
              controller: communityNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'r/yourCommunityName',
              ),
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () => createCommunity(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                minimumSize: MaterialStateProperty.all(
                  const Size(double.infinity, 50.0),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              child:
                  isLoading ? const Loader() : const Text('Create Community'),
            )
          ],
        ),
      ),
    );
  }
}
