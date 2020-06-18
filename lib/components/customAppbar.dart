import 'package:flutter/material.dart';
import 'package:splashbloc/currentLocation/currentlocation.dart';
import 'package:splashbloc/models/locationModel.dart';

class CustomAppBar extends PreferredSize {
  final Widget child;
  final Widget titleWidget;
  final double height;
  final double marginTitle;
  final LocationModel locationData;

  CustomAppBar(
      {@required this.child,
      @required this.titleWidget,
      @required this.marginTitle,
      @required this.locationData,
      this.height = kToolbarHeight});

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
                expandedHeight: MediaQuery.of(context).size.height / 4,
                floating: true,
                pinned: true,
                actions: <Widget>[
                  GestureDetector(
                    onTap: ()=> Navigator.of(context).pushNamed('/settings') ,
                    child: Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Icon(Icons.settings)),
                  ),
                ],
                flexibleSpace: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  double collapsedHeight = constraints.biggest.height;
                  return FlexibleSpaceBar(
                      centerTitle: true,
                      title: Container(
                        margin: EdgeInsets.only(
                            top: collapsedHeight > 80.0 ? marginTitle : 0),
                        child: collapsedHeight > 80.0
                            ? titleWidget
                            : Text(locationData.name),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Colors.blue, Colors.red])),
                        child: Stack(
                          alignment: const Alignment(-0.8, 0.0),
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'http://openweathermap.org/img/wn/${locationData.weather[0].icon}@2x.png'),
                              //radius: 30,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                  20,
                                  MediaQuery.of(context).size.height / 5.5,
                                  0,
                                  0),
                              // margin: EdgeInsets.only(
                              //     top: MediaQuery.of(context).size.height / 6),
                              child: Column(children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.keyboard_arrow_up,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    Text(
                                        '${temperature(locationData.main.tempMax)}'),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    Text(
                                        '${temperature(locationData.main.tempMin)}')
                                  ],
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ));
                }),
              ),
            ];
          },
          body: Center(
            child: child,
          )),
    );
  }
}
