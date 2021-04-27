import 'dart:math';

import 'package:drag/item.dart';
import 'package:flutter/material.dart';

class DraggableTaskListItem extends StatelessWidget {
  final VoidCallback onDragStarted;
  final DragEndCallback onDragEnd;
  final Task task;

  DraggableTaskListItem({
    Key? key,
    required this.onDragStarted,
    required this.onDragEnd,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Task>(
      data: task,
      dragAnchor: DragAnchor.child,
      childWhenDragging: Container(
        height: 80,
        color: Colors.grey.shade200,
      ),
      onDragStarted: onDragStarted,
      onDragEnd: onDragEnd,
      feedback: LayoutBuilder(
        builder: (context, constraints) {
          return Transform.rotate(
            alignment: Alignment.center,
            angle: -pi / 128,
            child: Container(
              width: MediaQuery.of(context).size.width - 32,
              height: 80,
              child: Card(
                child: ListTile(
                  tileColor: Color(0xFFFFC4BB).withOpacity(0.5),
                  title: Text(task.title),
                  subtitle: Text(
                    task.description,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      child: Container(
        height: 80,
        child: Card(
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
          ),
        ),
      ),
    );
  }
}
