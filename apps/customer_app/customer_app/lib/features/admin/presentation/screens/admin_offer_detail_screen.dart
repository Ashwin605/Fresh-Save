import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import 'package:go_router/go_router.dart';

final adminOfferDetailProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, id) async {
  // Let's just mock or fetch from the offers list since we don't have a specific GET /admin/offers/:id in controller.
  // Wait, we didn't add GET /admin/offers/:id! Let's just fetch all and find it, or we can just fetch the whole list again.
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/admin/offers', queryParameters: {'page': 1, 'limit': 100});
  final data = response.data['data'] as List;
  return data.firstWhere((o) => o['id'] == id, orElse: () => <String, dynamic>{});
});

class AdminOfferDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const AdminOfferDetailScreen({super.key, required this.id});

  @override
  ConsumerState<AdminOfferDetailScreen> createState() => _AdminOfferDetailScreenState();
}

class _AdminOfferDetailScreenState extends ConsumerState<AdminOfferDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(adminOfferDetailProvider(widget.id));

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Offer Details', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: dataAsync.when(
        data: (offer) => _buildContent(offer),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> offer) {
    if (offer.isEmpty) {
      return const Center(child: Text('Offer not found.'));
    }

    final isStatusActive = offer['status'] == 'ACTIVE';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: AppColors.surface,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Offer: ${offer['title'] ?? 'Untitled'}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: offer['status'],
                        items: const [
                          DropdownMenuItem(value: 'DRAFT', child: Text('DRAFT')),
                          DropdownMenuItem(value: 'SCHEDULED', child: Text('SCHEDULED')),
                          DropdownMenuItem(value: 'ACTIVE', child: Text('ACTIVE')),
                          DropdownMenuItem(value: 'EXPIRED', child: Text('EXPIRED')),
                          DropdownMenuItem(value: 'DISABLED', child: Text('DISABLED')),
                        ],
                        onChanged: (val) async {
                          if (val != null) {
                            try {
                              final dio = ref.read(dioProvider);
                              await dio.patch('/admin/offers/${offer['id']}', data: {'status': val});
                              ref.invalidate(adminOfferDetailProvider(widget.id));
                            } catch (e) {
                              // Ignore
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Description: ${offer['description'] ?? 'N/A'}'),
                  Text('Discount: ${offer['discountValue']} (${offer['discountType']})'),
                  Text('Valid: ${offer['startsAt']} to ${offer['endsAt']}'),
                  Text('Inventory ID: ${offer['inventoryId']}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
