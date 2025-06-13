class IDeliveryMethod {
  final String uuid;
  final String name;
  final String? image;
  final String? externalId;

  IDeliveryMethod({
    required this.uuid,
    required this.name,
    this.image,
    this.externalId,
  });

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
