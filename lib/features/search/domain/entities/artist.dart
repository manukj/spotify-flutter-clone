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
} 