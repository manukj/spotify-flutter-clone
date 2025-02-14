class SpotifyException implements Exception {
  final String message;
  final int statusCode;

  SpotifyException({required this.message, required this.statusCode});

  @override
  String toString() => 'SpotifyException: $message (Status Code: $statusCode)';
}

class UnauthorizedException extends SpotifyException {
  UnauthorizedException({required super.message}) : super(statusCode: 401);
}

class ForbiddenException extends SpotifyException {
  ForbiddenException({required super.message}) : super(statusCode: 403);
}

class RateLimitException extends SpotifyException {
  RateLimitException({required super.message}) : super(statusCode: 429);
} 