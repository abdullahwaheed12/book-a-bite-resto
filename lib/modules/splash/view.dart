import 'package:book_a_bite_resto/controller/general_controller.dart';
import 'package:book_a_bite_resto/modules/home/view.dart';
import 'package:book_a_bite_resto/modules/login/view.dart';
import 'package:book_a_bite_resto/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'logic.dart';
import 'state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashLogic logic = Get.put(SplashLogic());
  final SplashState state = Get.find<SplashLogic>().state;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5))
        .whenComplete(() => Get.offAll(const ScreenController()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/splashImage.png',
            width: MediaQuery.of(context).size.width * .7,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Food Tastes Better When It’s Saving The World',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: customThemeColor),
          )
        ],
      ),
    ));
  }
}

class ScreenController extends StatelessWidget {
  const ScreenController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.find<GeneralController>().boxStorage.hasData('session')) {
      // return const LoginPage();
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
