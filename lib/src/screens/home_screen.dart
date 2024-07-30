import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_app/src/screens/form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: ListView(
      children: [
        Container(
          height: screenSize.height,
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ListTile(
                title: Text("Library App",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
                subtitle: Text(
                    "Discover many amazing book and manage loans very easy.",
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: SvgPicture.asset(
                  "assets/images/splash_image.svg",
                  semanticsLabel: 'Home Image',
                  width: 200,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  child: const Text("Login"),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("Sign Up"),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
