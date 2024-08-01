import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:library_app/src/models/token.dart';
import 'package:library_app/src/models/user.dart';

class AuthProvider with ChangeNotifier {
  final storage = const FlutterSecureStorage();
  String baseUrl = 'http://localhost:8000/api/v1';

  User? user;
  bool isAuthenticated = false;
  bool invalidUsernameOrPassword = false;
  List<dynamic>? memberLoans;

  bool filterByUpcoming = false;
  bool filterByOverdued = false;

  int? userIdResetPw;
  bool isLoading = false;
  bool resetPasswordTokenSended = false;
  bool resetPasswordSucced = false;

  List<dynamic>? loans;
  List<dynamic>? nearOutstandingLoans;
  List<dynamic>? overduedLoans;

  Future<void> storeAccessToken(String accessToken) async {
    await storage.write(key: 'access_token', value: accessToken);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<void> signIn(String username, String password) async {
    isLoading = true;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = Token.fromJson(data)!.key;
        await storeAccessToken(token);

        isAuthenticated = true;
        invalidUsernameOrPassword = false;
        debugPrint("Login successful $token");
      } else if (response.statusCode == 401) {
        invalidUsernameOrPassword = true;

        debugPrint("Login failed: ${response.statusCode} ${response.body}");
      } else {
        final code = response.statusCode;
        debugPrint("Login failed $code");
      }

      isLoading = false;
      notifyListeners();
    } catch (error) {
      debugPrint("Login failed $error");
    }
  }

  Future<void> signOut() async {
    isLoading = true;
    final token = await getAccessToken();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        await storage.delete(key: 'token');
        isAuthenticated = false;
        user = null;
      } else {
        debugPrint("Logout failed: ${response.statusCode} ${response.body}");
      }

      isLoading = false;
      notifyListeners();
    } catch (error) {
      debugPrint("Logout failed $error");
    }
  }

  Future<void> signUp(String username, String email, String password) async {
    isLoading = true;

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
        String token = Token.fromJson(data)!.key;
        storeAccessToken(token);
        isAuthenticated = true;

        debugPrint("Signup successful $token");
      } else {
        debugPrint(
            "Error: sign up failed, ${response.statusCode}: ${response.body}");
      }

      isLoading = false;
      notifyListeners();
    } catch (error) {
      debugPrint("Error: sign up failed, $error");
    }
  }

  Future<void> getUserDetail() async {
    isLoading = true;
    final token = await getAccessToken();

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/user'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          user = User.fromJson(data);
        } else {
          debugPrint('Error fetching user details: ${response.statusCode}');
        }

        isLoading = true;
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
    isLoading = true;
    final token = await getAccessToken();

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
            'Authorization': 'Bearer $token'
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          user = User.fromJson(data);
        } else {
          debugPrint(
              'Error update user details: ${response.statusCode}, ${response.body}');
        }

        isLoading = false;
        notifyListeners();
      } catch (error) {
        debugPrint("Error update user details: $error");
      }
    }
  }

  Future<void> resetPassword(String email) async {
    isLoading = true;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password/request-token'),
        body: jsonEncode({"email": email}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        resetPasswordTokenSended = true;
        userIdResetPw = data["user_id_reset_pw"];
      } else {
        debugPrint(
            'Error reset user password: ${response.statusCode}, ${response.body}');
      }

      isLoading = false;
      notifyListeners();
    } catch (error) {
      debugPrint("Error reset user password: $error");
    }
  }

  Future<void> confirmResetPassword(
      int pin, String password1, String password2) async {
    isLoading = true;
    final body = jsonEncode({
      "pin": pin,
      "password1": password1,
      "password2": password2,
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password/confirm'),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        resetPasswordSucced = true;
      } else {
        debugPrint(
            'Error confirm reset user password: ${response.statusCode}, ${response.body}');
      }

      isLoading = false;
      notifyListeners();
    } catch (error) {
      debugPrint("Error confirm reset user password: $error");
    }
  }

  Future<void> getMemberLoan() async {
    isLoading = true;
    final token = await getAccessToken();

    String url = '$baseUrl/members/${user?.accountId}/loans/';
    if (filterByUpcoming) {
      url += '?near_outstanding=True';
    } else if (filterByOverdued) {
      url += '?overdue=True';
    } else {
      null;
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        memberLoans = data["results"];
      } else {
        debugPrint(
            "Failed to get member loan. ${response.statusCode}: ${response.body}");
      }

      isLoading = false;
      notifyListeners();
    } catch (error) {
      debugPrint("Failed to get member loan. $error");
    }
  }

  void setFilterUpcoming() {
    isLoading = true;
    filterByUpcoming = !filterByUpcoming;
    isLoading = false;
    notifyListeners();
  }

  void setFilterOverdued() {
    isLoading = true;
    filterByOverdued = !filterByOverdued;
    notifyListeners();
    isLoading = false;
  }

  Future<void> createMemberLoan(int memberId, int bookId, int loanDay) async {
    isLoading = true;
    final token = await getAccessToken();

    final now = DateTime.now();
    final dueDate = now.add(Duration(days: loanDay));
    final body = {
      "book": bookId,
      "member": memberId,
      "loan_date": now.toString(),
      "due_date": dueDate.toString(),
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/members/$memberId/loans/'),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        memberLoans = data["results"];
      } else {
        debugPrint(
            "Failed to create member loan. ${response.statusCode}: ${response.body}");
      }

      isLoading = false;
      notifyListeners();
    } catch (error) {
      debugPrint("Failed to create member loan. $error");
    }
  }

  // for admin or librarian
  Future<void> getLoans(String? type) async {
    isLoading = true;
    final token = await storage.read(key: 'access_token');
    String url = baseUrl;
    if (type == "upcoming") {
      url += "/upcoming-loans/";
    } else if (type == "overdue") {
      url += "/overdued-loans/";
    } else {
      url += "/book-loans/";
    }

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (type == "upcoming") {
            nearOutstandingLoans = data["results"];
          } else if (type == "overdue") {
            overduedLoans = data["results"];
          } else {
            loans = data["results"];
          }
        } else {
          final code = response.statusCode;
          debugPrint("Error: Fetch upcoming loans failed, $code");
        }

        isLoading = false;
        notifyListeners();
      } catch (error) {
        debugPrint("Error: Fetch upcoming loans failed, $error");
      }
    }
  }
}
