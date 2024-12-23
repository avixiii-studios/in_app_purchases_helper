enum PurchaseStatus {
  successful,
  pending,
  error,
  restored,
}

class PurchaseResult {
  final String productId;
  final PurchaseStatus status;
  final String? error;
  final String? transactionId;
  final DateTime purchaseTime;

  PurchaseResult({
    required this.productId,
    required this.status,
    this.error,
    this.transactionId,
    DateTime? purchaseTime,
  }) : purchaseTime = purchaseTime ?? DateTime.now();
}
