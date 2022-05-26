import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class ImageUpload {
  Future<String> uploadImages(
      String folderName, String childName, Uint8List image) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(folderName)
        .child('${childName}.jpg');
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
