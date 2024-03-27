import 'package:flutter/material.dart';

class LayoutSideBarButton extends StatelessWidget {
  const LayoutSideBarButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.maxFinite,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(shape: const LinearBorder()),
        child: Text(text),
      ),
    );
  }
}
