// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artists_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistsResponseModel _$ArtistsResponseModelFromJson(
        Map<String, dynamic> json) =>
    ArtistsResponseModel(
      data: ArtistsData.fromJson(json['artists'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ArtistsResponseModelToJson(
        ArtistsResponseModel instance) =>
    <String, dynamic>{
      'artists': instance.data,
    };

ArtistsData _$ArtistsDataFromJson(Map<String, dynamic> json) => ArtistsData(
      href: json['href'] as String,
      limit: (json['limit'] as num).toInt(),
      next: json['next'] as String?,
      offset: (json['offset'] as num).toInt(),
      previous: json['previous'] as String?,
      total: (json['total'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => ArtistModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArtistsDataToJson(ArtistsData instance) =>
    <String, dynamic>{
      'href': instance.href,
      'limit': instance.limit,
      'next': instance.next,
      'offset': instance.offset,
      'previous': instance.previous,
      'total': instance.total,
      'items': instance.items,
    };
