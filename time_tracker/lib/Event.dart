
import 'package:flutter/cupertino.dart';

class EventWidget{
  String name,hour,minute,second;

  EventWidget(String name, String hour, String minute, String second){
    this.hour=hour;
    this.minute=minute;
    this.second=second;
    this.name=name;
  }

}