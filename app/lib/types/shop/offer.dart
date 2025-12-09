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
  final String catchString;
  final String details;
  final String? image;
  final int? codeExpirationPeriod;

  IOfferEntry(
      {required this.id,
      required this.description,
      required this.partner,
      required this.points,
      required this.validUntil,
      required this.createdAt,
      this.featured,
      required this.totalRedeemed,
      required this.catchString,
      required this.details,
      this.image,
      this.codeExpirationPeriod});

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'description': description,
      'partner': partner.toJson(),
      'points': points,
      'valid_until': validUntil,
      'created_at': createdAt,
      'featured': featured,
      'total_redeemed': totalRedeemed.toString(),
      'catch': catchString,
      'details': details,
      'image': image,
      'code_expiration_period': codeExpirationPeriod.toString()
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
        catchString: json['catch'] ?? '',
        details: json['details'] ?? '',
        image: json['image'],
        codeExpirationPeriod: json['code_expiration_period'] != null
            ? int.tryParse(json['code_expiration_period'].toString())
            : null);
  }
}
