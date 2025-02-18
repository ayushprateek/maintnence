import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maintenance/Component/GetCredentials.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/SyncModels/CRDD.dart';
import 'package:maintenance/Sync/SyncModels/DGLMAPPING.dart';
import 'package:maintenance/Sync/SyncModels/DOC1.dart';
import 'package:maintenance/Sync/SyncModels/DOCN.dart';
import 'package:maintenance/Sync/SyncModels/OAMR.dart';
import 'package:maintenance/Sync/SyncModels/OCIN.dart';
import 'package:maintenance/Sync/SyncModels/OCRD.dart';
import 'package:maintenance/Sync/SyncModels/OCRN.dart';
import 'package:maintenance/Sync/SyncModels/ODOC.dart';
import 'package:maintenance/Sync/SyncModels/OEMG.dart';
import 'package:maintenance/Sync/SyncModels/OITM.dart';
import 'package:maintenance/Sync/SyncModels/OMNU.dart';
import 'package:maintenance/Sync/SyncModels/OMSP.dart';
import 'package:maintenance/Sync/SyncModels/ORTT.dart';
import 'package:maintenance/Sync/SyncModels/OTAX.dart';
import 'package:maintenance/Sync/SyncModels/OUOM.dart';
import 'package:maintenance/Sync/SyncModels/OUSR.dart';
import 'package:maintenance/Sync/SyncModels/OWHS.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../../../DatabaseInitialization.dart';

Customer1 Customer1FromJson(String str) => Customer1.fromJson(json.decode(str));

String Customer1ToJson(Customer1 data) => json.encode(data.toJson());

class Customer1 {
  static bool isFirstTimeSync = false;

//----------- CONSTRUCTOR ----------
  Customer1({
    this.crdd,
    this.dglmapping,
    this.doc1,
    this.docn,
    // this.exr1,
    this.oamr,
    // this.oaprv,
    // this.obdt,
    // this.obrn,
    // this.occt,
    this.ocin,
    this.ocrd,
    this.ocrn,
    // this.ocry,
    // this.ocst,
    // this.omdoc,
    this.oemg,
    // this.oemp,
    // this.ogrp,
    this.oitm,
    // this.olev,
    this.omnu,
    this.omsp,
    this.ortt,
    this.otax,
    // this.otrns,
    // this.oudp,
    this.ouom,
    this.ousr,
    // this.ovul,
    this.owhs,
    // this.oxpm,
    // this.oxpt,
    // this.rout,
    // this.sqdocstatus,
    this.odoc,
    // this.vcl1,
    // this.vcl2,
    // this.vcld,
    // this.vul1,
    // this.xpm1,
  });

//----------- VARIABLES ----------

  List<CRDDModel>? crdd;
  List<DGLMAPPING>? dglmapping;
  List<DOC1Model>? doc1;
  List<DOCNModel>? docn;

  // List<EXR1Model>? exr1;
  List<OAMRModel>? oamr;

  // List<OAPRVModel>? oaprv;
  // List<OBDTModel>? obdt;
  // List<OBRNModel>? obrn;
  // List<OCCTModel>? occt;
  List<OCINModel>? ocin;
  List<OCRDModel>? ocrd;
  List<OCRNModel>? ocrn;
  List<ODOC>? odoc;

  // List<OCRYModel>? ocry;
  // List<OCSTModel>? ocst;
  // List<OMDOCModel>? omdoc;
  List<OEMGModel>? oemg;

  // List<OEMPModel>? oemp;
  // List<OGRPModel>? ogrp;
  List<OITMModel>? oitm;

  // List<OLEVModel>? olev;
  List<OMNUModel>? omnu;
  List<OMSPModel>? omsp;
  List<ORTTModel>? ortt;
  List<OTAXModel>? otax;

  // List<OTRNSModel>? otrns;
  // List<OUDP>? oudp;
  List<OUOMModel>? ouom;
  List<OUSRModel>? ousr;

  // List<OVULModel>? ovul;
  List<OWHS>? owhs;

  // List<OXPMModel>? oxpm;
  // List<OXPT>? oxpt;
  // List<ROUTModel>? rout;

  // List<SQDocStatusModel>? sqdocstatus;
  // List<VCL1Model>? vcl1;
  // List<VCL2Model>? vcl2;
  // List<VCLDModel>? vcld;
  // List<VUL1Model>? vul1;
  // List<XPM1Model>? xpm1;

//----------- FROM JSON ----------
  factory Customer1.fromJson(Map<String, dynamic> json) => Customer1(
        crdd: List<CRDDModel>.from(
            json["CRDD"].map((x) => CRDDModel.fromJson(x))),
        dglmapping: List<DGLMAPPING>.from(
            json["DGLMAPPING"].map((x) => DGLMAPPING.fromJson(x))),
        doc1: List<DOC1Model>.from(
            json["DOC1"].map((x) => DOC1Model.fromJson(x))),
        docn: List<DOCNModel>.from(
            json["DOCN"].map((x) => DOCNModel.fromJson(x))),
        // exr1: List<EXR1Model>.from(
        //     json["EXR1"].map((x) => EXR1Model.fromJson(x))),
        oamr: List<OAMRModel>.from(
            json["OAMR"].map((x) => OAMRModel.fromJson(x))),
        // oaprv: List<OAPRVModel>.from(
        //     json["OAPRV"].map((x) => OAPRVModel.fromJson(x))),
        // obdt: List<OBDTModel>.from(
        //     json["OBDT"].map((x) => OBDTModel.fromJson(x))),
        // obrn: List<OBRNModel>.from(
        //     json["OBRN"].map((x) => OBRNModel.fromJson(x))),
        // occt: List<OCCTModel>.from(
        //     json["OCCT"].map((x) => OCCTModel.fromJson(x))),
        ocin: List<OCINModel>.from(
            json["OCIN"].map((x) => OCINModel.fromJson(x))),
        ocrd: List<OCRDModel>.from(
            json["OCRD"].map((x) => OCRDModel.fromJson(x))),
        ocrn: List<OCRNModel>.from(
            json["OCRN"].map((x) => OCRNModel.fromJson(x))),
        // ocry: List<OCRYModel>.from(
        //     json["OCRY"].map((x) => OCRYModel.fromJson(x))),
        // ocst: List<OCSTModel>.from(
        //     json["OCST"].map((x) => OCSTModel.fromJson(x))),
        // omdoc: List<OMDOCModel>.from(
        //     json["ODOC"].map((x) => OMDOCModel.fromJson(x))),
        // oemg: List<OEMGModel>.from(
        //     json["OEMG"].map((x) => OEMGModel.fromJson(x))),
        // oemp: List<OEMPModel>.from(
        //     json["OEMP"].map((x) => OEMPModel.fromJson(x))),
        // ogrp: List<OGRPModel>.from(
        //     json["OGRP"].map((x) => OGRPModel.fromJson(x))),
        oitm: List<OITMModel>.from(
            json["OITM"].map((x) => OITMModel.fromJson(x))),
        // olev: List<OLEVModel>.from(
        //     json["OLEV"].map((x) => OLEVModel.fromJson(x))),
        omnu: List<OMNUModel>.from(
            json["OMNU"].map((x) => OMNUModel.fromJson(x))),
        omsp: List<OMSPModel>.from(
            json["OMSP"].map((x) => OMSPModel.fromJson(x))),
        ortt: List<ORTTModel>.from(
            json["ORTT"].map((x) => ORTTModel.fromJson(x))),
        otax: List<OTAXModel>.from(
            json["OTAX"].map((x) => OTAXModel.fromJson(x))),
        // otrns: List<OTRNSModel>.from(
        //     json["OTRNS"].map((x) => OTRNSModel.fromJson(x))),
        // oudp: List<OUDP>.from(json["OUDP"].map((x) => OUDP.fromJson(x))),
        ouom: List<OUOMModel>.from(
            json["OUOM"].map((x) => OUOMModel.fromJson(x))),
        ousr: List<OUSRModel>.from(
            json["OUSR"].map((x) => OUSRModel.fromJson(x))),
        // ovul: List<OVULModel>.from(
        //     json["OVUL"].map((x) => OVULModel.fromJson(x))),
        owhs: List<OWHS>.from(json["OWHS"].map((x) => OWHS.fromJson(x))),
        // oxpm: List<OXPMModel>.from(
        //     json["OXPM"].map((x) => OXPMModel.fromJson(x))),
        // oxpt: List<OXPT>.from(json["OXPT"].map((x) => OXPT.fromJson(x))),
        // rout: List<ROUTModel>.from(
        //     json["ROUT"].map((x) => ROUTModel.fromJson(x))),
        // sqdocstatus : List<SQDocStatusModel>.from(json["SQDocStatus"].map((x) => SQDocStatusModel.fromJson(x))),
        // vcl1: List<VCL1Model>.from(
        //     json["VCL1"].map((x) => VCL1Model.fromJson(x))),
        // vcl2: List<VCL2Model>.from(
        //     json["VCL2"].map((x) => VCL2Model.fromJson(x))),
        // vcld: List<VCLDModel>.from(
        //     json["VCLD"].map((x) => VCLDModel.fromJson(x))),
        // vul1: List<VUL1Model>.from(
        //     json["VUL1"].map((x) => VUL1Model.fromJson(x))),
        // xpm1: List<XPM1Model>.from(
        //     json["XPM1"].map((x) => XPM1Model.fromJson(x))),
      );

//----------- TO JSON ----------
  Map<String, dynamic> toJson() => {
        "CRDD": List<dynamic>.from(crdd ?? [].map((x) => x.toJson())),
        "DGLMAPPING":
            List<dynamic>.from(dglmapping ?? [].map((x) => x.toJson())),
        "DOC1": List<dynamic>.from(doc1 ?? [].map((x) => x.toJson())),
        "DOCN": List<dynamic>.from(docn ?? [].map((x) => x.toJson())),
        // "EXR1": List<dynamic>.from(exr1 ?? [].map((x) => x.toJson())),
        "OAMR": List<dynamic>.from(oamr ?? [].map((x) => x.toJson())),
        // "OAPRV": List<dynamic>.from(oaprv ?? [].map((x) => x.toJson())),
        // "OBDT": List<dynamic>.from(obdt ?? [].map((x) => x.toJson())),
        // "OBRN": List<dynamic>.from(obrn ?? [].map((x) => x.toJson())),
        // "OCCT": List<dynamic>.from(occt ?? [].map((x) => x.toJson())),
        "OCIN": List<dynamic>.from(ocin ?? [].map((x) => x.toJson())),
        "OCRD": List<dynamic>.from(ocrd ?? [].map((x) => x.toJson())),
        "OCRN": List<dynamic>.from(ocrn ?? [].map((x) => x.toJson())),
        // "OCRY": List<dynamic>.from(ocry ?? [].map((x) => x.toJson())),
        // "OCST": List<dynamic>.from(ocst ?? [].map((x) => x.toJson())),
        "ODOC": List<dynamic>.from(odoc ?? [].map((x) => x.toJson())),
        "OEMG": List<dynamic>.from(oemg ?? [].map((x) => x.toJson())),
        // "OEMP": List<dynamic>.from(oemp ?? [].map((x) => x.toJson())),
        // "OGRP": List<dynamic>.from(ogrp ?? [].map((x) => x.toJson())),
        "OITM": List<dynamic>.from(oitm ?? [].map((x) => x.toJson())),
        // "OLEV": List<dynamic>.from(olev ?? [].map((x) => x.toJson())),
        "OMNU": List<dynamic>.from(omnu ?? [].map((x) => x.toJson())),
        "OMSP": List<dynamic>.from(omsp ?? [].map((x) => x.toJson())),
        "ORTT": List<dynamic>.from(ortt ?? [].map((x) => x.toJson())),
        "OTAX": List<dynamic>.from(otax ?? [].map((x) => x.toJson())),
        // "OTRNS": List<dynamic>.from(otrns ?? [].map((x) => x.toJson())),
        // "OUDP": List<dynamic>.from(oudp ?? [].map((x) => x.toJson())),
        "OUOM": List<dynamic>.from(ouom ?? [].map((x) => x.toJson())),
        "OUSR": List<dynamic>.from(ousr ?? [].map((x) => x.toJson())),
        // "OVUL": List<dynamic>.from(ovul ?? [].map((x) => x.toJson())),
        "OWHS": List<dynamic>.from(owhs ?? [].map((x) => x.toJson())),
        // "OXPM": List<dynamic>.from(oxpm ?? [].map((x) => x.toJson())),
        // "OXPT": List<dynamic>.from(oxpt ?? [].map((x) => x.toJson())),
        // "ROUT": List<dynamic>.from(rout ?? [].map((x) => x.toJson())),
        // "SQDocStatus": List<dynamic>.from(sqdocstatus??[].map((x) => x.toJson())),
        // "VCL1": List<dynamic>.from(vcl1 ?? [].map((x) => x.toJson())),
        // "VCL2": List<dynamic>.from(vcl2 ?? [].map((x) => x.toJson())),
        // "VCLD": List<dynamic>.from(vcld ?? [].map((x) => x.toJson())),
        // "VUL1": List<dynamic>.from(vul1 ?? [].map((x) => x.toJson())),
        // "XPM1": List<dynamic>.from(xpm1 ?? [].map((x) => x.toJson())),
      };

//----------- INSERT ----------
  getCustomer1FromWeb(BuildContext? context) async {
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
    late Customer1 getAll;
    while (!isSuccess) {
      try {
        var res = await http.get(
            headers: header,
            Uri.parse(isFirstTimeSync
                ? prefix + "customer/Customer_1"
                : prefix + "customer/Customer_Date_1"));
        print(res.body);
        getAll = Customer1.fromJson(jsonDecode(res.body));
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
    await insertCRDD(db, list: getAll.crdd);
    await insertDGLMAPPING(db, list: getAll.dglmapping);
    await insertDOC1(db, list: getAll.doc1);
    await insertDOCN(db, list: getAll.docn);
    // await insertEXR1(db, list: getAll.exr1);
    await insertOAMR(db, list: getAll.oamr);
    // await insertOAPRV(db, list: getAll.oaprv);
    // await insertOBDT(db, list: getAll.obdt);
    // await insertOBRN(db, list: getAll.obrn);
    // await insertOCCT(db, list: getAll.occt);
    await insertOCIN(db, list: getAll.ocin);
    await insertOCRD(db, list: getAll.ocrd);
    await insertOCRN(db, list: getAll.ocrn);
    // await insertOCRY(db, list: getAll.ocry);
    // await insertOCST(db, list: getAll.ocst);
    // await insertOMDOC(db, list: getAll.omdoc);
    await insertOEMG(db, list: getAll.oemg);
    // await insertOEMP(db, list: getAll.oemp);
    // await insertOGRP(db, list: getAll.ogrp);
    await insertOITM(db, list: getAll.oitm);
    // await insertOLEV(db, list: getAll.olev);
    await insertOMNU(db, list: getAll.omnu);
    await insertOMSP(db, list: getAll.omsp);
    await insertORTT(db, list: getAll.ortt);
    await insertOTAX(db, list: getAll.otax);
    // await insertOTRNS(db, list: getAll.otrns);
    // await insertOUDP(db, list: getAll.oudp);
    await insertOUOM(db, list: getAll.ouom);
    await insertOUSR(db, list: getAll.ousr);
    // await insertOVUL(db, list: getAll.ovul);
    await insertOWHS(db, list: getAll.owhs);
    // await insertOXPM(db, list: getAll.oxpm);
    // await insertOXPT(db, list: getAll.oxpt);
    // await insertROUT(db, list: getAll.rout);
    // await insertSQDocStatus(db,list: getAll.sqdocstatus);
    // await insertVCL1(db, list: getAll.vcl1);
    // await insertVCL2(db, list: getAll.vcl2);
    // await insertVCLD(db, list: getAll.vcld);
    // await insertVUL1(db, list: getAll.vul1);
    // await insertXPM1(db, list: getAll.xpm1);
  }
}
