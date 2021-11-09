import 'package:animator/animator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/home/riderList.dart';
import '../appTheme.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isOffline = false;

  late BitmapDescriptor bitmapDescriptorStartLocation;
  late BitmapDescriptor bitmapDescriptorStartLocation2;
  late BitmapDescriptor bitmapDescriptorStartLocation3;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  var lat = 51.506115;
  var long = -0.088339;

  var lat2 = 51.509587;
  var long2 = -0.080282;

  var lat3 = 51.505944;
  var long3 = -0.087001;

  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    seticonimage(context);
    seticonimage2(context);
    seticonimage3(context);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
          child: Drawer(
            child: AppDrawer(
              selectItemName: 'Home',
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          title: Row(
            children: <Widget>[
              SizedBox(
                height: AppBar().preferredSize.height,
                width: AppBar().preferredSize.height + 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: Icon(
                        Icons.dehaze,
                        color: Theme.of(context).textTheme.headline6!.color,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: !isOffline
                    ? Text(
                        AppLocalizations.of('OffLine'),
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.headline6!.color,
                            ),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        AppLocalizations.of('Online'),
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.headline6!.color,
                            ),
                        textAlign: TextAlign.center,
                      ),
              ),
              SizedBox(
                height: AppBar().preferredSize.height,
                width: AppBar().preferredSize.height + 40,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Switch(
                    activeColor: Theme.of(context).primaryColor,
                    value: isOffline,
                    onChanged: (bool value) {
                      setState(() {
                        isOffline = !isOffline;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(51.507477, -0.084761),
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                setLDMapStyle();
              },
              markers: Set<Marker>.of(getMarkerList(context).values),
              polylines: Set<Polyline>.of(getPolyLine(context).values),
            ),
            !isOffline
                ? Column(
                    children: <Widget>[
                      offLineMode(),
                      Expanded(
                        child: SizedBox(),
                      ),
                      myLocation(),
                      SizedBox(
                        height: 10,
                      ),
                      offLineModeDetail(),
                      Container(
                        height: MediaQuery.of(context).padding.bottom,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(),
                      ),
                      myLocation(),
                      SizedBox(
                        height: 10,
                      ),
                      onLineModeDetail(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget onLineModeDetail() {
    var bootmPadding = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.only(right: 10, left: 10, bottom: bootmPadding),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RiderList(),
              fullscreenDialog: true,
            ),
          );
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 16,
              child: Padding(
                padding: const EdgeInsets.only(right: 24, left: 24),
                child: Animator<Offset>(
                  tween: Tween<Offset>(
                    begin: Offset(0, 0.5),
                    end: Offset(0, 0),
                  ),
                  duration: Duration(seconds: 1),
                  cycles: 1,
                  builder: (context, animate, _) => SlideTransition(
                    position: animate.animation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          new BoxShadow(
                            color: AppTheme.isLightTheme ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 0,
              left: 0,
              bottom: 16,
              child: Padding(
                padding: const EdgeInsets.only(right: 12, left: 12),
                child: Animator<Offset>(
                  tween: Tween<Offset>(
                    begin: Offset(0, 0.5),
                    end: Offset(0, 0),
                  ),
                  duration: Duration(milliseconds: 700),
                  cycles: 1,
                  builder: (context, animate, _) => SlideTransition(
                    position: animate.animation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          new BoxShadow(
                            color: AppTheme.isLightTheme ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Animator<Offset>(
              tween: Tween<Offset>(
                begin: Offset(0, 0.4),
                end: Offset(0, 0),
              ),
              duration: Duration(milliseconds: 700),
              cycles: 1,
              builder: (context, animate, _) => SlideTransition(
                position: animate.animation,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        new BoxShadow(
                          color: Theme.of(context).dividerColor,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    ConstanceData.userImage,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of('Esther Berry'),
                                      style: Theme.of(context).textTheme.headline6!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.headline6!.color,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          height: 24,
                                          width: 74,
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of('ApplePay'),
                                              style: Theme.of(context).textTheme.button!.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: ConstanceData.secoundryFontColor,
                                                  ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Container(
                                          height: 24,
                                          width: 74,
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of('Discount'),
                                              style: Theme.of(context).textTheme.button!.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: ConstanceData.secoundryFontColor,
                                                  ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      '\$25.00',
                                      style: Theme.of(context).textTheme.headline6!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.headline6!.color,
                                          ),
                                    ),
                                    Text(
                                      '2.2 km',
                                      style: Theme.of(context).textTheme.caption!.copyWith(
                                            color: Theme.of(context).disabledColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0.5,
                            color: Theme.of(context).disabledColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of('PICKUP'),
                                      style: Theme.of(context).textTheme.caption!.copyWith(
                                            color: Theme.of(context).disabledColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      AppLocalizations.of('79 Swift Village'),
                                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.headline6!.color,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0.5,
                            color: Theme.of(context).disabledColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of('DROP OFF'),
                                      style: Theme.of(context).textTheme.caption!.copyWith(
                                            color: Theme.of(context).disabledColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      AppLocalizations.of('115 William St, Chicago, US'),
                                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.headline6!.color,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0.5,
                            color: Theme.of(context).disabledColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  height: 32,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of('Ignore'),
                                      style: Theme.of(context).textTheme.button!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).disabledColor,
                                          ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 32,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of('ACCEPT'),
                                      style: Theme.of(context).textTheme.button!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: ConstanceData.secoundryFontColor,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setLDMapStyle() async {
    // ignore: unnecessary_null_comparison
    if (mapController != null) {
      if (AppTheme.isLightTheme) {
        mapController.setMapStyle(await DefaultAssetBundle.of(context).loadString("jsonFile/lightmapstyle.json"));
      } else {
        mapController.setMapStyle(await DefaultAssetBundle.of(context).loadString("jsonFile/darkmapstyle.json"));
      }
    }
  }

  Widget offLineModeDetail() {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 14, left: 14),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(
                    ConstanceData.userImage,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('Jeremiah Curtis'),
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.headline6!.color,
                          ),
                    ),
                    Text(
                      AppLocalizations.of('Basic level'),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '\$325.00',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.headline6!.color,
                          ),
                    ),
                    Text(
                      AppLocalizations.of('Earned'),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.clock,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 20,
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '10.2',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('HOURS ONLINE'),
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.tachometerAlt,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 20,
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '30 KM',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('TOTAL DISTANCE'),
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.rocket,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 20,
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '20',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('TOTAL JOBS'),
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget myLocation() {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor,
                  blurRadius: 12,
                  spreadRadius: -5,
                  offset: new Offset(0.0, 0),
                )
              ],
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Icon(
                Icons.my_location,
                color: Theme.of(context).textTheme.headline6!.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<PolylineId, Polyline> getPolyLine(BuildContext context) {
    Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
    if (isOffline) {
      List<LatLng> latlng1 = [
        LatLng(51.506115, -0.088339),
        LatLng(51.507129, -0.087974),
        LatLng(51.509693, -0.087075),
        LatLng(51.509065, -0.082206),
        LatLng(51.509159, -0.081173),
        LatLng(51.509346, -0.080675),
        LatLng(51.509540, -0.080293),
        LatLng(51.509587, -0.080282)
      ];
      List<LatLng> latlng2 = [LatLng(51.505951, -0.086974), LatLng(51.506051, -0.087634), LatLng(51.506115, -0.088339)];
      final PolylineId polylineId = PolylineId('polylineId');
      final Polyline polyline = Polyline(
        polylineId: polylineId,
        color: Theme.of(context).primaryColor,
        consumeTapEvents: false,
        points: latlng1,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      );

      final PolylineId polylineId1 = PolylineId('polylineId1');
      List<PatternItem> patterns1 = [PatternItem.dot, PatternItem.gap(1)];
      final Polyline polyline1 = Polyline(
        polylineId: polylineId1,
        color: Theme.of(context).primaryColor,
        consumeTapEvents: false,
        points: latlng2,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        patterns: patterns1,
      );
      _polylines.addAll({polylineId: polyline});
      _polylines.addAll({polylineId1: polyline1});
    }
    return _polylines;
  }

  Map<MarkerId, Marker> getMarkerList(BuildContext context) {
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    final MarkerId markerId1 = MarkerId("markerId1");
    final MarkerId markerId2 = MarkerId("markerId2");
    final MarkerId markerId3 = MarkerId("markerId3");
    final Marker marker1 = Marker(
      markerId: markerId1,
      position: LatLng(lat, long),
      anchor: Offset(0.5, 0.5),
      icon: bitmapDescriptorStartLocation,
    );
    if (isOffline) {
      final Marker marker2 = Marker(
        markerId: markerId2,
        position: LatLng(lat2, long2),
        anchor: Offset(0.5, 0.5),
        icon: bitmapDescriptorStartLocation3,
      );

      final Marker marker3 = Marker(
        markerId: markerId3,
        position: LatLng(lat3, long3),
        anchor: Offset(0.5, 0.5),
        icon: bitmapDescriptorStartLocation2,
      );
      markers.addAll({markerId2: marker2});
      markers.addAll({markerId3: marker3});
    }
    markers.addAll({markerId1: marker1});
    return markers;
  }

  Future seticonimage3(BuildContext context) async {
    // ignore: unnecessary_null_comparison
    // if (bitmapDescriptorStartLocation3 == null) {
    final ImageConfiguration imagesStartConfiguration3 = createLocalImageConfiguration(context);
    bitmapDescriptorStartLocation3 = await BitmapDescriptor.fromAssetImage(
      imagesStartConfiguration3,
      ConstanceData.mylocation3,
    );
    setState(() {});
    // }
  }

  Future seticonimage2(BuildContext context) async {
    // ignore: unnecessary_null_comparison
    // if (bitmapDescriptorStartLocation2 == null) {
    final ImageConfiguration imagesStartConfiguration2 = createLocalImageConfiguration(context);
    bitmapDescriptorStartLocation2 = await BitmapDescriptor.fromAssetImage(
      imagesStartConfiguration2,
      ConstanceData.mylocation2,
    );
    setState(() {});
    // }
  }

  Future seticonimage(BuildContext context) async {
    // ignore: unnecessary_null_comparison
    // if (bitmapDescriptorStartLocation == null) {
    final ImageConfiguration imagesStartConfiguration = createLocalImageConfiguration(context);
    bitmapDescriptorStartLocation = await BitmapDescriptor.fromAssetImage(
      imagesStartConfiguration,
      ConstanceData.mylocation1,
    );
    setState(() {});
    // }
  }

  Widget offLineMode() {
    return Animator<double>(
      duration: Duration(milliseconds: 400),
      cycles: 1,
      builder: (_, animatorState, __) => SizeTransition(
        sizeFactor: animatorState.animation,
        axis: Axis.horizontal,
        child: Container(
          height: AppBar().preferredSize.height,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(right: 14, left: 14),
            child: Row(
              children: <Widget>[
                DottedBorder(
                  color: ConstanceData.secoundryFontColor,
                  borderType: BorderType.Circle,
                  strokeWidth: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      FontAwesomeIcons.cloudMoon,
                      color: ConstanceData.secoundryFontColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('You are offline !'),
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ConstanceData.secoundryFontColor,
                          ),
                    ),
                    Text(
                      AppLocalizations.of('Go online to strat accepting jobs.'),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: ConstanceData.secoundryFontColor,
                          ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
