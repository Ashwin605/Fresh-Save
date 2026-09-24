import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';

final adminReviewsProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, Map<String, dynamic>>((ref, queryParams) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/admin/reviews', queryParameters: queryParams);
  return response.data;
});

class AdminReviewsScreen extends ConsumerStatefulWidget {
  const AdminReviewsScreen({super.key});

  @override
  ConsumerState<AdminReviewsScreen> createState() => _AdminReviewsScreenState();
}

class _AdminReviewsScreenState extends ConsumerState<AdminReviewsScreen> {
  int _page = 1;
  int? _selectedRating;

  @override
  Widget build(BuildContext context) {
    final query = {'page': _page, 'limit': 20};
    if (_selectedRating != null) {
      query['rating'] = _selectedRating!;
    }
    final dataAsync = ref.watch(adminReviewsProvider(query));

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews & Moderation',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              DropdownButton<int?>(
                value: _selectedRating,
                hint: const Text('All Ratings'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All Ratings')),
                  DropdownMenuItem(value: 5, child: Text('5 Stars')),
                  DropdownMenuItem(value: 4, child: Text('4 Stars')),
                  DropdownMenuItem(value: 3, child: Text('3 Stars')),
                  DropdownMenuItem(value: 2, child: Text('2 Stars')),
                  DropdownMenuItem(value: 1, child: Text('1 Star')),
                ],
                onChanged: (val) => setState(() {
                  _selectedRating = val;
                  _page = 1;
                }),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: dataAsync.when(
              data: (data) => _buildDataView(data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataView(dynamic data) {
    final List items = data is List ? data : (data['data'] as List? ?? []);
    
    if (items.isEmpty) {
      return const Center(child: Text('No reviews found.'));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isHidden = item['status'] == 'HIDDEN';
        final isFlagged = item['status'] == 'FLAGGED';

        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          color: isHidden ? AppColors.surfaceVariant : AppColors.surface,
          child: ListTile(
            title: Row(
              children: [
                Text('${item['rating']} ⭐', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(item['shop']?['name'] ?? 'Unknown Shop', style: const TextStyle(color: AppColors.primary))),
                if (isHidden) const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Chip(label: Text('HIDDEN'), backgroundColor: Colors.grey, labelStyle: TextStyle(color: Colors.white, fontSize: 10)),
                ),
                if (isFlagged) const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Chip(label: Text('FLAGGED'), backgroundColor: Colors.orange, labelStyle: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('"${item['review'] ?? 'No comment'}"', style: const TextStyle(color: AppColors.textPrimary, fontStyle: FontStyle.italic)),
                const SizedBox(height: 4),
                Text('By: ${item['customer']?['name'] ?? 'Anonymous'}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (val) async {
                try {
                  final dio = ref.read(dioProvider);
                  await dio.patch('/admin/reviews/${item['id']}/moderate', data: {'status': val});
                  ref.invalidate(adminReviewsProvider);
                } catch (e) {
                  // Ignore
                }
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(value: 'VISIBLE', child: Text('Approve (VISIBLE)')),
                const PopupMenuItem(value: 'HIDDEN', child: Text('Hide (HIDDEN)')),
                const PopupMenuItem(value: 'FLAGGED', child: Text('Flag (FLAGGED)')),
              ],
            ),
          ),
        );
      },
    );
  }
}
