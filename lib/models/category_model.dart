class Category {
  int? id;
  String? name;
  String? description;

  categoryMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;

    return map;
  }
}