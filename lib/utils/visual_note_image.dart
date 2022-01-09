// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:visual_notes/helpers/sizer_helper.dart';
import 'package:visual_notes/providers/visual_note_provider.dart';

class VisualNoteImage extends StatefulWidget {
  // this is a callback function to return the picked image back
  // used in case of editing
  File? visualNoteImage;
  VisualNoteImage({Key? key, this.visualNoteImage}) : super(key: key);

  @override
  _VisualNoteImageState createState() => _VisualNoteImageState();
}

class _VisualNoteImageState extends State<VisualNoteImage> {
  File? pickedImage;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //  getting the cached image;
    pickedImage =
        Provider.of<VisualNoteProvider>(context, listen: false).pickedImage;
    // if its not null => then the user is editing the note
    // else =>
    if (widget.visualNoteImage != null) {
      pickedImage = widget.visualNoteImage;
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
      child: pickedImage == null
          ? chooseImageButton("Add Photo")
          :
          // if not show the image and a button above to change it
          Stack(
              clipBehavior: Clip.none,
              children: [
                Image.file(
                  pickedImage!,
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
    final sizer = SizeHelper(context);

    // when the user change orientation while camera is opened, a rebuild happens and the widget loses its state
    // and the picker returns null
    // to avoid this, locking the orientation according to the current orientation
    await lockOrientation(sizer);
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      cacheImage(pickedImage!);

      /// caching the image
      setState(() {});
    }
    // unlocking orientation after getting the image
    await unLockOrientation();
  }

  Future<void> unLockOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }

  Future<void> lockOrientation(SizeHelper sizer) async {
    List<DeviceOrientation> orientations = sizer.isLandscape
        ? [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
        : [DeviceOrientation.portraitUp];
    await SystemChrome.setPreferredOrientations(orientations);
  }

  // when the orientation changes, the ui rebuilds
  // and the picked image changes to null
  // this function caches the image outide of this widget`s state
  // and use its value when needed

  void cacheImage(File image) {
    Provider.of<VisualNoteProvider>(context, listen: false).cacheImage(image);
  }
}
