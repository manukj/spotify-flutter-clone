import 'artist.dart';
import 'external_urls.dart';
import 'image.dart';

class Album {
  final String albumType;
  final int totalTracks;
  final List<String> availableMarkets;
  final ExternalUrls? externalUrls;
  final String href;
  final String id;
  final List<Image>? images;
  final String name;
  final String releaseDate;
  final String releaseDatePrecision;
  final String type;
  final String uri;
  final List<Artist> artists;

  Album({
    required this.albumType,
    required this.totalTracks,
    required this.availableMarkets,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.releaseDate,
    required this.releaseDatePrecision,
    required this.type,
    required this.uri,
    required this.artists,
  });
} 