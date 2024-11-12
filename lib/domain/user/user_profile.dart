
import 'package:groundjp/component/image_helper.dart';
import 'package:groundjp/domain/enums/match_enums.dart';
import 'package:groundjp/domain/user/social_result.dart';
import 'package:flutter/material.dart';

class UserProfile {

  final int id;
  final SocialProvider provider;
  Image? image;
  String nickname;
  final SexType sex;
  final DateTime birth;

  int cash;



  UserProfile.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    provider = SocialProvider.fromJson(json['provider'])!,
    image = json['image'] == null
        ? null
        : ImageHelper.instance.parseImage(imagePath: ImagePath.THUMBNAIL, imageType: ImageType.PROFILE, imageName: json['image'], fit: BoxFit.fill),
    nickname = json['nickname'],
    sex = SexType.valueOf(json['sex'])!,
    birth = DateTime.parse(json['birth']),
    cash = json['cash'];

  UserProfile.clone(UserProfile state):
    id = state.id,
    provider = state.provider,
    image = state.image,
    nickname = state.nickname,
    sex = state.sex,
    birth = state.birth,
    cash = state.cash;


}