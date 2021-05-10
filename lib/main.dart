import 'package:flutter/material.dart';

import 'drag_demo/drag_demo.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: DragDemo(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
