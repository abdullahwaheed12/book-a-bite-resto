import 'dart:developer';
import 'dart:io';

import 'package:book_a_bite_resto/controller/general_controller.dart';
import 'package:book_a_bite_resto/modules/sign_up/view_map.dart';
import 'package:book_a_bite_resto/utils/colors.dart';
import 'package:book_a_bite_resto/widgets/custom_dialog.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:intl/intl.dart' as intl;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'logic.dart';
import 'state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final SignUpLogic logic = Get.put(SignUpLogic());
  final SignUpState state = Get.find<SignUpLogic>().state;

  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

  bool obscureText = true;
  final timeFormat = intl.DateFormat.jm();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<SignUpLogic>().requestLocationPermission(context);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpLogic>(
      builder: (signUpLogic) => GetBuilder<GeneralController>(
        builder: (generalController) => GestureDetector(
          onTap: () {
            Get.find<GeneralController>().focusOut(context);
          },
          child: ModalProgressHUD(
            inAsyncCall: generalController.formLoader!,
            progressIndicator: const CircularProgressIndicator(
              color: customThemeColor,
            ),
            child: Scaffold(
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Form(
                    key: _signUpFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),

                        ///---image
                        InkWell(
                          onTap: () {
                            imagePickerDialog(context);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * .1,
                            width: MediaQuery.of(context).size.width * .2,
                            decoration: BoxDecoration(
                                color: customTextGreyColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)),
                            child: signUpLogic.restaurantImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      signUpLogic.restaurantImage!,
                                      fit: BoxFit.cover,
                                    ))
                                : const Icon(
                                    Icons.add_a_photo,
                                    color: customThemeColor,
                                    size: 25,
                                  ),
                          ),
                        ),
                        Text(
                          'Restaurant Image',
                          style: state.labelTextStyle,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),

                        ///---owner-name-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: signUpLogic.ownerNameController,
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Owner Name",
                              labelStyle: state.labelTextStyle,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---restaurant-name-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: signUpLogic.nameController,
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Restaurant Name",
                              labelStyle: state.labelTextStyle,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---restaurant-location-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            readOnly: true,
                            onTap: () async {
                              ///---------------GOOGLE_ADDRESS_API_START

                              Get.to(const MapView());

                              ///---------------GOOGLE_ADDRESS_API_END
                            },
                            controller: signUpLogic.addressController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Restaurant Location",
                              labelStyle: state.labelTextStyle,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---open-time
                        Theme(
                          data: ThemeData(
                              primaryColor: customThemeColor,
                              primarySwatch: Colors.amber),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: DateTimeField(
                              format: timeFormat,
                              controller: signUpLogic.openTimeController,
                              decoration: InputDecoration(
                                labelText: "Opening Time",
                                labelStyle: state.labelTextStyle,
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.5))),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.5))),
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: customThemeColor)),
                                errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                signUpLogic.openTimeController.text =
                                    time!.format(context).toString();
                                log('--->>>OPEN_TIME-->>${signUpLogic.openTimeController.text}');
                                return DateTimeField.convert(time);
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Field Required';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---close-time
                        Theme(
                          data: ThemeData(
                              primaryColor: customThemeColor,
                              primarySwatch: Colors.amber),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: DateTimeField(
                              format: timeFormat,
                              controller: signUpLogic.closeTimeController,
                              decoration: InputDecoration(
                                labelText: "Closing Time",
                                labelStyle: state.labelTextStyle,
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.5))),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.5))),
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: customThemeColor)),
                                errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                              ),
                              onShowPicker: (context, currentValue) async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                signUpLogic.closeTimeController.text =
                                    time!.format(context).toString();
                                log('--->>>CLOSE_TIME-->>${signUpLogic.closeTimeController.text}');
                                return DateTimeField.convert(time);
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Field Required';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---email-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: signUpLogic.emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Email Address",
                              labelStyle: state.labelTextStyle,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              } else if (!GetUtils.isEmail(
                                  signUpLogic.emailController.text)) {
                                return 'Enter Valid Email';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---website-address-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: signUpLogic.websiteAddressController,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Website Address",
                              labelStyle: state.labelTextStyle,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---about-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: signUpLogic.aboutController,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "About",
                              labelStyle: state.labelTextStyle,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---password-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: signUpLogic.passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            cursorColor: Colors.black,
                            obscureText: obscureText,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: state.labelTextStyle,
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child: Icon(
                                  !obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: customThemeColor,
                                  size: 25,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black.withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: customThemeColor)),
                              errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              } else if (signUpLogic
                                      .passwordController.text.length <
                                  6) {
                                return 'Password length must be greater than 6 ';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .03,
                        ),

                        ///---sign-up-button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: InkWell(
                            onTap: () async {
                              generalController.focusOut(context);
                              if (_signUpFormKey.currentState!.validate()) {
                                if (signUpLogic.restaurantImage != null) {
                                  // Get.toNamed(PageRoutes.phoneLogin);
                                  Get.find<GeneralController>()
                                      .updateFormLoader(true);
                                  await Get.find<GeneralController>()
                                      .firebaseAuthentication
                                      .signUp(context);

                                  Get.find<GeneralController>()
                                      .updateFormLoader(false);
                                } else {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return CustomDialogBox(
                                          title: 'FAILED!',
                                          titleColor: customDialogErrorColor,
                                          descriptions:
                                              'Please Upload Restaurant Image',
                                          text: 'Ok',
                                          functionCall: () {
                                            Navigator.pop(context);
                                          },
                                          img: 'assets/dialog_error.svg',
                                        );
                                      });
                                }
                              }
                            },
                            child: Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: customThemeColor,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: customThemeColor.withOpacity(0.19),
                                    blurRadius: 40,
                                    spreadRadius: 0,
                                    offset: const Offset(
                                        0, 22), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text("Sign Up",
                                    style: state.buttonTextStyle),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Have an account? ",
                                style: state.doNotTextStyle),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child:
                                  Text("Login", style: state.registerTextStyle),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List restaurantImagesList = [];
  void imagePickerDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    setState(() {
                      restaurantImagesList = [];
                    });
                    restaurantImagesList.add(await ImagePickerGC.pickImage(
                        enableCloseButton: true,
                        context: context,
                        source: ImgSource.Camera,
                        barrierDismissible: true,
                        imageQuality: 10,
                        maxWidth: 400,
                        maxHeight: 600));
                    setState(() {
                      Get.find<SignUpLogic>().restaurantImage =
                          File(restaurantImagesList[0].path);
                    });
                    log(restaurantImagesList[0].path);
                  },
                  child: Text(
                    "Camera",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 18),
                  )),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    setState(() {
                      restaurantImagesList = [];
                    });
                    restaurantImagesList.add(await ImagePickerGC.pickImage(
                        enableCloseButton: true,
                        context: context,
                        source: ImgSource.Gallery,
                        barrierDismissible: true,
                        imageQuality: 10,
                        maxWidth: 400,
                        maxHeight: 600));
                    setState(() {
                      Get.find<SignUpLogic>().restaurantImage =
                          File(restaurantImagesList[0].path);
                    });
                    log(restaurantImagesList[0].path);
                  },
                  child: Text(
                    "Gallery",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 18),
                  )),
            ],
          );
        });
  }
}
