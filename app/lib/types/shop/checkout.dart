import 'package:excerbuys/types/general.dart';
import 'package:excerbuys/types/shop/delivery.dart';
import 'package:excerbuys/types/shop/product.dart';
import 'package:excerbuys/utils/utils.dart';
import 'package:uuid/v4.dart';

class ICartItem implements HasQuantity {
  final String? uuid;
  final IProductEntry product;
  final IProductVariant? variant;
  int quantity;
  final bool? notEligible;

  ICartItem({
    required this.product,
    this.variant,
    this.quantity = 1,
    this.notEligible,
    String? uuid,
  }) : uuid = uuid ?? UuidV4().generate();

  ICartItem copyWith(
      {IProductEntry? product,
      IProductVariant? variant,
      int? quantity,
      bool? notEligible}) {
    return ICartItem(
        product: product ?? this.product,
        variant: variant ?? this.variant,
        quantity: quantity ?? this.quantity,
        notEligible: notEligible ?? this.notEligible,
        uuid: this.uuid);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ICartItem &&
          runtimeType == other.runtimeType &&
          uuid == other.uuid;

  bool isEqualParamsSet(ICartItem other) {
    return product.uuid == other.product.uuid &&
        variant?.id == other.variant?.id;
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'product': product.toJson(),
        'variant': variant?.toJson(),
        'quantity': quantity,
        'notEligible': notEligible,
      };

  factory ICartItem.fromJson(Map<String, dynamic> json) {
    return ICartItem(
      uuid: json['uuid'],
      product: IProductEntry.fromJson(json['product']),
      variant: json['variant'] != null
          ? IProductVariant.fromJson(json['variant'])
          : null,
      quantity: json['quantity'] ?? 1,
      notEligible: json['notEligible'],
    );
  }

  double getPrice({bool? isEligible}) {
    isEligible ??= !(notEligible ?? false);

    return (variant?.price ?? product.originalPrice) *
        (isEligible
            ? (100 - (variant?.discount ?? product.discount)) / 100
            : 1);
  }

  String? getImage() {
    return variant?.images?.isNotEmpty == true
        ? product.images![variant!.images!.first]
        : product.mainImage;
  }
}

class ICompanyData {
  final String name;
  final String nip;

  ICompanyData({
    required this.name,
    required this.nip,
  });
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nip': nip,
    };
  }

  factory ICompanyData.fromJson(Map<String, dynamic> json) {
    return ICompanyData(
      name: json['name'],
      nip: json['nip'],
    );
  }
}

class IUserOrderData {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final IAddressDetails address;
  final ICompanyData? companyData;

  IUserOrderData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.companyData,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address.toJson(),
      'companyData': companyData?.toJson(),
    };
  }

  factory IUserOrderData.fromJson(Map<String, dynamic> json) {
    return IUserOrderData(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: IAddressDetails.fromJson(json['address']),
      companyData: json['companyData'] != null
          ? ICompanyData.fromJson(json['companyData'])
          : null,
    );
  }
}

class IOrder {
  final String uuid;
  final String groupId;
  final List<String> cartItemsIds;
  final IDeliveryDetails? deliveryDetails;
  final IUserOrderData? userData;

  IOrder(
      {required this.cartItemsIds,
      this.deliveryDetails,
      this.userData,
      required this.groupId,
      String? uuid})
      : uuid = uuid ?? UuidV4().generate();

  factory IOrder.fromJson(Map<String, dynamic> json) {
    return IOrder(
        uuid: json['uuid'],
        cartItemsIds: List<String>.from(json['cart_items_ids']),
        deliveryDetails: json['delivery_details'] != null
            ? IDeliveryDetails.fromJson(json['delivery_details'])
            : null,
        userData: json['user_data'] != null
            ? IUserOrderData.fromJson(json['user_data'])
            : null,
        groupId: json['group_id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'cart_items_ids': cartItemsIds,
      'delivery_details': deliveryDetails?.toJson(),
      'user_data': userData?.toJson(),
      'group_id': groupId
    };
  }

  IOrder copyWith(
      {String? uuid,
      List<String>? cartItemsIds,
      IDeliveryDetails? deliveryDetails,
      IUserOrderData? userData,
      String? groupId}) {
    return IOrder(
        uuid: uuid ?? this.uuid,
        cartItemsIds: cartItemsIds ?? this.cartItemsIds,
        deliveryDetails: deliveryDetails ?? this.deliveryDetails,
        userData: userData ?? this.userData,
        groupId: groupId ?? this.groupId);
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IOrder &&
          (uuid == other.uuid ||
              areListsEqualContent(cartItemsIds, other.cartItemsIds));

  @override
  int get hashCode => Object.hashAll(cartItemsIds);

  bool isEqualItems(List<ICartItem> items) {
    if (cartItemsIds.length != items.length) return false;

    for (final item in items) {
      if (!cartItemsIds.contains(item.uuid)) return false;
    }

    return true;
  }

  bool containsItem(String itemId) {
    return cartItemsIds.contains(itemId);
  }
}
