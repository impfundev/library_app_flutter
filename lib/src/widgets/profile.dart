import 'package:flutter/material.dart';
import 'package:library_app/src/providers/auth_provider.dart';

import 'package:library_app/src/screens/form_screen.dart';
import 'package:library_app/src/widgets/navigations.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => Provider.of<AuthProvider>(context, listen: false).getUserDetail(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        final firstName = user?.firstName ?? "";
        final lastName = user?.lastName ?? "";
        final fullName = "$firstName $lastName";

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [const TopBar(title: "Profile")];
            },
            body: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50.0,
                      child: Icon(
                        Icons.person_rounded,
                        size: 50.0,
                      ),
                    ),
                    ListTile(
                      title: Column(
                        children: [
                          Text(
                            user.username,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.labelSmall,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      subtitle: Text(
                        fullName,
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    FilledButton(
                      child: const Text("Edit Profile"),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProfileEditScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    OutlinedButton(
                      child: const Text("Log Out"),
                      onPressed: () {
                        authProvider.signOut();
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
