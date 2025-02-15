import 'package:flutter/material.dart';

class SpotifySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final VoidCallback? onClear;
  final bool isAlbumSelected;
  final bool isArtistSelected;
  final ValueChanged<bool>? onAlbumSelected;
  final ValueChanged<bool>? onArtistSelected;

  const SpotifySearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText,
    this.onClear,
    this.isAlbumSelected = false,
    this.isArtistSelected = false,
    this.onAlbumSelected,
    this.onArtistSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  cursorColor: Colors.black,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText ?? 'Artists, albums...',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black.withOpacity(0.6),
                      size: 24,
                    ),
                    suffixIcon: value.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.black.withOpacity(0.6),
                              size: 24,
                            ),
                            onPressed: () {
                              controller.clear();
                              onClear?.call();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _FilterChip(
                label: 'Albums',
                isSelected: isAlbumSelected,
                onSelected: onAlbumSelected,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Artists',
                isSelected: isArtistSelected,
                onSelected: onArtistSelected,
              ),
            ],
          ),
        ),
      ],
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
