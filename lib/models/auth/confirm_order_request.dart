class CancelOrderRequest {
  final bool isConfirmOrder;

  CancelOrderRequest({required this.isConfirmOrder});

  Map<String, dynamic> toJson() {
    return {
      'isConfirmOrder': isConfirmOrder,
    };
  }
}