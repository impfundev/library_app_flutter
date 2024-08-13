import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";
import 'package:flutter_svg/flutter_svg.dart';

import "package:library_app/src/providers/auth_provider.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isAutheticated();
  }

  void isAutheticated() async {
    final token = await Provider.of<AuthProvider>(context, listen: false)
        .getAccessToken();

    if (token != null) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (context.mounted) context.go("/home");
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (context.mounted) context.go("/login");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/splash_image.svg",
            semanticsLabel: "Splash Screen",
            height: screenSize.height * 0.3,
          ),
          const SizedBox(
            height: 40.0,
          ),
          const SizedBox(
            width: 30.0,
            height: 30.0,
            child: CircularProgressIndicator(),
          ),
        ],
      )),
    );
  }
}
