import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:library_app/src/models/token.dart';
import 'package:library_app/src/models/user.dart';

class AuthProvider with ChangeNotifier {
  String baseUrl = 'http://localhost:8000/api/v1';

  Token? token;
  User? user;
  bool get isLoggedIn => token != null;
  bool invalidUsernameOrPassword = false;
  List<dynamic>? memberLoans;

  Future<void> signIn(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/members/auth/login'),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token = Token.fromJson(data);

        debugPrint("Login successful $token");
      } else if (response.statusCode == 401) {
        invalidUsernameOrPassword = true;

        debugPrint("Login failed: ${response.statusCode} ${response.body}");
      } else {
        final code = response.statusCode;
        debugPrint("Login failed $code");
      }

      notifyListeners();
    } catch (error) {
      debugPrint("Login failed $error");
    }
  }

  Future<void> signOut() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token?.key}'
        },
      );

      if (response.statusCode == 200) {
        token = null;
      } else {
        debugPrint("Logout failed: ${response.statusCode} ${response.body}");
      }

      notifyListeners();
    } catch (error) {
      debugPrint("Logout failed $error");
    }
  }

  Future<void> signUp(String username, String email, String password) async {
    try {
      final body = {
        "username": username,
        "email": email,
        "password": password,
      };
      final response = await http.post(
        Uri.parse('$baseUrl/members/auth/register'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token = Token.fromJson(data);
        debugPrint(response.body);
      } else {
        debugPrint(
            "Error: sign up failed, ${response.statusCode}: ${response.body}");
      }

      notifyListeners();
    } catch (error) {
      debugPrint("Error: sign up failed, $error");
    }
  }

  Future<void> getUserDetail() async {
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/user'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token?.key}'
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          user = User.fromJson(data);
        } else {
          debugPrint('Error fetching user details: ${response.statusCode}');
        }

        notifyListeners();
      } catch (error) {
        debugPrint('Error user details: $error');
      }
    }
  }

  Future<void> updateUserDetail(
    int id,
    String username,
    String email,
    String? firstName,
    String? lastName,
    bool isStaff,
  ) async {
    if (token != null) {
      try {
        final body = jsonEncode({
          "username": username,
          "email": email,
          "first_name": firstName,
          "last_name": lastName,
        });
        final response = await http.put(
          Uri.parse('$baseUrl/user/$id/'),
          body: body,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token?.key}'
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          user = User.fromJson(data);
        } else {
          debugPrint(
              'Error update user details: ${response.statusCode}, ${response.body}');
        }

        notifyListeners();
      } catch (error) {
        debugPrint("Error update user details: $error");
      }
    }
  }

  Future<void> getMemberLoan(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/members/$id/loans/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token?.key}'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        memberLoans = data["results"];
      } else {
        debugPrint(
            "Failed to get member loan. ${response.statusCode}: ${response.body}");
      }

      notifyListeners();
    } catch (error) {
      debugPrint("Failed to get member loan. $error");
    }
  }

  Future<void> createMemberLoan(int memberId, int bookId, int loanDay) async {
    final loanDate = DateTime.now();
    final dueDay = loanDate.day + loanDay;
    final dueDate = loanDate.add(Duration(days: dueDay));
    final body = {
      "book": bookId,
      "member": memberId,
      "loan_date": loanDate.toString(),
      "due_date": dueDate.toString(),
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/members/$memberId/loans/'),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token?.key}'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        memberLoans = data["results"];
      } else {
        debugPrint(
            "Failed to create member loan. ${response.statusCode}: ${response.body}");
      }

      notifyListeners();
    } catch (error) {
      debugPrint("Failed to create member loan. $error");
    }
  }
}
