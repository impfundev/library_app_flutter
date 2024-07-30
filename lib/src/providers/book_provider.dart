import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BookProvider with ChangeNotifier {
  String baseUrl = 'http://localhost:8000/api/v1';
  List<dynamic>? books;

  BookProvider({this.books});

  Future<void> getBooks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        books = data["results"];
      } else {
        final code = response.statusCode;
        debugPrint("Error: Fetch books failed, $code");
      }

      notifyListeners();
    } catch (error) {
      debugPrint("Error: Fetch books failed, $error");
    }
  }

  Future<void> searchBook(String? keyword) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books?search=$keyword'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        books = data["results"];
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
