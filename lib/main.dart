import 'package:flutter/material.dart';
import 'kanban_reorderable/kanban_reorderable_demo.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: KanbanDemo(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
