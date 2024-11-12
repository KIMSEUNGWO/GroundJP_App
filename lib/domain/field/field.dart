
import 'package:groundjp/component/image_helper.dart';
import 'package:groundjp/domain/field/address.dart';
import 'package:groundjp/domain/field/field_data.dart';
import 'package:groundjp/domain/field/field_simp.dart';
import 'package:flutter/material.dart';

class Field {

  final int fieldId;
  final String title;
  final Address address;
  final FieldData fieldData;
  final String description;
  final List<Image> images;

  Field.fromJson(Map<String, dynamic> json):
    fieldId = json['fieldId'],
    title = json['title'],
    description = json['description'],
    address = Address.fromJson(json['address']),
    fieldData = FieldData.fromJson(json['fieldData']),
    images = json['images'] != null
      ? List<Image>.from(json['images'].map((image) => ImageHelper.instance.parseImage(imagePath: ImagePath.ORIGINAL, imageType: ImageType.FIELD, imageName: image, fit: BoxFit.fitWidth)))
      : [];

  Field(this.fieldId, this.title, this.address, this.fieldData,
      this.description, this.images);

  FieldSimp toFieldSimp() {
    return FieldSimp(fieldId, title, address.address, address.region);
  }
}