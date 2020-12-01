import 'package:flutter/material.dart';
import 'package:direct_select/direct_select.dart';
import 'my_selection_item.dart';

//Widget Implementation
// ignore: must_be_immutable
class DirectOptions extends StatefulWidget {
  final List<String> elements;
  var selectedIndex = 0;
  final String title;
  final bool enable;
  final Function(String) onSelected;
  DirectOptions(
      {Key key,
      this.title,
      this.elements,
      this.onSelected,
      this.enable = false})
      : super(key: key);

  @override
  _DirectOptionsState createState() => _DirectOptionsState();
}

class _DirectOptionsState extends State<DirectOptions> {
  //final List<String> elements;
  List<Widget> _buildItems() {
    print(widget.elements);
    List<Widget> returnWidgetSelectItems = new List<Widget>();
    widget.elements
        .forEach((val) => returnWidgetSelectItems.add(MySelectionItem(
              title: val,
            )));
    return returnWidgetSelectItems;
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
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
            ),
            AbsorbPointer(
                absorbing: !widget.enable,
                child: Opacity(
                  opacity: widget.enable ? 1 : 0.35,
                  child: DirectSelect(
                      itemExtent: 35.0,
                      selectedIndex: (widget.selectedIndex >= 0 &&
                              widget.selectedIndex < widget.elements.length)
                          ? widget.selectedIndex
                          : 0,
                      child: MySelectionItem(
                        isForList: false,
                        title: widget.elements[widget.selectedIndex],
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          index = (index >= 0 && index < widget.elements.length)
                              ? index
                              : 0;
                          widget.selectedIndex = index;
                          widget.onSelected(widget.elements[index]);
                        });
                      },
                      mode: DirectSelectMode.tap,
                      items: _buildItems()),
                ))
          ]),
    );
  }
}
