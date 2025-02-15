import 'package:flutter/material.dart';

class SpotifySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final VoidCallback? onClear;

  const SpotifySearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
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
    );
  }
}
