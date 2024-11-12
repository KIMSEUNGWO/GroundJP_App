import 'package:groundjp/api/api_service.dart';
import 'package:flutter/material.dart';

class ImageHelper {

  static const ImageHelper instance = ImageHelper();
  const ImageHelper();

  parse({required ImagePath imagePath, required ImageType imageType, required String imageName}) {
    return '${ApiService.server}/images${imagePath.path}${imageType.path}/$imageName';
  }

  Image parseImage({required ImagePath imagePath, required ImageType imageType, required String imageName, required BoxFit fit}) {
    String uri = parse(imagePath: imagePath, imageType: imageType, imageName: imageName);
    return Image.network(uri, fit: fit,);
  }
}

enum ImagePath {

  ORIGINAL('/original'),
  THUMBNAIL('/thumbnail');

  final String path;

  const ImagePath(this.path);
}

enum ImageType {

  PROFILE('/profile'),
  FIELD('/field');

  final String path;

  const ImageType(this.path);
}