import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotify_flutter/features/search/data/datasources/search_remote_data_source.dart';
import 'package:spotify_flutter/features/search/data/models/album_model.dart';
import 'package:spotify_flutter/features/search/data/models/albums_response_model.dart';
import 'package:spotify_flutter/features/search/data/models/artist_model.dart';
import 'package:spotify_flutter/features/search/data/models/artists_response_model.dart';
import 'package:spotify_flutter/features/search/data/repositories/music_repository_impl.dart';
import 'package:spotify_flutter/features/search/domain/entities/albums_response.dart';
import 'package:spotify_flutter/features/search/domain/entities/artists_response.dart';

class MockSearchRemoteDataSource extends Mock implements SearchRemoteDataSource {}

void main() {
  late MusicRepositoryImpl repository;
  late MockSearchRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockSearchRemoteDataSource();
    repository = MusicRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tQuery = 'test query';

  group('searchArtists', () {
    final tArtistsResponse = ArtistsResponseModel(
      data: ArtistsData(
        href: 'test_href',
        limit: 20,
        next: null,
        offset: 0,
        previous: null,
        total: 1,
        items: [
          ArtistModel(
            id: 'test_id',
            name: 'Test Artist',
            href: 'test_href',
            uri: 'test_uri',
            popularity: 80,
            genres: ['pop'],
            followers: null,
            externalUrls: null,
            images: null,
          ),
        ],
      ),
    );

    test(
      'should return ArtistsResponse when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.searchArtists(
              query: any(named: 'query'),
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            )).thenAnswer((_) async => tArtistsResponse);

        // act
        final result = await repository.searchArtists(tQuery);

        // assert
        verify(() => mockRemoteDataSource.searchArtists(
              query: tQuery,
              limit: 20,
              offset: 0,
            )).called(1);
        expect(result, isA<ArtistsResponse>());
        expect(result.items.length, 1);
        expect(result.items.first.name, 'Test Artist');
      },
    );
  });

  group('searchAlbums', () {
    final tAlbumsResponse = AlbumsResponseModel(
      data: AlbumsData(
        href: 'test_href',
        limit: 20,
        next: null,
        offset: 0,
        previous: null,
        total: 1,
        items: [
          AlbumModel(
            albumType: 'album',
            totalTracks: 12,
            availableMarkets: ['US'],
            href: 'test_href',
            id: 'test_id',
            name: 'Test Album',
            releaseDate: '2021',
            releaseDatePrecision: 'year',
            type: 'album',
            uri: 'test_uri',
            artists: [
              ArtistModel(
                id: 'test_id',
                name: 'Test Artist',
                href: 'test_href',
                uri: 'test_uri',
                popularity: 80,
                genres: [],
                followers: null,
                externalUrls: null,
                images: null,
              ),
            ],
            externalUrls: null,
            images: null,
          ),
        ],
      ),
    );

    test(
      'should return AlbumsResponse when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.searchAlbums(
              query: any(named: 'query'),
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            )).thenAnswer((_) async => tAlbumsResponse);

        // act
        final result = await repository.searchAlbums(tQuery);

        // assert
        verify(() => mockRemoteDataSource.searchAlbums(
              query: tQuery,
              limit: 20,
              offset: 0,
            )).called(1);
        expect(result, isA<AlbumsResponse>());
        expect(result.items.length, 1);
        expect(result.items.first.name, 'Test Album');
      },
    );
  });
} 