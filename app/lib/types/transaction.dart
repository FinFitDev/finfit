import 'package:excerbuys/types/shop/product.dart';
import 'package:excerbuys/types/user.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';

class ITransactionEntry {
  final String uuid;
  final String type;
  final DateTime createdAt;
  final double? amountFinpoints;
  final List<TransactionProduct>? products;
  final List<User>? secondUsers;

  ITransactionEntry({
    required this.uuid,
    required this.type,
    required this.createdAt,
    this.amountFinpoints,
    this.products,
    this.secondUsers,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'type': type,
      'second_users': secondUsers != null
          ? secondUsers!.map((user) => user.toString()).toList()
          : [],
      'amount_finpoints': amountFinpoints,
      'created_at': createdAt.toIso8601String(),
      'products': products != null
          ? products!.map((product) => product.toJson()).toList()
          : [],
    };
  }

  factory ITransactionEntry.fromJson(Map<String, dynamic> json) {
    return ITransactionEntry(
      uuid: json['uuid'],
      type: json['type'],
      secondUsers: json['second_users'] != null
          ? (json['second_users'] as List)
              .map((item) => User.fromJson(item))
              .toList()
          : null,
      amountFinpoints: (json['amount_finpoints'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      products: json['products'] != null
          ? (json['products'] as List)
              .map((item) => TransactionProduct.fromJson(item))
              .toList()
          : null,
    );
  }

  double? get totalProductsPrice {
    return products != null && products!.isNotEmpty
        ? products!.fold(0, (prev, el) => (prev ?? 0) + el.calculatedPrice)
        : null;
  }

  int get totalFinpoints {
    return amountFinpoints?.round() ??
        parseInt(products != null && products!.isNotEmpty
            ? products!
                .fold(0, (prev, el) => prev + el.product.finpointsPrice.round())
            : 0);
  }
}

class TransactionProduct {
  final IProductEntry product;
  final String? variantId;
  final int? quantity;
  final bool? eligible;

  TransactionProduct(
      {required this.product, this.variantId, this.quantity, this.eligible});

  Map<String, dynamic> toJson() {
    final json = product.toJson();
    if (variantId != null) json['variant_id'] = variantId;
    if (quantity != null) json['quantity'] = quantity;
    if (eligible != null) json['eligible'] = eligible;
    return json;
  }

  factory TransactionProduct.fromJson(Map<String, dynamic> json) {
    return TransactionProduct(
        product: IProductEntry.fromJson(json['product']),
        variantId: json['variant_id'],
        quantity:
            json['quantity'] != null ? (json['quantity'] as num).toInt() : null,
        eligible:
            json['eligible'] != null ? bool.parse(json['eligible']) : null);
  }

  double get calculatedPrice {
    final originalPrice = ((variantId != null
            ? product.getVariantByVariantId(variantId!)?.price
            : product.originalPrice) ??
        0);
    final discount = 1 -
        ((variantId != null
                    ? product.getVariantByVariantId(variantId!)?.discount
                    : product.discount) ??
                100) /
            100;

    return originalPrice * (eligible == false ? 1 : discount);
  }
}
