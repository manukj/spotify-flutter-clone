import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotify_flutter/features/search/data/datasources/search_remote_data_source_impl.dart';
import 'package:spotify_flutter/features/search/data/models/albums_response_model.dart';
import 'package:spotify_flutter/features/search/data/models/artists_response_model.dart';

class MockDio extends Mock implements Dio {}

class FakeRequestOptions extends Fake implements RequestOptions {}

class FakeOptions extends Fake implements Options {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
    registerFallbackValue(FakeOptions());
    registerFallbackValue({});
  });

  late SearchRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = SearchRemoteDataSourceImpl(dio: mockDio);
  });

  const tQuery = 'test query';
  const tLimit = 20;
  const tOffset = 0;

  group('searchArtists', () {
    final tArtistsResponse = {
      'artists': {
        'href': 'test_href',
        'limit': 20,
        'next': null,
        'offset': 0,
        'previous': null,
        'total': 1,
        'items': [
          {
            'external_urls': {'spotify': 'test_spotify_url'},
            'followers': {'href': null, 'total': 1000},
            'genres': ['pop'],
            'href': 'test_href',
            'id': 'test_id',
            'images': [
              {'url': 'test_url', 'height': 300, 'width': 300}
            ],
            'name': 'Test Artist',
            'popularity': 80,
            'type': 'artist',
            'uri': 'test_uri'
          }
        ]
      }
    };

    test(
      'should perform GET request with proper headers and query parameters',
      () async {
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenAnswer(
          (_) async => Response(
            data: tArtistsResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        await dataSource.searchArtists(
          query: tQuery,
          limit: tLimit,
          offset: tOffset,
        );

        verify(
          () => mockDio.get(
            'https://api.spotify.com/v1/search',
            queryParameters: {
              'q': tQuery,
              'type': 'artist',
              'limit': tLimit,
              'offset': tOffset,
            },
            options: any(named: 'options'),
          ),
        ).called(1);
      },
    );

    test(
      'should return ArtistsResponseModel when response is successful',
      () async {
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenAnswer(
          (_) async => Response(
            data: tArtistsResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        final result = await dataSource.searchArtists(
          query: tQuery,
          limit: tLimit,
          offset: tOffset,
        );

        expect(result, isA<ArtistsResponseModel>());
      },
    );
  });

  group('searchAlbums', () {
    final tAlbumsResponse = {
      'albums': {
        'href': 'test_href',
        'limit': 20,
        'next': null,
        'offset': 0,
        'previous': null,
        'total': 1,
        'items': [
          {
            'album_type': 'album',
            'total_tracks': 12,
            'available_markets': ['US'],
            'external_urls': {'spotify': 'test_spotify_url'},
            'href': 'test_href',
            'id': 'test_id',
            'images': [
              {'url': 'test_url', 'height': 300, 'width': 300}
            ],
            'name': 'Test Album',
            'release_date': '2021',
            'release_date_precision': 'year',
            'type': 'album',
            'uri': 'test_uri',
            'artists': [
              {
                'external_urls': {'spotify': 'test_spotify_url'},
                'href': 'test_href',
                'id': 'test_id',
                'name': 'Test Artist',
                'type': 'artist',
                'uri': 'test_uri',
                'popularity': 80,
                'genres': [],
                'followers': {'total': 1000}
              }
            ]
          }
        ]
      }
    };

    test(
      'should perform GET request with proper headers and query parameters',
      () async {
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenAnswer(
          (_) async => Response(
            data: tAlbumsResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        await dataSource.searchAlbums(
          query: tQuery,
          limit: tLimit,
          offset: tOffset,
        );

        verify(
          () => mockDio.get(
            'https://api.spotify.com/v1/search',
            queryParameters: {
              'q': tQuery,
              'type': 'album',
              'limit': tLimit,
              'offset': tOffset,
            },
            options: any(named: 'options'),
          ),
        ).called(1);
      },
    );

    test(
      'should return AlbumsResponseModel when response is successful',
      () async {
        when(() => mockDio.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenAnswer(
          (_) async => Response(
            data: tAlbumsResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        final result = await dataSource.searchAlbums(
          query: tQuery,
          limit: tLimit,
          offset: tOffset,
        );

        expect(result, isA<AlbumsResponseModel>());
      },
    );
  });
}
