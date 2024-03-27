import 'package:flutter/widgets.dart';

class LayoutHelper {
  LayoutHelper(this.constraints);

  final BoxConstraints constraints;
  final small = 640;
  final large = 1024;

  bool get isMobile => constraints.maxWidth < small;
  bool get isMedium =>
      constraints.maxWidth > small && constraints.maxWidth < 1024;
  bool get isLarge => constraints.maxWidth > large;
}
