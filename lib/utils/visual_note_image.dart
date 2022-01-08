// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visual_notes/helpers/sizer_helper.dart';

class VisualNoteImage extends StatefulWidget {
  Function saveImage;
  File? image;
  VisualNoteImage(this.saveImage, {Key? key, this.image}) : super(key: key);

  @override
  _VisualNoteImageState createState() => _VisualNoteImageState();
}

class _VisualNoteImageState extends State<VisualNoteImage> {
  File? image;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    final sizer = SizeHelper(context);
    return Container(
      height: sizer.height * .4,
      width: sizer.width,
      decoration: BoxDecoration(
        border: Border.all(
            width: 1, color: Theme.of(context).colorScheme.secondaryVariant),
      ),
      child: image == null
          ? chooseImageButton("Add Photo")
          : Stack(
              clipBehavior: Clip.none,
              children: [
                Image.file(
                  image!,
                  fit: BoxFit.fill,
                  width: sizer.width,
                ),
                Positioned(
                  top: sizer.height * .36,
                  child: Container(
                    color: Colors.white,
                    child: chooseImageButton("Change Photo"),
                  ),
                )
              ],
            ),
    );
  }

  Center chooseImageButton(String title) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          _openCamera();
        },
        icon: const Icon(Icons.add_a_photo),
        label: Text(title),
      ),
    );
  }

  _openCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      image = File(pickedFile.path);
      widget.saveImage(image);
      setState(() {});
    }
  }
}
