import 'package:flutter/material.dart';
import '../smart_select.dart';
import '../choices.dart' as choices;

class MultipleOptions extends StatefulWidget {
  final List<String> elements;
  final bool requirements;
  final String title;
  final List<Map<String, dynamic>> subjects;
  final Function(String) onSelected;
  const MultipleOptions(
      {Key key,
      this.title,
      this.elements,
      this.onSelected,
      this.subjects,
      this.requirements})
      : super(key: key);
  @override
  _MultipleOptionsState createState() => _MultipleOptionsState();
}

class _MultipleOptionsState extends State<MultipleOptions> {
  List<String> _subjects = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment(0.0, 0.0),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  widget.title,
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
              ),
              Container(
                alignment: Alignment(0.0, 0.0),
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.45),
                        spreadRadius: 0.055,
                        blurRadius: 0,
                        offset: Offset(0, 0.65), // changes position of shadow
                      ),
                    ],
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(5.0),
                      topRight: const Radius.circular(5.0),
                      bottomLeft: const Radius.circular(5.0),
                      bottomRight: const Radius.circular(5.0),
                    )),
                child: SmartSelect<String>.multiple(
                    title: "",
                    placeholder: 'Select your subject',
                    value: _subjects,
                    onChange: (state) =>
                        setState(() => _subjects = state.value),
                    //List of Items
                    choiceItems: S2Choice.listFrom<String, Map>(
                      source: choices.subjects, //widget.subjects,
                      value: (index, item) => item['id'],
                      title: (index, item) => item['name'],
                      group: (index, item) => item['semester'],
                    ),
                    choiceGrouped: true,
                    modalType: S2ModalType.bottomSheet,
                    modalFilter: true,
                    tileBuilder: (context, state) {
                      return S2Tile.fromState(
                        state,
                        isTwoLine: true,
                      );
                    }),
              )
            ]));
  }
}
