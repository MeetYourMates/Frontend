import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:logger/logger.dart' as loggerImp;

class MapLeaflet extends StatefulWidget {
  const MapLeaflet({Key key}) : super(key: key);

  @override
  _MapLeafletState createState() => _MapLeafletState();
}

class _MapLeafletState extends State<MapLeaflet> {
  /// [logger] to logg all of the logs in console prettily!
  loggerImp.Logger logger = loggerImp.Logger(level: loggerImp.Level.debug);
  List<Marker> markers = [
    new Marker(
      width: 30.0,
      height: 30.0,
      point: new LatLng(41.27533, 1.98723),
      builder: (ctx) => new Container(
        child: new FlutterLogo(),
      ),
    ),
    new Marker(
      width: 30.0,
      height: 30.0,
      point: new LatLng(41.27544, 1.98723),
      builder: (ctx) => new Container(
        child: new FlutterLogo(),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return new FlutterMap(
      options: new MapOptions(
        center: new LatLng(41.27533, 1.98723),
        zoom: 17.0,
        maxZoom: 18.0,
        minZoom: 7.0,
        onTap: (tapLocation) {
          logger.i("User Tapped Location: " + tapLocation.toString());
          Marker tempMrkr = new Marker(
            width: 30.0,
            height: 30.0,
            point: new LatLng(41.27544, 1.98723),
            builder: (ctx) => new Container(
              child: new FlutterLogo(),
            ),
          );
          setState(() => {
                markers.add(tempMrkr),
                logger.i("Marker Added: ${markers.length}"),
              });
        },
      ),
      layers: [
        new TileLayerOptions(urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
        new MarkerLayerOptions(
          markers: markers,
        ),
      ],
    );
  }
}
