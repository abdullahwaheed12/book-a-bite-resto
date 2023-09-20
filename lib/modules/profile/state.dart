import 'package:book_a_bite_resto/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileState {
  TextStyle? updateButtonStyle;
  TextStyle? headingTextStyle;
  TextStyle? subHeadingTextStyle;
  TextStyle? nameTextStyle;
  TextStyle? detailTextStyle;
  TextStyle? tileTitleTextStyle;
  ProfileState() {
    ///Initialize variables
    updateButtonStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w900, fontSize: 17, color: Colors.white);
    headingTextStyle = GoogleFonts.nunito(
        fontSize: 34, fontWeight: FontWeight.w800, color: customThemeColor);
    subHeadingTextStyle = GoogleFonts.nunito(
        fontSize: 18, fontWeight: FontWeight.w700, color: customTextGreyColor);
    nameTextStyle = GoogleFonts.nunito(
        fontSize: 18, fontWeight: FontWeight.w900, color: customTextGreyColor);
    detailTextStyle = GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Colors.black.withOpacity(0.5));
    tileTitleTextStyle = GoogleFonts.nunito(
        fontSize: 18, fontWeight: FontWeight.w900, color: customTextGreyColor);
  }
}
