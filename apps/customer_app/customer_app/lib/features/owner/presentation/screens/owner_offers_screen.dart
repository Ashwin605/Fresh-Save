import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';

class OwnerOffersScreen extends StatelessWidget {
  const OwnerOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Offers', style: AppTypography.title),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: const Center(child: Text('Offers Foundation')),
    );
  }
}
