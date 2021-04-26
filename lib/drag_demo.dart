import 'dart:math';

import 'package:drag/item.dart';
import 'package:flutter/material.dart';

class DragDemo extends StatefulWidget {
  @override
  _DragDemoState createState() => _DragDemoState();
}

class _DragDemoState extends State<DragDemo> {
  final _listGlobalKey = GlobalKey<AnimatedListState>();
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return buildTaskList(TasksStore.tasks);
  }

  Widget buildTaskList(List<Task> tasks) {
    return Column(
      children: [
        Stack(
          children: [
            DragTarget<Task>(
              onAccept: (data) {
                _listGlobalKey.currentState!.removeItem(
                  tasks.indexOf(data),
                  (_, Animation<double> animation) {
                    return SizeTransition(
                      sizeFactor: CurvedAnimation(
                        parent: animation,
                        curve: Interval(0.0, 1.0),
                      ),
                      axisAlignment: 0.0,
                      child: SizedBox(height: 80),
                    );
                  },
                );
                setState(() {
                  tasks.remove(data);
                });
              },
              builder: (_, candidateData, rejectedData) {
                return AnimatedCrossFade(
                  crossFadeState: !_isDragging
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Duration(milliseconds: 200),
                  firstChild: Container(
                    alignment: Alignment.center,
                    height: 80,
                    child: Text(
                      "Todo",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  secondChild: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    color: candidateData.isNotEmpty
                        ? Color(0xFFFFC4BB)
                        : Color(0xFFFFC4BB).withOpacity(0.3),
                    height: 80,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Drop here to delete",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF2F4858),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        Expanded(
          child: AnimatedList(
            key: _listGlobalKey,
            initialItemCount: TasksStore.tasks.length,
            itemBuilder: (_, index, animation) => buildTaskItem(tasks[index]),
            padding: EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget buildTaskItem(Task task) {
    return LongPressDraggable<Task>(
      data: task,
      dragAnchor: DragAnchor.child,
      childWhenDragging: Container(
        height: 80,
        color: Colors.grey.shade200,
      ),
      onDragStarted: () {
        setState(() {
          _isDragging = true;
        });
      },
      onDragEnd: (_) {
        setState(() {
          _isDragging = false;
        });
      },
      onDragUpdate: (details) {
        print(details);
      },
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
