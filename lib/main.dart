import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:library_app/src/providers/book_provider.dart';
import 'package:library_app/src/screens/form_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:library_app/src/providers/auth_provider.dart';
import 'package:library_app/src/providers/navigations_provider.dart';
import 'package:library_app/src/screens/list_screen.dart';

void main() {
  runApp(const LibraryApp());
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});
  @override
  Widget build(BuildContext context) {
    const title = 'Library App';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => NavigationsProvider()),
        ChangeNotifierProvider(create: (context) => BookProvider()),
      ],
      child: MaterialApp(
        title: title,
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(108, 99, 255, 1.000),
          ),
          useMaterial3: true,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return authProvider.isLoggedIn
                ? const ListScreen()
                : const LoginScreen();
          },
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
