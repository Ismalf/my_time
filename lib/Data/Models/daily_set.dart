import 'package:json_annotation/json_annotation.dart';
import 'package:my_time/Data/Models/activity_model.dart';

part 'daily_set.g.dart';

/// A Daily set of activities, this class holds
/// a specific list of 'tasks' or 'activities'
/// related to a specific date
/// 
/// SAVE THIS OBJECT TO DB
@JsonSerializable(explicitToJson: true)
class DailySet{
  DateTime day;
  List<Task> tasks;

  DailySet({this.day, this.tasks});

  factory DailySet.fromJson(Map<String, dynamic> json) => _$DailySetFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$DailySetToJson(this);

}


/// Helper class meant to hold all the sets loaded
/// from the db



class DailySetList{
  
  List<DailySet> dailysets;

  DailySetList({this.dailysets});

  factory DailySetList.fromJson(List<dynamic> json) {
    return DailySetList(
        dailysets: json
            .map((e) => DailySet.fromJson(e as Map<String, dynamic>))
            .toList());
  }

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  //Map<String, dynamic> toJson() => _$DailySetListToJson(this);

}