import 'package:excerbuys/types/product.dart';
import 'package:excerbuys/types/shop/offer.dart';
import 'package:excerbuys/types/user.dart';

class ITransactionEntry {
  final String uuid;
  final String type;
  final DateTime createdAt;
  final double? amountPoints;
  final IOfferEntry? offer;
  final User? secondUser;

  ITransactionEntry({
    required this.uuid,
    required this.type,
    required this.createdAt,
    this.amountPoints,
    this.offer,
    this.secondUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'type': type,
      'second_user': secondUser.toString(),
      'amount_points': amountPoints,
      'created_at': createdAt,
      'offer': offer?.toJson(),
    };
  }

  factory ITransactionEntry.fromJson(Map<String, dynamic> json) {
    return ITransactionEntry(
      uuid: json['uuid'],
      type: json['type'],
      secondUser: json['second_user'] != null
          ? User.fromJson(json['second_user'])
          : null,
      amountPoints: (json['amount_points'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      offer: json['offer'] != null ? IOfferEntry.fromJson(json['offer']) : null,
    );
  }
}
