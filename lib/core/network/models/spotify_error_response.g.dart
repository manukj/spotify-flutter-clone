// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotifyErrorResponse _$SpotifyErrorResponseFromJson(
        Map<String, dynamic> json) =>
    SpotifyErrorResponse(
      error: SpotifyError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SpotifyErrorResponseToJson(
        SpotifyErrorResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
    };

SpotifyError _$SpotifyErrorFromJson(Map<String, dynamic> json) => SpotifyError(
      status: (json['status'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$SpotifyErrorToJson(SpotifyError instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
