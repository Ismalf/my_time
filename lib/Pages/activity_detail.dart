import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_time/BL/dataholder.dart';
import 'package:my_time/Data/Daos/dailySet_dao.dart';
import 'package:my_time/Data/Models/activity_model.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

import 'Widgets/activityWidget.dart';

enum DraggingMode {
  iOS,
  Android,
}

class ActivityDetail extends StatefulWidget {
  @override
  _ActivityDetail createState() => _ActivityDetail();
}

class _ActivityDetail extends State<ActivityDetail> {
  List<ActivityWidget> _activities;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _activities = [];
  }

  _loadTasks() {
    var tasks = StateContainer.of(context).getTodaySet().tasks;

    for (var i = 0; i < tasks.length; i++) {
      _activities.add(ActivityWidget(
        tasks[i],
        key: ValueKey(i),
        onChanged: (task) => _updateTask(i, task),
      ));
    }
    setState(() {});
  }

  _exit() {
    setState(() {});
    StateContainer.of(context).updateDailySet();
    Navigator.of(context).pop();
  }

  /// current index of task, and new task
  _updateTask(int index, Task task) {
    StateContainer.of(context).getTodaySet().tasks[index] = task;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Color _appbarcolors = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;

    if (_activities.isEmpty) {
      _loadTasks();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: _appbarcolors,
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Theme.of(context).primaryColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios), onPressed: () => _exit()),
        centerTitle: true,
        title: Row(
          children: <Widget>[
            Text(
              'My',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _appbarcolors,
                fontSize: 25.0,
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Activities',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _appbarcolors,
                fontSize: 25.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      body: ReorderableList(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Hero(
                    tag: 'ActivitiesTag',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        'Activities for today',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            ListView.builder(
              itemBuilder: (context, index) {
                return Item(
                  data: _activities[index],
                  isFirst: index == 0,
                  isLast: index == _activities.length - 1,
                  draggingMode: DraggingMode.Android,
                );
              },
              itemCount: _activities.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
            ),
          ],
        ),
        onReorder: this._reorderCallback,
        onReorderDone: this._reorderDone,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newActivity,
        tooltip: 'Increment',
        child: Icon(
          Icons.add,
          color: _appbarcolors,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        splashColor: Colors.white,
      ),
    );
  }

  _newActivity() {
    ///TODO implement new activity page
  }

  int _indexOfKey(Key key) {
    return _activities.indexWhere((ActivityWidget d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = _activities[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      _activities.removeAt(draggingIndex);
      _activities.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = _activities[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.task.name}}");
    List<Task> tasks = [];
    //get new list of tasks
    _activities.forEach((ac) => tasks.add(ac.task));
    StateContainer.of(context).getTodaySet().tasks = tasks;
    setState(() {});
  }
}

class Item extends StatelessWidget {
  Item({
    this.data,
    this.isFirst,
    this.isLast,
    this.draggingMode,
  });

  final ActivityWidget data;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Colors.transparent);
    }

    // For iOS dragging mdoe, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = draggingMode == DraggingMode.iOS
        ? ReorderableListener(
            child: Container(
              padding: EdgeInsets.only(right: 10.0, left: .0),
              color: Colors.transparent,
              child: Center(
                child: Icon(Icons.reorder, color: Color(0xFF888888)),
              ),
            ),
          )
        : Container();

    Widget content = Container(
      //decoration: decoration,
      child: Opacity(
        // hide content for placeholder
        opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
        child: Row(
          children: <Widget>[
            Expanded(
              child: data,
            ),
            // Triggers the reordering
            dragHandle,
          ],
        ),
      ),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.Android) {
      content = DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild);
  }
}
