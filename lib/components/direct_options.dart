import 'package:direct_select/direct_select.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meet_your_mates/components/error.dart';

import 'my_selection_item.dart';

//Widget Implementation
class DirectOptions extends StatefulWidget {
  final List<String> elements;
  final String title;
  final bool isEnabled;
  final Size sizeText;
  final Size sizeDirectSelect;
  final int indexInitial;
  final Function(String) onItemSelected;
  const DirectOptions(
      {Key key,
      this.title,
      this.elements,
      this.onItemSelected,
      @required this.isEnabled,
      this.indexInitial,
      @required this.sizeText,
      @required this.sizeDirectSelect})
      : super(key: key);

  @override
  _DirectOptionsState createState() => _DirectOptionsState();
}

class _DirectOptionsState extends State<DirectOptions> {
  int _index = 0;
  ValueNotifier<String> selectedItemTitle;
  //String selectedItemTitle = "Text";
  var logger = Logger(level: Level.error);
  @override
  void initState() {
    super.initState();
    logger.w("Init State Called on ${widget.title}");
    //_index = _index ?? 0;
    selectedItemTitle = selectedItemTitle ?? ValueNotifier(widget.elements[0]);
    //selectedItemTitle = selectedItemTitle ?? "Test...";
  }

  void _setIndex(int index) {
    setState(() {
      index = (index >= 0 && index < widget.elements.length) ? index : 0;
      _index = index;
      selectedItemTitle.value = widget.elements[index];
    });
  }

  //final List<String> elements;
  List<Widget> _buildItems() {
    //print(widget.elements);
    List<Widget> returnWidgetSelectItems = <Widget>[];
    if (widget.elements.isNotEmpty) {
      widget.elements.forEach((val) => returnWidgetSelectItems.add(MySelectionItem(
            title: val,
            isForList: true,
          )));
    } else {
      returnWidgetSelectItems.add(MySelectionItem(title: "Option:"));
    }
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
              )),
          AbsorbPointer(
            absorbing: !widget.isEnabled,
            child: Opacity(
                opacity: widget.isEnabled ? 1 : 0.35,
                child: SizedBox(
                  width: widget.sizeDirectSelect.width,
                  height: widget.sizeDirectSelect.height,
                  child: DirectSelect(
                    itemExtent: 40.0,
                    itemMagnification: 1.55,
                    selectedIndex: _index,
                    backgroundColor: Colors.grey[100],
                    child: ValueListenableBuilder(
                      builder: (BuildContext context, String _selectTitleValue, Widget child) {
                        return MySelectionItem(
                          key: UniqueKey(),
                          isForList: false,
                          title: _selectTitleValue,
                        );
                      },
                      valueListenable: selectedItemTitle,
                      child:
                          ErrorShow(errorText: "Unexpected error occured, Please Restart the App"),
                    ),
                    onSelectedItemChanged: (index) {
                      _setIndex(index);
                      widget.onItemSelected(widget.elements[_index]);
                    },
                    mode: DirectSelectMode.drag,
                    items: _buildItems(),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
