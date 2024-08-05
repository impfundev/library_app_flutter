import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:library_app/src/models/token.dart';
import 'package:library_app/src/models/user.dart';

class AuthProvider with ChangeNotifier {
  final storage = const FlutterSecureStorage();

  String baseUrl = 'http://localhost:8000/api/v1';
  String? message;

  User? user;
  bool isAuthenticated = false;
  bool invalidUsernameOrPassword = false;
  List<dynamic>? memberLoans;

  bool filterByUpcoming = false;
  bool filterByOverdued = false;

  bool isLoading = false;
  bool resetPasswordTokenSended = false;
  bool resetPasswordSucced = false;
  bool changePasswordSucced = false;
  bool loanBookSuccess = false;

  List<dynamic>? loans;
  List<dynamic>? nearOutstandingLoans;
  List<dynamic>? overduedLoans;

  Future<void> storeAccessToken(String accessToken) async {
    await storage.write(key: 'access_token', value: accessToken);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'access_token');
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setLoanBookSuccess(bool value) {
    loanBookSuccess = value;
  }

  void setInvalidUsernameOrPassword(bool value) {
    invalidUsernameOrPassword = value;
  }

  Future<void> signIn(
      BuildContext context, String username, String password) async {
    try {
      setLoading(true);
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        String token = Token.fromJson(data)!.key;
        await storeAccessToken(token);

        isAuthenticated = true;
        setInvalidUsernameOrPassword(false);

        debugPrint("Login successful $token");
      } else if (response.statusCode == 400) {
        setInvalidUsernameOrPassword(true);
        debugPrint("Login failed: ${response.statusCode} ${response.body}");
      } else {
        debugPrint("Login failed: ${response.statusCode} ${response.body}");
      }

      setLoading(false);
      notifyListeners();
    } catch (error) {
      debugPrint("Login failed $error");
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    final token = await getAccessToken();

    try {
      setLoading(true);
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
        filterByUpcoming = false;
        filterByOverdued = false;
        memberLoans = null;

        isLoading = false;
        resetPasswordTokenSended = false;
        resetPasswordSucced = false;

        loans = null;
        nearOutstandingLoans = null;
        overduedLoans = null;
      } else {
        debugPrint("Logout failed: ${response.statusCode} ${response.body}");
      }

      setLoading(false);
      notifyListeners();
    } catch (error) {
      debugPrint("Logout failed $error");
    }
  }

  Future<void> signUp(BuildContext context, String username, String email,
      String password) async {
    try {
      setLoading(true);
      final body = {
        "username": username,
        "email": email,
        "password": password,
      };
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        String token = Token.fromJson(data)!.key;
        storeAccessToken(token);
        isAuthenticated = true;

        if (context.mounted) {
          context.go("/");
        }
        debugPrint("Signup successful $token");
      } else {
        debugPrint(
            "Error: sign up failed, ${response.statusCode}: ${response.body}");
      }

      setLoading(false);
      notifyListeners();
    } catch (error) {
      debugPrint("Error: sign up failed, $error");
    }
  }

  Future<void> getUserDetail() async {
    final token = await getAccessToken();

    if (token != null) {
      try {
        setLoading(true);
        final response = await http.get(
          Uri.parse('$baseUrl/user'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          user = User.fromJson(data);
          message = null;
        } else {
          debugPrint(
              'Error fetching user details: ${response.statusCode} ${response.body}');
        }

        setLoading(false);
        notifyListeners();
      } catch (error) {
        debugPrint('Error user details: $error');
      }
    }
  }

  Future<void> updateUserDetail(
    BuildContext context,
    int id,
    String username,
    String email,
    String? firstName,
    String? lastName,
    bool isStaff,
  ) async {
    setLoading(true);
    final token = await getAccessToken();

    if (token != null) {
      try {
        final data = {
          "username": username,
          "email": email,
          "first_name": firstName,
          "last_name": lastName,
        };
        final body = jsonEncode(data);
        final response = await http.put(
          Uri.parse('$baseUrl/user/update'),
          body: body,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );

        if (response.statusCode == 200) {
          await getUserDetail();
          message = null;
          if (context.mounted) {
            context.pop();
          }
        } else {
          final data = jsonDecode(response.body);
          message = data["message"];
          debugPrint(
              'Error update user details: ${response.statusCode}, ${response.body}');
        }

        setLoading(false);
        notifyListeners();
      } catch (error) {
        debugPrint("Error update user details: $error");
      }
    }
  }

  Future<void> changePassword(
    BuildContext context,
    String oldPassword,
    String newPassword1,
    String newPassword2,
  ) async {
    final token = await getAccessToken();

    try {
      setLoading(true);
      final response = await http.put(
        Uri.parse('$baseUrl/auth/change-password'),
        body: jsonEncode({
          "old_password": oldPassword,
          "new_password1": newPassword1,
          "new_password2": newPassword2,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        message = null;
        if (context.mounted) {
          context.go("/");
        }
        changePasswordSucced = true;
      } else {
        final data = jsonDecode(response.body);
        message = data["message"];
        debugPrint(
            'Change password failed: ${response.statusCode}, ${response.body}');
      }

      setLoading(false);
      notifyListeners();
    } catch (error) {
      debugPrint("Change password failed: $error");
    }
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      setLoading(true);
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        body: jsonEncode({"email": email}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        message = null;
        resetPasswordTokenSended = true;
        if (context.mounted) {
          context.go("/confirm-reset-password");
        }
      } else {
        final data = jsonDecode(response.body);
        message = data["message"];
        debugPrint(
            'Error reset user password: ${response.statusCode}, ${response.body}');
      }

      setLoading(false);
      notifyListeners();
    } catch (error) {
      debugPrint("Error reset user password: $error");
    }
  }

  Future<void> confirmResetPassword(
    BuildContext context,
    int pin,
    String password1,
    String password2,
  ) async {
    setLoading(true);
    final body = jsonEncode({
      "pin": pin,
      "password1": password1,
      "password2": password2,
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password-confirm'),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        message = null;
        resetPasswordSucced = true;
        if (context.mounted) {
          context.go("/");
        }
      } else {
        final data = jsonDecode(response.body);
        message = data["message"];
        debugPrint(
            'Error confirm reset user password: ${response.statusCode}, ${response.body}');
      }

      setLoading(false);
      notifyListeners();
    } catch (error) {
      debugPrint("Error confirm reset user password: $error");
    }
  }

  Future<void> getMemberLoan() async {
    setLoading(true);
    final token = await getAccessToken();

    String url = '$baseUrl/user/loans';
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
        message = null;
        final data = jsonDecode(response.body);
        memberLoans = data;
      } else {
        final data = jsonDecode(response.body);
        message = data["message"];
        debugPrint(
            "Failed to get member loan. ${response.statusCode}: ${response.body}");
      }

      setLoading(false);
      notifyListeners();
    } catch (error) {
      debugPrint("Failed to get member loan. $error");
    }
  }

  void setFilterUpcoming() {
    setLoading(true);
    filterByUpcoming = !filterByUpcoming;
    setLoading(false);
    notifyListeners();
  }

  void setFilterOverdued() {
    setLoading(true);
    filterByOverdued = !filterByOverdued;
    setLoading(false);
    notifyListeners();
  }

  Future<void> createMemberLoan(int memberId, int bookId, int loanDay) async {
    final token = await getAccessToken();
    String url = '$baseUrl/user/loans';

    final now = DateTime.now();
    final dueDate = now.add(Duration(days: loanDay));
    final body = {
      "book": bookId,
      "member": memberId,
      "loan_date": now.toString(),
      "due_date": dueDate.toString(),
    };

    try {
      setLoading(true);
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        message = null;
        await getMemberLoan();
      } else {
        final data = jsonDecode(response.body);
        message = data["message"];
        debugPrint(
            "Failed to add member loan. ${response.statusCode}: ${response.body}");
      }

      loanBookSuccess = true;
      setLoading(false);
      notifyListeners();
    } catch (error) {
      debugPrint("Failed to add member loan. $error");
    }
  }

  // for admin or librarian
  Future<void> getLoans(String? type) async {
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
        setLoading(true);
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

        setLoading(false);
        notifyListeners();
      } catch (error) {
        debugPrint("Error: Fetch upcoming loans failed, $error");
      }
    }
  }
}
