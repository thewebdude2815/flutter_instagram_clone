import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagepicker = ImagePicker();
  XFile? _file = await _imagepicker.pickImage(source: source);

  if (_file != null) {
    return _file.readAsBytes();
  } else {
    print("No Image Selected");
  }

  showSnackBar(BuildContext context, String content) {
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(content)));
  }
}
