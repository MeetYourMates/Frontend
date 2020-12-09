import 'package:flutter/material.dart';
import 'package:direct_select/direct_select.dart';
import 'my_selection_item.dart';

//Widget Implementation
class DirectOptions extends StatefulWidget {
  final List<String> elements;
  final String title;
  final bool enable;
  final int indexInitial;
  final Function(String) onSelected;
  const DirectOptions(
      {Key key,
      this.title,
      this.elements,
      this.onSelected,
      this.enable = false,
      this.indexInitial})
      : super(key: key);

  @override
  _DirectOptionsState createState() => _DirectOptionsState();
}

class _DirectOptionsState extends State<DirectOptions> {
  final ValueNotifier<int> _index = ValueNotifier(0);
  //final List<String> elements;
  List<Widget> _buildItems() {
    //print(widget.elements);
    List<Widget> returnWidgetSelectItems = new List<Widget>();
    if (widget.elements.isNotEmpty) {
      widget.elements
          .forEach((val) => returnWidgetSelectItems.add(MySelectionItem(
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
              child: Text(
                widget.title,
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
            ),
            AbsorbPointer(
                absorbing: !widget.enable,
                child: Opacity(
                  opacity: widget.enable ? 1 : 0.35,
                  child: ValueListenableBuilder(
                    builder: (BuildContext context, int indx, Widget child) {
                      // This builder will only get called when the _counter
                      // is updated.
                      var doIndex = () {
                        return indx < widget.elements.length ? indx : 0;
                      };
                      return DirectSelect(
                          itemExtent: 40.0,
                          itemMagnification: 1.55,
                          selectedIndex: doIndex(),
                          backgroundColor: Colors.grey[100],
                          child: MySelectionItem(
                            isForList: false,
                            title: widget.elements[doIndex()],
                          ),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              index =
                                  (index >= 0 && index < widget.elements.length)
                                      ? index
                                      : 0;
                              _index.value = index;
                              widget.onSelected(widget.elements[index]);
                              _index.value = index;
                            });
                          },
                          mode: DirectSelectMode.drag,
                          items: _buildItems());
                    },
                    valueListenable: _index,
                    child: Container(),
                  ),
                ))
          ]),
    );
  }
}
