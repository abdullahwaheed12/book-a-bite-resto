import 'dart:developer';
import 'dart:io';

import 'package:book_a_bite_resto/controller/general_controller.dart';
import 'package:book_a_bite_resto/utils/colors.dart';
import 'package:book_a_bite_resto/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:multiselect/multiselect.dart';

import 'logic.dart';
import 'state.dart';

class AddBiteBagPage extends StatefulWidget {
  const AddBiteBagPage({Key? key}) : super(key: key);

  @override
  _AddBiteBagPageState createState() => _AddBiteBagPageState();
}

class _AddBiteBagPageState extends State<AddBiteBagPage> {
  final AddBiteBagLogic logic = Get.put(AddBiteBagLogic());
  final AddBiteBagState state = Get.find<AddBiteBagLogic>().state;

  final GlobalKey<FormState> _addBiteBagFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<GeneralController>().updateFormLoader(false);
    });
    logic.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddBiteBagLogic>(
      builder: (_addBiteBagLogic) => GetBuilder<GeneralController>(
        builder: (_generalController) => GestureDetector(
          onTap: () {
            Get.find<GeneralController>().focusOut(context);
          },
          child: ModalProgressHUD(
            inAsyncCall: _generalController.formLoader!,
            progressIndicator: const CircularProgressIndicator(
              color: customThemeColor,
            ),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: customThemeColor,
                    size: 25,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Form(
                    key: _addBiteBagFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
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
                            child: _addBiteBagLogic.productImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      _addBiteBagLogic.productImage!,
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
                          'Bite Bag Image',
                          style: state.labelTextStyle,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: DropDownMultiSelect(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 0.0),
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
                            onChanged: (List<String> x) {
                              setState(() {
                                _addBiteBagLogic.selectedCategories = x;
                              });
                            },
                            options: _addBiteBagLogic.categoriesDropDownList,
                            selectedValues: _addBiteBagLogic.selectedCategories,
                            whenEmpty: 'Product Category',
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * .0,
                        ),

                        ///---bite-bag-items-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: _addBiteBagLogic.itemsController,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Bite Bag Items",
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

                        ///---bite-bag-quantity-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: _addBiteBagLogic.quantityController,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Bite Bag Quantity",
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

                        ///---bite-bag-original-price-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            onChanged: (String? newValue) {
                              if (_addBiteBagLogic.originalPriceController.text
                                      .isNotEmpty &&
                                  _addBiteBagLogic.discountedPriceController
                                      .text.isNotEmpty) {
                                setState(() {
                                  _addBiteBagLogic.discountValueController
                                      .text = (((int.parse(_addBiteBagLogic
                                                      .originalPriceController
                                                      .text
                                                      .toString()) -
                                                  int.parse(_addBiteBagLogic
                                                      .discountedPriceController
                                                      .text
                                                      .toString())) /
                                              int.parse(_addBiteBagLogic
                                                  .originalPriceController.text
                                                  .toString())) *
                                          100)
                                      .toPrecision(1)
                                      .toString();
                                });
                                log('DISCOUNTED VALUE--->>${_addBiteBagLogic.discountValueController.text}');
                              } else {
                                _addBiteBagLogic.discountValueController.text =
                                    '0';
                              }
                            },
                            controller:
                                _addBiteBagLogic.originalPriceController,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Original Price",
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

                        ///---bite-bag-discounted-price-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            onChanged: (String? newValue) {
                              if (_addBiteBagLogic.originalPriceController.text
                                      .isNotEmpty &&
                                  _addBiteBagLogic.discountedPriceController
                                      .text.isNotEmpty) {
                                setState(() {
                                  _addBiteBagLogic.discountValueController
                                      .text = (((int.parse(_addBiteBagLogic
                                                      .originalPriceController
                                                      .text
                                                      .toString()) -
                                                  int.parse(_addBiteBagLogic
                                                      .discountedPriceController
                                                      .text
                                                      .toString())) /
                                              int.parse(_addBiteBagLogic
                                                  .originalPriceController.text
                                                  .toString())) *
                                          100)
                                      .toPrecision(1)
                                      .toString();
                                });
                                log('DISCOUNTED VALUE--->>${_addBiteBagLogic.discountValueController.text}');
                              } else {
                                _addBiteBagLogic.discountValueController.text =
                                    '0';
                              }
                            },
                            controller:
                                _addBiteBagLogic.discountedPriceController,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Price After Discount",
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

                        ///---bite-bag-discount-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            readOnly: true,
                            controller:
                                _addBiteBagLogic.discountValueController,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Discount Percentage",
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
                              } else if (double.parse(_addBiteBagLogic
                                          .discountValueController.text
                                          .toString())
                                      .toInt() <
                                  50) {
                                return 'Discount Must Be Greater Than Equal To 50%';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),

                        ///---chef-note-field
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFormField(
                            controller: _addBiteBagLogic.chefNoteController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            minLines: 1,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              labelText: "Chef's Note",
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
                          height: MediaQuery.of(context).size.height * .03,
                        ),

                        ///---add-bite-bag-button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: InkWell(
                            onTap: () async {
                              _generalController.focusOut(context);
                              if (_addBiteBagFormKey.currentState!.validate() &&
                                  _addBiteBagLogic
                                      .selectedCategories.isNotEmpty) {
                                if (_addBiteBagLogic.productImage != null) {
                                  _generalController.updateFormLoader(true);
                                  _addBiteBagLogic.uploadFile(
                                      _addBiteBagLogic.productImage, context);
                                } else {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return CustomDialogBox(
                                          title: 'FAILED!',
                                          titleColor: customDialogErrorColor,
                                          descriptions:
                                              'Please Upload Bite Bag Image',
                                          text: 'Ok',
                                          functionCall: () {
                                            Navigator.pop(context);
                                          },
                                          img: 'assets/dialog_error.svg',
                                        );
                                      });
                                }
                              } else {
                                Get.snackbar(
                                  'Fill All Fields Please...',
                                  '',
                                  colorText: Colors.white,
                                  backgroundColor:
                                      customThemeColor.withOpacity(0.7),
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: const EdgeInsets.all(15),
                                );
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
                                child:
                                    Text("ADD", style: state.buttonTextStyle),
                              ),
                            ),
                          ),
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

  List productImagesList = [];
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
                      productImagesList = [];
                    });
                    productImagesList.add(await ImagePickerGC.pickImage(
                        enableCloseButton: true,
                        context: context,
                        source: ImgSource.Camera,
                        barrierDismissible: true,
                        imageQuality: 10,
                        maxWidth: 400,
                        maxHeight: 600));
                    setState(() {
                      Get.find<AddBiteBagLogic>().productImage =
                          File(productImagesList[0].path);
                    });
                    log(productImagesList[0].path);
                  },
                  child: Text(
                    "Camera",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontSize: 18),
                  )),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    setState(() {
                      productImagesList = [];
                    });
                    productImagesList.add(await ImagePickerGC.pickImage(
                        enableCloseButton: true,
                        context: context,
                        source: ImgSource.Gallery,
                        barrierDismissible: true,
                        imageQuality: 10,
                        maxWidth: 400,
                        maxHeight: 600));
                    setState(() {
                      Get.find<AddBiteBagLogic>().productImage =
                          File(productImagesList[0].path);
                    });
                    log(productImagesList[0].path);
                  },
                  child: Text(
                    "Gallery",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontSize: 18),
                  )),
            ],
          );
        });
  }
}
