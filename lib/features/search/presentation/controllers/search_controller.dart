import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/debouncer.dart';
import '../../domain/entities/albums_response.dart';
import '../../domain/entities/artists_response.dart';
import '../../domain/usecases/search_albums.dart';
import '../../domain/usecases/search_artists.dart';

class SearchController extends GetxController {
  final SearchArtists searchArtists;
  final SearchAlbums searchAlbums;
  final _debouncer = Debouncer();
  final searchController = TextEditingController();

  SearchController({
    required this.searchArtists,
    required this.searchAlbums,
  });

  final isLoading = false.obs;
  final query = ''.obs;
  final artistsResponse = Rxn<ArtistsResponse>();
  final albumsResponse = Rxn<AlbumsResponse>();
  final error = Rxn<String>();
  final isArtistSelected = false.obs;
  final isAlbumSelected = false.obs;

  @override
  void onClose() {
    _debouncer.dispose();
    searchController.dispose();
    super.onClose();
  }

  void onSearchQueryChanged(String searchQuery) {
    if (searchQuery.isEmpty) {
      clearSearch();
      return;
    }
    
    error.value = null;
    query.value = searchQuery;
    isLoading.value = true;
    
    _debouncer.run(() => _search(searchQuery));
  }

  Future<void> _search(String searchQuery) async {
    if (searchQuery.isEmpty) return;

    try {
      if (!isArtistSelected.value && !isAlbumSelected.value) {
        final results = await Future.wait([
          searchArtists(searchQuery),
          searchAlbums(searchQuery),
        ]);
        artistsResponse.value = results[0] as ArtistsResponse;
        albumsResponse.value = results[1] as AlbumsResponse;
      } else {
        if (isArtistSelected.value) {
          artistsResponse.value = await searchArtists(searchQuery);
          albumsResponse.value = null;
        }
        if (isAlbumSelected.value) {
          albumsResponse.value = await searchAlbums(searchQuery);
          artistsResponse.value = null;
        }
      }
    } catch (e) {
      error.value = e.toString();
      artistsResponse.value = null;
      albumsResponse.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    _debouncer.dispose();
    searchController.clear();
    query.value = '';
    artistsResponse.value = null;
    albumsResponse.value = null;
    error.value = null;
    isArtistSelected.value = false;
    isAlbumSelected.value = false;
    isLoading.value = false;
  }
}
