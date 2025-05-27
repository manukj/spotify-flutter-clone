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
        return const SliverToBoxAdapter(
          key: Key('empty_album_widget'),
          child: SizedBox.shrink(),
        );
      }

      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final album = controller.albumsResponse.value!.items[index];
            return AlbumItem(album: album);
          },
          childCount: controller.albumsResponse.value?.items.length ?? 0,
        ),
      );
    });
  }
}
