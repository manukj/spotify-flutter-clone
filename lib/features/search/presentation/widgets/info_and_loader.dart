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
        return SizedBox(
          height: MediaQuery.of(context).size.height *
              0.4, // Adjust height as needed
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.error.value != null) {
        return _buildErrorState(context);
      }

      if (controller.query.value.isEmpty) {
        return _buildEmptySearchState(context);
      }

      if (controller.isArtistSelected.value &&
          controller.artistsResponse.value?.items.isEmpty == true) {
        return _buildNoResultsState(context, 'Artists');
      }

      if (controller.isAlbumSelected.value &&
          controller.albumsResponse.value?.items.isEmpty == true) {
        return _buildNoResultsState(context, 'Albums');
      }

      return const SizedBox.shrink();
    });
  }

  Widget _buildEmptySearchState(BuildContext context) {
    final searchType = controller.isArtistSelected.value ? 'Artists' : 'Albums';
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
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
    );
  }

  Widget _buildNoResultsState(BuildContext context, String type) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
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
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
