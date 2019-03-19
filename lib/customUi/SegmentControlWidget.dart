import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class SegmentControlView {
  SegmentControlView(this.title, this.content);

  final String title;
  final Widget content;
}

abstract class SegmentControlCallbacks {
  void _changeTab(String title);
}

class SegmentControl extends StatefulWidget {
  SegmentControl(this.tabs, {this.activeTabIndex = 0})
      : assert(tabs.length > 1 && tabs.length <= 3),
        assert(activeTabIndex <= tabs.length - 1);

  final List<SegmentControlView> tabs;
  final int activeTabIndex;

  @override
  _SegmentControlState createState() => _SegmentControlState();
}

class _SegmentControlState extends State<SegmentControl>
    with SegmentControlCallbacks {
  int _activeTabIndex;

  @override
  void initState() {
    super.initState();

    setState(() {
      _activeTabIndex = widget.activeTabIndex;
    });
  }

  void _changeTab(String title) {
    setState(() {
      for (int i = 0; i < widget.tabs.length; i++) {
        SegmentControlView t = widget.tabs[i];
        if (t.title == title) {
          _activeTabIndex = i;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<_SegmentControlView> list = <_SegmentControlView>[];

    for (int i = 0; i < widget.tabs.length; i++) {
      SegmentControlView tap = widget.tabs[i];
      bool isActive = tap == widget.tabs[_activeTabIndex];
      _ButtonPlace place = _ButtonPlace.start;

      if (i > 0 && (widget.tabs.length - 1 == i)) {
        place = _ButtonPlace.end;
      } else if (i > 0 && (widget.tabs.length - 1 > i)) {
        place = _ButtonPlace.middle;
      }

      list.add(_SegmentControlView(this, tap, place, isActive));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: list,
          ),
          padding: EdgeInsets.all(12.0),
        ),
      ],
    );
  }
}

class _SegmentControlView extends StatefulWidget {
  _SegmentControlView(
      this.callbacks, this.buttonTab, this.place, this.isActive);

  final double _defaultBorderRadius = 5.0;

  final SegmentControlView buttonTab;
  final SegmentControlCallbacks callbacks;
  final _ButtonPlace place;
  final bool isActive;
  final Color color = Color.fromRGBO(255, 255, 255, 1.0);
  final Color inverseColor = Color.fromRGBO(255, 255, 255, 0.0);

  @override
  State createState() {
    return _SegmentControlViewState(color, inverseColor);
  }
}

class _SegmentControlViewState extends State<_SegmentControlView> {
  _SegmentControlViewState(this.color, this.inverseColor);

  Color color;
  Color inverseColor;
  bool tapDown = false;

  BoxDecoration _boxDecoration(_ButtonPlace place) {
    BorderRadius radius;

    switch (place) {
      case _ButtonPlace.start:
        radius = BorderRadius.only(
          topLeft: Radius.circular(widget._defaultBorderRadius),
          bottomLeft: Radius.circular(widget._defaultBorderRadius),
        );
        break;
      case _ButtonPlace.end:
        radius = BorderRadius.only(
          topRight: Radius.circular(widget._defaultBorderRadius),
          bottomRight: Radius.circular(widget._defaultBorderRadius),
        );
        break;
      default:
        break;
    }

    BoxDecoration dec = BoxDecoration(
      color: widget.isActive ? color : inverseColor,
      border: place == _ButtonPlace.middle
          ? Border(
              top: BorderSide(color: tapDown ? inverseColor : color),
              bottom: BorderSide(color: tapDown ? inverseColor : color),
            )
          : Border.all(color: tapDown ? inverseColor : color),
      borderRadius: radius,
    );

    return dec;
  }

  void _tabDown() {
    if (!widget.isActive) {
      setState(() {
        tapDown = true;
        final Color _backupColor = color;
        color = inverseColor;
        inverseColor = _backupColor;
      });
    }
  }

  void _tabUp() {
    if (!widget.isActive) {
      tapDown = false;
      final Color _backupColor = color;
      color = inverseColor;
      inverseColor = _backupColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _tabDown();
      },
      onTapUp: (_) {
        _tabUp();
      },
      onTap: () {
        widget.callbacks._changeTab(widget.buttonTab.title);
      },
      child: Container(
        decoration: _boxDecoration(widget.place),
        padding: EdgeInsets.fromLTRB(20.0, 7.0, 20.0, 7.0),
        child: Text(
          widget.buttonTab.title,
          style: TextStyle(
              color: widget.isActive ? CupertinoColors.activeBlue : color),
        ),
      ),
    );
  }
}

enum _ButtonPlace { start, middle, end }
