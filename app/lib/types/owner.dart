import 'package:excerbuys/utils/parsers/parsers.dart';

class IProductOwnerEntry {
  final String uuid;
  final String name;
  final String description;
  final String createdAt;
  final int totalTransactions;
  final int totalProducts;
  final String? link;
  final String? image;
  final String? bannerImage;

  IProductOwnerEntry({
    required this.uuid,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.totalTransactions,
    required this.totalProducts,
    this.link,
    this.image,
    this.bannerImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'description': description,
      'created_at': createdAt,
      'total_transactions': totalTransactions,
      'link': link,
      'image': image,
      'banner_image': bannerImage,
      'total_products': totalProducts,
    };
  }

  factory IProductOwnerEntry.fromJson(Map<String, dynamic> json) {
    return IProductOwnerEntry(
        uuid: json['uuid'],
        name: json['name'],
        description: json['description'],
        createdAt: json['created_at'],
        totalTransactions: json['total_transactions'] ?? 0,
        link: json['link'],
        image: json['image'],
        bannerImage: json['banner_image'],
        totalProducts: parseInt((json['total_products'])));
  }
}
