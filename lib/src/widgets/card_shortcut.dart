import 'package:flutter/material.dart';

class Shortcut extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final Function()? onTap;

  const Shortcut(
      {super.key,
      required this.title,
      required this.subtitle,
      this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Card(
            child: InkWell(
          splashColor: Theme.of(context).splashColor,
          onTap: onTap,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: screenSize.width * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
                Icon(
                  icon,
                  size: screenSize.width * 0.2,
                ),
              ],
            ),
          ),
        )));
  }
}
