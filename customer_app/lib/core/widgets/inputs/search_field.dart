import 'package:flutter/material.dart';
import 'app_text_field.dart';

class SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final VoidCallback? onClear;
  final VoidCallback? onFilterTap;

  const SearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText = 'Search deals, stores, products...',
    this.onClear,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      prefixIcon: const Icon(Icons.search),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onClear != null && (controller?.text.isNotEmpty ?? false))
            IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: onClear,
            ),
          if (onFilterTap != null)
            IconButton(
              icon: const Icon(Icons.tune, size: 20),
              onPressed: onFilterTap,
            ),
        ],
      ),
    );
  }
}
