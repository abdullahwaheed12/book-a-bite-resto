import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashState {
  TextStyle? splashTitleTextStyle;
  TextStyle? splashSubTitleTextStyle;
  SplashState() {
    ///Initialize variables
    splashTitleTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black);
    splashSubTitleTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.normal, fontSize: 12, color: Colors.black);
  }
}
