// var builderParam = FutureBuilder<bool>(
//     future: candidateAuth(), // async work
//     builder: (BuildContext context, AsyncSnapshot snapshot) {
//       Widget newwidget;
//       List<dynamic> list;
//       if (snapshot != null) {
//         if (snapshot.data != null) {
//           if (snapshot.data.snapshot != null) {
//             if (snapshot.data.snapshot.value != null) {
//               if (snapshot.hasData) {
//                 newwidget = new Container(
//                   child: Text("Hello"),
//                 );
//                 switch (snapshot.connectionState) {
//                   case ConnectionState.none:
//                     newwidget = Text("Loading......");
//                     break;
//                   default:
//                     Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
//                     list = map.values.toList();
//                     print("rideBookingsdriverList snapshot list $list");

//                     newwidget = ListView.builder(
//                       itemCount: list.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         print(" rideBookingsdriverList ${list[index]}");
//                         var mType = list[index]["type"] != null
//                             ? list[index]["type"]
//                             : "Message";
//                         return Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Card(
//                             shape: new RoundedRectangleBorder(
//                                 side: new BorderSide(
//                                     color: Theme.of(context).primaryColor,
//                                     width: 1.0),
//                                 borderRadius: BorderRadius.circular(4.0)),
//                             color: Color(0xFFfafafa),
//                             child: Container(
//                               color: Theme.of(context).scaffoldBackgroundColor,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   children: <Widget>[
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: <Widget>[
//                                           CircleAvatar(
//                                             radius: 24,
//                                             child: ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(40),
//                                               child: Image.asset(
//                                                 ConstanceData.user5,
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 16,
//                                           ),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: <Widget>[
//                                               Text(
//                                                 AppLocalizations.of(f.format(
//                                                     new DateTime
//                                                             .fromMillisecondsSinceEpoch(
//                                                         DateTime.parse(list[
//                                                                         index]
//                                                                     ["date"])
//                                                                 .microsecond *
//                                                             1000))),
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .headline6!
//                                                     .copyWith(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 15,
//                                                       color: Theme.of(context)
//                                                           .textTheme
//                                                           .headline6!
//                                                           .color,
//                                                     ),
//                                               ),
//                                               Text(
//                                                 '#6467488',
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .subtitle2!
//                                                     .copyWith(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       color: Theme.of(context)
//                                                           .disabledColor,
//                                                     ),
//                                               ),
//                                             ],
//                                           ),
//                                           Expanded(child: SizedBox()),
//                                           Text(
//                                             '\$25.00',
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodyText2!
//                                                 .copyWith(
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Theme.of(context)
//                                                       .textTheme
//                                                       .headline6!
//                                                       .color,
//                                                 ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       height: 0.5,
//                                       color: Theme.of(context).disabledColor,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );

//                     break;
//                 }
//               } else {
//                 newwidget = Text("Loading......");
//               }
//             } else {
//               newwidget = returnControlMessage(
//                   "No Messages1", "No messages Found.", false);
//             }
//           } else {
//             newwidget = returnControlMessage(
//                 "No Messages2", "No messages Found.", false);
//           }
//         } else {
//           newwidget =
//               returnControlMessage("No Messages3", "No messages Found.", false);
//         }
//       } else {
//         newwidget =
//             returnControlMessage("No Messages4", "No messages Found.", false);
//       }
//       return newwidget;
//     });
