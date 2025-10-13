class IPartnerEntry {
  final String uuid;
  final String name;
  final String description;
  final String createdAt;
  final String? link;
  final String? image;
  final String? bannerImage;

  IPartnerEntry({
    required this.uuid,
    required this.name,
    required this.description,
    required this.createdAt,
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
      'link': link,
      'image': image,
      'banner_image': bannerImage,
    };
  }

  factory IPartnerEntry.fromJson(Map<String, dynamic> json) {
    return IPartnerEntry(
      uuid: json['uuid'],
      name: json['name'],
      description: json['description'],
      createdAt: json['created_at'],
      link: json['link'],
      image: json['image'],
      bannerImage: json['banner_image'],
    );
  }
}
