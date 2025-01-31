import 'package:flutter/material.dart';
import '../widget.dart';

/// Default trigger/tile widget
class S2Tile<T> extends StatelessWidget {
  /// The value of the selected option.
  final String value;

  /// Called when the user taps this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureTapCallback onTap;

  /// The primary content of the list tile.
  final Widget title;

  /// A widget to display before the title.
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget.
  final Widget leading;

  /// A widget to display after the title.
  ///
  /// Typically an [Icon] widget.
  ///
  /// To show right-aligned metadata (assuming left-to-right reading order;
  /// left-aligned for right-to-left reading order), consider using a [Row] with
  /// [MainAxisAlign.baseline] alignment whose first item is [Expanded] and
  /// whose second child is the metadata text, instead of using the [trailing]
  /// property.
  final Widget trailing;

  /// Whether this list tile is intended to display loading stats.
  final bool isLoading;

  // String text used as loading text
  final String loadingText;

  /// Whether this list tile is intended to display two lines of text.
  final bool isTwoLine;

  /// Whether this list tile is interactive.
  ///
  /// If false, this list tile is styled with the disabled color from the
  /// current [Theme] and the [onTap] and [onLongPress] callbacks are
  /// inoperative.

  /// If this tile is also [enabled] then icons and text are rendered with the same color.
  ///
  /// By default the selected color is the theme's primary color. The selected color
  /// can be overridden with a [ListTileTheme].
  final bool selected;

  /// Whether this list tile is part of a vertically dense list.
  ///
  /// If this property is null then its value is based on [ListTileTheme.dense].
  ///
  /// Dense list tiles default to a smaller height.
  final bool dense;

  /// Whether the [value] is displayed or not
  final bool hideValue;

  /// The tile's internal padding.
  ///
  /// Insets a [ListTile]'s contents: its [leading], [title], [subtitle],
  /// and [trailing] widgets.
  ///
  /// If null, `EdgeInsets.symmetric(horizontal: 16.0)` is used.
  final EdgeInsetsGeometry padding;

  /// widget to display below the tile
  /// usually used to display chips with S2TileChips
  final Widget body;

  /// Create a default trigger widget
  S2Tile({
    Key key,
    @required this.value,
    @required this.onTap,
    @required this.title,
    this.leading,
    this.trailing,
    this.loadingText = 'Loading..',
    this.isLoading = false,
    this.isTwoLine = false,
    this.selected = false,
    this.dense = false,
    this.hideValue = false,
    this.padding,
    this.body,
  }) : super(key: key);

  /// Create a default trigger widget from state
  S2Tile.fromState(
    S2State<T> state, {
    Key key,
    String value,
    GestureTapCallback onTap,
    Widget title,
    this.leading,
    this.trailing,
    this.loadingText = 'Loading..',
    this.isLoading = false,
    this.isTwoLine = false,
    this.selected = false,
    this.dense = false,
    this.hideValue = false,
    this.padding,
    this.body,
  })  : title = title ?? state.titleWidget,
        value = value ?? state.valueDisplay,
        onTap = onTap ?? state.showModal,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onTap,
      child: SizedBox(
          height: 60.0,
          child: Card(
            child: Stack(
              children: <Widget>[
                _buildItem(context),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.arrow_drop_down),
                )
              ],
            ),
          )),
    );
  }

  Widget _buildItem(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Text(
          isLoading ? loadingText : value,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ));
  }
}
