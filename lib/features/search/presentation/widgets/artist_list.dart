import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_flutter/features/search/presentation/controllers/search_controller.dart'
    as spotify;
import 'package:spotify_flutter/features/search/presentation/widgets/artist_item.dart';

class ArtistList extends GetView<spotify.SearchController> {
  const ArtistList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final showArtists = controller.isArtistSelected.value &&
          controller.artistsResponse.value?.items.isNotEmpty == true;

      if (!showArtists) {
        return const SizedBox.shrink();
      }
      return Expanded(
        child: ListView.builder(
          itemCount: controller.artistsResponse.value?.items.length ?? 0,
          itemBuilder: (context, index) {
            final artist = controller.artistsResponse.value!.items[index];
            return ArtistItem(artist: artist);
          },
        ),
      );
    });
  }
}
