import 'package:flutter/material.dart';
import 'package:ordering_app/features/checkout/domain/entities/checkout_summary_entity.dart';

class OrderConfirmationStep extends Step {
  OrderConfirmationStep({
    required CheckoutSummaryEntity? checkoutSummary,
    required TextEditingController commentController,
    required int currentStep,
  }) : super(
          title: const Text('Order Confirmation'),
          content: _OrderConfirmationContent(
            checkoutSummary: checkoutSummary,
            commentController: commentController,
          ),
          isActive: currentStep >= 4,
        );
}

class _OrderConfirmationContent extends StatelessWidget {
  final CheckoutSummaryEntity? checkoutSummary;
  final TextEditingController commentController;

  const _OrderConfirmationContent({
    required this.checkoutSummary,
    required this.commentController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 2,
        shadowColor: Theme.of(context).colorScheme.inverseSurface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Review Order Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please verify all information before placing your order.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
              ),
              const Divider(height: 32),
              if (checkoutSummary != null) ...[
                _buildSectionTitle('Delivery Method'),
                _buildInfoTile(
                  icon: Icons.local_shipping,
                  title: checkoutSummary!.shippingMethod.shippingMethod,
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Payment Method'),
                _buildInfoTile(
                  icon: Icons.payment,
                  title: checkoutSummary!.paymentMethod.title,
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Shipping Address'),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${checkoutSummary!.shippingAddress.firstName} ${checkoutSummary!.shippingAddress.lastName}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(checkoutSummary!.shippingAddress.address1),
                      if (checkoutSummary!.shippingAddress.address2 != null)
                        Text(checkoutSummary!.shippingAddress.address2!),
                      Text(
                          '${checkoutSummary!.shippingAddress.city}, ${checkoutSummary!.shippingAddress.postcode}'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Order Summary'),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildPriceLine(
                        'Subtotal',
                        checkoutSummary!.checkoutTotals.subTotal,
                        isTotal: false,
                      ),
                      ...checkoutSummary!.checkoutTotals.appliedTotals
                          .map((total) => _buildPriceLine(
                                total.title,
                                total.value,
                                isTotal: false,
                              )),
                      if (checkoutSummary!.checkoutTotals.taxes.isNotEmpty) ...[
                        const Divider(),
                        ...checkoutSummary!.checkoutTotals.taxes
                            .map((tax) => _buildPriceLine(
                                  tax.title,
                                  tax.value.toString(),
                                  isTotal: false,
                                )),
                      ],
                      const Divider(),
                      _buildPriceLine(
                        'Total',
                        checkoutSummary!.checkoutTotals.total,
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: 'Order Comments (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade600),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceLine(String label, String amount, {required bool isTotal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}