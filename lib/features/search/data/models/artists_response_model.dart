import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/artists_response.dart';
import 'artist_model.dart';

part 'artists_response_model.g.dart';

@JsonSerializable()
class ArtistsResponseModel {
  @JsonKey(name: 'artists')
  final ArtistsData data;

  const ArtistsResponseModel({required this.data});

  factory ArtistsResponseModel.fromJson(Map<String, dynamic> json) => _$ArtistsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ArtistsResponseModelToJson(this);

  ArtistsResponse toEntity() => data.toEntity();
}

@JsonSerializable()
class ArtistsData {
  final String href;
  final int limit;
  final String? next;
  final int offset;
  final String? previous;
  final int total;
  final List<ArtistModel> items;

  const ArtistsData({
    required this.href,
    required this.limit,
    this.next,
    required this.offset,
    this.previous,
    required this.total,
    required this.items,
  });

  factory ArtistsData.fromJson(Map<String, dynamic> json) => _$ArtistsDataFromJson(json);
  Map<String, dynamic> toJson() => _$ArtistsDataToJson(this);

  ArtistsResponse toEntity() => ArtistsResponse(
        href: href,
        limit: limit,
        next: next,
        offset: offset,
        previous: previous,
        total: total,
        items: items.map((e) => e.toEntity()).toList(),
      );
} 