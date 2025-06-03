import 'package:goevent2/AppModel/Homedata/HomeModelSubData.dart';

class HomeSection {
  final int id;
  final String displayName;
  final String apiUrl;
  List<Homemodelsubdata> homemodelsubdata;

  HomeSection({
    required this.id,
    required this.displayName,
    required this.apiUrl,
    required this.homemodelsubdata,
  });

  factory HomeSection.fromJson(Map<String, dynamic> json) {
    return HomeSection(
      id: json['id'],
      displayName: json['displayName'],
      apiUrl: json['apiUrl'],
      homemodelsubdata: [], // You can replace this with actual data later
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'apiUrl': apiUrl,
      // Optional: Include if you want to serialize subdata too
      'homemodelsubdata': homemodelsubdata.map((e) => e.toJson()).toList(),
    };
  }
}
