import 'package:excerbuys/types/owner.dart';
import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/types/user.dart';

class ITransactionEntry {
  final String uuid;
  final String type;
  final String createdAt;
  final double? amountFinpoints;
  final IProductEntry? product;
  final User? secondUser;

  ITransactionEntry({
    required this.uuid,
    required this.type,
    required this.createdAt,
    this.amountFinpoints,
    this.product,
    this.secondUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'type': type,
      'second_user': secondUser.toString(),
      'amount_finpoints': amountFinpoints,
      'created_at': createdAt,
      'product': product?.toJson(),
    };
  }

  factory ITransactionEntry.fromJson(Map<String, dynamic> json) {
    return ITransactionEntry(
      uuid: json['uuid'],
      type: json['type'],
      secondUser: json['second_user'] != null
          ? User.fromJson(json['second_user'])
          : null,
      amountFinpoints: (json['amount_finpoints'] as num?)?.toDouble(),
      createdAt: json['created_at'],
      product: json['product'] != null
          ? IProductEntry.fromJson(json['product'])
          : null,
    );
  }
}
