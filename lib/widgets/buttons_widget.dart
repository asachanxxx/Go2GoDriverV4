import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TaxiButtonSmall extends StatelessWidget {

  final String title;
  final Color color;
  final VoidCallback onPress;

  TaxiButtonSmall({required this.title,required this.onPress,required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black),backgroundColor: MaterialStateProperty.all(color),
        shape:MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)), ),
      ),
      child: Container(height: 30, child: Center(child: Text(title, style: GoogleFonts.roboto(
          fontSize: 17, color: Colors.white, fontWeight: FontWeight.normal),))),
      onPressed: onPress,
    );

  }
}

class TaxiButtonSmallWithSize extends StatelessWidget {

  final String title;
  final Color color;
  final VoidCallback onPress;
  final double fontSize;

  TaxiButtonSmallWithSize({required this.title,required this.onPress,required this.color,required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black),backgroundColor: MaterialStateProperty.all(color),
        shape:MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)), ),
      ),
      child: Container(height: 30, child: Center(child: Text(title, style: GoogleFonts.roboto(
          fontSize: fontSize, color: Colors.white, fontWeight: FontWeight.normal),))),
      onPressed: onPress,
    );


  }
}

class TaxiButtonSmallWithSizeSM extends StatelessWidget {

  final String title;
  final Color color;
  final VoidCallback onPress;
  final double fontSize;

  TaxiButtonSmallWithSizeSM({required this.title,required this.onPress,required this.color,required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black),backgroundColor: MaterialStateProperty.all(color),
        shape:MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)), ),
      ),
      child: Container(height: 15, child: Center(child: Text(title, style: GoogleFonts.roboto(
          fontSize: fontSize, color: Colors.white, fontWeight: FontWeight.normal),))),
      onPressed: onPress,
    );


  }
}