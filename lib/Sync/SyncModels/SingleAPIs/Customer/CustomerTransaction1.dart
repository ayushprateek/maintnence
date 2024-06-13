import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/GetCredentials.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/SyncModels/DLN1.dart';
import 'package:maintenance/Sync/SyncModels/DLN2.dart';
import 'package:maintenance/Sync/SyncModels/DLN3.dart';
import 'package:maintenance/Sync/SyncModels/INV1.dart';
import 'package:maintenance/Sync/SyncModels/INV2.dart';
import 'package:maintenance/Sync/SyncModels/INV3.dart';
import 'package:maintenance/Sync/SyncModels/OCRT.dart';
import 'package:maintenance/Sync/SyncModels/ODLN.dart';
import 'package:maintenance/Sync/SyncModels/OINV.dart';
import 'package:maintenance/Sync/SyncModels/OPTR.dart';
import 'package:maintenance/Sync/SyncModels/OQUT.dart';
import 'package:maintenance/Sync/SyncModels/ORDR.dart';
import 'package:maintenance/Sync/SyncModels/QUT1.dart';
import 'package:maintenance/Sync/SyncModels/QUT2.dart';
import 'package:maintenance/Sync/SyncModels/QUT3.dart';
import 'package:maintenance/Sync/SyncModels/RDR1.dart';
import 'package:maintenance/Sync/SyncModels/RDR2.dart';
import 'package:maintenance/Sync/SyncModels/RDR3.dart';
import 'package:sqflite/sqlite_api.dart';

class CustomerTransaction1 {
  static bool isFirstTimeSync = false;

//----------- CONSTRUCTOR ----------
  CustomerTransaction1({
    // this.act1,
    // this.act2,
    // this.act3,
    this.dln1,
    this.dln2,
    this.dln3,
    // this.dpt1,
    // this.dsc1,
    // this.dsc2,
    this.inv1,
    this.inv2,
    this.inv3,
    // this.oact,
    this.ocrt,
    // this.ocsh,
    this.odln,
    // this.odpt,
    // this.odsc,
    // this.oecp,
    // this.oexr,
    this.oinv,
    this.optr,
    this.oqut,
    this.ordr,
    // this.ortp,
    // this.ovld,
    this.qut1,
    this.qut2,
    this.qut3,
    this.rdr1,
    this.rdr2,
    this.rdr3,
    // this.rtn1,
    // this.rtn2,
    // this.rtn3,
    // this.rtp1,
    // this.rtp2,
    // this.vld1,
  });

//----------- VARIABLES ----------
//   List<ACT1Model>? act1;
//   List<ACT2Model>? act2;
//   List<ACT3Model>? act3;
  List<DLN1Model>? dln1;
  List<DLN2Model>? dln2;
  List<DLN3Model>? dln3;

  // List<DPT1Model>? dpt1;
  // List<DSC1Model>? dsc1;
  // List<DSC2Model>? dsc2;
  List<INV1Model>? inv1;
  List<INV2Model>? inv2;
  List<INV3Model>? inv3;

  // List<OACTModel>? oact;
  List<OCRTModel>? ocrt;

  // List<OCSH>? ocsh;
  List<ODLNModel>? odln;

  // List<ODPTModel>? odpt;
  // List<ODSCModel>? odsc;
  // List<OECPModel>? oecp;
  // List<OEXRModel>? oexr;
  List<OINVModel>? oinv;
  List<OPTRModel>? optr;
  List<OQUTModel>? oqut;
  List<ORDRModel>? ordr;

  // List<ORTPModel>? ortp;
  // List<OVLDModel>? ovld;
  List<QUT1Model>? qut1;
  List<QUT2Model>? qut2;
  List<QUT3Model>? qut3;
  List<RDR1Model>? rdr1;
  List<RDR2Model>? rdr2;
  List<RDR3Model>? rdr3;

  // List<RTN1Model>? rtn1;
  // List<RTN2Model>? rtn2;
  // List<RTN3Model>? rtn3;
  // List<RTP1Model>? rtp1;
  // List<RTP2Model>? rtp2;
  // List<VLD1Model>? vld1;

//----------- FROM JSON ----------
  factory CustomerTransaction1.fromJson(Map<String, dynamic> json) =>
      CustomerTransaction1(
        // act1: List<ACT1Model>.from(
        //     json["ACT1"].map((x) => ACT1Model.fromJson(x))),
        // act2: List<ACT2Model>.from(
        //     json["ACT2"].map((x) => ACT2Model.fromJson(x))),
        // act3: List<ACT3Model>.from(
        //     json["ACT3"].map((x) => ACT3Model.fromJson(x))),
        dln1: List<DLN1Model>.from(
            json["DLN1"].map((x) => DLN1Model.fromJson(x))),
        dln2: List<DLN2Model>.from(
            json["DLN2"].map((x) => DLN2Model.fromJson(x))),
        dln3: List<DLN3Model>.from(
            json["DLN3"].map((x) => DLN3Model.fromJson(x))),
        // dpt1: List<DPT1Model>.from(
        //     json["DPT1"].map((x) => DPT1Model.fromJson(x))),
        // dsc1: List<DSC1Model>.from(
        //     json["DSC1"].map((x) => DSC1Model.fromJson(x))),
        // dsc2: List<DSC2Model>.from(
        //     json["DSC2"].map((x) => DSC2Model.fromJson(x))),
        inv1: List<INV1Model>.from(
            json["INV1"].map((x) => INV1Model.fromJson(x))),
        inv2: List<INV2Model>.from(
            json["INV2"].map((x) => INV2Model.fromJson(x))),
        inv3: List<INV3Model>.from(
            json["INV3"].map((x) => INV3Model.fromJson(x))),
        // oact: List<OACTModel>.from(
        //     json["OACT"].map((x) => OACTModel.fromJson(x))),
        ocrt: List<OCRTModel>.from(
            json["OCRT"].map((x) => OCRTModel.fromJson(x))),
        // ocsh: List<OCSH>.from(json["OCSH"].map((x) => OCSH.fromJson(x))),
        odln: List<ODLNModel>.from(
            json["ODLN"].map((x) => ODLNModel.fromJson(x))),
        // odpt: List<ODPTModel>.from(
        //     json["ODPT"].map((x) => ODPTModel.fromJson(x))),
        // odsc: List<ODSCModel>.from(
        //     json["ODSC"].map((x) => ODSCModel.fromJson(x))),
        // oecp: List<OECPModel>.from(
        //     json["OECP"].map((x) => OECPModel.fromJson(x))),
        // oexr: List<OEXRModel>.from(
        //     json["OEXR"].map((x) => OEXRModel.fromJson(x))),
        oinv: List<OINVModel>.from(
            json["OINV"].map((x) => OINVModel.fromJson(x))),
        optr: List<OPTRModel>.from(
            json["OPTR"].map((x) => OPTRModel.fromJson(x))),
        oqut: List<OQUTModel>.from(
            json["OQUT"].map((x) => OQUTModel.fromJson(x))),
        ordr: List<ORDRModel>.from(
            json["ORDR"].map((x) => ORDRModel.fromJson(x))),
        // ortp: List<ORTPModel>.from(
        //     json["ORTP"].map((x) => ORTPModel.fromJson(x))),
        // ovld: List<OVLDModel>.from(
        //     json["OVLD"].map((x) => OVLDModel.fromJson(x))),
        qut1: List<QUT1Model>.from(
            json["QUT1"].map((x) => QUT1Model.fromJson(x))),
        qut2: List<QUT2Model>.from(
            json["QUT2"].map((x) => QUT2Model.fromJson(x))),
        qut3: List<QUT3Model>.from(
            json["QUT3"].map((x) => QUT3Model.fromJson(x))),
        rdr1: List<RDR1Model>.from(
            json["RDR1"].map((x) => RDR1Model.fromJson(x))),
        rdr2: List<RDR2Model>.from(
            json["RDR2"].map((x) => RDR2Model.fromJson(x))),
        rdr3: List<RDR3Model>.from(
            json["RDR3"].map((x) => RDR3Model.fromJson(x))),
        // rtn1: List<RTN1Model>.from(
        //     json["RTN1"].map((x) => RTN1Model.fromJson(x))),
        // rtn2: List<RTN2Model>.from(
        //     json["RTN2"].map((x) => RTN2Model.fromJson(x))),
        // rtn3: List<RTN3Model>.from(
        //     json["RTN3"].map((x) => RTN3Model.fromJson(x))),
        // rtp1: List<RTP1Model>.from(
        //     json["RTP1"].map((x) => RTP1Model.fromJson(x))),
        // rtp2: List<RTP2Model>.from(
        //     json["RTP2"].map((x) => RTP2Model.fromJson(x))),
        // vld1: List<VLD1Model>.from(
        //     json["VLD1"].map((x) => VLD1Model.fromJson(x))),
      );

//----------- TO JSON ----------
  Map<String, dynamic> toJson() => {
        // "ACT1": List<dynamic>.from(act1 ?? [].map((x) => x.toJson())),
        // "ACT2": List<dynamic>.from(act2 ?? [].map((x) => x.toJson())),
        // "ACT3": List<dynamic>.from(act3 ?? [].map((x) => x.toJson())),
        "DLN1": List<dynamic>.from(dln1 ?? [].map((x) => x.toJson())),
        "DLN2": List<dynamic>.from(dln2 ?? [].map((x) => x.toJson())),
        "DLN3": List<dynamic>.from(dln3 ?? [].map((x) => x.toJson())),
        // "DPT1": List<dynamic>.from(dpt1 ?? [].map((x) => x.toJson())),
        // "DSC1": List<dynamic>.from(dsc1 ?? [].map((x) => x.toJson())),
        // "DSC2": List<dynamic>.from(dsc2 ?? [].map((x) => x.toJson())),
        "INV1": List<dynamic>.from(inv1 ?? [].map((x) => x.toJson())),
        "INV2": List<dynamic>.from(inv2 ?? [].map((x) => x.toJson())),
        "INV3": List<dynamic>.from(inv3 ?? [].map((x) => x.toJson())),
        // "OACT": List<dynamic>.from(oact ?? [].map((x) => x.toJson())),
        "OCRT": List<dynamic>.from(ocrt ?? [].map((x) => x.toJson())),
        // "OCSH": List<dynamic>.from(ocsh ?? [].map((x) => x.toJson())),
        "ODLN": List<dynamic>.from(odln ?? [].map((x) => x.toJson())),
        // "ODPT": List<dynamic>.from(odpt ?? [].map((x) => x.toJson())),
        // "ODSC": List<dynamic>.from(odsc ?? [].map((x) => x.toJson())),
        // "OECP": List<dynamic>.from(oecp ?? [].map((x) => x.toJson())),
        // "OEXR": List<dynamic>.from(oexr ?? [].map((x) => x.toJson())),
        "OINV": List<dynamic>.from(oinv ?? [].map((x) => x.toJson())),
        "OPTR": List<dynamic>.from(optr ?? [].map((x) => x.toJson())),
        "OQUT": List<dynamic>.from(oqut ?? [].map((x) => x.toJson())),
        "ORDR": List<dynamic>.from(ordr ?? [].map((x) => x.toJson())),
        // "ORTP": List<dynamic>.from(ortp ?? [].map((x) => x.toJson())),
        // "OVLD": List<dynamic>.from(ovld ?? [].map((x) => x.toJson())),
        "QUT1": List<dynamic>.from(qut1 ?? [].map((x) => x.toJson())),
        "QUT2": List<dynamic>.from(qut2 ?? [].map((x) => x.toJson())),
        "QUT3": List<dynamic>.from(qut3 ?? [].map((x) => x.toJson())),
        "RDR1": List<dynamic>.from(rdr1 ?? [].map((x) => x.toJson())),
        "RDR2": List<dynamic>.from(rdr2 ?? [].map((x) => x.toJson())),
        "RDR3": List<dynamic>.from(rdr3 ?? [].map((x) => x.toJson())),
        // "RTN1": List<dynamic>.from(rtn1 ?? [].map((x) => x.toJson())),
        // "RTN2": List<dynamic>.from(rtn2 ?? [].map((x) => x.toJson())),
        // "RTN3": List<dynamic>.from(rtn3 ?? [].map((x) => x.toJson())),
        // "RTP1": List<dynamic>.from(rtp1 ?? [].map((x) => x.toJson())),
        // "RTP2": List<dynamic>.from(rtp2 ?? [].map((x) => x.toJson())),
        // "VLD1": List<dynamic>.from(vld1 ?? [].map((x) => x.toJson())),
      };

//----------- INSERT ----------
  getCustomerTransaction1FromWeb(BuildContext? context) async {
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
    late CustomerTransaction1 transactions;
    while (!isSuccess) {
      try {
        var res = await http.get(
            headers: header,
            Uri.parse(isFirstTimeSync
                ? prefix + "customer/Transaction_1"
                : prefix + "customer/Transaction_Date"));
        print(res.body);
        transactions = CustomerTransaction1.fromJson(jsonDecode(res.body));
        print(transactions.toJson());
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
    // await insertACT1(db, list: transactions.act1);
    // await insertACT2(db, list: transactions.act2);
    // await insertACT3(db, list: transactions.act3);
    await insertDLN1(db, list: transactions.dln1);
    await insertDLN2(db, list: transactions.dln2);
    await insertDLN3(db, list: transactions.dln3);
    // await insertDPT1(db, list: transactions.dpt1);
    // await insertDSC1(db, list: transactions.dsc1);
    // await insertDSC2(db, list: transactions.dsc2);
    await insertINV1(db, list: transactions.inv1);
    await insertINV2(db, list: transactions.inv2);
    await insertINV3(db, list: transactions.inv3);
    // await insertOACT(db, list: transactions.oact);
    await insertOCRT(db, list: transactions.ocrt);
    // await insertOCSH(db, list: transactions.ocsh);
    await insertODLN(db, list: transactions.odln);
    // await insertODPT(db, list: transactions.odpt);
    // await insertODSC(db, list: transactions.odsc);
    // await insertOECP(db, list: transactions.oecp);
    // await insertOEXR(db, list: transactions.oexr);
    await insertOINV(db, list: transactions.oinv);
    await insertOPTR(db, list: transactions.optr);
    await insertOQUT(db, list: transactions.oqut);
    await insertORDR(db, list: transactions.ordr);
    // await insertORTP(db, list: transactions.ortp);
    // await insertOVLD(db, list: transactions.ovld);
    await insertQUT1(db, list: transactions.qut1);
    await insertQUT2(db, list: transactions.qut2);
    await insertQUT3(db, list: transactions.qut3);
    await insertRDR1(db, list: transactions.rdr1);
    await insertRDR2(db, list: transactions.rdr2);
    await insertRDR3(db, list: transactions.rdr3);
    // await insertRTN1(db, list: transactions.rtn1);
    // await insertRTN2(db, list: transactions.rtn2);
    // await insertRTN3(db, list: transactions.rtn3);
    // await insertRTP1(db, list: transactions.rtp1);
    // await insertRTP2(db, list: transactions.rtp2);
    // await insertVLD1(db, list: transactions.vld1);
  }
}
