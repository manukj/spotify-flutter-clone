// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'albums_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumsResponseModel _$AlbumsResponseModelFromJson(Map<String, dynamic> json) =>
    AlbumsResponseModel(
      data: AlbumsData.fromJson(json['albums'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AlbumsResponseModelToJson(
        AlbumsResponseModel instance) =>
    <String, dynamic>{
      'albums': instance.data,
    };

AlbumsData _$AlbumsDataFromJson(Map<String, dynamic> json) => AlbumsData(
      href: json['href'] as String,
      limit: (json['limit'] as num).toInt(),
      next: json['next'] as String?,
      offset: (json['offset'] as num).toInt(),
      previous: json['previous'] as String?,
      total: (json['total'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => AlbumModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AlbumsDataToJson(AlbumsData instance) =>
    <String, dynamic>{
      'href': instance.href,
      'limit': instance.limit,
      'next': instance.next,
      'offset': instance.offset,
      'previous': instance.previous,
      'total': instance.total,
      'items': instance.items,
    };
