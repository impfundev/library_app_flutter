import 'package:flutter/material.dart';
import 'package:library_app/src/widgets/loading.dart';

class ButtonCustom extends StatefulWidget {
  final Widget? child;
  final bool? isLoading;
  final void Function()? onPressed;

  const ButtonCustom({super.key, this.onPressed, this.child, this.isLoading});

  @override
  State<StatefulWidget> createState() => _ButtonCustom();
}

class _ButtonCustom extends State<ButtonCustom> {
  get onPressed => widget.onPressed;
  get child => widget.child;
  get isLoading => widget.isLoading;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: isLoading ? const Loading() : child,
    );
  }
}
