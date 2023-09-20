import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProductState {
  TextStyle? labelTextStyle;
  TextStyle? buttonTextStyle;
  EditProductState() {
    ///Initialize variables
    labelTextStyle = GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w900,
        color: Colors.black.withOpacity(0.4));
    buttonTextStyle = GoogleFonts.nunito(
        fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white);
  }
}
