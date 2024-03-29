
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_cab_driver/home/VoiceTripRequest.dart';
import 'package:my_cab_driver/models/Address.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/models/Customer.dart';

class TripTile3 extends StatelessWidget {
  // final assetsAudioPlayer = AssetsAudioPlayer();
  final String  rideId;
  final String datetime;
  final String keyx;
  TripTile3({required this.rideId,required this.datetime,required this.keyx});

  void getPlaceDetails(Address pickupAddPass , context) async {
    print('rideId ${rideId}');
    //print('PredictionTile->getPlaceDetails-> CustomerID : ${customer.CustomerID}');
    //Navigator.pushNamedAndRemoveUntil(context, CustomerTrips.Id, (route) => false, arguments: : customer.CustomerID );

    // Navigator.push(context,
    //     MaterialPageRoute(
    //         builder: (context) => CustomerTrips(customerId:customer.CustomerID)
    //     )
    // );
  }


  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: (){
        //getPlaceDetails(pickupAdd, context);
      },
      child: Container(
        color: Color(0xFFfafafa),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8,),
            Row(
              children:<Widget> [
                SizedBox(width:12 ),
                Icon(Icons.account_circle_rounded,color: Colors.redAccent,),
                SizedBox(width:12 ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:<Widget> [
                      Text('$rideId',overflow: TextOverflow.ellipsis,maxLines: 1, style: GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.normal ,color: Color(0xFF212121)),),
                      SizedBox(height: 5,),
                      Text("$datetime",overflow: TextOverflow.ellipsis,maxLines: 1, style:GoogleFonts.roboto(fontSize: 12,fontWeight: FontWeight.normal))
                    ],
                  ),
                ),
                FloatingActionButton(
                  // heroTag: "btn2",
                  onPressed: () async{
                    //File file = new File("filetoplay.acc");
                    //await FirebaseStorage.instance.ref("/audio/rideRequest/${keyx}.acc").writeToFile(file);
                    //print(file.path);

                    var fileToPlay = await FirebaseStorage.instance.ref("/audio/rideRequest/${keyx}.acc").getDownloadURL();
                    print("fileToPlay = $fileToPlay");
                    //final assetsAudioPlayer = AssetsAudioPlayer();
                    try {
                      // await assetsAudioPlayer.open(
                      //   Audio.network(fileToPlay),
                      // );
                    } catch (t) {
                      print("error = $t");
                    }

                  },
                  child:Icon(Icons.play_arrow) ,
                  backgroundColor:true ? Colors.redAccent: Color(0xFF616161),
                ),
                SizedBox(width: 20,),

                Icon(Icons.arrow_forward_ios_outlined, size: 15 , color: Colors.redAccent,)
              ],
            ),
            SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }
}

class SearchCustomerTile extends StatelessWidget {
  final Customer custommerObj;
  final bool isPickUpSearch;
  final BuildContext parentContext;
  SearchCustomerTile({required this.custommerObj, required this.isPickUpSearch, required this.parentContext});

  void getPlaceDetails(Customer customer, context) async {

  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        getPlaceDetails(custommerObj, context);
      },
      child: Container(
        color: Color(0xFFfafafa),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Row(
              children:<Widget> [
                SizedBox(width:12 ),
                Icon(Icons.account_circle_rounded,color: Colors.redAccent,),
                SizedBox(width:12 ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:<Widget> [
                      Row(
                        children: <Widget>[
                          Text(
                            '${custommerObj.fullName}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121)),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'ID: ${custommerObj.Id}-',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.roboto(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF212121)),
                          ),
                          Text("  TP: ${custommerObj.phoneNumber}",overflow: TextOverflow.ellipsis,maxLines: 1, style: GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.normal ,color: Color(0xFF212121)),),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Text(custommerObj.nicName,overflow: TextOverflow.ellipsis,maxLines: 1, style:GoogleFonts.roboto(fontSize: 12,fontWeight: FontWeight.normal))
                    ],
                  ),
                ),
                FloatingActionButton(
                  heroTag: "btnx",
                  onPressed: () async{
                    print("getPlaceDetails");
                    CustomParameters.selectedCustomer = custommerObj;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VoiceTripRequest(
                          ),
                        ));
                  },
                  child:Icon(Icons.play_arrow , color: Colors.white,) ,
                  backgroundColor:true ? Color(0xFFeb1165): Color(0xFF616161),
                ),
                SizedBox(width: 20,),
                Icon(Icons.arrow_forward_ios_outlined, size: 15 , color: Color(0xFFeb1165),)
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
