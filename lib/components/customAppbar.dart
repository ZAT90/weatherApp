import 'package:flutter/material.dart';
import 'package:splashbloc/currentLocation/currentlocation.dart';
import 'package:splashbloc/models/locationModel.dart';

class CustomAppBar extends PreferredSize {
  final Widget child;
  final Widget titleWidget;
  final double height;
  final LocationModel locationData;

  CustomAppBar({@required this.child, @required this.titleWidget, @required this.locationData, this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: preferredSize.height,
      alignment: Alignment.center,
      child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                actions: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Icon(Icons.settings)),
                ],
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
                      child: titleWidget,
                    ),
                    background: 
                    // Image.network(
                    //   "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                    //   fit: BoxFit.cover,
                    // )
Stack(
    alignment: const Alignment(-0.8, 0.0),
    children: [
      CircleAvatar(
        backgroundImage: NetworkImage(
                     "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                       //fit: BoxFit.cover,
                     ),
        //radius: 30,
      ),
      Container(
        margin: EdgeInsets.only(top:MediaQuery.of(context).size.height / 6),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.keyboard_arrow_up, size: 40, color: Colors.white,),
                Text('${temperature(locationData.main.tempMax)}°C'),
              ],
            ),
            
            Row(
              children: <Widget>[
                Icon(Icons.keyboard_arrow_down, size: 40, color: Colors.white,),
                Text('${temperature(locationData.main.tempMin)}°C')
              ],
            ),
          ]   
        ),
      ),
    ],
  )
                    ),
              ),
            ];
          },
          body: Center(
            child: child,
          )),
    );
  }
}
