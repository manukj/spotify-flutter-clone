import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/external_urls.dart';

part 'external_urls_model.g.dart';

@JsonSerializable()
class ExternalUrlsModel {
  final String? spotify;

  const ExternalUrlsModel({this.spotify});

  factory ExternalUrlsModel.fromJson(Map<String, dynamic> json) => _$ExternalUrlsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalUrlsModelToJson(this);

  ExternalUrls toEntity() => ExternalUrls(spotify: spotify);
  factory ExternalUrlsModel.fromEntity(ExternalUrls entity) => ExternalUrlsModel(spotify: entity.spotify);
} 