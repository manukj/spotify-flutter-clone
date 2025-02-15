import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotify_flutter/features/search/presentation/controllers/search_controller.dart' as spotify;

class SpotifyFilterChips extends GetView<spotify.SearchController> {
  const SpotifyFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Obx(() => _FilterChip(
                label: 'Artists',
                isSelected: controller.isArtistSelected.value,
                onSelected: (_) => controller.selectArtist(),
              )),
          const SizedBox(width: 8),
          Obx(() => _FilterChip(
                label: 'Albums',
                isSelected: controller.isAlbumSelected.value,
                onSelected: (_) => controller.selectAlbum(),
              )),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.white.withOpacity(0.1),
      selectedColor: const Color(0xFF1DB954), // Spotify green
      checkmarkColor: Colors.transparent,
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
} 