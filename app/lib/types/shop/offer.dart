import 'package:excerbuys/types/partner.dart';

class IOfferEntry {
  final BigInt id;
  final String description;
  final IPartnerEntry partner;
  final double points;
  final String validUntil;
  final String createdAt;
  final bool? featured;
  final BigInt totalRedeemed;

  IOfferEntry({
    required this.id,
    required this.description,
    required this.partner,
    required this.points,
    required this.validUntil,
    required this.createdAt,
    this.featured,
    required this.totalRedeemed,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(), // ✅ BigInt → String
      'description': description,
      'partner': partner.toJson(),
      'points': points,
      'valid_until': validUntil,
      'created_at': createdAt,
      'featured': featured,
      'total_redeemed': totalRedeemed.toString(), // ✅ BigInt → String
    };
  }

  factory IOfferEntry.fromJson(Map<String, dynamic> json) {
    return IOfferEntry(
      id: BigInt.parse(json['id'].toString()),
      description: json['description'] ?? '',
      partner: IPartnerEntry.fromJson(json['partner']),
      points: (json['points'] as num?)?.toDouble() ?? 0,
      validUntil: json['valid_until'] ?? '',
      createdAt: json['created_at'] ?? '',
      featured: json['featured'],
      totalRedeemed: BigInt.parse((json['total_redeemed'] ?? '0').toString()),
    );
  }
}
