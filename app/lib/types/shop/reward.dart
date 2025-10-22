import 'package:excerbuys/types/shop/offer.dart';

class IClaimEntry {
  final String code;
  final IOfferEntry offer;
  final String validUntil;
  final String createdAt;

  IClaimEntry({
    required this.code,
    required this.offer,
    required this.validUntil,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'offer': offer.toJson(),
      'validUntil': validUntil,
      'createdAt': createdAt,
    };
  }

  factory IClaimEntry.fromJson(Map<String, dynamic> json) {
    return IClaimEntry(
      code: json['code'] ?? '',
      offer: IOfferEntry.fromJson(json['offer']),
      validUntil: json['valid_until'] ?? json['validUntil'] ?? '',
      createdAt: json['created_at'] ?? json['createdAt'] ?? '',
    );
  }
}
