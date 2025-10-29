import 'package:flutter/material.dart';

class FloatingOption extends StatelessWidget {
  final IconData iconName;
  final Widget page;
  final String heroTag;

  const FloatingOption({
    super.key,
    required this.iconName,
    required this.page,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: heroTag,
      shape: const CircleBorder(),
      backgroundColor: Colors.black87,
      foregroundColor: Colors.white,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Icon(iconName),
    );
  }
}
