import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_spacing.dart';

/// Search bar matching the reference design: clean rounded input with cycling "Search for [Item]".
class SearchEntryBar extends StatefulWidget {
  const SearchEntryBar({super.key});

  @override
  State<SearchEntryBar> createState() => _SearchEntryBarState();
}

class _SearchEntryBarState extends State<SearchEntryBar> {
  static const List<String> _searchKeywords = [
    'Soap',
    'Biscuits',
    'Rice',
    'Detergent',
    'Tea & Coffee',
    'Chocolates',
    'Atta & Flour',
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 2800), (_) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _searchKeywords.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentKeyword = _searchKeywords[_currentIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 4,
      ),
      child: GestureDetector(
        onTap: () => context.push('/search'),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFD1D5DB), // Light grey matching reference
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                color: Color(0xFF374151),
                size: 22,
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  const Text(
                    'Search for ',
                    style: TextStyle(
                      fontSize: 14.5,
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.4),
                          end: Offset.zero,
                        ).animate(animation),
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: Text(
                      currentKeyword,
                      key: ValueKey<String>(currentKeyword),
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
