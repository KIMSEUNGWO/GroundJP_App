
import 'package:flutter/material.dart';
import 'package:groundjp/component/image_helper.dart';

class UserSimp {

  final int userId;
  final String nickname;
  final Image? profile;

  UserSimp.fromJson(Map<String, dynamic> json):
    userId = json['userId'],
    nickname = json['nickname'],
    profile = json['profile'] == null ? null
      : ImageHelper.instance.parseImage(imagePath: ImagePath.THUMBNAIL, imageType: ImageType.PROFILE, imageName: json['profile'], fit: BoxFit.fill,);

  UserSimp({required this.userId, required this.nickname, required this.profile});
}