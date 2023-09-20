import 'package:book_a_bite_resto/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailState {
  TextStyle? appBarTextStyle;
  TextStyle? restaurantNameTextStyle;
  TextStyle? otpTextStyle;
  TextStyle? productNameTextStyle;
  TextStyle? productPriceTextStyle;
  TextStyle? billValueTextStyle;
  TextStyle? billLabelTextStyle;
  TextStyle? grandTotalTextStyle;
  TextStyle? buttonTextStyle;
  OrderDetailState() {
    ///Initialize variables
    appBarTextStyle = GoogleFonts.nunito(
        fontSize: 28, fontWeight: FontWeight.w800, color: customTextGreyColor);
    restaurantNameTextStyle = GoogleFonts.nunito(
        fontSize: 28, fontWeight: FontWeight.w800, color: customTextGreyColor);
    otpTextStyle = GoogleFonts.nunito(
        fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white);
    productNameTextStyle = GoogleFonts.nunito(
        fontSize: 17, fontWeight: FontWeight.w600, color: customTextGreyColor);
    productPriceTextStyle = GoogleFonts.nunito(
        fontSize: 15, fontWeight: FontWeight.w700, color: customTextGreyColor);
    billValueTextStyle = GoogleFonts.nunito(
        fontSize: 15, fontWeight: FontWeight.w700, color: customTextGreyColor);
    billLabelTextStyle = GoogleFonts.nunito(
        fontSize: 17, fontWeight: FontWeight.w900, color: customTextGreyColor);
    grandTotalTextStyle = GoogleFonts.nunito(
        fontSize: 25, fontWeight: FontWeight.w900, color: customThemeColor);
    buttonTextStyle = GoogleFonts.nunito(
        fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white);
  }
}
