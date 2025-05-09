class CategoryModel {
  final int id;
  final String name;
  final String state;

  CategoryModel({this.id = 0, required this.name, required this.state});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['category_id'] ?? 0,
      name: json['category_name'],
      state: json['category_state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'category_name': name, 'category_state': state};
  }
}
