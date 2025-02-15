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
  final isArtistSelected = true.obs;
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
      if (isArtistSelected.value) {
        artistsResponse.value = await searchArtists(searchQuery);
      } else if (isAlbumSelected.value) {
        albumsResponse.value = await searchAlbums(searchQuery);
      }
    } catch (e) {
      error.value = e.toString();
      if (isArtistSelected.value) {
        artistsResponse.value = null;
      } else if (isAlbumSelected.value) {
        albumsResponse.value = null;
      }
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
    isArtistSelected.value = true;
    isAlbumSelected.value = false;
    isLoading.value = false;
  }

  void selectAlbum() {
    if (isAlbumSelected.value) return;
    isAlbumSelected.value = true;
    isArtistSelected.value = false;
    if (query.value.isNotEmpty &&
        albumsResponse.value?.items.isEmpty != false) {
      _refreshSearchIfNeeded();
    }
  }

  void selectArtist() {
    if (isArtistSelected.value) return;
    isArtistSelected.value = true;
    isAlbumSelected.value = false;
    if (query.value.isNotEmpty &&
        artistsResponse.value?.items.isEmpty != false) {
      _refreshSearchIfNeeded();
    }
  }

  void _refreshSearchIfNeeded() {
    isLoading.value = true;
    error.value = null;
    _search(query.value);
  }
}
