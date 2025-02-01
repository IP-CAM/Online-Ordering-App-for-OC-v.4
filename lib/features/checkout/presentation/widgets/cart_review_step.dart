import 'package:flutter/material.dart';
import 'package:ordering_app/core/utils/helpers.dart';
import 'package:ordering_app/features/checkout/domain/entities/cart_item_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/cart_summary_entity.dart';

class CartReviewStep extends Step {
  CartReviewStep({
    required bool showProgressIndicator,
    required CartSummaryEntity? summary,
    required int currentStep,
  }) : super(
          title: const Text('Review Cart'),
          content: _CartReviewContent(
            showProgressIndicator: showProgressIndicator,
            summary: summary,
          ),
          isActive: currentStep >= 0,
        );
}

class _CartReviewContent extends StatelessWidget {
  final bool showProgressIndicator;
  final CartSummaryEntity? summary;

  const _CartReviewContent({
    required this.showProgressIndicator,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return showProgressIndicator
        ? const CircularProgressIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCartItemsList(context),
            ],
          );
  }

  Widget _buildCartItemsList(BuildContext context) {
    final theme = Theme.of(context);

    if (summary == null) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: summary!.products.length,
      itemBuilder: (context, index) {
        final item = summary!.products[index];
        return Card(
          elevation: theme.brightness == Brightness.light ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: theme.brightness == Brightness.dark
                ? BorderSide(color: theme.colorScheme.outline)
                : BorderSide.none,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: item.image != null && item.image != ''
                              ? Image.network(
                                  item.image!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  color: theme.colorScheme.surfaceVariant,
                                  child: Icon(
                                    Icons.image,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                decodeHtmlEntities(item.name),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (item.model.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.model,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (item.options != null && item.options!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildOptionsSection(context, item),
                    ],
                    const SizedBox(height: 12),
                    _buildQuantityAndPrice(context, item),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionsSection(BuildContext context, CartItemEntity item) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Options',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...item.options!.map((option) => _buildOptionItem(context, option)),
        ],
      ),
    );
  }

  Widget _buildOptionItem(BuildContext context, CartItemOptionEntity option) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            decodeHtmlEntities(option.name),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            option.value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityAndPrice(BuildContext context, CartItemEntity item) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Quantity: ${item.quantity}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              item.total,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            if (item.price != item.total)
              Text(
                '${item.price} each',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ],
    );
  }
}