import 'package:flutter/material.dart';

class ChoiceChipTheme extends StatelessWidget {
  final ChoiceChip child;
  final bool isSelected;

  const ChoiceChipTheme(
      {Key? key, required this.isSelected, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        chipTheme: ChipThemeData(
          backgroundColor: Colors.transparent,
          disabledColor: Colors.transparent,
          selectedColor: Colors.transparent,
          secondarySelectedColor: Theme.of(context).primaryColor,
          labelPadding: EdgeInsets.zero,
          padding: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.grey),
          ),
          labelStyle: TextStyle(color: Colors.black),
          secondaryLabelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w800),
          brightness: Brightness.light,
        ),
      ),
      child: child,
    );
  }
}
