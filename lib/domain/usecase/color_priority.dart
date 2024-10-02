import 'package:flutter/material.dart';

class ColorPriority{
  
  static Color getColor(int priority){
    switch (priority) {
      case 1: return Colors.red;       
      case 2: return Colors.yellow;
      case 3: return Colors.green;  
      default: return Colors.green; 
    }
  }
}