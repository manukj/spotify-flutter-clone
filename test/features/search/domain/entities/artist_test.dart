import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_flutter/features/search/domain/entities/artist.dart';
import 'package:spotify_flutter/features/search/domain/entities/external_urls.dart';
import 'package:spotify_flutter/features/search/domain/entities/followers.dart';
import 'package:spotify_flutter/features/search/domain/entities/image.dart';

void main() {
  test('Artist entity should be instantiated correctly', () {
    final artist = Artist(
      id: '540vIaP2JwjQb9dm3aArA4',
      name: 'DJ Snake',
      popularity: 77,
      uri: 'spotify:artist:540vIaP2JwjQb9dm3aArA4',
      href: 'https://api.spotify.com/v1/artists/540vIaP2JwjQb9dm3aArA4',
      externalUrls: ExternalUrls(spotify: 'https://open.spotify.com/artist/540vIaP2JwjQb9dm3aArA4'),
      followers: Followers(href: null, total: 9034970),
      genres: [],
      images: [
        Image(
          url: 'https://i.scdn.co/image/ab6761610000e5ebca97cf089968b569e29d795c',
          height: 640,
          width: 640
        ),
        Image(
          url: 'https://i.scdn.co/image/ab67616100005174ca97cf089968b569e29d795c',
          height: 320,
          width: 320
        ),
        Image(
          url: 'https://i.scdn.co/image/ab6761610000f178ca97cf089968b569e29d795c',
          height: 160,
          width: 160
        )
      ],
    );

    expect(artist.id, '540vIaP2JwjQb9dm3aArA4');
    expect(artist.name, 'DJ Snake');
    expect(artist.popularity, 77);
    expect(artist.uri, 'spotify:artist:540vIaP2JwjQb9dm3aArA4');
    expect(artist.href,
        'https://api.spotify.com/v1/artists/540vIaP2JwjQb9dm3aArA4');
    expect(artist.externalUrls?.spotify, 'https://open.spotify.com/artist/540vIaP2JwjQb9dm3aArA4');
    expect(artist.followers?.total, 9034970);
    expect(artist.genres, isEmpty);
    expect(artist.images?.length, 3);
  });
}
