import 'dart:developer';

import 'package:book_a_bite_resto/controller/general_controller.dart';
import 'package:book_a_bite_resto/controller/local_notification.dart';
import 'package:book_a_bite_resto/modules/splash/view.dart';
import 'package:book_a_bite_resto/route_generator.dart';
import 'package:book_a_bite_resto/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Get.put(GeneralController());
  // log(message.notification.title.toString());
  // if (message.data['channel'] != null) {
  //   String route = message.data['route'];
  //   log('route check ' + route.toString());
  //   channelName = message.data['channel'];
  //   Get.find<AppController>().updateAgoraToken(message.data['channel_token']);
  //   log('FromNotiToken-->>${message.data['channel_token']}');
  // }
  LocalNotificationService.display(message);
  log(message.data.toString());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await GetStorage.init();

  Get.put(GeneralController());
  runApp(const InitClass());
}

class InitClass extends StatefulWidget {
  const InitClass({Key? key}) : super(key: key);

  @override
  _InitClassState createState() => _InitClassState();
}

class _InitClassState extends State<InitClass> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ]);

    LocalNotificationService.initialize(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
      getPages: routes(),
      themeMode: ThemeMode.light,
      theme: lightTheme(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    /// on app closed
    FirebaseMessaging.instance.getInitialMessage().then((message) {});

    ///forground messages
    FirebaseMessaging.onMessage.listen((message) {
      log('foreground messages----->>');
      log(message.notification.toString());
      if (message.notification != null) {
        log(message.notification!.body.toString());
        log(message.notification!.title.toString());
      }
      LocalNotificationService.display(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('Notifications--->>$message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashPage();
    // return const SignUpPage();
  }
}
