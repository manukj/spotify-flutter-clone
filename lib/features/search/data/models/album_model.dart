import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/album.dart';
import 'artist_model.dart';
import 'external_urls_model.dart';
import 'image_model.dart';

part 'album_model.g.dart';

@JsonSerializable()
class AlbumModel {
  @JsonKey(name: 'album_type')
  final String albumType;
  @JsonKey(name: 'total_tracks')
  final int totalTracks;
  @JsonKey(name: 'available_markets')
  final List<String> availableMarkets;
  @JsonKey(name: 'external_urls')
  final ExternalUrlsModel? externalUrls;
  final String href;
  final String id;
  final List<ImageModel>? images;
  final String name;
  @JsonKey(name: 'release_date')
  final String releaseDate;
  @JsonKey(name: 'release_date_precision')
  final String releaseDatePrecision;
  final String type;
  final String uri;
  final List<ArtistModel> artists;

  const AlbumModel({
    required this.albumType,
    required this.totalTracks,
    required this.availableMarkets,
    this.externalUrls,
    required this.href,
    required this.id,
    this.images,
    required this.name,
    required this.releaseDate,
    required this.releaseDatePrecision,
    required this.type,
    required this.uri,
    required this.artists,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) => _$AlbumModelFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumModelToJson(this);

  Album toEntity() => Album(
        albumType: albumType,
        totalTracks: totalTracks,
        availableMarkets: availableMarkets,
        externalUrls: externalUrls?.toEntity(),
        href: href,
        id: id,
        images: images?.map((e) => e.toEntity()).toList(),
        name: name,
        releaseDate: releaseDate,
        releaseDatePrecision: releaseDatePrecision,
        type: type,
        uri: uri,
        artists: artists.map((e) => e.toEntity()).toList(),
      );

  factory AlbumModel.fromEntity(Album entity) => AlbumModel(
        albumType: entity.albumType,
        totalTracks: entity.totalTracks,
        availableMarkets: entity.availableMarkets,
        externalUrls: entity.externalUrls != null ? ExternalUrlsModel.fromEntity(entity.externalUrls!) : null,
        href: entity.href,
        id: entity.id,
        images: entity.images?.map((e) => ImageModel.fromEntity(e)).toList(),
        name: entity.name,
        releaseDate: entity.releaseDate,
        releaseDatePrecision: entity.releaseDatePrecision,
        type: entity.type,
        uri: entity.uri,
        artists: entity.artists.map((e) => ArtistModel.fromEntity(e)).toList(),
      );
} 