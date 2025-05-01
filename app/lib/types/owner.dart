class IProductOwnerEntry {
  final String uuid;
  final String name;
  final String description;
  final String createdAt;
  final int totalTransactions;
  final String? link;
  final String? image;

  IProductOwnerEntry({
    required this.uuid,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.totalTransactions,
    this.link,
    this.image,
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
    };
  }

  factory IProductOwnerEntry.fromJson(Map<String, dynamic> json) {
    return IProductOwnerEntry(
      uuid: json['uuid'],
      name: json['name'],
      description: json['description'],
      createdAt: json['created_at'],
      totalTransactions: json['total_transactions'],
      link: json['link'],
      image: json['image'],
    );
  }
}
