import 'package:flutter/material.dart';
import 'package:my_time/BL/common.dart';
import 'package:my_time/Data/Daos/dailySet_dao.dart';
import 'package:my_time/Data/Models/activity_model.dart';
import 'package:my_time/Data/Models/daily_set.dart';

class TaskManagement {
  /// Sort tasks of all the current dailysets available
  /// so all tasks are related to their due date set
  static sortTasksToDueDate(DailySetList _sets) {
    List<Task> _dueTomorrow = [];
    _sets.dailysets.forEach((_ds) {
      //Add to the new set all the tasks that didn't correspond to the
      //previous set
      if (_dueTomorrow.isNotEmpty) {
        _ds.tasks.addAll(_dueTomorrow);
        _dueTomorrow = [];
      }

      //get all the tasks that have a due date different to the current daily set
      _ds.tasks.forEach((_t) {
        if (!Commons().compareDates(_t.dueDate, _ds.day)) {
          _dueTomorrow.add(_t);
        }
      });

      //remove all those tasks from the current daily set
      _dueTomorrow.forEach((_t) => _ds.tasks.removeAt(_ds.tasks.indexOf(_t)));

      //keep them to add for the next day
    });
  }

  /// Call these method every night to reassing to the next day tasks that
  /// are not yet completed
  static reassingNotCompletedTasks() {}

  /// Empties database registers until a certain date (inclusive)
  static removeTasksUntil(DateTime _date, Map<int, String> _keys,
      DailySetList _sets) async {
    // first get all the sets that are prior to provided date
    List<int> _index = [];
    int i = 0;
    var _candidates = [];
    _sets.dailysets.forEach((_ds) {
      // as daily sets are added in order, once one ds is after the
      // specified date, break the loop
      if (_ds.day.isBefore(_date)) {
        _candidates.add(_ds.formatDate());
        _index.add(i++);
      }
    });
    //remove from sets object
    _index.forEach((_i) => _sets.dailysets.removeAt(_i));
    //get keys and delete from db
    int _kl = _keys.keys.length;
    int _cl = _candidates.length;
    for (int i = 0; i < _kl; i++) {
      for (int j = 0; j < _cl; j++) {
        if (_candidates[j] == _keys[i]) {
          await DailySetDao().delete(i);
          return;
        }
      }
    }
    /* _keys.keys.forEach(
      (_k) => _candidates.forEach(
        (_c) {
          if (_c == _keys[_k]) {
            //once app is loaded again these sets wwont exist
            DailySetDao().delete(_k).then((_v) => print(_v));
            return;
          }
        },
      ),
    ); */
    // clean the keys memory register
    _candidates.forEach((_c) => _keys.removeWhere((_k, _v) => _v == _c));
    
    return _index.length;
  }
}
