import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_flutter/features/search/presentation/controllers/search_controller.dart'
    as spotify;

class InfoAndLoader extends GetView<spotify.SearchController> {
  const InfoAndLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Expanded(
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.error.value != null) {
        return _buildErrorState();
      }

      if (controller.query.value.isEmpty) {
        return _buildEmptySearchState();
      }

      if (controller.isArtistSelected.value &&
          controller.artistsResponse.value?.items.isEmpty == true) {
        return _buildNoResultsState('artists');
      }

      if (controller.isAlbumSelected.value &&
          controller.albumsResponse.value?.items.isEmpty == true) {
        return _buildNoResultsState('albums');
      }

      return const SizedBox(width: 0, height: 0);
    });
  }

  Widget _buildEmptySearchState() {
    final searchType = controller.isArtistSelected.value ? 'artists' : 'albums';
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Search',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white.withAlpha(204),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchType,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withAlpha(153),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState(String type) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Couldn\'t find "$type"',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white.withAlpha(204),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Go online to search again.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withAlpha(153),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white.withAlpha(204),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.error.value ?? 'Please try again.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withAlpha(153),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
