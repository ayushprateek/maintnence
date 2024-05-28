import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Component/UploadImageToServer.dart';
import 'package:maintenance/main.dart';


class ShareDatabase extends StatefulWidget {
  const ShareDatabase({super.key});

  @override
  State<ShareDatabase> createState() => _ShareDatabaseState();
}

class _ShareDatabaseState extends State<ShareDatabase> {
  bool _isLoading = false,_obscureText=true;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayDialogBox();
  }

  String getHashedPassword() {
    var stringInBytes = utf8.encode(_passwordController.text);
    String value = sha256.convert(stringInBytes).toString();
    return value;
  }

  Future<bool> validatePassword() async {
    bool isSuccess = false;
    if (userModel.Password == getHashedPassword()) {
      isSuccess = true;
    }
    return isSuccess;
  }

  displayDialogBox() async {
    await Future.delayed(Duration(milliseconds: 500));
    List<Widget> titleRowWidgets = [Text("Enter Password")];
    List<Widget> actions = [
      Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                color: barColor,
                child: Text(
                  'Verify',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (await validatePassword()) {
                    Navigator.pop(context);
                  } else {
                    getErrorSnackBar('Invalid Password');
                  }
                },
              ),
            ],
          )),
    ];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Row(
              children: titleRowWidgets,
            ),
            content: getTextFieldWithoutLookup(
                controller: _passwordController, labelText: 'Password',
              obscureText: _obscureText,
              maxLines: 1,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: Icon(_obscureText
                      ? Icons.visibility
                      : Icons.visibility_off)),
            ),
            actions: actions,
          );
        } else {
          return AlertDialog(
            title: Row(
              children: titleRowWidgets,
            ),
            content:  getTextFieldWithoutLookup(
              controller: _passwordController, labelText: 'Password',
              obscureText: _obscureText,
              maxLines: 1,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: Icon(_obscureText
                      ? Icons.visibility
                      : Icons.visibility_off)),
            ),
            actions: actions,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: barColor,
        title: Text(
          "Share Database",
          style: TextStyle(color: Colors.white, fontFamily: custom_font),
        ),
      ),
      body: Center(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Row(
                children: [
                  Expanded(
                      child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 13,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: barColor,
                        elevation: 0.0,
                        child: MaterialButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await uploadLocalDBToServer();
                              getSuccessSnackBar('Database Uploaded');
                              Navigator.pop(context);
                            } catch (e) {
                              writeToLogFile(
                                  text: e.toString(),
                                  fileName: StackTrace.current.toString(),
                                  lineNo: 141);
                              getErrorSnackBar('Something went wrong');
                            }
                          },
                          minWidth: MediaQuery.of(context).size.width,
                          child: Text(
                            "Upload DB on Server",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),

                  // Expanded(
                  //     child: Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: MediaQuery.of(context).size.height / 13,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Material(
                  //       borderRadius: BorderRadius.circular(10.0),
                  //       color: barColor,
                  //       elevation: 0.0,
                  //       child: MaterialButton(
                  //         onPressed: () async {},
                  //         minWidth: MediaQuery.of(context).size.width,
                  //         child: Text(
                  //           "Execute Query and Share",
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )),
                ],
              ),
      ),
    );
  }
}
