import 'package:flutter/material.dart';

class ColorProvider extends ChangeNotifier {
  Color _color = const Color(0xFF2563EB);
  String _colorName = 'Electric Blue';

  Color get color => _color;
  String get colorName => _colorName;

  ColorProvider({Color color = const Color(0xFF2563EB), String colorName = 'Electric Blue'}) {
    _color = color;
    _colorName = colorName;
  }

  void setColor(Color color, [String? name]) {
    _color = color;
    if (name != null) {
      _colorName = name;
    }
    notifyListeners();
  }
}