class CountryModel {
  final String id;
  final String sortname;
  final String name;
  final String phonecode;

  CountryModel({
    required this.id,
    required this.sortname,
    required this.name,
    required this.phonecode,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id']?.toString() ?? '',
      sortname: json['sortname']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phonecode: json['phonecode']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sortname': sortname,
      'name': name,
      'phonecode': phonecode,
    };
  }
}
