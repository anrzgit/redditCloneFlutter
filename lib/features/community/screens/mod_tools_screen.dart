import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  final String communityName;
  const ModToolsScreen({required this.communityName, super.key});

  @override
  Widget build(BuildContext context) {
    ///
    void navigateToEditCommunityScreen(BuildContext context) {
      Routemaster.of(context).push('/mod/tools/$communityName/edit');
    }

    void navigateToAddModsScreen(BuildContext context) {
      Routemaster.of(context).push('/mod/tools/$communityName/addMods');
    }

    ///
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mod Tools'),
        ),
        body: Column(
          children: [
            ListTile(
              title: Text(communityName),
            ),
            ListTile(
              leading: const Icon(Icons.add_moderator_outlined),
              title: const Text('Add Moderators'),
              onTap: () => navigateToAddModsScreen(context),
            ),
            ListTile(
              leading: const Icon(Icons.add_moderator_outlined),
              title: const Text('Edit Comminity'),
              onTap: () => navigateToEditCommunityScreen(context),
            ),
          ],
        ));
  }
}
