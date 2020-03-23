// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailySet _$DailySetFromJson(Map<String, dynamic> json) {
  return DailySet(
    day: json['day'] == null ? null : DateTime.parse(json['day'] as String),
    tasks: (json['tasks'] as List)
        ?.map(
            (e) => e == null ? null : Task.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DailySetToJson(DailySet instance) => <String, dynamic>{
      'day': instance.day?.toIso8601String(),
      'tasks': instance.tasks?.map((e) => e?.toJson())?.toList(),
    };
