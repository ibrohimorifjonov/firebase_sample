import 'dart:io';
import 'package:firebase_sample/core/theme/app_colors.dart';
import 'package:firebase_sample/core/theme/app_text_style.dart';
import 'package:firebase_sample/data/data_source/local_source.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DoNotAskAgainDialog extends StatefulWidget {
  final String title, subTitle, positiveButtonText, negativeButtonText;
  final Function onPositiveButtonClicked;
  final String doNotAskAgainText;
  final String dialogKeyName;

  const DoNotAskAgainDialog(
    this.dialogKeyName,
    this.title,
    this.subTitle,
    this.positiveButtonText,
    this.negativeButtonText,
    this.onPositiveButtonClicked, {
    Key? key,
    this.doNotAskAgainText = 'Never ask again',
  }) : super(key: key);

  @override
  _DoNotAskAgainDialogState createState() => _DoNotAskAgainDialogState();
}

class _DoNotAskAgainDialogState extends State<DoNotAskAgainDialog> {
  bool doNotAskAgain = false;

  _updateDoNotShowAgain() async {
    final sharedPreferences = LocalSource.getInstance();
    await sharedPreferences.setUpdateDialog(false);
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(widget.title, style: stlAppBarTitle),
        content: Text(widget.subTitle, style: stlAppBarTitle),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              widget.positiveButtonText,
              style: stlAppBarTitle.copyWith(
                fontSize: 17,
                color: clrOrange,
              ),
            ),
            onPressed: () {
              widget.onPositiveButtonClicked();
            },
          ),
          CupertinoDialogAction(
            child: Text(
              widget.doNotAskAgainText,
              style: stlAppBarTitle.copyWith(
                fontSize: 17,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              _updateDoNotShowAgain();
            },
          ),
          CupertinoDialogAction(
            child: Text(
              widget.negativeButtonText,
              style: stlAppBarTitle,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    }
    return AlertDialog(
      backgroundColor: clrOrange,
      title: Text(
        widget.title + " ${widget.subTitle}",
        style:
            stlAppBarTitle.copyWith(fontWeight: FontWeight.w600, fontSize: 17),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      content: FittedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    activeColor: clrOrange,
                    value: doNotAskAgain,
                    onChanged: (val) {
                      setState(() {
                        doNotAskAgain = val!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      doNotAskAgain = doNotAskAgain == false;
                    });
                  },
                  child: Text(
                    widget.doNotAskAgainText,
                    style: stlAppBarTitle.copyWith(
                        fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            widget.positiveButtonText,
            style: stlAppBarTitle.copyWith(
              fontWeight: FontWeight.w500,
              color: clrOrange,
            ),
          ),
          onPressed: () {
            if (doNotAskAgain) {
              widget.onPositiveButtonClicked();
            }
          },
        ),
        TextButton(
          child: Text(
            widget.negativeButtonText,
            style: stlAppBarTitle.copyWith(
                fontWeight: FontWeight.w500, color: clrWhite),
          ),
          onPressed: () async {
            Navigator.pop(context);
            if (doNotAskAgain) {
              _updateDoNotShowAgain();
            }
          },
        ),
      ],
    );
  }
}
