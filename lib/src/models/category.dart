class Category {
  String name;

  Category(this.name);

  factory Category.fromJson(Map<String, dynamic> data) {
    return Category(
      data['name'] as String,
    );
  }
}

final initialCategories = [
  Category('Children'),
  Category('Religion'),
  Category('Fantasy'),
  Category('Horror'),
  Category('Romance'),
  Category('Mistery'),
  Category('Adventure'),
  Category('Science Fiction'),
];
