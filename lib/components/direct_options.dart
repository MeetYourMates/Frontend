import 'package:flutter/material.dart';
import 'package:direct_select/direct_select.dart';
import 'my_selection_item.dart';

int selectedIndex;

//Widget Implementation
class DirectOptions extends StatefulWidget {
  final List<String> elements;
  final String title;
  const DirectOptions({Key key, this.title, this.elements}) : super(key: key);

  @override
  _DirectOptionsState createState() => _DirectOptionsState();
}

class _DirectOptionsState extends State<DirectOptions> {
  //final List<String> elements;
  List<Widget> _buildItems() {
    return widget.elements
        .map((val) => MySelectionItem(
              title: val,
            ))
        .toList();
  }

  //Widget Design
  @override
  Widget build(BuildContext context) {
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
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ),
            DirectSelect(
                itemExtent: 35.0,
                selectedIndex: selectedIndex,
                child: MySelectionItem(
                  isForList: false,
                  title: widget.elements[selectedIndex],
                ),
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                mode: DirectSelectMode.tap,
                items: _buildItems()),
          ]),
    );
  }
}
