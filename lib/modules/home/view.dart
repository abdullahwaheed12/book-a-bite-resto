import 'dart:developer';

import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:book_a_bite_resto/controller/general_controller.dart';
import 'package:book_a_bite_resto/modules/order_detail/view.dart';
import 'package:book_a_bite_resto/modules/product_detail/view.dart';
import 'package:book_a_bite_resto/route_generator.dart';
import 'package:book_a_bite_resto/utils/colors.dart';
import 'package:book_a_bite_resto/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'logic.dart';
import 'state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final HomeLogic logic = Get.put(HomeLogic());
  final HomeState state = Get.find<HomeLogic>().state;
  final _generalController = Get.find<GeneralController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    Get.find<HomeLogic>().updateToken();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    log('apear--->>>');
    Get.find<HomeLogic>().currentRestaurant();
  }

  TabController? tabController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      body: Stack(
        children: [
          ///---gradient
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                customThemeColor.withOpacity(0.3),
                customThemeColor.withOpacity(0.8),
                customThemeColor
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            )),
          ),

          ///---main
          GetBuilder<HomeLogic>(
            builder: (_homeLogic) => AdvancedDrawer(
              disabledGestures: false,
              backdropColor: Colors.transparent,
              controller: _homeLogic.advancedDrawerController,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              childDecoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              drawer: const MyCustomDrawer(),
              child: GestureDetector(
                onTap: () {
                  _generalController.focusOut(context);
                },
                child: Scaffold(
                  drawerEnableOpenDragGesture: false,
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                    leading: InkWell(
                      onTap: () {
                        _homeLogic.handleMenuButtonPressed();
                      },
                      child: ValueListenableBuilder<AdvancedDrawerValue>(
                        valueListenable: _homeLogic.advancedDrawerController,
                        builder: (_, value, __) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(30, 5, 5, 5),
                            child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: value.visible
                                    ? const Icon(
                                        Icons.arrow_back,
                                        size: 25,
                                        color: customTextGreyColor,
                                      )
                                    : SvgPicture.asset(
                                        'assets/drawerIcon.svg')),
                          );
                        },
                      ),
                    ),
                  ),
                  body: _homeLogic.currentRestaurantData == null
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: customThemeColor,
                          ),
                        )
                      : ListView(
                          controller: _homeLogic.scrollController,
                          children: [
                            ///---heading
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 20, 0, 0),
                                child: Text(
                                    "${_homeLogic.currentRestaurantData!.get('name')}",
                                    style: state.homeHeadingTextStyle)),

                            ///---rating
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                              child: Container(
                                height: 57,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(19),
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
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'My Ratings',
                                          style: state.listTileTitleTextStyle,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.star,
                                        color: customThemeColor,
                                        size: 15,
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        _homeLogic.averageRating!
                                            .toStringAsPrecision(2),
                                        style: state.listTileSubTitleTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            ///---earning-of-week
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                              child: Container(
                                height: 57,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(19),
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
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Earnings this week',
                                          style: state.listTileTitleTextStyle,
                                        ),
                                      ),
                                      Text(
                                        '\$${_homeLogic.totalEarning}',
                                        style: state.listTileSubTitleTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            ///---order-of-week
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                              child: Container(
                                height: 57,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(19),
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
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Orders this week',
                                          style: state.listTileTitleTextStyle,
                                        ),
                                      ),
                                      Text(
                                        '${_homeLogic.totalOrder}',
                                        style: state.listTileSubTitleTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            ///---tabs
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                              child: Center(
                                child: DefaultTabController(
                                    length: 3, // length of tabs
                                    initialIndex: 0,
                                    child: TabBar(
                                      controller: tabController,
                                      isScrollable: true,
                                      labelStyle: GoogleFonts.nunito(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
                                      labelColor: Colors.white,
                                      unselectedLabelColor: customThemeColor,
                                      indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: customThemeColor,
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

                                      onTap: (int? currentIndex) {
                                        _homeLogic.updateTabIndex(currentIndex);
                                      },
                                      //TABS USED
                                      tabs: [
                                        SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .2,
                                          child: const Center(
                                            child: Text(
                                              'Orders',
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .2,
                                          child: const Center(
                                            child: Text(
                                              'Bites',
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .25,
                                          child: const Center(
                                            child: Text(
                                              'Bite Bags',
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),

                            ///---tab-views

                            if (_homeLogic.tabIndex == 0)

                              ///---order-list
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('orders')
                                      .orderBy('date_time', descending: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.docs.isEmpty) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 30),
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
                                        return Wrap(
                                          children: List.generate(
                                              snapshot.data!.docs.length,
                                              (index) {
                                            if (snapshot.data!.docs[index]
                                                    .get('restaurant_id') ==
                                                _homeLogic
                                                    .currentRestaurantData!
                                                    .get('id')) {
                                              DateTime dt = (snapshot
                                                          .data!.docs[index]
                                                          .get('date_time')
                                                      as Timestamp)
                                                  .toDate();

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 30, 15, 0),
                                                child: InkWell(
                                                  onTap: () {
                                                    Get.to(OrderDetailPage(
                                                      orderModel: snapshot
                                                          .data!.docs[index],
                                                    ));
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              19),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              customThemeColor
                                                                  .withOpacity(
                                                                      0.19),
                                                          blurRadius: 40,
                                                          spreadRadius: 0,
                                                          offset: const Offset(
                                                              0,
                                                              22), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Row(
                                                        children: [
                                                          ///---image
                                                          Hero(
                                                            tag:
                                                                '${snapshot.data!.docs[index].get('restaurant_image')}',
                                                            child: Material(
                                                              child: Container(
                                                                height: 80,
                                                                width: 80,
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .grey,
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              40),
                                                                  child: Image
                                                                      .network(
                                                                    '${snapshot.data!.docs[index].get('restaurant_image')}',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 20),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  ///---name-otp
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Text(
                                                                            '${snapshot.data!.docs[index]['customerName'] ?? 'update name'}',
                                                                            softWrap:
                                                                                true,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: state.nameTextStyle),
                                                                      ),
                                                                      // const SizedBox(
                                                                      //   width:
                                                                      //       5,
                                                                      // ),
                                                                      // Expanded(
                                                                      //   child:
                                                                      //       Align(
                                                                      //     alignment:
                                                                      //         Alignment.centerRight,
                                                                      //     child: Text(
                                                                      //         'Bite Code: ${snapshot.data!.docs[index].get('otp')}',
                                                                      //         style: state.otpTextStyle),
                                                                      //   ),
                                                                      // ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        .01,
                                                                  ),

                                                                  ///---date
                                                                  Text(
                                                                      DateFormat(
                                                                              'dd-MM-yy')
                                                                          .format(
                                                                              dt),
                                                                      style: state
                                                                          .otpTextStyle),
                                                                  SizedBox(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        .01,
                                                                  ),

                                                                  ///---status-amount
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child: Text(
                                                                              '${snapshot.data!.docs[index].get('status')}',
                                                                              style: state.otpTextStyle),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                70,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(19), color: customThemeColor),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                                                              child: Center(
                                                                                child: Text('\$${snapshot.data!.docs[index].get('grand_total')}', style: state.priceTextStyle!.copyWith(color: Colors.white)),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
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
                            if (_homeLogic.tabIndex == 1)

                              ///---product-list
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('products')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.docs.isEmpty) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 30),
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
                                                snapshot.data!.docs.length,
                                                (index) {
                                              if (snapshot.data!.docs[index]
                                                      .get('restaurant_id') ==
                                                  _homeLogic
                                                      .currentRestaurantData!
                                                      .get('id')) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 30, 15, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Get.to(ProductDetailPage(
                                                        productModel: snapshot
                                                            .data!.docs[index],
                                                        isProduct: true,
                                                      ));
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(19),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                customThemeColor
                                                                    .withOpacity(
                                                                        0.19),
                                                            blurRadius: 40,
                                                            spreadRadius: 0,
                                                            offset: const Offset(
                                                                0,
                                                                22), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: Row(
                                                          children: [
                                                            ///---image
                                                            Hero(
                                                              tag:
                                                                  '${snapshot.data!.docs[index].get('image')}',
                                                              child: Material(
                                                                child:
                                                                    Container(
                                                                  height: 80,
                                                                  width: 80,
                                                                  decoration: const BoxDecoration(
                                                                      color: Colors
                                                                          .grey,
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                    child: Image
                                                                        .network(
                                                                      '${snapshot.data!.docs[index].get('image')}',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            ///---detail
                                                            Expanded(
                                                                child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20),
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
                                                                      height: MediaQuery.of(context)
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
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text('${snapshot.data!.docs[index].get('quantity')} left', style: state.priceTextStyle),
                                                                          ),
                                                                        ),

                                                                        ///---discount
                                                                        Expanded(
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child:
                                                                                Text('${snapshot.data!.docs[index].get('discount')}% off', style: state.priceTextStyle),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: MediaQuery.of(context)
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
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text('\$${snapshot.data!.docs[index].get('original_price')}', style: state.priceTextStyle!.copyWith(decoration: TextDecoration.lineThrough)),
                                                                          ),
                                                                        ),

                                                                        ///---price
                                                                        Expanded(
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child:
                                                                                Container(
                                                                              width: 70,
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(19), color: customThemeColor),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                                                                child: Center(
                                                                                  child: Text('\$${snapshot.data!.docs[index].get('dis_price')}', style: state.priceTextStyle!.copyWith(color: Colors.white)),
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

                            if (_homeLogic.tabIndex == 2)

                              ///---bite-bags-list
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('biteBags')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.docs.isEmpty) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 30),
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
                                                snapshot.data!.docs.length,
                                                (index) {
                                              if (snapshot.data!.docs[index]
                                                      .get('restaurant_id') ==
                                                  _homeLogic
                                                      .currentRestaurantData!
                                                      .get('id')) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 30, 15, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Get.to(ProductDetailPage(
                                                        productModel: snapshot
                                                            .data!.docs[index],
                                                        isProduct: false,
                                                      ));
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(19),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                customThemeColor
                                                                    .withOpacity(
                                                                        0.19),
                                                            blurRadius: 40,
                                                            spreadRadius: 0,
                                                            offset: const Offset(
                                                                0,
                                                                22), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: Row(
                                                          children: [
                                                            ///---image
                                                            Hero(
                                                              tag:
                                                                  '${snapshot.data!.docs[index].get('image')}',
                                                              child: Material(
                                                                child:
                                                                    Container(
                                                                  height: 80,
                                                                  width: 80,
                                                                  decoration: const BoxDecoration(
                                                                      color: Colors
                                                                          .grey,
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            40),
                                                                    child: Image
                                                                        .network(
                                                                      '${snapshot.data!.docs[index].get('image')}',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            ///---detail
                                                            Expanded(
                                                                child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20),
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
                                                                        'Bite Bag',
                                                                        style: state
                                                                            .nameTextStyle),
                                                                    SizedBox(
                                                                      height: MediaQuery.of(context)
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
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text('${snapshot.data!.docs[index].get('quantity')} left', style: state.priceTextStyle),
                                                                          ),
                                                                        ),

                                                                        ///---discount
                                                                        Expanded(
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child:
                                                                                Text('${snapshot.data!.docs[index].get('discount')}% off', style: state.priceTextStyle),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: MediaQuery.of(context)
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
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text('\$${snapshot.data!.docs[index].get('original_price')}', style: state.priceTextStyle!.copyWith(decoration: TextDecoration.lineThrough)),
                                                                          ),
                                                                        ),

                                                                        ///---price
                                                                        Expanded(
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child:
                                                                                Container(
                                                                              width: 70,
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(19), color: customThemeColor),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                                                                child: Center(
                                                                                  child: Text('\$${snapshot.data!.docs[index].get('dis_price')}', style: state.priceTextStyle!.copyWith(color: Colors.white)),
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
                              height: MediaQuery.of(context).size.height * .05,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addBiteDialog(context);
        },
        backgroundColor: customThemeColor,
        child: const Icon(
          Icons.add_circle_outline,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  void addBiteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            actions: <Widget>[
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    Get.toNamed(PageRoutes.addProduct);
                  },
                  child: Text("Bites",
                      style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    Get.toNamed(PageRoutes.addBiteBag);
                  },
                  child: Text("Bite Bag",
                      style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))),
            ],
          );
        });
  }
}
