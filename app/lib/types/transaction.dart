import 'package:excerbuys/types/shop/offer.dart';
import 'package:excerbuys/types/user.dart';

class ITransactionEntry {
  final String uuid;
  final String type;
  final DateTime createdAt;
  final double? amountPoints;
  final IOfferEntry? offer;
  final List<User>? secondUsers;

  ITransactionEntry({
    required this.uuid,
    required this.type,
    required this.createdAt,
    this.amountPoints,
    this.offer,
    this.secondUsers,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'type': type,
      'second_users': secondUsers?.map((el) => el.toString()).toList() ?? [],
      'amount_points': amountPoints,
      'created_at': createdAt.toIso8601String(),
      'offer': offer?.toJson(),
    };
  }

  factory ITransactionEntry.fromJson(Map<String, dynamic> json) {
    return ITransactionEntry(
      uuid: json['uuid'],
      type: json['type'],
      secondUsers: (json['second_users'] as List<dynamic>?)
          ?.map((variant) => User.fromJson(variant))
          .toList(),
      amountPoints: (json['amount_points'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      offer: json['offer'] != null ? IOfferEntry.fromJson(json['offer']) : null,
    );
  }
}
