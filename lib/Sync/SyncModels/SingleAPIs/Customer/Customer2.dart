import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/GetCredentials.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/SyncModels/CRD1.dart';
import 'package:maintenance/Sync/SyncModels/CRD2.dart';
import 'package:maintenance/Sync/SyncModels/CRD3.dart';
import 'package:maintenance/Sync/SyncModels/IUOM.dart';
import 'package:maintenance/Sync/SyncModels/IWHS.dart';
import 'package:maintenance/Sync/SyncModels/OMSP.dart';
import 'package:maintenance/Sync/SyncModels/ORTU.dart';
import 'package:maintenance/Sync/SyncModels/OUDAR.dart';
import 'package:maintenance/Sync/SyncModels/OUOM.dart';
import 'package:sqflite/sqlite_api.dart';

Customer2 GetAllMaster1FromJson(String str) =>
    Customer2.fromJson(json.decode(str));

String GetAllMaster1ToJson(Customer2 data) => json.encode(data.toJson());

class Customer2 {
  static bool isFirstTimeSync = false;

//----------- CONSTRUCTOR ----------
  Customer2({
    this.crd1,
    this.crd2,
    this.crd3,
    // this.maps,
    // this.orol,
    this.ortu,
    // this.ovcl,
    this.iuom,
    this.iwhs,
    this.ouom,
    // this.ecp1,
    // this.ooal,
    // this.oac1,
    // this.oac2,
    // this.ooac,
    // this.itmp,
    this.oudar,
    // this.bpmg,

    // this.otrns,
    // this.ouda,
    // this.ocinp,
    // this.oadm,
    // this.bpsg,
  });

//----------- VARIABLES ----------
  List<CRD1Model>? crd1;
  List<CRD2Model>? crd2;
  List<CRD3Model>? crd3;

  // List<mapsModel>? maps;

  // List<OROLModel>? orol;
  List<ORTUModel>? ortu;

  // List<OVCLModel>? ovcl;
  List<IUOM>? iuom;
  List<IWHS>? iwhs;
  List<OUOMModel>? ouom;

  // List<ECP1>? ecp1;
  // List<LITPL_OOAL>? ooal;
  // List<LITPL_OAC1>? oac1;
  // List<LITPL_OAC2>? oac2;
  // List<LITPL_OADM>? oadm;
  // List<LITPL_OOAC>? ooac;
  //
  // List<ITMP>? itmp;
  List<OUDAR>? oudar;

  // List<BPMG>? bpmg;
  // List<OWHS>? owhs;
  // List<OTRNSModel>? otrns;
  // List<OUDA>? ouda;
  List<OMSPModel>? omsp;

  // List<OCINP>? ocinp;

//----------- FROM JSON ----------
  factory Customer2.fromJson(Map<String, dynamic> json) => Customer2(
        crd1: List<CRD1Model>.from(
            json["CRD1"].map((x) => CRD1Model.fromJson(x))),
        crd2: List<CRD2Model>.from(
            json["CRD2"].map((x) => CRD2Model.fromJson(x))),
        crd3: List<CRD3Model>.from(
            json["CRD3"].map((x) => CRD3Model.fromJson(x))),
        // maps: List<mapsModel>.from(
        //     json["maps"].map((x) => mapsModel.fromJson(x))),
        // orol: List<OROLModel>.from(
        //     json["OROL"].map((x) => OROLModel.fromJson(x))),
        ortu: List<ORTUModel>.from(
            json["ORTU"].map((x) => ORTUModel.fromJson(x))),
        // ovcl: List<OVCLModel>.from(
        //     json["OVCL"].map((x) => OVCLModel.fromJson(x))),
        iuom: List<IUOM>.from(json["IUOM"].map((x) => IUOM.fromJson(x))),
        iwhs: List<IWHS>.from(json["IWHS"].map((x) => IWHS.fromJson(x))),
        ouom: List<OUOMModel>.from(
            json["OUOM"].map((x) => OUOMModel.fromJson(x))),
        // ecp1: List<ECP1>.from(json["ECP1"].map((x) => ECP1.fromJson(x))),
        // ooal: List<LITPL_OOAL>.from(
        //     json["LITPL_OOAL"].map((x) => LITPL_OOAL.fromJson(x))),
        // oac1: List<LITPL_OAC1>.from(
        //     json["LITPL_OAC1"].map((x) => LITPL_OAC1.fromJson(x))),
        // ooac: List<LITPL_OOAC>.from(
        //     json["LITPL_OOAC"].map((x) => LITPL_OOAC.fromJson(x))),
        // itmp: List<ITMP>.from(json["ITMP"].map((x) => ITMP.fromJson(x))),
        oudar: List<OUDAR>.from(json["OUDAR"].map((x) => OUDAR.fromJson(x))),
        // bpmg: List<BPMG>.from(json["BPMG"].map((x) => BPMG.fromJson(x))),

        // otrns: List<OTRNSModel>.from(
        //     json["OTRNS"].map((x) => OTRNSModel.fromJson(x))),
        // ouda: List<OUDA>.from(json["OUDA"].map((x) => OUDA.fromJson(x))),
        // ocinp: List<OCINP>.from(json["OCINP"].map((x) => OCINP.fromJson(x))),
        // oac2: List<LITPL_OAC2>.from(
        //     json["LITPL_OAC2"].map((x) => LITPL_OAC2.fromJson(x))),
        // oadm: List<LITPL_OADM>.from(
        //     json["LITPL_OADM"].map((x) => LITPL_OADM.fromJson(x))),
      );

//----------- TO JSON ----------
  Map<String, dynamic> toJson() => {
        "CRD1": List<dynamic>.from(crd1 ?? [].map((x) => x.toJson())),
        "CRD2": List<dynamic>.from(crd2 ?? [].map((x) => x.toJson())),
        "CRD3": List<dynamic>.from(crd3 ?? [].map((x) => x.toJson())),
        // "maps": List<dynamic>.from(maps ?? [].map((x) => x.toJson())),
        // "OROL": List<dynamic>.from(orol ?? [].map((x) => x.toJson())),
        "ORTU": List<dynamic>.from(ortu ?? [].map((x) => x.toJson())),
        // "OVCL": List<dynamic>.from(ovcl ?? [].map((x) => x.toJson())),
        "IUOM": List<dynamic>.from(iuom ?? [].map((x) => x.toJson())),
        "IWHS": List<dynamic>.from(iwhs ?? [].map((x) => x.toJson())),
        "OUOM": List<dynamic>.from(ouom ?? [].map((x) => x.toJson())),
        // "ECP1": List<dynamic>.from(ecp1 ?? [].map((x) => x.toJson())),
        // "LITPL_OOAL": List<dynamic>.from(ooal ?? [].map((x) => x.toJson())),
        // "LITPL_OAC2": List<dynamic>.from(oac2 ?? [].map((x) => x.toJson())),
        // "LITPL_OAC1": List<dynamic>.from(oac1 ?? [].map((x) => x.toJson())),
        // "LITPL_OADM": List<dynamic>.from(oadm ?? [].map((x) => x.toJson())),
        // "LITPL_OOAC": List<dynamic>.from(ooac ?? [].map((x) => x.toJson())),
        // "ITMP": List<dynamic>.from(itmp ?? [].map((x) => x.toJson())),
        "OUDAR": List<dynamic>.from(oudar ?? [].map((x) => x.toJson())),
        // "BPMG": List<dynamic>.from(bpmg ?? [].map((x) => x.toJson())),

        // "OTRNS": List<dynamic>.from(otrns ?? [].map((x) => x.toJson())),
        // "OUDA": List<dynamic>.from(ouda ?? [].map((x) => x.toJson())),
        // "OCINP": List<dynamic>.from(ocinp ?? [].map((x) => x.toJson())),
      };

//----------- INSERT ----------
  getCustomer2FromWeb(BuildContext? context) async {
    if (isFirstTimeSync) {
      print("Syncing First Time");
    } else {
      print("Not Syncing First Time");
    }
    credentials = getCredentials();
    String encoded = stringToBase64.encode(credentials + secretKey);
    header = {
      'Authorization': 'Basic $encoded',
      "content-type": "application/json",
      "connection": "keep-alive"
    };
    bool isSuccess = false;
    late Customer2 getAll;
    while (!isSuccess) {
      try {
        var res = await http.get(
            headers: header,
            Uri.parse(isFirstTimeSync
                ? prefix + "customer/Customer_2"
                : prefix + "customer/Customer_Date_2"));
        print(res.body);
        getAll = Customer2.fromJson(jsonDecode(res.body));
        print(getAll.toJson());
        isSuccess = true;
      } catch (e) {
        writeToLogFile(
            text: e.toString(),
            fileName: StackTrace.current.toString(),
            lineNo: 141);
        print(e.toString());
      }
    }

    Database db = await initializeDB(context);
    await insertCRD1(db, list: getAll.crd1);
    await insertCRD2(db, list: getAll.crd2);
    await insertCRD3(db, list: getAll.crd3);
    // await insertmaps(db, list: getAll.maps);
    // await insertOROL(db, list: getAll.orol);
    await insertORTU(db, list: getAll.ortu);
    // await insertOVCL(db, list: getAll.ovcl);
    await insertIUOM(db, list: getAll.iuom);
    await insertIWHS(db, list: getAll.iwhs);
    await insertOUOM(db, list: getAll.ouom);
    // await insertECP1(db, list: getAll.ecp1);
    // await insertLITPL_OOAL(db, list: getAll.ooal);
    // await insertLITPL_OAC1(db, list: getAll.oac1);
    // await insertLITPL_OAC2(db, list: getAll.oac2);
    // await insertLITPL_OOAC(db, list: getAll.ooac);
    // await insertLITPL_OADM(db, list: getAll.oadm);
    // await insertITMP(db, list: getAll.itmp);
    await insertOUDAR(db, list: getAll.oudar);
    // await insertBPMG(db, list: getAll.bpmg);

    // await insertOTRNS(db, list: getAll.otrns);
    // await insertOUDA(db, list: getAll.ouda);
    // await insertOCINP(db, list: getAll.ocinp);
  }
}
