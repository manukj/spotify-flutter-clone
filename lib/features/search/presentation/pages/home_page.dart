import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_flutter/features/search/presentation/controllers/search_controller.dart'
    as spotify;
import 'package:spotify_flutter/features/search/presentation/widgets/album_list.dart';
import 'package:spotify_flutter/features/search/presentation/widgets/artist_list.dart';
import 'package:spotify_flutter/features/search/presentation/widgets/filter_chip.dart';
import 'package:spotify_flutter/features/search/presentation/widgets/info_and_loader.dart';
import 'package:spotify_flutter/features/search/presentation/widgets/search_bar.dart';

class HomePage extends GetView<spotify.SearchController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                floating: false,
                backgroundColor: Theme.of(context).colorScheme.surface,
                expandedHeight: 120,
                collapsedHeight: 80,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1.0,
                  titlePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  title: SpotifySearchBar(
                    controller: controller.searchController,
                    onChanged: controller.onSearchQueryChanged,
                    onClear: controller.clearSearch,
                  ),
                  background: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Search',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            body: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: const [
                        SpotifyFilterChips(),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: const [
                        InfoAndLoader(),
                        AlbumList(),
                        ArtistList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
