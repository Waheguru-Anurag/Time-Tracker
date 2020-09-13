import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Input extends StatelessWidget{
  final String hintText;
  final TextEditingController controller;
  final Color cursorColor;
  IconData icon;
  TextAlign textAlign;
  TextInputType textInputType;

  Input({Key key, this.hintText, this.controller, this.cursorColor, this.icon, this.textAlign,this.textInputType}) : super(key: key);

  @override
  Widget build(BuildContext buildContext){
    return TextField(
      textAlign: textAlign==null?TextAlign.start:textAlign,
      keyboardType: textInputType,
      decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(icon)
      ),
      cursorColor: cursorColor,
      controller: controller,
    );
  }
}