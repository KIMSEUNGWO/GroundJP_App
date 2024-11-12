import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageCroppers {

  static const ImageCroppers instance = ImageCroppers();
  const ImageCroppers();

  Future<CroppedFile?> getCropper(XFile imageFile) async {
    return await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '프로필 편집',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],

        ),
        IOSUiSettings(
          title: '프로필 편집',
          aspectRatioLockDimensionSwapEnabled: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          ],
        ),
      ],
    );


}

}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}


class ImagePick {

  static const ImagePick instance = ImagePick();
  const ImagePick();

  Future<PermissionStatus> _getPermission() async {
    final status = await Permission.photos.status;
    if (status.isDenied) {
      return Permission.photos.request();
    }
    return PermissionStatus.granted;
  }
  Future<XFile?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

  Future<List<XFile>> _pickMultiImage() async {
    final ImagePicker picker = ImagePicker();
    return picker.pickMultiImage();
  }



  Future<XFile?> get() async {
    final status = await _getPermission();
    if (status.isGranted) {
      return _pickImage();
    } else {
      print('이미지 권한 없음');
      return null;
    }
  }

  Future<CroppedFile?> getAndCrop() async {
    final XFile? image = await get();
    if (image != null) {
      return await ImageCroppers.instance.getCropper(image);
    }

    return null;
  }

}

