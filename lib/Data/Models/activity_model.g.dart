// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(
    hasDailyReminder: json['hasDailyReminder'] as bool,
    category: json['category'] as String,
    dueDate: json['dueDate'] == null
        ? null
        : DateTime.parse(json['dueDate'] as String),
    dueDateTime:
        const CustomTODConverter().fromJson(json['dueDateTime'] as String),
    hasAlarm: json['hasAlarm'] as bool,
    hasPlan: json['hasPlan'] as bool,
    name: json['name'] as String,
    priority: json['priority'] as String,
    reminder: json['reminder'] == null
        ? null
        : DateTime.parse(json['reminder'] as String),
    startDate: json['startDate'] == null
        ? null
        : DateTime.parse(json['startDate'] as String),
    startDateTime:
        const CustomTODConverter().fromJson(json['startDateTime'] as String),
    taskColor: const CustomColorEncode().fromJson(json['taskColor'] as String),
    timeForTask:
        const CustomTODConverter().fromJson(json['timeForTask'] as String),
  );
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'hasDailyReminder': instance.hasDailyReminder,
      'hasPlan': instance.hasPlan,
      'taskColor': const CustomColorEncode().toJson(instance.taskColor),
      'hasAlarm': instance.hasAlarm,
      'priority': instance.priority,
      'category': instance.category,
      'name': instance.name,
      'dueDate': instance.dueDate?.toIso8601String(),
      'startDate': instance.startDate?.toIso8601String(),
      'dueDateTime': const CustomTODConverter().toJson(instance.dueDateTime),
      'startDateTime':
          const CustomTODConverter().toJson(instance.startDateTime),
      'timeForTask': const CustomTODConverter().toJson(instance.timeForTask),
      'reminder': instance.reminder?.toIso8601String(),
    };
