import 'package:flutter/material.dart';
import '../smart_select.dart';
import '../choices.dart' as choices;

class MultipleOptions extends StatefulWidget {
  final List<String> elements;
  final String title;
  final Function(String) onSelected;
  const MultipleOptions({Key key, this.title, this.elements, this.onSelected})
      : super(key: key);
  @override
  _MultipleOptionsState createState() => _MultipleOptionsState();
}

class _MultipleOptionsState extends State<MultipleOptions> {
  List<String> _subjects = [];

  @override
  Widget build(BuildContext context) {
    const Divider(
      color: Colors.black,
      height: 0,
      thickness: 5,
      indent: 20,
      endIndent: 0,
    );
    return Container(
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
              Divider(),
              const SizedBox(height: 7),
              SmartSelect<String>.multiple(
                  title: widget.title,
                  placeholder: 'Select your subject',
                  value: _subjects,
                  onChange: (state) => setState(() => _subjects = state.value),
                  //List of Items
                  choiceItems: S2Choice.listFrom<String, Map>(
                    source: choices.subjects,
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
              Divider(),
            ]));
  }
}
