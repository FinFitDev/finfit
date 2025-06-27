import 'package:excerbuys/types/owner.dart';
import 'package:excerbuys/utils/debug.dart';
import 'package:excerbuys/utils/parsers/parsers.dart';
import 'package:excerbuys/utils/utils.dart';

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
  final List<String>? images;
  final String category;
  final int totalTransactions;
  final bool? isAffordable;
  final List<IProductVariant>? variants;
  final String referenceId;
  final int inStock;
  final List<String>? unavaialbleDeliveryMethods;
  final bool? isDigital;

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
    this.images,
    required this.category,
    required this.totalTransactions,
    this.isAffordable,
    this.variants,
    required this.referenceId,
    required this.inStock,
    this.unavaialbleDeliveryMethods,
    this.isDigital,
  });

  List<String> get variantsMainImages {
    if (variants == null || images == null) return [];

    final imageList = variants!
        .map((v) =>
            v.images?.isNotEmpty == true ? images![v.images!.first] : null)
        .whereType<String>()
        .toSet()
        .toList();

    return imageList;
  }

  List<String> get initialCarouselImages {
    final fallbackVariant = variants
        ?.where(
          (v) => v.images != null && v.images!.isNotEmpty,
        )
        .firstOrNull;

    if (fallbackVariant != null && images != null) {
      return selectByIndices(images ?? [], fallbackVariant.images ?? []);
    } else {
      return images ?? [];
    }
  }

  String? get mainImage {
    if (images == null || images!.isEmpty) {
      return null;
    }

    final firstVariantWithImage = variants
        ?.where(
          (v) => v.images != null && v.images!.isNotEmpty,
        )
        .firstOrNull;

    if (firstVariantWithImage != null) {
      return images![firstVariantWithImage.images!.first];
    }

    return images!.first;
  }

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
      'images': images,
      'category': category.toString(),
      'total_transactions': totalTransactions,
      'isAffordable': isAffordable,
      'variants': variants?.map((variant) => variant.toJson()).toList(),
      'reference_id': referenceId,
      'in_stock': inStock,
      'unavailable_delivery_methods': unavaialbleDeliveryMethods,
      'is_digital': isDigital,
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
        images:
            json['images'] != null ? List<String>.from(json['images']) : null,
        category: json['category'],
        totalTransactions: json['total_transactions'],
        isAffordable: json['is_affordable'],
        variants: (json['variants'] as List<dynamic>?)
            ?.map((variant) => IProductVariant.fromJson(variant))
            .toList(),
        referenceId: json['reference_id'],
        inStock: parseInt(json['in_stock']),
        unavaialbleDeliveryMethods:
            (json['unavailable_delivery_methods'] as List?)
                ?.map((e) => e.toString())
                .toList(),
        isDigital: json['is_digital'] == null
            ? null
            : json['is_digital'] is bool
                ? json['is_digital']
                : bool.parse(json['is_digital']));
  }
}

class IProductVariant {
  final String id;
  final double discount;
  final double price;
  final int inStock;
  // image indices
  final List<int>? images;
  final Map<String, String> attributes;

  IProductVariant({
    required this.id,
    required this.discount,
    required this.price,
    required this.inStock,
    this.images,
    required this.attributes,
  });

  bool get available => inStock > 0;

  factory IProductVariant.fromJson(Map<String, dynamic> json) {
    return IProductVariant(
      id: json['id'],
      discount: (json['discount'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      inStock: parseInt(json['in_stock'] ?? '0'),
      images: json['images'] != null ? List<int>.from(json['images']) : null,
      attributes: Map<String, String>.from(json['attributes'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'discount': discount,
      'price': price,
      'in_stock': inStock,
      'images': images,
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

  String createAttributesString() {
    return attributes.entries
        .map((e) =>
            '${capitalizeFirst(e.key.toLowerCase())}: ${capitalizeFirst(e.value.toLowerCase())}')
        .join(' | ');
  }
}
