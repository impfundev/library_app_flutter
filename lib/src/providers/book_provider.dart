import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BookProvider with ChangeNotifier {
  String baseUrl = 'http://localhost:8000/api/v1';
  List<dynamic>? books;
  List<dynamic>? categories;
  Category? category;

  String? searchKeyword;
  String? filterByCategory;

  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
  }

  Future<void> getBooks() async {
    try {
      setLoading(true);
      String url = '$baseUrl/books';
      if (filterByCategory != null) {
        url += '?category__name=$filterByCategory';
      } else if (searchKeyword != null) {
        url += "?search=$searchKeyword";
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        books = data["results"];
      } else {
        final code = response.statusCode;
        debugPrint("Error: Fetch books failed, $code");
      }

      setLoading(false);
      notifyListeners();
    } catch (error) {
      debugPrint("Error: Fetch books failed, $error");
    }
  }

  void filterBookByCategory(String? name) {
    filterByCategory = name;
    notifyListeners();
  }

  void setSearchKeyword(String? keyword) {
    searchKeyword = keyword;
    notifyListeners();
  }

  Future<void> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        categories = data["results"];
      } else {
        debugPrint("Error: Fetch books failed, ${response.statusCode}");
      }

      notifyListeners();
    } catch (error) {
      debugPrint("Error: Fetch books failed, $error");
    }
  }

  Future<void> getCategoryById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        category = data;
      } else {
        final code = response.statusCode;
        debugPrint("Error: Fetch books failed, $code");
      }

      notifyListeners();
    } catch (error) {
      debugPrint("Error: Fetch books failed, $error");
    }
  }
}
