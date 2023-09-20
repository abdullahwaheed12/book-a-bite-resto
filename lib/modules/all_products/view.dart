import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:book_a_bite_resto/controller/general_controller.dart';
import 'package:book_a_bite_resto/modules/home/logic.dart';
import 'package:book_a_bite_resto/modules/product_detail/view.dart';
import 'package:book_a_bite_resto/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'logic.dart';
import 'state.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({Key? key}) : super(key: key);

  @override
  _AllProductsPageState createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final AllProductsLogic logic = Get.put(AllProductsLogic());
  final AllProductsState state = Get.find<AllProductsLogic>().state;
  final _generalController = Get.find<GeneralController>();
  final _homeLogic = Get.find<HomeLogic>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllProductsLogic>(
      builder: (_allProductsLogic) => GestureDetector(
        onTap: () {
          _generalController.focusOut(context);
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 15,
                ),
              ),
            ),
            centerTitle: true,
            title: Text(
              'Products',
              style: state.appBarTextStyle,
            ),
          ),
          body: ListView(
            children: [
              ///---tabs
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Center(
                  child: DefaultTabController(
                      length: 2, // length of tabs
                      initialIndex: 0,
                      child: TabBar(
                        isScrollable: true,
                        labelStyle: GoogleFonts.nunito(
                            fontSize: 17, fontWeight: FontWeight.w700),
                        labelColor: Colors.white,
                        unselectedLabelColor: customThemeColor,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: customThemeColor,
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

                        onTap: (int? currentIndex) {
                          _allProductsLogic.updateTabIndex(currentIndex);
                        },
                        //TABS USED
                        tabs: const [
                          Tab(text: 'Bites'),
                          Tab(text: 'Bite Bags'),
                        ],
                      )),
                ),
              ),

              ///---tab-views
              if (_allProductsLogic.tabIndex == 0)

                ///---product-list
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text(
                              'Record not found',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          );
                        } else {
                          return FadedSlideAnimation(
                            child: Wrap(
                              children: List.generate(
                                  snapshot.data!.docs.length, (index) {
                                if (snapshot.data!.docs[index]
                                        .get('restaurant_id') ==
                                    _homeLogic.currentRestaurantData!
                                        .get('id')) {

                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 30, 15, 0),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(ProductDetailPage(
                                          productModel:
                                              snapshot.data!.docs[index],
                                          isProduct: true,
                                        ));
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(19),
                                          boxShadow: [
                                            BoxShadow(
                                              color: customThemeColor
                                                  .withOpacity(0.19),
                                              blurRadius: 40,
                                              spreadRadius: 0,
                                              offset: const Offset(0,
                                                  22), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            children: [
                                              ///---image
                                              Hero(
                                                tag:
                                                    '${snapshot.data!.docs[index].get('image')}',
                                                child: Material(
                                                  child: Container(
                                                    height: 80,
                                                    width: 80,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Colors.grey,
                                                            shape: BoxShape
                                                                .circle),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      child: Image.network(
                                                        '${snapshot.data!.docs[index].get('image')}',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              ///---detail
                                              Expanded(
                                                  child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ///---name
                                                      Text(
                                                          '${snapshot.data!.docs[index].get('name')}',
                                                          style: state
                                                              .nameTextStyle),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .01,
                                                      ),

                                                      ///---quantity-discount
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          ///---quantity
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  '${snapshot.data!.docs[index].get('quantity')} left',
                                                                  style: state
                                                                      .priceTextStyle),
                                                            ),
                                                          ),

                                                          ///---discount
                                                          Expanded(
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  '${snapshot.data!.docs[index].get('discount')}% off',
                                                                  style: state
                                                                      .priceTextStyle),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .01,
                                                      ),

                                                      ///---price
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          ///---price
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  '\$${snapshot.data!.docs[index].get('original_price')}',
                                                                  style: state
                                                                      .priceTextStyle!
                                                                      .copyWith(
                                                                          decoration:
                                                                              TextDecoration.lineThrough)),
                                                            ),
                                                          ),

                                                          ///---price
                                                          Expanded(
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Container(
                                                                width: 70,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            19),
                                                                    color:
                                                                        customThemeColor),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          0,
                                                                          2,
                                                                          0,
                                                                          2),
                                                                  child: Center(
                                                                    child: Text(
                                                                        '\$${snapshot.data!.docs[index].get('dis_price')}',
                                                                        style: state
                                                                            .priceTextStyle!
                                                                            .copyWith(color: Colors.white)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              }),
                            ),
                            beginOffset: const Offset(0, 0.3),
                            endOffset: const Offset(0, 0),
                            slideCurve: Curves.linearToEaseOut,
                          );
                        }
                      } else {
                        return Text(
                          'Record not found',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        );
                      }
                    }),

              if (_allProductsLogic.tabIndex == 1)

                ///---bite-bags-list
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('biteBags')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text(
                              'Record not found',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          );
                        } else {
                          return FadedSlideAnimation(
                            child: Wrap(
                              children: List.generate(
                                  snapshot.data!.docs.length, (index) {
                                if (snapshot.data!.docs[index]
                                        .get('restaurant_id') ==
                                    _homeLogic.currentRestaurantData!
                                        .get('id')) {
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 30, 15, 0),
                                    child: InkWell(
                                      onTap: () {

                                        Get.to(ProductDetailPage(
                                          productModel:
                                              snapshot.data!.docs[index],
                                          isProduct: false,
                                          
                                        ));
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(19),
                                          boxShadow: [
                                            BoxShadow(
                                              color: customThemeColor
                                                  .withOpacity(0.19),
                                              blurRadius: 40,
                                              spreadRadius: 0,
                                              offset: const Offset(0,
                                                  22), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            children: [
                                              ///---image
                                              Hero(
                                                tag:
                                                    '${snapshot.data!.docs[index].get('image')}',
                                                child: Material(
                                                  child: Container(
                                                    height: 80,
                                                    width: 80,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Colors.grey,
                                                            shape: BoxShape
                                                                .circle),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      child: Image.network(
                                                        '${snapshot.data!.docs[index].get('image')}',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              ///---detail
                                              Expanded(
                                                  child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ///---name
                                                      Text('Bite Bag',
                                                          style: state
                                                              .nameTextStyle),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .01,
                                                      ),

                                                      ///---quantity-discount
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          ///---quantity
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  '${snapshot.data!.docs[index].get('quantity')} left',
                                                                  style: state
                                                                      .priceTextStyle),
                                                            ),
                                                          ),

                                                          ///---discount
                                                          Expanded(
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  '${snapshot.data!.docs[index].get('discount')}% off',
                                                                  style: state
                                                                      .priceTextStyle),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .01,
                                                      ),

                                                      ///---price
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          ///---price
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  '\$${snapshot.data!.docs[index].get('original_price')}',
                                                                  style: state
                                                                      .priceTextStyle!
                                                                      .copyWith(
                                                                          decoration:
                                                                              TextDecoration.lineThrough)),
                                                            ),
                                                          ),

                                                          ///---price
                                                          Expanded(
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Container(
                                                                width: 70,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            19),
                                                                    color:
                                                                        customThemeColor),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          0,
                                                                          2,
                                                                          0,
                                                                          2),
                                                                  child: Center(
                                                                    child: Text(
                                                                        '\$${snapshot.data!.docs[index].get('dis_price')}',
                                                                        style: state
                                                                            .priceTextStyle!
                                                                            .copyWith(color: Colors.white)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              }),
                            ),
                            beginOffset: const Offset(0, 0.3),
                            endOffset: const Offset(0, 0),
                            slideCurve: Curves.linearToEaseOut,
                          );
                        }
                      } else {
                        return Text(
                          'Record not found',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        );
                      }
                    }),

              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
