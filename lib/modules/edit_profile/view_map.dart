import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:book_a_bite_resto/modules/edit_profile/logic.dart';
import 'package:book_a_bite_resto/modules/edit_profile/places_services.dart';
import 'package:book_a_bite_resto/modules/edit_profile/view_location_search.dart';
import 'package:book_a_bite_resto/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class MapEditView extends StatefulWidget {
  const MapEditView({Key? key}) : super(key: key);

  @override
  _MapEditViewState createState() => _MapEditViewState();
}

class _MapEditViewState extends State<MapEditView> {
  final MapType _currentMapType = MapType.normal;

  void _onMapCreated(GoogleMapController controller) {
    Get.find<EditProfileLogic>().controller.complete(controller);
    Get.find<EditProfileLogic>().onAddMarkerButtonPressed();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<EditProfileLogic>().controller = Completer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileLogic>(builder: (logic) {
      return Scaffold(
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                GoogleMap(
                  minMaxZoomPreference: const MinMaxZoomPreference(11, 22),
                  zoomGesturesEnabled: true,
                  // tiltGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition:
                      CameraPosition(target: logic.center, zoom: 11.0),
                  mapType: _currentMapType,
                  markers: logic.markers,
                  onCameraMove: logic.onCameraMove,
                  onLongPress: (pos) {
                    setState(() {
                      logic.center = LatLng(pos.latitude, pos.longitude);
                      logic.lastMapPosition = logic.center;
                      logic.markers = {};
                    });

                    logic.onAddMarkerButtonPressed();
                    log('POS--->>${pos.latitude}');
                  },
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  right: 65,
                  child: InkWell(
                    onTap: () async {
                      final sessionToken = const Uuid().v4();
                      final Suggestion? result = await showSearch(
                        context: context,
                        delegate: AddressSearch(sessionToken),
                      );

                      if (result != null) {
                        // log('RESULT---->>>${result.description.toString().split(', ')[2]}');
                        final placeDetails =
                            await PlaceApiProvider(sessionToken)
                                .getPlaceDetailFromId(result.placeId);

                        await logic.saveData(
                            latLong: json.encode({
                              'lat': placeDetails['lat'],
                              'lng': placeDetails['lng']
                            }),
                            place: result.description);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Text(
                                logic.addressController.text.isEmpty
                                    ? 'Search here...'
                                    : logic.addressController.text,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: customTextGreyColor),
                              ),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Icon(
                                Icons.search,
                                color: customTextGreyColor,
                                size: 20,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 15,
                  right: 15,
                  child: InkWell(
                    onTap: () {
                      logic.saveLocation();
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: customThemeColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          'Pick This Location',
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
