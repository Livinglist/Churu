import 'package:flutter/material.dart';
import 'package:innout/ui/components/spring_curve.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:innout/model/display_type.dart';

class TypePicker extends StatefulWidget {
  final ValueChanged<DisplayType> onTypeChanged;
  final int initialPage;

  const TypePicker({Key key, this.initialPage, this.onTypeChanged}) : super(key: key);

  @override
  _TypePickerState createState() => _TypePickerState();
}

class _TypePickerState extends State<TypePicker> {
  PageController _pageController;
  DisplayType displayType = DisplayType.day;
  String buttonStr = "日";
  List<DisplayType> types = [DisplayType.day, DisplayType.month, DisplayType.year, DisplayType.category, DisplayType.single];

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.initialPage);
    displayType = widget.initialPage == 0 ? DisplayType.single : types.elementAt(widget.initialPage - 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTypeChanged(displayType);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (_pageController.page == 4) {
            _pageController.jumpToPage(0);
          } else {
            _pageController.animateToPage(_pageController.page.ceil() + 1,
                duration: Duration(milliseconds: 200), curve: SpringCurve.underDamped);
          }
        },
        style: OutlinedButton.styleFrom(backgroundColor: Colors.white, shape: CircleBorder()),
        child: Padding(
            padding: EdgeInsets.all(12),
            child: Container(
                height: 36,
                width: 36,
                child: Center(
                  child: PageView(
                    allowImplicitScrolling: false,
                    pageSnapping: true,
                    controller: _pageController,
                    onPageChanged: (index) {
                      if (index == 0) {
                        widget.onTypeChanged(DisplayType.single);
                      } else {
                        widget.onTypeChanged(types.elementAt(index - 1));
                      }
                      saveCurrentPage(index);
                    },
                    children: [
                      Text("日",
                          textAlign: TextAlign.center, style: TextStyle(fontFamily: 'noto', fontSize: 24, fontWeight: FontWeight.bold)),
                      Text("月",
                          textAlign: TextAlign.center, style: TextStyle(fontFamily: 'noto', fontSize: 24, fontWeight: FontWeight.bold)),
                      Text("年",
                          textAlign: TextAlign.center, style: TextStyle(fontFamily: 'noto', fontSize: 24, fontWeight: FontWeight.bold)),
                      Text("类",
                          textAlign: TextAlign.center, style: TextStyle(fontFamily: 'noto', fontSize: 24, fontWeight: FontWeight.bold)),
                      Text("次",
                          textAlign: TextAlign.center, style: TextStyle(fontFamily: 'noto', fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ))));
  }

  void saveCurrentPage(int index) async {
    SharedPreferences.getInstance().then((value) => value.setInt("lastVisitedPage", index));
  }
}
