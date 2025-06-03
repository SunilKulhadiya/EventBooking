class Homemodelsubdata {
  final int id;
  final String name;
  final String iconUrl;

  Homemodelsubdata({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  factory Homemodelsubdata.fromJson(Map<String, dynamic> json) {
    return Homemodelsubdata(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      iconUrl: json['iconUrl'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconUrl': iconUrl,
    };
  }
}
