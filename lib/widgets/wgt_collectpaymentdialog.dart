import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/Services/commonService.dart';
import 'package:my_cab_driver/home/homeScreen.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/widgets/devider_widget.dart';


class CollectPayment extends StatelessWidget {
  final String paymentMethod;
  final int fares;

  CollectPayment({required this.paymentMethod, required this.fares});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Theme.of(context).dividerColor,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
              color: Colors.black26,
              border: Border.all(color:Theme.of(context).primaryColor)
          ),
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        //decoration: ThemeLight.ButtonPrimaryDeco,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text('${paymentMethod.toUpperCase()} PAYMENT',style: GoogleFonts.roboto(fontSize: 25, color: Theme.of(context).scaffoldBackgroundColor)),
            SizedBox(
              height: 20,
            ),
            BrandDivider(),
            BrandDivider(),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'LKR $fares.00',
              style: GoogleFonts.roboto(fontSize: 35, color:  Theme.of(context).scaffoldBackgroundColor),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Amount above is the total fares to be charged to the rider(ඉහත මුදල යනු  පාරිබෝගිකයාගෙන් අය කළ යුතු මුළු ගාස්තු වේ)',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(color: Theme.of(context).scaffoldBackgroundColor),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 230,
              color: Theme.of(context).scaffoldBackgroundColor,
              child:
              InkWell(

                highlightColor: Theme.of(context).scaffoldBackgroundColor,
                splashColor: Theme.of(context).scaffoldBackgroundColor,
                onTap: () {
                  if(CustomParameters.appRestaredMiddleOfRide){
                    CustomParameters.appRestaredMiddleOfRide = false;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen(),
                        ));
                  }else {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                  CommonService.enableHomTabLocationUpdates();
                },
                child:
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).textTheme.headline6!.color,
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of((paymentMethod == 'cash') ? 'COLLECT CASH' : 'CONFIRM'),
                      style: Theme.of(context).textTheme.button!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
                // Text(
                //   AppLocalizations.of((paymentMethod == 'cash') ? 'COLLECT CASH' : 'CONFIRM'),
                //   style: Theme.of(context).textTheme.button!.copyWith(
                //     color: Theme.of(context).scaffoldBackgroundColor,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),


              ),

            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
