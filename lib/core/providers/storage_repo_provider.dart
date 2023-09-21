import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/type_def.dart';

/// StorageRepo is a class that handles all the storage related operations
/// like uploading files to firebase storage
///
/// create a instance of this class using the provider
final storageRepoProvider =
    Provider((ref) => StorageRepo(storage: ref.watch(storageProvider)));

///
///## Example
// final firebaseSrorageProvider =
// Provider((res) => StorageRepo(storage: FirebaseStorage.instance));
///
///

class StorageRepo {
  final FirebaseStorage _firebaseStorage;

  StorageRepo({required FirebaseStorage storage}) : _firebaseStorage = storage;

  ///
  FutureEither<String> storeFile(
      {required String path, required String id, required File? file}) async {
    try {
      //take ref to the path
      final ref = _firebaseStorage.ref().child(path).child(id);
      //take upload task
      UploadTask uploadTask = ref.putFile(file!);
      final snapshot = await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
      //get download url
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
