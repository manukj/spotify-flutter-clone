import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_flutter/features/search/domain/entities/album.dart';
import 'package:spotify_flutter/features/search/domain/entities/artist.dart';
import 'package:spotify_flutter/features/search/domain/entities/external_urls.dart';
import 'package:spotify_flutter/features/search/domain/entities/followers.dart';
import 'package:spotify_flutter/features/search/domain/entities/image.dart';

void main() {
  test('Album entity should be instantiated correctly', () {
    final album = Album(
      albumType: 'album',
      totalTracks: 9,
      availableMarkets: [
        'AR', 'AU', 'AT', 'BE', 'BO', 'BR', 'BG', 'CA', 'CL', 'CO', 'CR', 'CY', 'CZ', 'DK', 'DO', 'DE', 'EC', 'EE', 'SV', 'FI', 'FR', 'GR', 'GT', 'HN', 'HK', 'HU', 'IS', 'IE', 'IT', 'LV', 'LT', 'LU', 'MY', 'MT', 'MX', 'NL', 'NZ', 'NI', 'NO', 'PA', 'PY', 'PE', 'PH', 'PL', 'PT', 'SG', 'SK', 'ES', 'SE', 'CH', 'TW', 'TR', 'UY', 'US', 'GB', 'AD', 'MC', 'ID', 'JP', 'TH', 'VN', 'RO', 'IL', 'ZA', 'SA', 'AE', 'BH', 'QA', 'OM', 'KW', 'EG', 'MA', 'DZ', 'TN', 'LB', 'JO', 'IN', 'BY', 'KZ', 'MD', 'UA', 'AL', 'BA', 'HR', 'ME', 'MK', 'RS', 'SI', 'KR', 'BD', 'PK', 'LK', 'GH', 'KE', 'NG', 'TZ', 'UG', 'AG', 'AM', 'BS', 'BB', 'BZ', 'BW', 'BF', 'CV', 'CW', 'DM', 'FJ', 'GM', 'GD', 'GW', 'HT', 'JM', 'LS', 'LR', 'MW', 'ML', 'FM', 'NA', 'NE', 'PG', 'PR', 'SM', 'ST', 'SN', 'SC', 'SL', 'KN', 'LC', 'VC', 'TL', 'TT', 'AZ', 'BN', 'BI', 'KH', 'CM', 'TD', 'KM', 'GQ', 'SZ', 'GA', 'GN', 'KG', 'LA', 'MO', 'MR', 'MN', 'NP', 'RW', 'TG', 'UZ', 'ZW', 'BJ', 'MG', 'MU', 'MZ', 'AO', 'CI', 'DJ', 'ZM', 'CD', 'CG', 'IQ', 'LY', 'TJ', 'VE', 'ET', 'XK'
      ],
      externalUrls: ExternalUrls(spotify: 'https://open.spotify.com/album/28IDISyL4r5E5PXP0aQMnl'),
      href: 'https://api.spotify.com/v1/albums/28IDISyL4r5E5PXP0aQMnl',
      id: '28IDISyL4r5E5PXP0aQMnl',
      images: [
        Image(
          url: 'https://i.scdn.co/image/ab67616d0000b273cab3178ef948cebe41e44a42',
          height: 640,
          width: 640
        ),
        Image(
          url: 'https://i.scdn.co/image/ab67616d00001e02cab3178ef948cebe41e44a42',
          height: 300,
          width: 300
        ),
        Image(
          url: 'https://i.scdn.co/image/ab67616d00004851cab3178ef948cebe41e44a42',
          height: 64,
          width: 64
        )
      ],
      name: 'Doo-Bop',
      releaseDate: '1992-06-26',
      releaseDatePrecision: 'day',
      type: 'album',
      uri: 'spotify:album:28IDISyL4r5E5PXP0aQMnl',
      artists: [
        Artist(
          id: '0kbYTNQb4Pb1rPbbaF0pT4',
          name: 'Miles Davis',
          externalUrls: ExternalUrls(spotify: 'https://open.spotify.com/artist/0kbYTNQb4Pb1rPbbaF0pT4'),
          href: 'https://api.spotify.com/v1/artists/0kbYTNQb4Pb1rPbbaF0pT4',
          uri: 'spotify:artist:0kbYTNQb4Pb1rPbbaF0pT4',
          popularity: 0,
          followers: Followers(href: null, total: 0),
          genres: [],
          images: [],
        )
      ],
    );

    expect(album.albumType, 'album');
    expect(album.totalTracks, 9);
    expect(album.availableMarkets.length, 100);
    expect(album.externalUrls?.spotify, 'https://open.spotify.com/album/28IDISyL4r5E5PXP0aQMnl');
    expect(album.href, 'https://api.spotify.com/v1/albums/28IDISyL4r5E5PXP0aQMnl');
    expect(album.id, '28IDISyL4r5E5PXP0aQMnl');
    expect(album.images?.length, 3);
    expect(album.name, 'Doo-Bop');
    expect(album.releaseDate, '1992-06-26');
    expect(album.releaseDatePrecision, 'day');
    expect(album.type, 'album');
    expect(album.uri, 'spotify:album:28IDISyL4r5E5PXP0aQMnl');
    expect(album.artists.length, 1);
    expect(album.artists.first.name, 'Miles Davis');
  });
} 