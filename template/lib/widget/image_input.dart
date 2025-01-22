import 'dart:io';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:template/providers/image_path_provider.dart';

class ImageInput extends ConsumerStatefulWidget {
  const ImageInput({super.key, this.imgPath});

  final String? imgPath;

  @override
  ConsumerState<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends ConsumerState<ImageInput> {
  File? selectedImage;
  void _captureImage() async {
    final imagePicker = ImagePicker();
    var pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 100, maxHeight: 100);
    if (pickedImage == null) {
      return;
    }

    ref.read(pathProvider.notifier).updateImagePath(pickedImage.path);
    setState(() {
      selectedImage = File(pickedImage.path);
    });
  }

  void _chooseImage() async {
    final imagePicker = ImagePicker();
    var pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 100, maxHeight: 100);
    if (pickedImage == null) {
      return;
    }

    ref.read(pathProvider.notifier).updateImagePath(pickedImage.path);
    setState(() {
      selectedImage = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget imageFile = TextButton.icon(
      icon: const Icon(Icons.camera),
      label: const Text("Capture Image!"),
      onPressed: _captureImage,
    );

    Widget galleryImageFile = TextButton.icon(
      icon: const Icon(Icons.camera),
      label: const Text("Pick Image!"),
      onPressed: _chooseImage,
    );

    if (selectedImage != null) {
      imageFile = GestureDetector(
          onTap: _captureImage,
          child: Image.file(
            selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ));
      galleryImageFile = GestureDetector(
          onTap: _chooseImage,
          child: Image.file(
            selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ));
    } else if (selectedImage == null && widget.imgPath != null) {
      selectedImage = File(widget.imgPath!);
      imageFile = GestureDetector(
          onTap: _captureImage,
          child: Image.file(
            selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ));
      galleryImageFile = GestureDetector(
          onTap: _chooseImage,
          child: Image.file(
            selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ));
    }

    return Container(
      height: 150,
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
              ),
            ),
            height: 150,
            width: 150,
            child: imageFile,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
              ),
            ),
            height: 150,
            width: 150,
            child: galleryImageFile,
          ),
        ],
      ),
    );
  }
}
