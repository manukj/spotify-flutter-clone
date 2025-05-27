import 'package:json_annotation/json_annotation.dart';

part 'spotify_error_response.g.dart';

@JsonSerializable()
class SpotifyErrorResponse {
  final SpotifyError error;

  const SpotifyErrorResponse({required this.error});

  factory SpotifyErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$SpotifyErrorResponseFromJson(json);
}

@JsonSerializable()
class SpotifyError {
  final int status;
  final String message;

  const SpotifyError({
    required this.status,
    required this.message,
  });

  factory SpotifyError.fromJson(Map<String, dynamic> json) =>
      _$SpotifyErrorFromJson(json);
} 