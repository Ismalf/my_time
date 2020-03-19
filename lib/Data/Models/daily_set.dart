import 'package:json_annotation/json_annotation.dart';
import 'package:my_time/Data/Models/activity_model.dart';


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

}


/// Helper class meant to hold all the sets loaded
/// from the db
/// 
/// 
@JsonSerializable(explicitToJson: true)
class DailySetList{
  
  List<DailySet> dailysets;

  DailySetList({this.dailysets});

}