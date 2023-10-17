import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String communityName;

  const AddModsScreen({super.key, required this.communityName});

  @override
  ConsumerState<AddModsScreen> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  ///
  Set<String> uids = {};
  int _counter = 0;

  void addUids(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUids(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods() {
    ref
        .watch(communityContollerProvider.notifier)
        .addMods(widget.communityName, uids.toList(), context);
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => saveMods(),
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.communityName)).when(
            data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (context, index) {
                //fix
                final currentMods = community.moderators;
                //
                final member = community.members[index]; //it will retur uid
                //get username from uid
                return ref.watch(getUserDataProvider(member)).when(
                      data: (user) {
                        if (community.moderators.contains(member) &&
                            _counter == 0) {
                          for (String mods in currentMods) {
                            uids.add(mods);
                          }
                          _counter++;
                        }
                        return CheckboxListTile(
                          value: uids.contains(member),
                          onChanged: (val) {
                            if (val!) {
                              addUids(user.uid!);
                            } else {
                              removeUids(user.uid!);
                            }
                          },
                          title: Text(user!.name!),
                        );
                      },
                      error: (error, stackTrace) =>
                          showSnackBar(context, error.toString()),
                      loading: () => const Loader(),
                    );
              },
            ),
            error: (error, stackTrace) =>
                showSnackBar(context, error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
