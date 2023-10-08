import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push("/add/post/$type");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///
    double cardWidth = MediaQuery.of(context).size.width / 3.2;

    ///
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => navigateToType(context, 'image'),
              child: SizedBox(
                height: cardWidth,
                width: cardWidth,
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  elevation: 16,
                  child: Center(
                      child: Icon(Icons.image_outlined,
                          size: 100, color: Colors.grey[400])),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => navigateToType(context, 'text'),
              child: SizedBox(
                height: cardWidth,
                width: cardWidth,
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  elevation: 16,
                  child: Center(
                      child: Icon(Icons.font_download_off_outlined,
                          size: 100, color: Colors.grey[400])),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => navigateToType(context, 'link'),
              child: SizedBox(
                height: cardWidth,
                width: cardWidth,
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  elevation: 16,
                  child: Center(
                      child: Icon(Icons.link_outlined,
                          size: 100, color: Colors.grey[400])),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
