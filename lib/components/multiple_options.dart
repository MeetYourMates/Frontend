import 'package:flutter/material.dart';

import '../smart_select.dart';

class MultipleOptions extends StatefulWidget {
  final List<Map<String, dynamic>> elements;
  final String title;
  final Size sizeText;
  final Size sizeMultiSelect;
  final Function(List<String>) onSelected;

  const MultipleOptions(
      {Key key,
      this.title,
      @required this.elements,
      this.onSelected,
      @required this.sizeText,
      @required this.sizeMultiSelect})
      : super(key: key);
  @override
  _MultipleOptionsState createState() => _MultipleOptionsState();
}

class _MultipleOptionsState extends State<MultipleOptions> {
  List<String> _list = [];

  @override
  Widget build(BuildContext context) {
    const Divider(
      color: Colors.black,
      height: 0,
      thickness: 5,
      indent: 20,
      endIndent: 0,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: SizedBox(
            width: widget.sizeText.width,
            height: widget.sizeText.height,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                widget.title,
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
            ),
          ),
        ),
        //Divider(),
        //const SizedBox(height: 7),
        SizedBox(
          width: widget.sizeMultiSelect.width,
          height: widget.sizeMultiSelect.height,
          child: Container(
            alignment: Alignment(0.0, 0.0),
            margin: EdgeInsets.symmetric(horizontal: 6),
            child: SmartSelect<String>.multiple(
              title: "",
              placeholder: 'Select your subject',
              value: _list,
              onChange: (state) => setState(() {
                _list = state.value.toList();
                widget.onSelected(_list);
              }),
              //List of Items
              choiceItems: S2Choice.listFrom<String, Map>(
                source: widget.elements,
                value: (index, item) => item['id'],
                title: (index, item) => item['name'],
                group: (index, item) => item['group'],
              ),
              choiceGrouped: true,
              modalType: S2ModalType.bottomSheet,
              modalFilter: true,
              tileBuilder: (context, state) {
                return S2Tile.fromState(
                  state,
                  isTwoLine: false,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
