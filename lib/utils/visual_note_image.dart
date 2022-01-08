// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visual_notes/helpers/sizer_helper.dart';

class VisualNoteImage extends StatefulWidget {
  // this is a callback function to return the picked image back
  Function saveImage;
  // used in case of editing
  File? image;
  VisualNoteImage(this.saveImage, {Key? key, this.image}) : super(key: key);

  @override
  _VisualNoteImageState createState() => _VisualNoteImageState();
}

File? image;

class _VisualNoteImageState extends State<VisualNoteImage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if its not null => then the user is editing the note
    // else =>
    if (widget.image != null) {
      image = widget.image;
    }
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
      // if the image is not set, show a button
      child: image == null
          ? chooseImageButton("Add Photo")
          :
          // if not show the image and a button above to change it
          Stack(
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
