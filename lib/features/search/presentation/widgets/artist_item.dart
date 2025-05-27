import 'package:flutter/material.dart';

import '../../domain/entities/artist.dart';

class ArtistItem extends StatelessWidget {
  static const double _imageSize = 56.0;
  static const double _iconSize = 24.0;
  static const double _borderWidth = 1.0;
  static const double _borderOpacity = 0.1;
  static const double _iconOpacity = 0.6;

  final Artist artist;
  final VoidCallback? onTap;

  const ArtistItem({
    super.key,
    required this.artist,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            _buildArtistImage(context),
            const SizedBox(width: 16),
            Expanded(child: _buildArtistName(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistImage(BuildContext context) {
    return Container(
      width: _imageSize,
      height: _imageSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surface,
        border: artist.images?.firstOrNull?.url == null
            ? _createBorder()
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        artist.images?.firstOrNull?.url ?? '',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(context),
      ),
    );
  }

  Widget _buildErrorPlaceholder(BuildContext context) {
    return Container(
      width: _imageSize,
      height: _imageSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: _createBorder(),
      ),
      child: Center(
        child: Icon(
          Icons.person,
          size: _iconSize,
          color: Theme.of(context).colorScheme.onSurface
              .withOpacity(_iconOpacity),
        ),
      ),
    );
  }

  Border _createBorder() {
    return Border.all(
      color: Colors.white.withOpacity(_borderOpacity),
      width: _borderWidth,
    );
  }

  Widget _buildArtistName(BuildContext context) {
    return Text(
      artist.name,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
