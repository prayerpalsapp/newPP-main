import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prayer_pals/core/utils/constants.dart';

class UpdatePicture extends HookWidget {
  final Function(File) callback;
  const UpdatePicture({
    required BuildContext context,
    required this.callback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        StringConstants.updateProfilePicture,
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            var pickerFile =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (pickerFile != null) callback(File(pickerFile.path));
          },
          child: const Text(StringConstants.photos),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            var pickerFile =
                await ImagePicker().pickImage(source: ImageSource.camera);
            if (pickerFile != null) callback(File(pickerFile.path));
          },
          child: const Text(StringConstants.camera),
        ),
      ],
    );
  }
}
