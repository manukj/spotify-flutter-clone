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

  const Album({
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

  Album copyWith({
    String? albumType,
    int? totalTracks,
    List<String>? availableMarkets,
    ExternalUrls? externalUrls,
    String? href,
    String? id,
    List<Image>? images,
    String? name,
    String? releaseDate,
    String? releaseDatePrecision,
    String? type,
    String? uri,
    List<Artist>? artists,
  }) {
    return Album(
      albumType: albumType ?? this.albumType,
      totalTracks: totalTracks ?? this.totalTracks,
      availableMarkets: availableMarkets ?? this.availableMarkets,
      externalUrls: externalUrls ?? this.externalUrls,
      href: href ?? this.href,
      id: id ?? this.id,
      images: images ?? this.images,
      name: name ?? this.name,
      releaseDate: releaseDate ?? this.releaseDate,
      releaseDatePrecision: releaseDatePrecision ?? this.releaseDatePrecision,
      type: type ?? this.type,
      uri: uri ?? this.uri,
      artists: artists ?? this.artists,
    );
  }
}
