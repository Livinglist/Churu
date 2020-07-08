import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:innout/util/helpers.dart';
import 'package:innout/bloc/bill_bloc.dart';

const String noto = 'noto';

class TypeDetailPage extends StatefulWidget {
  final List<Transaction> transactions;
  final String title;

  TypeDetailPage({this.transactions, this.title});

  @override
  _TypeDetailPageState createState() => _TypeDetailPageState();
}

class _TypeDetailPageState extends State<TypeDetailPage> {
  final scrollController = ScrollController();

  Color backgroundColor, foregroundColor, subForegroundColor;
  bool showShadow = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (this.mounted) {
        if (scrollController.offset <= 0) {
          setState(() {
            showShadow = false;
          });
        } else if (showShadow == false) {
          setState(() {
            showShadow = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    localizations = AppLocalizations(Localizations.localeOf(context));
    backgroundColor = MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.white : Colors.black;
    foregroundColor = MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black : Colors.white;
    subForegroundColor = MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black54 : Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        brightness: MediaQuery.of(context).platformBrightness,
        elevation: showShadow ? 8 : 0,
        title: Text(
          widget.title,
          style: TextStyle(color: foregroundColor, fontFamily: noto),
        ),
      ),
      body: ListView(
        controller: scrollController,
        children: widget.transactions.map((e) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {}
            },
            confirmDismiss: (direction) {
              return showCupertinoModalPopup<bool>(
                  context: context,
                  builder: (_) {
                    return CupertinoActionSheet(
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                            onPressed: () {
                              BillBloc.instance.removeTransaction(e);
                              Navigator.pop(context, true);
                            },
                            child: Text('删除', style: TextStyle(fontFamily: noto)),
                            isDestructiveAction: true)
                      ],
                      cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text('取消', style: TextStyle(fontFamily: noto)),
                          isDefaultAction: true),
                    );
                  });
            },
            background: Container(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      '删',
                      style: TextStyle(fontFamily: noto, fontSize: 18, color: Colors.white),
                    ),
                  )),
              color: Colors.redAccent,
            ),
            child: ListTile(
              title: Text('${e.amount < 0 ? '出' : '入'}¥${e.amount.abs().toCommaString()}', style: TextStyle(fontSize: 24, color: foregroundColor)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    localizations.transactionTypeToString(e.transactionType),
                    style: TextStyle(color: subForegroundColor),
                  ),
                  Text(
                    '${e.createdDate.year}年${e.createdDate.month}月${e.createdDate.day}日 ${e.createdDate.toString().substring(12, 16)}',
                    style: TextStyle(color: subForegroundColor),
                  ),
                ],
              ),
              onTap: () {},
            ),
          );
        }).toList(),
      ),
    );
  }
}
