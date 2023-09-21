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
              leading: Icon(Icons.add_moderator_outlined),
              title: Text('Add Moderators'),
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
