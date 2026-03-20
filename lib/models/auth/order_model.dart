class OrderProduct {
  final String name;
  final int qty;
  final double price;
  final String store;
  final String imageUrl;
  final double subtotal;

  OrderProduct({
    required this.name,
    required this.qty,
    required this.price,
    required this.store,
    required this.imageUrl,
    required this.subtotal,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      name: json['name'],
      qty: json['qty'],
      price: (json['price'] as num).toDouble(),
      store: json['store'],
      imageUrl: json['imageUrl'],
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "qty": qty,
      "price": price,
      "store": store,
      "imageUrl": imageUrl,
      "subtotal": subtotal,
    };
  }
}

class OrderRequest {
  final double deliveryFee;
  final String paymentMethod;
  final List<OrderProduct> products;
  final String? remark;
  final String? estimatedDeliveryTime;
  final double? totalDiscount;
  final double? latitude;
  final double? longitude;

  OrderRequest({
    required this.deliveryFee,
    required this.paymentMethod,
    required this.products,
    this.remark,
    this.estimatedDeliveryTime,
    this.totalDiscount,
    this.latitude,
    this.longitude,
  });

  factory OrderRequest.fromJson(Map<String, dynamic> json) {
    return OrderRequest(
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      paymentMethod: json['payment_method'],
      products: (json['products'] as List)
          .map((e) => OrderProduct.fromJson(e))
          .toList(),
      remark: json['remark'],
      estimatedDeliveryTime: json['estimated_delivery_time'],
      totalDiscount: json['total_discount'] != null
          ? (json['total_discount'] as num).toDouble()
          : null,
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "delivery_fee": deliveryFee,
      "payment_method": paymentMethod,
      "products": products.map((e) => e.toJson()).toList(),
      if (remark != null) "remark": remark,
      if (estimatedDeliveryTime != null)
        "estimated_delivery_time": estimatedDeliveryTime,
      if (totalDiscount != null) "total_discount": totalDiscount,
      if (latitude != null) "latitude": latitude!.toString(),
      if (longitude != null) "longitude": longitude!.toString(),
    };
  }
}

//for get
class OrderProductModel {
  final String id;
  final String name;
  final int qty;
  final double price;
  final double subtotal;
  final String imageUrl;
  final StoreModel store;

  OrderProductModel({
    required this.id,
    required this.name,
    required this.qty,
    required this.price,
    required this.subtotal,
    required this.imageUrl,
    required this.store,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      id: json['_id'],
      name: json['name'],
      qty: json['qty'],
      price: (json['price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      store: StoreModel.fromJson(json['store']),
    );
  }
}

class AddressModel {
  final double latitude;
  final double longitude;

  AddressModel({required this.latitude, required this.longitude});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
    );
  }
}

class StoreModel {
  final String id;
  final String name;
  final AddressModel? address; // ✅ nullable

  StoreModel({required this.id, required this.name, this.address});

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['_id'],
      name: json['name'],
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : null, // ✅ SAFE
    );
  }
}

class OrderModel {
  final String id;
  final List<OrderProductModel> products;
  final double deliveryFee;
  final double total;
  final String status;
  final String paymentMethod;
  final String? remark;
  final String? estimatedDeliveryTime;
  final double totalDiscount;
  final DateTime createdAt;
  final String? storeurl;
  final String? latitude;
  final String? longitude;

  OrderModel({
    required this.id,
    required this.products,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.paymentMethod,
    this.remark,
    this.estimatedDeliveryTime,
    required this.totalDiscount,
    required this.createdAt,
    this.storeurl,
    this.longitude,
    this.latitude,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? '',
      products: (json['products'] as List? ?? [])
          .map((e) => OrderProductModel.fromJson(e))
          .toList(),
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      remark: json['remark'],
      estimatedDeliveryTime: json['estimated_delivery_time'],
      totalDiscount: (json['total_discount'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}
