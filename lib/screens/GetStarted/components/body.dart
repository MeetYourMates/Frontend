import 'package:flutter/material.dart';
import 'package:meet_your_mates/components/direct_options.dart';
import 'package:meet_your_mates/components/rounded_button.dart';
import 'background.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    var doStart = () {};
    Size size = MediaQuery.of(context).size;
    List<String> universities = [
      "Select your university",
      "UPC",
      "UB",
      "UAB",
      "UPF",
    ];
    List<String> campus = [
      "Select your campus",
      "EETAC",
      "ESAB",
      "ETSEIB",
    ];
    List<String> degrees = [
      "Select your degree",
      "Grau Enginyeria Telematica",
      "Grau Enginyeria Telecomunicacions",
      "Grau Enginyeria Aeroespacial",
    ];
    return SafeArea(
      child: Scaffold(
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.03),
                Image.asset(
                  "assets/images/getstarted.png",
                  width: size.width * 0.4,
                ),
                DirectOptions(title: "University", elements: universities),
                DirectOptions(title: "Campus", elements: campus),
                DirectOptions(title: "Degree", elements: degrees),
                SizedBox(height: size.height * 0.03),
                RoundedButton(
                  text: "START",
                  press: doStart,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
