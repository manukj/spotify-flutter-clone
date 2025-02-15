import 'external_urls.dart';
import 'followers.dart';
import 'image.dart';

class Artist {
  final String id;
  final String name;
  final ExternalUrls? externalUrls;
  final String href;
  final String uri;
  final int popularity;
  final Followers? followers;
  final List<String> genres;
  final List<Image>? images;

  const Artist({
    required this.id,
    required this.name,
    required this.externalUrls,
    required this.href,
    required this.uri,
    required this.popularity,
    required this.followers,
    required this.genres,
    required this.images,
  });

  Artist copyWith({
    String? id,
    String? name,
    ExternalUrls? externalUrls,
    String? href,
    String? uri,
    int? popularity,
    Followers? followers,
    List<String>? genres,
    List<Image>? images,
  }) {
    return Artist(
      id: id ?? this.id,
      name: name ?? this.name,
      externalUrls: externalUrls ?? this.externalUrls,
      href: href ?? this.href,
      uri: uri ?? this.uri,
      popularity: popularity ?? this.popularity,
      followers: followers ?? this.followers,
      genres: genres ?? this.genres,
      images: images ?? this.images,
    );
  }
} 