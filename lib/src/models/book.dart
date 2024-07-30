class Book {
  int id;
  String title;
  String author;
  String description;
  String? coverUrl;
  String? category;

  Book(this.id, this.title, this.author, this.description, this.coverUrl,
      this.category);

  factory Book.fromJson(Map<String, dynamic> data) {
    return Book(
      data['id'] as int,
      data['title'] as String,
      data['author'] as String,
      data['description'] as String,
      data['coverUrl'] as String?,
      data['category'] as String?,
    );
  }
}

final initialBooks = [
  Book(
    1,
    'The Doe in the Forest',
    'Laurel Toven',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id mauris ligula. Mauris nec elit ultrices, gravida tortor ac, faucibus velit.',
    'https://dummyjson.com/image/260x400',
    'Children',
  ),
  Book(
    1,
    'Norse Mythology',
    'Neil Gaiman',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id mauris ligula. Mauris nec elit ultrices, gravida tortor ac, faucibus velit.',
    'https://dummyjson.com/image/260x400',
    'Religion',
  ),
  Book(
    1,
    'The Sun, the Moon, the Stars',
    'Junot Diaz',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id mauris ligula. Mauris nec elit ultrices, gravida tortor ac, faucibus velit.',
    'https://dummyjson.com/image/260x400',
    'Drama',
  ),
  Book(
    1,
    'Harry Potter',
    'JK Rowling',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id mauris ligula. Mauris nec elit ultrices, gravida tortor ac, faucibus velit.',
    'https://dummyjson.com/image/260x400',
    'Fantasy',
  ),
];
