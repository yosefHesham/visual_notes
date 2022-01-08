import 'package:flutter/material.dart';

/// this is class to get device sizes , to write less code
class SizeHelper {
  BuildContext context;
  SizeHelper(this.context);

  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;

  bool get isLandscape =>
      MediaQuery.of(context).orientation == Orientation.landscape;
}
