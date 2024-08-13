import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/src/screens/profile_edit_screen.dart';
import 'package:provider/provider.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/providers/navigations_provider.dart';
import 'package:library_app/src/providers/book_provider.dart';

import 'package:library_app/src/screens/form_screen.dart';
import 'package:library_app/src/screens/list/list_screen.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final isAuthenticated = prefs.getString('access_token') != null;

  runApp(isAuthenticated ? const LibraryApp() : const LoginScreen());
}

class LibraryApp extends StatefulWidget {
  const LibraryApp({super.key});

  @override
  State<LibraryApp> createState() => _LibraryApp();
}

class _LibraryApp extends State<LibraryApp> {
  @override
  Widget build(BuildContext context) {
    const title = 'Library App';

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ListScreen(),
        ),
        GoRoute(
          path: '/sign-up',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: '/reset-password',
          builder: (context, state) => const ResetPasswordScreen(),
        ),
        GoRoute(
          path: '/confirm-reset-password',
          builder: (context, state) => const ConfirmResetPasswordScreen(),
        ),
        GoRoute(
          path: "/change-password",
          builder: (context, state) => const ChangePasswordScreen(),
        ),
        GoRoute(
          path: "/profile-edit",
          builder: (context, state) => const ProfileEditScreen(),
        ),
      ],
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => NavigationsProvider()),
        ChangeNotifierProvider(create: (context) => BookProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: title,
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(108, 99, 255, 1.000),
          ),
          useMaterial3: true,
        ),
        scrollBehavior: AdaptiveScrollBehavior(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AdaptiveScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
