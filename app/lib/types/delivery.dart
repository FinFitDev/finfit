class IDeliveryMethod {
  final String uuid;
  final String name;
  final String? image;
  final String? externalId;
  final List<String>? unavailableFor;

  IDeliveryMethod(
      {required this.uuid,
      required this.name,
      this.image,
      this.externalId,
      this.unavailableFor});

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
      externalId: externalId ?? this.externalId,
      unavailableFor: unavailableFor ?? this.unavailableFor,
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
      'external_id': externalId,
    };
  }

  factory IDeliveryMethod.fromJson(Map<String, dynamic> json) {
    return IDeliveryMethod(
      uuid: json['uuid'],
      name: json['name'],
      image: json['image'],
      externalId: json['external_id'],
    );
  }
}
