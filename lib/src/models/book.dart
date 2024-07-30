class Book {
  String title;
  String author;
  String description;
  String? coverUrl;
  String? category;

  Book(this.title, this.author, this.description, this.coverUrl, this.category);

  factory Book.fromJson(Map<String, dynamic> data) {
    return Book(
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
    'The Doe in the Forest',
    'Laurel Toven',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id mauris ligula. Mauris nec elit ultrices, gravida tortor ac, faucibus velit.',
    'https://dummyjson.com/image/260x400',
    'Children',
  ),
  Book(
    'Norse Mythology',
    'Neil Gaiman',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id mauris ligula. Mauris nec elit ultrices, gravida tortor ac, faucibus velit.',
    'https://dummyjson.com/image/260x400',
    'Religion',
  ),
  Book(
    'The Sun, the Moon, the Stars',
    'Junot Diaz',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id mauris ligula. Mauris nec elit ultrices, gravida tortor ac, faucibus velit.',
    'https://dummyjson.com/image/260x400',
    'Drama',
  ),
  Book(
    'Harry Potter',
    'JK Rowling',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id mauris ligula. Mauris nec elit ultrices, gravida tortor ac, faucibus velit.',
    'https://dummyjson.com/image/260x400',
    'Fantasy',
  ),
];
