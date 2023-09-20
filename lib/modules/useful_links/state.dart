import 'package:book_a_bite_resto/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyState {
  TextStyle? appBarTextStyle;
  TextStyle? titleTextStyle;
  PrivacyPolicyState() {
    ///Initialize variables
    appBarTextStyle = GoogleFonts.nunito(
        fontSize: 28, fontWeight: FontWeight.w800, color: customTextGreyColor);
    titleTextStyle = GoogleFonts.nunito(
        fontSize: 14, fontWeight: FontWeight.w700, color: customTextGreyColor);
  }
}
