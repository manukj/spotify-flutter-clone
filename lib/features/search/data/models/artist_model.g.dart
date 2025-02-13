// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistModel _$ArtistModelFromJson(Map<String, dynamic> json) => ArtistModel(
      id: json['id'] as String,
      name: json['name'] as String,
      externalUrls: json['externalUrls'] == null
          ? null
          : ExternalUrlsModel.fromJson(
              json['externalUrls'] as Map<String, dynamic>),
      href: json['href'] as String,
      uri: json['uri'] as String,
      popularity: (json['popularity'] as num).toInt(),
      followers: json['followers'] == null
          ? null
          : FollowersModel.fromJson(json['followers'] as Map<String, dynamic>),
      genres:
          (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArtistModelToJson(ArtistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'externalUrls': instance.externalUrls,
      'href': instance.href,
      'uri': instance.uri,
      'popularity': instance.popularity,
      'followers': instance.followers,
      'genres': instance.genres,
      'images': instance.images,
    };
