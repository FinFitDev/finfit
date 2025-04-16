class IProductOwnerEntry {
  final String uuid;
  final String name;
  final String description;
  final String createdAt;
  final String? link;
  final String? image;

  IProductOwnerEntry({
    required this.uuid,
    required this.name,
    required this.description,
    required this.createdAt,
    this.link,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'description': description,
      'created_at': createdAt,
      'link': link,
      'image': image,
    };
  }

  factory IProductOwnerEntry.fromJson(Map<String, dynamic> json) {
    return IProductOwnerEntry(
      uuid: json['uuid'],
      name: json['name'],
      description: json['description'],
      createdAt: json['created_at'],
      link: json['link'],
      image: json['image'],
    );
  }
}
