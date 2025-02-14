import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/albums_response.dart';
import 'album_model.dart';

part 'albums_response_model.g.dart';

@JsonSerializable()
class AlbumsResponseModel {
  @JsonKey(name: 'albums')
  final AlbumsData data;

  const AlbumsResponseModel({required this.data});

  factory AlbumsResponseModel.fromJson(Map<String, dynamic> json) => _$AlbumsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumsResponseModelToJson(this);

  AlbumsResponse toEntity() => data.toEntity();
}

@JsonSerializable()
class AlbumsData {
  final String href;
  final int limit;
  final String? next;
  final int offset;
  final String? previous;
  final int total;
  @JsonKey(name: 'items')
  final List<AlbumModel> items;

  const AlbumsData({
    required this.href,
    required this.limit,
    this.next,
    required this.offset,
    this.previous,
    required this.total,
    required this.items,
  });

  factory AlbumsData.fromJson(Map<String, dynamic> json) => _$AlbumsDataFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumsDataToJson(this);

  AlbumsResponse toEntity() => AlbumsResponse(
        href: href,
        limit: limit,
        next: next,
        offset: offset,
        previous: previous,
        total: total,
        items: items.map((e) => e.toEntity()).toList(),
      );
} 