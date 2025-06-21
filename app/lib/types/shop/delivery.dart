import 'package:latlong2/latlong.dart';

class IDeliveryMethod {
  final String uuid;
  final String name;
  final String? image;
  final String? description;
  final String? externalId;
  final List<String>? unavailableFor;

  IDeliveryMethod({
    required this.uuid,
    required this.name,
    this.image,
    this.description,
    this.unavailableFor,
    this.externalId,
  });

  copyWith({
    String? uuid,
    String? name,
    String? image,
    String? externalId,
    List<String>? unavailableFor,
  }) {
    return IDeliveryMethod(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      image: image ?? this.image,
      description: externalId ?? this.description,
      unavailableFor: unavailableFor ?? this.unavailableFor,
      externalId: externalId ?? this.externalId,
    );
  }

  get isAvailable {
    return unavailableFor == null || unavailableFor!.isEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'image': image,
      'description': description,
      'external_id': externalId,
    };
  }

  factory IDeliveryMethod.fromJson(Map<String, dynamic> json) {
    return IDeliveryMethod(
      uuid: json['uuid'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      externalId: json['external_id'],
    );
  }
}

class IAddressDetails {
  final String country;
  final String city;
  final String street;
  final String postCode;
  final String? houseNumber;
  final String? flatNumber;
  final String? province;

  IAddressDetails({
    required this.country,
    required this.city,
    required this.street,
    required this.postCode,
    this.houseNumber,
    this.flatNumber,
    this.province,
  });
  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'city': city,
      'street': street,
      'post_code': postCode,
      'house_number': houseNumber,
      'flat_number': flatNumber,
      'province': province,
    };
  }

  factory IAddressDetails.fromJson(Map<String, dynamic> json) {
    return IAddressDetails(
      country: json['country'],
      city: json['city'],
      street: json['street'],
      postCode: json['post_code'],
      houseNumber: json['house_number'],
      flatNumber: json['flat_number'],
      province: json['province'],
    );
  }

  String toAddressString() {
    final buffer = StringBuffer();

    buffer.write(street);

    if (houseNumber != null && houseNumber!.isNotEmpty) {
      buffer.write(' $houseNumber');
    }

    if (flatNumber != null && flatNumber!.isNotEmpty) {
      buffer.write('/$flatNumber');
    }

    buffer.write(', $postCode, $city');

    return buffer.toString();
  }
}

class IInpostOutOfTheBoxPoint {
  final String id;
  final String name;
  final String? description;
  final IAddressDetails address;
  final LatLng coordinates;
  final String? image;

  IInpostOutOfTheBoxPoint({
    required this.id,
    required this.name,
    this.description,
    required this.address,
    required this.coordinates,
    this.image,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address.toJson(),
      'coordinates': {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
      },
      'image': image,
    };
  }

  factory IInpostOutOfTheBoxPoint.fromJson(Map<String, dynamic> json) {
    return IInpostOutOfTheBoxPoint(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: IAddressDetails.fromJson(json['address']),
      coordinates: LatLng(
        json['coordinates']['latitude'],
        json['coordinates']['longitude'],
      ),
      image: json['image'],
    );
  }
}
