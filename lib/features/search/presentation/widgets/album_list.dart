import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_flutter/features/search/presentation/controllers/search_controller.dart'
    as spotify;
import 'package:spotify_flutter/features/search/presentation/widgets/album_item.dart';

class AlbumList extends GetView<spotify.SearchController> {
  const AlbumList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final showAlbums = controller.isAlbumSelected.value &&
          controller.albumsResponse.value?.items.isNotEmpty == true &&
          !controller.isLoading.value;

      if (!showAlbums) {
        return const SizedBox.shrink();
      }
      return Expanded(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.albumsResponse.value?.items.length ?? 0,
          itemBuilder: (context, index) {
            final album = controller.albumsResponse.value!.items[index];
            return AlbumItem(album: album);
          },
        ),
      );
    });
  }
}
