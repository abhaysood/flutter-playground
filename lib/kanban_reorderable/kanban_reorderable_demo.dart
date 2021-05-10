import 'package:drag/item.dart';
import 'package:flutter/material.dart';

class KanbanDemo extends StatefulWidget {
  @override
  _KanbanDemoState createState() => _KanbanDemoState();
}

class _KanbanDemoState extends State<KanbanDemo> {
  late List<Task> tasks;
  late List<String> columns;

  @override
  void initState() {
    tasks = TasksStore.tasks;
    columns = ["Backlog", "In Progress", "Done"];
    super.initState();
  }

  void _reorderTask(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final removedTask = tasks.removeAt(oldIndex);
      tasks.insert(newIndex, removedTask);
    });
  }

  void _reorderColumn(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = columns.removeAt(oldIndex);
      columns.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: columns.length,
        onReorder: (int oldIndex, int newIndex) =>
            _reorderColumn(oldIndex, newIndex),
        itemBuilder: (_, columnIndex) {
          return Padding(
            key: ValueKey(columns[columnIndex]),
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              width: MediaQuery.of(context).size.width / 1.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      columns[columnIndex],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ReorderableListView.builder(
                      itemCount: tasks.length,
                      onReorder: (oldIndex, newIndex) =>
                          _reorderTask(oldIndex, newIndex),
                      itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.all(4),
                        key: ValueKey(tasks[index].id),
                        child: Card(
                          child: ListTile(
                            title: Text(tasks[index].title),
                            subtitle: Text(tasks[index].description),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
