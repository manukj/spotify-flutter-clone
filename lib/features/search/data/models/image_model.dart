import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/image.dart';

part 'image_model.g.dart';

@JsonSerializable()
class ImageModel {
  final String? url;
  final int? height;
  final int? width;

  const ImageModel({this.url, this.height, this.width});

  factory ImageModel.fromJson(Map<String, dynamic> json) => _$ImageModelFromJson(json);
  Map<String, dynamic> toJson() => _$ImageModelToJson(this);

  Image toEntity() => Image(url: url, height: height, width: width);
  factory ImageModel.fromEntity(Image entity) => ImageModel(
        url: entity.url,
        height: entity.height,
        width: entity.width,
      );
} 