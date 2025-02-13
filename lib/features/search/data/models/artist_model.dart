import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/artist.dart';
import 'external_urls_model.dart';
import 'followers_model.dart';
import 'image_model.dart';

part 'artist_model.g.dart';

@JsonSerializable()
class ArtistModel {
  final String id;
  final String name;
  final ExternalUrlsModel? externalUrls;
  final String href;
  final String uri;
  final int popularity;
  final FollowersModel? followers;
  final List<String> genres;
  final List<ImageModel>? images;

  const ArtistModel({
    required this.id,
    required this.name,
    this.externalUrls,
    required this.href,
    required this.uri,
    required this.popularity,
    this.followers,
    required this.genres,
    this.images,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) => _$ArtistModelFromJson(json);
  Map<String, dynamic> toJson() => _$ArtistModelToJson(this);

  Artist toEntity() => Artist(
        id: id,
        name: name,
        externalUrls: externalUrls?.toEntity(),
        href: href,
        uri: uri,
        popularity: popularity,
        followers: followers?.toEntity(),
        genres: genres,
        images: images?.map((e) => e.toEntity()).toList(),
      );

  factory ArtistModel.fromEntity(Artist entity) => ArtistModel(
        id: entity.id,
        name: entity.name,
        externalUrls: entity.externalUrls != null ? ExternalUrlsModel.fromEntity(entity.externalUrls!) : null,
        href: entity.href,
        uri: entity.uri,
        popularity: entity.popularity,
        followers: entity.followers != null ? FollowersModel.fromEntity(entity.followers!) : null,
        genres: entity.genres,
        images: entity.images?.map((e) => ImageModel.fromEntity(e)).toList(),
      );
}
