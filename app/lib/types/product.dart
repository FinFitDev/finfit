import 'package:excerbuys/types/enums.dart';
import 'package:excerbuys/types/owner.dart';
import 'package:excerbuys/utils/shop/product/utils.dart';

class IProductEntry {
  final String uuid;
  final String name;
  final String description;
  final IProductOwnerEntry owner;
  final double originalPrice;
  final double finpointsPrice;
  final double discount;
  final String createdAt;
  final String? link;
  final String? image;
  final PRODUCT_CATEGORY category;
  final int totalTransactions;
  final bool? isAffordable;

  IProductEntry({
    required this.uuid,
    required this.name,
    required this.description,
    required this.owner,
    required this.originalPrice,
    required this.finpointsPrice,
    required this.discount,
    required this.createdAt,
    this.link,
    this.image,
    required this.category,
    required this.totalTransactions,
    this.isAffordable,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'description': description,
      'product_owner': owner.toJson(),
      'original_price': originalPrice,
      'finpoints_price': finpointsPrice,
      'discount': discount,
      'created_at': createdAt,
      'link': link,
      'image': image,
      'category': category.toString(),
      'total_transactions': totalTransactions,
      'isAffordable': isAffordable,
    };
  }

  factory IProductEntry.fromJson(Map<String, dynamic> json) {
    return IProductEntry(
      uuid: json['uuid'],
      name: json['name'],
      description: json['description'],
      owner: IProductOwnerEntry.fromJson(json['product_owner']),
      originalPrice: (json['original_price'] as num).toDouble(),
      finpointsPrice: (json['finpoints_price'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      createdAt: json['created_at'],
      link: json['link'],
      image: json['image'],
      category: productCategoryStringToEnum(json['category']),
      totalTransactions: json['total_transactions'],
      isAffordable: json['is_affordable'],
    );
  }
}
