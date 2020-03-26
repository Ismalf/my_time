import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:my_time/BL/helpers/custom_ColorSerialization.dart';
import 'package:my_time/BL/helpers/custom_timeOfDay.dart';


part 'activity_model.g.dart';

@JsonSerializable()
@CustomTODConverter()
@CustomColorEncode()
class Task {
  bool hasDailyReminder;

  bool hasPlan;

  Color taskColor;

  bool hasAlarm;

  String priority;

  String category;

  String name;

  DateTime dueDate;

  DateTime startDate;

  TimeOfDay dueDateTime;

  TimeOfDay startDateTime;

  TimeOfDay timeForTask;

  DateTime reminder;

  Task(
      {this.hasDailyReminder = false,
      this.category = 'Misc',
      this.dueDate,
      this.dueDateTime,
      this.hasAlarm = false,
      this.hasPlan = false,
      this.name = '',
      this.priority = 'Low',
      this.reminder,
      this.startDate,
      this.startDateTime,
      this.taskColor = Colors.lightBlue,
      this.timeForTask});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
