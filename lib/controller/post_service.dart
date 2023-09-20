import 'dart:developer';
import 'dart:io';
import 'package:book_a_bite_resto/controller/url.dart';
import 'package:dio/dio.dart' as dio_instance;
import 'package:flutter/material.dart';
import 'package:book_a_bite_resto/controller/header.dart';

postMethod(
    BuildContext context,
    String apiUrl,
    dynamic postData,
    bool addAuthHeader,
    Function executionMethod   // for performing functionalities
    ) async{

  dio_instance.Response response;
  dio_instance.Dio dio = dio_instance.Dio();

  // dio.options.connectTimeout = 10000;
  // dio.options.receiveTimeout = 6000;


  setAcceptHeader(dio);
  setContentHeader(dio);



  if(apiUrl == fcmService){
    setCustomHeader(dio, 'Content-Type', 'application/json');
    setCustomHeader(dio, 'Authorization', 'key=AAAAMtiT2IA:APA91bEHqOn4hWzdZVuLS6NazF9Y6RxW5o6mGdHGD1MPkJ7hm_mnH3gimkAFyHh-'
        'Duna6cBBELy2t3wp3tZlIYy3gCgzjQ1GZaPP6sgo_l5_NToGmtmIrTtzgD2yTKs767mtev1FJULa');

  }

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      log('Internet Connected');
      try{

        log('postData--->> $postData');
        response = await dio.post(apiUrl, data: postData);

        if(response.statusCode == 200){
          log('StatusCode------>> ${response.statusCode}');
          log('Response $apiUrl------>> ${response.data}');

          executionMethod(context,true, response.data);
        }else{

          executionMethod(context,false, {'status':null});
          log('StatusCode------>> ${response.statusCode}');
          log('Response $apiUrl------>> $response');
        }
      } on dio_instance.DioError catch (e){

        executionMethod(context,false,{'status':null});

        if(e.response != null){
          log('Dio Error From Get $apiUrl -->> ${e.response}');
        }else{
          log('Dio Error From Get $apiUrl -->> $e');
        }
      }
    }
  } on SocketException catch (_) {

    log('Internet Not Connected');
  }


}method1(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  log('---->>> NotificationResponse $response');
  if (response['success'].toString() == '1') {}
}