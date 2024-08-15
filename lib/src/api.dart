class API {
    static Future<void> signIn(
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

        setInvalidUsernameOrPassword(false);
        if (context.mounted) context.go("/");
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

  static Future<void> signOut(BuildContext context) async {
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('access_token');
        resetAllState();
        if (context.mounted) context.go("/");
      } else {
        debugPrint("Logout failed: ${response.statusCode} ${response.body}");
      }

      setLoading(false);
      notifyListeners();
    } catch (error) {
      debugPrint("Logout failed $error");
    }
  }

  static Future<void> signUp(BuildContext context, String username, String email,
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
        message = null;

        if (context.mounted) {
          context.go("/");
        }
        debugPrint("Signup successful $token");
      } else {
        final data = jsonDecode(response.body);
        message = data["message"];
        debugPrint(
            "Error: sign up failed, ${response.statusCode}: ${response.body}");
      }

      setLoading(false);
      notifyListeners();
    } catch (error) {
      debugPrint("Error: sign up failed, $error");
    }
  }

  static Future<void> getUserDetail() async {
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

  static Future<void> updateUserDetail(
    BuildContext context,
    int id,
    String username,
    String email,
    String? firstName,
    String? lastName,
    bool isStaff,
  ) async {
    final token = await getAccessToken();

    if (token != null) {
      try {
        setLoading(true);
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

  static Future<void> changePassword(
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

  static Future<void> resetPassword(BuildContext context, String email) async {
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

  static Future<void> confirmResetPassword(
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

  static Future<void> getMemberLoan() async {
    setLoading(true);
    final token = await getAccessToken();

    String url = '$baseUrl/user/loans';
    if (filterByUpcoming) {
      url += '?near_outstanding=True';
    } else if (filterByOverdued) {
      url += '?overdue=True';
    } else if (pageNumber > 1) {
      url += "?page=$pageNumber";
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
        memberLoans = data["data"];
        hasNextPage = data["has_next"];
        hasPrevPage = data["has_prev"];
        pageNumber = data["page_number"];
        totalPages = data["total_pages"];
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

  static Future<void> createMemberLoan(int memberId, int bookId, int loanDay) async {
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
  static Future<void> getLoans(String? type) async {
    final token = await getAccessToken();
    String url = "$baseUrl/book-loans";
    if (type == "upcoming") {
      url += '?near_outstanding=True';
    } else if (type == "overdue") {
      url += '?overdue=True';
    } else if (pageNumber > 1) {
      url += "?page=$pageNumber";
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
            nearOutstandingLoans = data["data"];
          } else if (type == "overdue") {
            overduedLoans = data["data"];
          } else {
            loans = data["data"];
          }
          hasNextPage = data["has_next"];
          hasPrevPage = data["has_prev"];
          pageNumber = data["page_number"];
          totalPages = data["total_pages"];
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