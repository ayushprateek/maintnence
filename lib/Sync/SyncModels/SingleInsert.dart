import 'dart:convert';

import 'package:maintenance/Sync/SyncModels/IMGDI1.dart';
import 'package:maintenance/Sync/SyncModels/IMOGDI.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD1.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD2.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD3.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD2.dart';
import 'package:maintenance/Sync/SyncModels/MNOCLD.dart';
import 'package:maintenance/Sync/SyncModels/MNOJCD.dart';
import 'package:maintenance/Sync/SyncModels/PRITR1.dart';
import 'package:maintenance/Sync/SyncModels/PROITR.dart';
import 'package:maintenance/Sync/SyncModels/PROPDN.dart';
import 'package:maintenance/Sync/SyncModels/PROPRQ.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN1.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN2.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN3.dart';
import 'package:maintenance/Sync/SyncModels/PRPRQ1.dart';

SingleInsert singleInsertFromJson(String str) =>
    SingleInsert.fromJson(json.decode(str));

String singleInsertToJson(SingleInsert data) => json.encode(data.toJson());

class SingleInsert {
  List<MNOCLD>? mnoclDs;
  List<MNCLD1>? mncld1S;
  List<MNCLD2>? mncld2S;
  List<MNCLD3>? mncld3S;
  List<MNOJCD>? mnojcDs;
  List<MNCLD1>? mnjcd1S;
  List<MNJCD2>? mnjcd2S;
  List<MNCLD2>? mnjcd3S;

  // List<MNJCD4>? mnjcd4S;
  List<IMOGDI>? imogdIs;
  List<IMGDI1>? imgdi1S;
  List<PROPRQ>? proprQs;
  List<PRPRQ1>? prprq1S;
  List<PROPDN>? propdNs;
  List<PRPDN1>? prpdn1S;
  List<PRPDN2>? prpdn2S;
  List<PRPDN3>? prpdn3S;
  List<PROITR>? proitRs;
  List<PRITR1>? pritr1S;

  SingleInsert({
    this.mnoclDs,
    this.mncld1S,
    this.mncld2S,
    this.mncld3S,
    this.mnojcDs,
    this.mnjcd1S,
    this.mnjcd2S,
    this.mnjcd3S,
    // this.mnjcd4S,
    this.imogdIs,
    this.imgdi1S,
    this.proprQs,
    this.prprq1S,
    this.propdNs,
    this.prpdn1S,
    this.prpdn2S,
    this.prpdn3S,
    this.proitRs,
    this.pritr1S,
  });

  factory SingleInsert.fromJson(Map<String, dynamic> json) => SingleInsert(
        mnoclDs: json["MNOCLDs"] == null
            ? []
            : List<MNOCLD>.from(
                json["MNOCLDs"]!.map((x) => MNOCLD.fromJson(x))),
        mncld1S: json["MNCLD1s"] == null
            ? []
            : List<MNCLD1>.from(
                json["MNCLD1s"]!.map((x) => MNCLD1.fromJson(x))),
        mncld2S: json["MNCLD2s"] == null
            ? []
            : List<MNCLD2>.from(
                json["MNCLD2s"]!.map((x) => MNCLD2.fromJson(x))),
        mncld3S: json["MNCLD3s"] == null
            ? []
            : List<MNCLD3>.from(
                json["MNCLD3s"]!.map((x) => MNCLD3.fromJson(x))),
        mnojcDs: json["MNOJCDs"] == null
            ? []
            : List<MNOJCD>.from(
                json["MNOJCDs"]!.map((x) => MNOJCD.fromJson(x))),
        mnjcd1S: json["MNJCD1s"] == null
            ? []
            : List<MNCLD1>.from(
                json["MNJCD1s"]!.map((x) => MNCLD1.fromJson(x))),
        mnjcd2S: json["MNJCD2s"] == null
            ? []
            : List<MNJCD2>.from(
                json["MNJCD2s"]!.map((x) => MNJCD2.fromJson(x))),
        mnjcd3S: json["MNJCD3s"] == null
            ? []
            : List<MNCLD2>.from(
                json["MNJCD3s"]!.map((x) => MNCLD2.fromJson(x))),
        // mnjcd4S: json["MNJCD4s"] == null ? [] : List<MNJCD4>.from(json["MNJCD4s"]!.map((x) => MNJCD4.fromJson(x))),
        imogdIs: json["IMOGDIs"] == null
            ? []
            : List<IMOGDI>.from(
                json["IMOGDIs"]!.map((x) => IMOGDI.fromJson(x))),
        imgdi1S: json["IMGDI1s"] == null
            ? []
            : List<IMGDI1>.from(
                json["IMGDI1s"]!.map((x) => IMGDI1.fromJson(x))),
        proprQs: json["PROPRQs"] == null
            ? []
            : List<PROPRQ>.from(
                json["PROPRQs"]!.map((x) => PROPRQ.fromJson(x))),
        prprq1S: json["PRPRQ1s"] == null
            ? []
            : List<PRPRQ1>.from(
                json["PRPRQ1s"]!.map((x) => PRPRQ1.fromJson(x))),
        propdNs: json["PROPDNs"] == null
            ? []
            : List<PROPDN>.from(
                json["PROPDNs"]!.map((x) => PROPDN.fromJson(x))),
        prpdn1S: json["PRPDN1s"] == null
            ? []
            : List<PRPDN1>.from(
                json["PRPDN1s"]!.map((x) => PRPDN1.fromJson(x))),
        prpdn2S: json["PRPDN2s"] == null
            ? []
            : List<PRPDN2>.from(
                json["PRPDN2s"]!.map((x) => PRPDN2.fromJson(x))),
        prpdn3S: json["PRPDN3s"] == null
            ? []
            : List<PRPDN3>.from(
                json["PRPDN3s"]!.map((x) => PRPDN3.fromJson(x))),
        proitRs: json["PROITRs"] == null
            ? []
            : List<PROITR>.from(
                json["PROITRs"]!.map((x) => PROITR.fromJson(x))),
        pritr1S: json["PRITR1s"] == null
            ? []
            : List<PRITR1>.from(
                json["PRITR1s"]!.map((x) => PRITR1.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "MNOCLDs": mnoclDs == null
            ? []
            : List<dynamic>.from(mnoclDs!.map((x) => x.toJson())),
        "MNCLD1s": mncld1S == null
            ? []
            : List<dynamic>.from(mncld1S!.map((x) => x.toJson())),
        "MNCLD2s": mncld2S == null
            ? []
            : List<dynamic>.from(mncld2S!.map((x) => x.toJson())),
        "MNCLD3s": mncld3S == null
            ? []
            : List<dynamic>.from(mncld3S!.map((x) => x.toJson())),
        "MNOJCDs": mnojcDs == null
            ? []
            : List<dynamic>.from(mnojcDs!.map((x) => x.toJson())),
        "MNJCD1s": mnjcd1S == null
            ? []
            : List<dynamic>.from(mnjcd1S!.map((x) => x.toJson())),
        "MNJCD2s": mnjcd2S == null
            ? []
            : List<dynamic>.from(mnjcd2S!.map((x) => x.toJson())),
        "MNJCD3s": mnjcd3S == null
            ? []
            : List<dynamic>.from(mnjcd3S!.map((x) => x.toJson())),
        // "MNJCD4s": mnjcd4S == null ? [] : List<dynamic>.from(mnjcd4S!.map((x) => x.toJson())),
        "IMOGDIs": imogdIs == null
            ? []
            : List<dynamic>.from(imogdIs!.map((x) => x.toJson())),
        "IMGDI1s": imgdi1S == null
            ? []
            : List<dynamic>.from(imgdi1S!.map((x) => x.toJson())),
        "PROPRQs": proprQs == null
            ? []
            : List<dynamic>.from(proprQs!.map((x) => x.toJson())),
        "PRPRQ1s": prprq1S == null
            ? []
            : List<dynamic>.from(prprq1S!.map((x) => x.toJson())),
        "PROPDNs": propdNs == null
            ? []
            : List<dynamic>.from(propdNs!.map((x) => x.toJson())),
        "PRPDN1s": prpdn1S == null
            ? []
            : List<dynamic>.from(prpdn1S!.map((x) => x.toJson())),
        "PRPDN2s": prpdn2S == null
            ? []
            : List<dynamic>.from(prpdn2S!.map((x) => x.toJson())),
        "PRPDN3s": prpdn3S == null
            ? []
            : List<dynamic>.from(prpdn3S!.map((x) => x.toJson())),
        "PROITRs": proitRs == null
            ? []
            : List<dynamic>.from(proitRs!.map((x) => x.toJson())),
        "PRITR1s": pritr1S == null
            ? []
            : List<dynamic>.from(pritr1S!.map((x) => x.toJson())),
      };
}
