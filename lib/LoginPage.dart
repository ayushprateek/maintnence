import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/AppConfig.dart';
import 'package:maintenance/Component/CheckInternet.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/CustomFont.dart';
import 'package:maintenance/Component/GetCredentials.dart';
import 'package:maintenance/Component/GetTextField.dart';
import 'package:maintenance/Component/KeyboardVisible.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';
import 'package:maintenance/Dashboard.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/DataSync.dart';
import 'package:maintenance/Sync/SyncModels/OUSR.dart';
import 'package:maintenance/main.dart';
import 'package:sqflite/sqflite.dart';

class LoginPage extends StatefulWidget {
  static bool hasSynced = false;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double div = 1.35;

  final key = GlobalKey<ScaffoldState>();
  bool accountExists = false, obscurePassword = true;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  DateTime? syncDate;

  // TextEditingController username = TextEditingController(text: "Aayush.Regmi");
  // TextEditingController password = TextEditingController(text: "MKKL@123456");
  //
  TextEditingController username = TextEditingController(text: "Admin");
  TextEditingController password = TextEditingController(text: "MSL@DK@2022");

  // TextEditingController username = TextEditingController();
  // TextEditingController password = TextEditingController();
  //
  //
  // TextEditingController username = TextEditingController(text: "1426");
  // TextEditingController password = TextEditingController(text: "MSL@DK@2022");
  //
  // TextEditingController username = TextEditingController(text: "1316");
  // TextEditingController password = TextEditingController(text: "MSL@DK@2022");
  //
  // TextEditingController username = TextEditingController(text: "1374");
  // TextEditingController password = TextEditingController(text: "Msl@1374");
  //
  // TextEditingController username = TextEditingController(text: "183");
  // TextEditingController password = TextEditingController(text: "12345678");

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      if (displayTakeSS == true) {
        // imagesController.show();
      }

      syncDate = getDataSyncDate();
      DateTime now = DateTime.now();
      if (syncDate != null && syncDate?.day != now.day) {
        Get.to(() => DataSync(
              '/GetData',
              isComingFromLogin: false,
            ));
      } else {
        setState(() {});
      }
    });
  }

  String getHashedPassword() {
    var stringInBytes = utf8.encode(password.text);
    String value = sha256.convert(stringInBytes).toString();
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 60,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      // width: MediaQuery.of(context).size.width/3,
                      // height: MediaQuery.of(context).size.height/15,
                      color: barColor,
                      child: Image.asset(
                        logoPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Container(
                    color: Colors.white,
                    child: Text(
                      "Welcome!",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: custom_font),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  color: Colors.white,
                  child: Text(
                    "Please enter username and password!",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: custom_font),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8),
                child: getTextFieldWithoutLookup(
                  controller: username,
                  labelText: 'Username',
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8),
                child: getTextFieldWithoutLookup(
                    labelText: 'Password',
                    controller: password,
                    maxLines: 1,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off)),
                    obscureText: obscurePassword),
              ),
              if (syncDate != null)
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 8),
                    child: TextButton(
                      child: Text(
                        "Forgot password",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () {
                        //todo:
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => PasswordReset()));
                      },
                    ),
                  ),
                ),
              if (keyboardIsVisible(
                  context: context, scrollController: _scrollController)) ...[
                const SizedBox(
                  height: 30,
                ),
                _buttonContainer(),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: !keyboardIsVisible(
              context: context, scrollController: _scrollController)
          ? _buttonContainer()
          : null,
    );
  }

  Widget _buttonContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 13,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: barColor,
          elevation: 0.0,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : MaterialButton(
                  // onPressed: () async {
                  //
                  //   // Navigator.push(
                  //   //     context,
                  //   //     MaterialPageRoute(
                  //   //         builder: (_) => SalesQuotationUI(0)));
                  // },
                  onPressed: () async {
                    try {
                      _onLogin();
                    } catch (e) {
                      writeToLogFile(
                          text: e.toString(),
                          fileName: StackTrace.current.toString(),
                          lineNo: 141);
                      getErrorSnackBar('Something went wrong');
                    }
                    // await isValidAppVersion();
                    // if(isAppVersionValid==RxBool(true))
                    // {
                    //   try {
                    //     _onLogin();
                    //   } catch (e) {
                    //     writeToLogFile(
                    //         text: e.toString(),
                    //         fileName: StackTrace.current.toString(),
                    //         lineNo: 141);
                    //     getErrorSnackBar('Something went wrong');
                    //   }
                    // }
                    // else
                    // {
                    //   showUpdateAppAlertDialog();
                    // }
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  child: Text(
                    "Proceed Securely",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
        ),
      ),
    );
  }

  _onLogin() async {
    if (username.text.isEmpty || password.text.isEmpty) {
      getErrorSnackBar('Username or password ca not be empty');
    } else {
      setState(() {
        isLoading = true;
      });
      credentials = getCredentials();
      if (credentials == '') {
        //SYNCING FIRST TIME
        if (await isInternetAvailable()) {
          if (await validateCredentialsOnline()) {
            ///VALID USER
            credentials = '${username.text}:${password.text}';
            setCredentials(credentials: credentials);

            // credentials = localStorage?.getString('credentials') ?? '';
            // print(credentials);
            setState(() {
              isLoading = false;
            });

            Timer(
                Duration(milliseconds: 500),
                () => Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new DataSync(
                              "/GetAll",
                              isComingFromLogin: true,
                            ))));
          } else {
            getErrorSnackBar('Invalid username/password');
            setState(() {
              isLoading = false;
            });
          }
        } else {
          getErrorSnackBar('No Internet Available');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        // NOT FIRST TIME SYNC
        credentials = getCredentials();
        print(credentials);
        if (credentials == '${username.text}:${password.text}') {
          ///SAME USER AS PREVIOUS
          validateCredentialsOffline();
        } else {
          /// DIFFERENT USER
          /// DELETE DATABASE AND THE SYNC

          String user = localStorage?.getString('user') ?? '';
          userModel = OUSRModel.fromJson(jsonDecode(user));

          if (userModel.Type != 'Employee') {
            ///USER IS CUSTOMER
            ///DELETE DATABASE
            if (await isInternetAvailable()) {
              if (await validateCredentialsOnline()) {
                String path = await getDatabasesPath();
                await databaseFactory.deleteDatabase(path + "/LITSale.db");
                await initializeDB(context);
                setCredentials(credentials: '');
                _onLogin();
              } else {
                getErrorSnackBar('Invalid username/password');
                setState(() {
                  isLoading = false;
                });
              }
            } else {
              getErrorSnackBar('No Internet Available');
              setState(() {
                isLoading = false;
              });
            }
          } else {
            ///USER IS AN EMPLOYEE
            ///NO NEED TO DELETE DATABASE
            ///LOGIN WITH DATABASE
            validateCredentialsOffline();
          }
        }
        // if (!LoginPage.hasSynced) {
        //   DateTime? syncDate = DateTime.tryParse(
        //       localStorage?.getString("syncDate") ?? '');
        //   if (syncDate == null) {
        //     // FIRST TIME SYNC
        //     if (!LoginPage.hasSynced) {
        //       Timer(
        //           Duration(milliseconds: 500),
        //           () => Navigator.push(
        //               context,
        //               new MaterialPageRoute(
        //                   builder: (context) => new DataSync(
        //                         "/GetAll",
        //                         isComingFromLogin: true,
        //                         isFirstTimeSync: true,
        //                       ))));
        //     }
        //   } else if (syncDate.day < DateTime.now().day) {
        //     // NOT FIRST TIME SYNC
        //     if (!LoginPage.hasSynced) {
        //       Timer(
        //           Duration(milliseconds: 500),
        //           () => Navigator.push(
        //               context,
        //               new MaterialPageRoute(
        //                   builder: (context) => new DataSync(
        //                         "/GetData",
        //                         isComingFromLogin: true,
        //                         isFirstTimeSync: false,
        //                       ))));
        //     }
        //   }
        //
        //   Timer(
        //       Duration(milliseconds: 500),
        //       () => Navigator.push(
        //           context,
        //           new MaterialPageRoute(
        //               builder: (context) => new DataSync(
        //                     "/GetData",
        //                     isComingFromLogin: true,
        //                     isFirstTimeSync: false,
        //                   ))));
        // }
      }
    }
  }

  Future<bool> validateCredentialsOnline() async {
    credentials = '${username.text}:${password.text}';
    String encoded = stringToBase64.encode(credentials + secretKey);
    header = {
      'Authorization': 'Basic $encoded',
      "content-type": "application/json",
      "connection": "keep-alive"
    };
    var res = await http.get(Uri.parse(prefix + 'OUSR/auth'), headers: header);
    print(res.body);
    if (res.statusCode == 200) {
      print(jsonEncode(res.body));
      localStorage?.setString('tableScript', res.body);
      localStorage?.setString('user', res.body);
      // localStorage?.setString(
      //     'MaintenanceTransactionTableCreationScript', jsonDecode(res.body)['MaintenanceTransactionTableCreationScript']);
      String? str = localStorage?.getString('user');
      Map<String, dynamic> m = jsonDecode(str ?? '');
      print(m);
      userModel = OUSRModel.fromJson(m);
      print(userModel.toJson());
      return true;
    } else {
      return false;
    }
  }

  validateCredentialsOffline() async {
    String hashedPassword = getHashedPassword();
    credentials = '${username.text}:${password.text}';
    String encoded = stringToBase64.encode(credentials + secretKey);
    header = {
      'Authorization': 'Basic $encoded',
      "content-type": "application/json",
      "connection": "keep-alive"
    };
    List<OUSRModel> data =
        await retrieveLoginData(context, username.text, hashedPassword);
    if (data.length != 0) {
      userModel = data[0];
      if (userModel.MUser) {
        await setRequiredData();
        setCredentials(credentials: credentials);
        localStorage?.setString('user', jsonEncode(userModel.toJson()));
        setLogInTime(dateTime: DateTime.now());
        Navigator.push(
            context, MaterialPageRoute(builder: ((context) => Dashboard())));
      } else {
        getErrorSnackBar('Sorry, you are not authorized to use mobile app!');
      }
    } else {
      if (await isInternetAvailable()) {
        if (await validateCredentialsOnline()) {
          ///VALID USER
          credentials = '${username.text}:${password.text}';
          setCredentials(credentials: credentials);

          // credentials = localStorage?.getString('credentials') ?? '';
          // print(credentials);
          setState(() {
            isLoading = false;
          });

          await setRequiredData();
          setLogInTime(dateTime: DateTime.now());
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => Dashboard())));
        } else {
          getErrorSnackBar('Invalid username/password');
        }
      } else {
        username.clear();
        password.clear();
        getErrorSnackBar("Invalid username/password");
        getErrorSnackBar("Please enable internet service to check online");
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}
