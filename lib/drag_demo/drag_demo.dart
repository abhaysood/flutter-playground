import 'package:drag/drag_demo/task_list_item.dart';
import 'package:drag/item.dart';
import 'package:flutter/material.dart';

import '../circular_reveal_clipper.dart';

class DragDemo extends StatefulWidget {
  @override
  _DragDemoState createState() => _DragDemoState();
}

class _DragDemoState extends State<DragDemo> {
  final _listGlobalKey = GlobalKey<AnimatedListState>();
  bool _isDragging = false;
  final _tasks = TasksStore.tasks;

  Widget _buildList() {
    return Expanded(
      child: AnimatedList(
        key: _listGlobalKey,
        initialItemCount: _tasks.length,
        itemBuilder: (_, index, animation) => _buildTaskItem(_tasks[index]),
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildHeader() {
    return DragTarget<Task>(
      onAccept: (data) {
        _listGlobalKey.currentState!.removeItem(
          _tasks.indexOf(data),
          (_, Animation<double> animation) {
            return SizeTransition(
              sizeFactor: CurvedAnimation(
                parent: animation,
                curve: Interval(0, 1),
              ),
              child: SizedBox(height: 80),
            );
          },
        );
        setState(() {
          _tasks.remove(data);
        });
      },
      builder: (_, candidateData, rejectedData) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 100),
          child: _isDragging
              ? _buildDropTargetHeader(candidateData)
              : _buildListHeading(),
        );
      },
    );
  }

  Widget _buildDropTargetHeader(List<Task?> candidateData) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0.1, end: 1),
      builder: (_, value, child) {
        return ClipPath(
          clipper: CircularRevealClipper(
            fraction: value,
          ),
          child: child,
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        alignment: Alignment.center,
        height: 80,
        color: candidateData.isNotEmpty
            ? Color(0xFFFFC4BB)
            : Color(0xFFFFC4BB).withOpacity(0.5),
        child: Text(
          "Drop a task here to delete",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF2F4858),
          ),
        ),
      ),
    );
    /*
    return AnimatedContainer(
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
    );
     */
  }

  Container _buildListHeading() {
    return Container(
      alignment: Alignment.center,
      height: 80,
      child: Text(
        "In Progress",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return DraggableTaskListItem(
      onDragStarted: () {
        setState(() {
          _isDragging = true;
        });
      },
      onDragEnd: (details) {
        setState(() {
          _isDragging = false;
        });
      },
      task: task,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildList(),
      ],
    );
  }
}
