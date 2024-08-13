import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:library_app/src/screens/list/list_screen.dart';
import 'package:library_app/src/screens/profile_edit_screen.dart';
import 'package:library_app/src/widgets/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/providers/navigations_provider.dart';
import 'package:library_app/src/providers/book_provider.dart';

import 'package:library_app/src/screens/form_screen.dart';

void main() {
  runApp(const LibraryApp());
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Library App';

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const ListScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/sign-up',
          builder: (context, state) => const SignUpScreen(),
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
