import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class CustomTODConverter implements JsonConverter<TimeOfDay, String>{
  const CustomTODConverter();
  
  @override
  TimeOfDay fromJson(String json) {
    // TODO: implement fromJson
    var values = json.split(':');
    return TimeOfDay(hour: int.parse(values[0]), minute: int.parse(values[1]));
  }

  @override
  String toJson(TimeOfDay object) {
    // TODO: implement toJson
    return object.hour.toString()+':'+object.minute.toString();
  }
  
}