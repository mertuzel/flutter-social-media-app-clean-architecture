import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:friend_zone/src/data/utils/keys.dart';

class UploadHelper {
  Future<String> uploadImageToStorage(
    String imagePath,
    String uid, {
    bool isPost = false,
  }) async {
    final FirebaseStorage _firebaseStorage =
        FirebaseStorage.instanceFor(bucket: Keys.firebaseBucket);

    String filePath = '$uid-${DateTime.now().millisecondsSinceEpoch}.png';

    String fullPath = isPost ? 'postImages/$filePath' : 'storyImages/$filePath';

    Reference fileReference = _firebaseStorage.ref().child(fullPath);

    UploadTask uploadTask = fileReference.putFile(File(imagePath));

    String? imageUrl;
    await uploadTask.whenComplete(() async {
      try {
        imageUrl = await fileReference.getDownloadURL();
      } catch (e, st) {
        print(e);
        print(st);
        rethrow;
      }
    });

    return imageUrl!;
  }
}
