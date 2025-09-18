import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImageUtilityService {
  const ImageUtilityService();
  Future<File?> pickImageFromGallery(
      {bool cropImage = false,
      CameraDevice preferredCameraDevice = CameraDevice.rear});

  Future<File?> pickImageFromCamera(
      {bool cropImage = false,
      CameraDevice preferredCameraDevice = CameraDevice.rear});

  Future<File?> pickImage({bool cropImage = false});
}

class ImageUtilityServiceImpl implements ImageUtilityService {
  const ImageUtilityServiceImpl();
  static int imageQuality = 45;
  @override
  Future<File?> pickImageFromGallery(
      {bool cropImage = false,
      CameraDevice preferredCameraDevice = CameraDevice.rear}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
    );

    if (cropImage && pickedFile != null) {
      return cropSelectedImage(pickedFile.path);
    }

    return pickedFile != null ? File(pickedFile.path) : null;
  }

  @override
  Future<File?> pickImageFromCamera(
      {bool cropImage = false,
      CameraDevice preferredCameraDevice = CameraDevice.rear}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
    );

    if (cropImage && pickedFile != null) {
      return cropSelectedImage(pickedFile.path);
    }

    return pickedFile != null ? File(pickedFile.path) : null;
  }

  @override
  Future<File?> pickImage({bool cropImage = false}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png',
        'jpeg',
        'heif',
        'webp',
        'tiff',
        'psd',
        'ai',
      ],
    );

    if (result == null || result.files.isEmpty) return null;

    if (cropImage) {
      final croppedFile = await cropSelectedImage(result.files.first.path!);
      return File(croppedFile!.path);
    }

    return File(result.files.first.path!);
  }

  Future<File?> cropSelectedImage( String filePath) async {
    final imageCropper = ImageCropper();
    final file = await imageCropper.cropImage(
      uiSettings: [
        AndroidUiSettings(
          lockAspectRatio: true,
          toolbarWidgetColor: Colors.white,
          toolbarTitle: 'Crop Selected Picture',
          initAspectRatio: CropAspectRatioPreset.square,
        ),
        IOSUiSettings(
          aspectRatioLockEnabled: true,
          cancelButtonTitle: 'Cancel',
          doneButtonTitle: 'Done',
          hidesNavigationBar: true,
          title: 'Crop Selected Picture',
        )
      ],
      sourcePath: filePath,
      maxHeight: 800,
      maxWidth: 800,
      compressQuality: 100,
    );
    if (file == null) {
      return null;
    } else {
      return File(file.path);
    }
  }
}
