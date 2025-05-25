import 'package:excerbuys/types/owner.dart';

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
  final String category;
  final int totalTransactions;
  final bool? isAffordable;
  final List<IProductVariant>? variants;
  final List<String>? images;

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
    this.variants,
    this.images,
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
      'variants': variants?.map((variant) => variant.toJson()).toList(),
      'images': images,
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
      category: json['category'],
      totalTransactions: json['total_transactions'],
      isAffordable: json['is_affordable'],
      variants: (json['variants'] as List<dynamic>?)
          ?.map((variant) => IProductVariant.fromJson(variant))
          .toList(),
      images: json['images'] != null ? List<String>.from(json['images']) : null,
    );
  }
}

class IProductVariant {
  final String id;
  final double discount;
  final double price;
  final bool available;
  final Map<String, String> attributes;

  IProductVariant({
    required this.id,
    required this.discount,
    required this.price,
    required this.available,
    required this.attributes,
  });

  factory IProductVariant.fromJson(Map<String, dynamic> json) {
    return IProductVariant(
      id: json['id'],
      discount: (json['discount'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      available: json['available'],
      attributes: Map<String, String>.from(json['attributes'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'discount': discount,
      'price': price,
      'available': available,
      'attributes': attributes,
    };
  }

  bool hasSameAttributes(Map<String, String> otherAttributes) {
    if (attributes.length != otherAttributes.length) return false;
    for (final key in attributes.keys) {
      if (attributes[key] != otherAttributes[key]) return false;
    }

    return true;
  }
}
