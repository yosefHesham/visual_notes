import 'package:flutter/material.dart';

class SizeHelper {
  BuildContext context;
  SizeHelper(this.context);

  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
}
