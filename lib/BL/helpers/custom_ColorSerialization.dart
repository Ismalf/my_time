import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';


class CustomColorEncode implements JsonConverter<Color, String>{
  
  const CustomColorEncode();
  
  @override
  Color fromJson(String json) {
    // TODO: implement fromJson
    return Color(int.parse(json));
  }

  @override
  String toJson(Color object) {
    // TODO: implement toJson
    return object.value.toString();
  }

}