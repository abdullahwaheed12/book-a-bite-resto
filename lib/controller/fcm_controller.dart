import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'general_controller.dart';

sendNotificationCall(String token, String? title, String body) async {
  http.Response response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAMtiT2IA:APA91bEHqOn4hWzdZVuLS6NazF9Y6RxW5o6mGdHGD1MPkJ7hm_mnH3gimkAFyHh-'
              'Duna6cBBELy2t3wp3tZlIYy3gCgzjQ1GZaPP6sgo_l5_NToGmtmIrTtzgD2yTKs767mtev1FJULa',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body':
              '${Get.find<GeneralController>().boxStorage.read('uid')}:$body',
          'title': title
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
        },
        'to': token
      },
    ),
  );
}
