import 'package:book_a_bite_resto/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeState {
  TextStyle? drawerTitleTextStyle;
  TextStyle? homeHeadingTextStyle;
  TextStyle? homeSubHeadingTextStyle;
  TextStyle? listTileTitleTextStyle;
  TextStyle? listTileSubTitleTextStyle;
  TextStyle? nameTextStyle;
  TextStyle? priceTextStyle;
  TextStyle? otpTextStyle;
  HomeState() {
    ///Initialize variables
    drawerTitleTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white);
    homeHeadingTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w800, fontSize: 34, color: customTextGreyColor);
    homeSubHeadingTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w700, fontSize: 17, color: customThemeColor);
    listTileTitleTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w700, fontSize: 18, color: customTextGreyColor);
    listTileSubTitleTextStyle = GoogleFonts.nunito(
        fontWeight: FontWeight.w700, fontSize: 13, color: customTextGreyColor);
    nameTextStyle = GoogleFonts.nunito(
        fontSize: 18, fontWeight: FontWeight.w700, color: customTextGreyColor);
    priceTextStyle = GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: customTextGreyColor.withOpacity(0.5));
    otpTextStyle = GoogleFonts.nunito(
        fontSize: 11, fontWeight: FontWeight.w600, color: customTextGreyColor);
  }
}
