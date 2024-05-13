import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maintenance/Component/GetCredentials.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD1.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD2.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD3.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD1.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD2.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD3.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD4.dart';
import 'package:maintenance/Sync/SyncModels/MNOCLD.dart';
import 'package:maintenance/Sync/SyncModels/MNOJCD.dart';
import 'package:maintenance/Sync/SyncModels/OPCNA1.dart';
import 'package:maintenance/Sync/SyncModels/OPCNA2.dart';
import 'package:maintenance/Sync/SyncModels/OPCNA3.dart';
import 'package:maintenance/Sync/SyncModels/OPCNA4.dart';
import 'package:maintenance/Sync/SyncModels/OPOCNA.dart';
import 'package:maintenance/Sync/SyncModels/OPOTRE.dart';
import 'package:maintenance/Sync/SyncModels/OPOTRP.dart';
import 'package:maintenance/Sync/SyncModels/OPTRE1.dart';
import 'package:maintenance/Sync/SyncModels/OPTRP1.dart';
import 'package:maintenance/Sync/SyncModels/PRINV1.dart';
import 'package:maintenance/Sync/SyncModels/PRINV2.dart';
import 'package:maintenance/Sync/SyncModels/PRINV3.dart';
import 'package:maintenance/Sync/SyncModels/PRITR1.dart';
import 'package:maintenance/Sync/SyncModels/PROINV.dart';
import 'package:maintenance/Sync/SyncModels/PROITR.dart';
import 'package:maintenance/Sync/SyncModels/PROPDN.dart';
import 'package:maintenance/Sync/SyncModels/PROPOR.dart';
import 'package:maintenance/Sync/SyncModels/PROPRQ.dart';
import 'package:maintenance/Sync/SyncModels/PROQUT.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN1.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN2.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN3.dart';
import 'package:maintenance/Sync/SyncModels/PRPOR1.dart';
import 'package:maintenance/Sync/SyncModels/PRPOR2.dart';
import 'package:maintenance/Sync/SyncModels/PRPOR3.dart';
import 'package:maintenance/Sync/SyncModels/PRPRQ1.dart';
import 'package:maintenance/Sync/SyncModels/PRQUT1.dart';
import 'package:maintenance/Sync/SyncModels/PRQUT2.dart';
import 'package:maintenance/Sync/SyncModels/PRQUT3.dart';
import 'package:sqflite/sqlite_api.dart';

class Transaction1 {
  // static bool isFirstTimeSync = false;

//----------- CONSTRUCTOR ----------
  Transaction1({
    // this.act1,
    // this.act2,
    // this.act3,
    // this.dln1,
    // this.dln2,
    // this.dln3,
    // this.dpt1,
    // this.dsc1,
    // this.dsc2,
    // this.inv1,
    // this.inv2,
    // this.inv3,
    // this.oact,
    // this.ocrt,
    // this.ocsh,
    // this.odln,
    // this.odpt,
    // this.odsc,
    // this.oecp,
    // this.oexr,
    // this.oinv,
    // this.optr,
    // this.oqut,
    // this.ordr,
    // this.ortp,
    // this.ovld,
    // this.qut1,
    // this.qut2,
    // this.qut3,
    // this.rdr1,
    // this.rdr2,
    // this.rdr3,
    // this.rtn1,
    // this.rtn2,
    // this.rtn3,
    // this.rtp1,
    // this.rtp2,
    // this.vld1,
    // this.ostk,
    // this.stk1,
    // this.cvocvp,
    // this.cvcvp1,
    // this.suoita,
    // this.suita1,
    // this.suita2,
    // this.suoatp,
    // this.suatp1,
    this.mnocld,
    this.mncld1,
    this.mncld2,
    this.mncld3,
    this.mnjcd1,
    this.mnjcd2,
    this.mnjcd3,
    this.mnjcd4,
    this.mnojcd,
    this.opcna1,
    this.opcna2,
    this.opcna3,
    this.opcna4,
    this.opocna,
    this.opotre,
    this.opotrp,
    this.optre1,
    this.optrp1,
    this.prinv1,
    this.prinv2,
    this.prinv3,
    this.pritr1,
    this.proinv,
    this.proitr,
    this.propdn,
    this.propor,
    this.proprq,
    this.proqut,
    this.prpdn1,
    this.prpdn2,
    this.prpdn3,
    this.prpor1,
    this.prpor2,
    this.prpor3,
    this.prprq1,
    this.prqut1,
    this.prqut2,
    this.prqut3,
  });

//----------- VARIABLES ----------
//   List<ACT1Model>? act1;
//   List<ACT2Model>? act2;
//   List<ACT3Model>? act3;
//   List<DLN1Model>? dln1;
//   List<DLN2Model>? dln2;
//   List<DLN3Model>? dln3;
//   List<DPT1Model>? dpt1;
//   List<DSC1Model>? dsc1;
//   List<DSC2Model>? dsc2;
//   List<INV1Model>? inv1;
//   List<INV2Model>? inv2;
//   List<INV3Model>? inv3;
//   List<OACTModel>? oact;
//   List<OCRTModel>? ocrt;
//   List<OCSH>? ocsh;
//   List<ODLNModel>? odln;
//   List<ODPTModel>? odpt;
//   List<ODSCModel>? odsc;
//   List<OECPModel>? oecp;
//   List<OEXRModel>? oexr;
//   List<OINVModel>? oinv;
//   List<OPTRModel>? optr;
//   List<OQUTModel>? oqut;
//   List<ORDRModel>? ordr;
//   List<ORTPModel>? ortp;
//   List<OVLDModel>? ovld;
//   List<QUT1Model>? qut1;
//   List<QUT2Model>? qut2;
//   List<QUT3Model>? qut3;
//   List<RDR1Model>? rdr1;
//   List<RDR2Model>? rdr2;
//   List<RDR3Model>? rdr3;
//   List<RTN1Model>? rtn1;
//   List<RTN2Model>? rtn2;
//   List<RTN3Model>? rtn3;
//   List<RTP1Model>? rtp1;
//   List<RTP2Model>? rtp2;
//   List<VLD1Model>? vld1;
//   List<OSTK>? ostk;
//   List<STK1>? stk1;
//   List<CVOCVP>? cvocvp;
//   List<CVCVP1>? cvcvp1;
//   List<SUOITA>? suoita;
//   List<SUITA1>? suita1;
//   List<SUITA2>? suita2;
//   List<SUOATP>? suoatp;
//   List<SUATP1>? suatp1;
  List<MNOCLD>? mnocld;
  List<MNCLD1>? mncld1;
  List<MNCLD2>? mncld2;
  List<MNCLD3>? mncld3;

  //--------------------
  List<MNJCD1>? mnjcd1;
  List<MNJCD2>? mnjcd2;
  List<MNJCD3>? mnjcd3;
  List<MNJCD4>? mnjcd4;
  List<MNOJCD>? mnojcd;
  List<OPCNA1>? opcna1;
  List<OPCNA2>? opcna2;
  List<OPCNA3>? opcna3;
  List<OPCNA4>? opcna4;
  List<OPOCNA>? opocna;
  List<OPOTRE>? opotre;
  List<OPOTRP>? opotrp;
  List<OPTRE1>? optre1;
  List<OPTRP1>? optrp1;
  List<PRINV1>? prinv1;
  List<PRINV2>? prinv2;
  List<PRINV3>? prinv3;
  List<PRITR1>? pritr1;
  List<PROINV>? proinv;
  List<PROITR>? proitr;
  List<PROPDN>? propdn;
  List<PROPOR>? propor;
  List<PROPRQ>? proprq;
  List<PROQUT>? proqut;
  List<PRPDN1>? prpdn1;
  List<PRPDN2>? prpdn2;
  List<PRPDN3>? prpdn3;
  List<PRPOR1>? prpor1;
  List<PRPOR2>? prpor2;
  List<PRPOR3>? prpor3;
  List<PRPRQ1>? prprq1;
  List<PRQUT1>? prqut1;
  List<PRQUT2>? prqut2;
  List<PRQUT3>? prqut3;

//----------- FROM JSON ----------
  factory Transaction1.fromJson(Map<String, dynamic> json) => Transaction1(
        // act1: List<ACT1Model>.from(
        //     json["ACT1"].map((x) => ACT1Model.fromJson(x))),
        // act2: List<ACT2Model>.from(
        //     json["ACT2"].map((x) => ACT2Model.fromJson(x))),
        // act3: List<ACT3Model>.from(
        //     json["ACT3"].map((x) => ACT3Model.fromJson(x))),
        // dln1: List<DLN1Model>.from(
        //     json["DLN1"].map((x) => DLN1Model.fromJson(x))),
        // dln2: List<DLN2Model>.from(
        //     json["DLN2"].map((x) => DLN2Model.fromJson(x))),
        // dln3: List<DLN3Model>.from(
        //     json["DLN3"].map((x) => DLN3Model.fromJson(x))),
        // dpt1: List<DPT1Model>.from(
        //     json["DPT1"].map((x) => DPT1Model.fromJson(x))),
        // dsc1: List<DSC1Model>.from(
        //     json["DSC1"].map((x) => DSC1Model.fromJson(x))),
        // dsc2: List<DSC2Model>.from(
        //     json["DSC2"].map((x) => DSC2Model.fromJson(x))),
        // inv1: List<INV1Model>.from(
        //     json["INV1"].map((x) => INV1Model.fromJson(x))),
        // inv2: List<INV2Model>.from(
        //     json["INV2"].map((x) => INV2Model.fromJson(x))),
        // inv3: List<INV3Model>.from(
        //     json["INV3"].map((x) => INV3Model.fromJson(x))),
        // oact: List<OACTModel>.from(
        //     json["OACT"].map((x) => OACTModel.fromJson(x))),
        // ocrt: List<OCRTModel>.from(
        //     json["OCRT"].map((x) => OCRTModel.fromJson(x))),
        // ocsh: List<OCSH>.from(json["OCSH"].map((x) => OCSH.fromJson(x))),
        // odln: List<ODLNModel>.from(
        //     json["ODLN"].map((x) => ODLNModel.fromJson(x))),
        // odpt: List<ODPTModel>.from(
        //     json["ODPT"].map((x) => ODPTModel.fromJson(x))),
        // odsc: List<ODSCModel>.from(
        //     json["ODSC"].map((x) => ODSCModel.fromJson(x))),
        // oecp: List<OECPModel>.from(
        //     json["OECP"].map((x) => OECPModel.fromJson(x))),
        // oexr: List<OEXRModel>.from(
        //     json["OEXR"].map((x) => OEXRModel.fromJson(x))),
        // oinv: List<OINVModel>.from(
        //     json["OINV"].map((x) => OINVModel.fromJson(x))),
        // optr: List<OPTRModel>.from(
        //     json["OPTR"].map((x) => OPTRModel.fromJson(x))),
        // oqut: List<OQUTModel>.from(
        //     json["OQUT"].map((x) => OQUTModel.fromJson(x))),
        // ordr: List<ORDRModel>.from(
        //     json["ORDR"].map((x) => ORDRModel.fromJson(x))),
        // ortp: List<ORTPModel>.from(
        //     json["ORTP"].map((x) => ORTPModel.fromJson(x))),
        // ovld: List<OVLDModel>.from(
        //     json["OVLD"].map((x) => OVLDModel.fromJson(x))),
        // qut1: List<QUT1Model>.from(
        //     json["QUT1"].map((x) => QUT1Model.fromJson(x))),
        // qut2: List<QUT2Model>.from(
        //     json["QUT2"].map((x) => QUT2Model.fromJson(x))),
        // qut3: List<QUT3Model>.from(
        //     json["QUT3"].map((x) => QUT3Model.fromJson(x))),
        // rdr1: List<RDR1Model>.from(
        //     json["RDR1"].map((x) => RDR1Model.fromJson(x))),
        // rdr2: List<RDR2Model>.from(
        //     json["RDR2"].map((x) => RDR2Model.fromJson(x))),
        // rdr3: List<RDR3Model>.from(
        //     json["RDR3"].map((x) => RDR3Model.fromJson(x))),
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
        // cvocvp:
        //     List<CVOCVP>.from(json["CVOCVP"].map((x) => CVOCVP.fromJson(x))),
        // ostk: List<OSTK>.from(json["OSTK"].map((x) => OSTK.fromJson(x))),
        // stk1: List<STK1>.from(json["STK1"].map((x) => STK1.fromJson(x))),
        // cvcvp1:
        //     List<CVCVP1>.from(json["CVCVP1"].map((x) => CVCVP1.fromJson(x))),
        // suoita:
        //     List<SUOITA>.from(json["SUOITA"].map((x) => SUOITA.fromJson(x))),
        // suita1:
        //     List<SUITA1>.from(json["SUITA1"].map((x) => SUITA1.fromJson(x))),
        // suita2:
        //     List<SUITA2>.from(json["SUITA2"].map((x) => SUITA2.fromJson(x))),
        // suoatp:
        //     List<SUOATP>.from(json["SUOATP"].map((x) => SUOATP.fromJson(x))),
        // suatp1:
        //     List<SUATP1>.from(json["SUATP1"].map((x) => SUATP1.fromJson(x))),
        mnocld:
            List<MNOCLD>.from(json["MNOCLD"].map((x) => MNOCLD.fromJson(x))),
        mncld1:
            List<MNCLD1>.from(json["MNCLD1"].map((x) => MNCLD1.fromJson(x))),
        mncld2:
            List<MNCLD2>.from(json["MNCLD2"].map((x) => MNCLD2.fromJson(x))),
        mncld3:
            List<MNCLD3>.from(json["MNCLD3"].map((x) => MNCLD3.fromJson(x))),
        mnjcd1:
            List<MNJCD1>.from(json["MNJCD1"].map((x) => MNJCD1.fromJson(x))),
        mnjcd2:
            List<MNJCD2>.from(json["MNJCD2"].map((x) => MNJCD2.fromJson(x))),
        mnjcd3:
            List<MNJCD3>.from(json["MNJCD3"].map((x) => MNJCD3.fromJson(x))),
        mnjcd4:
            List<MNJCD4>.from(json["MNJCD4"].map((x) => MNJCD4.fromJson(x))),
        mnojcd:
            List<MNOJCD>.from(json["MNOJCD"].map((x) => MNOJCD.fromJson(x))),
        opcna1:
            List<OPCNA1>.from(json["OPCNA1"].map((x) => OPCNA1.fromJson(x))),
        opcna2:
            List<OPCNA2>.from(json["OPCNA2"].map((x) => OPCNA2.fromJson(x))),
        opcna3:
            List<OPCNA3>.from(json["OPCNA3"].map((x) => OPCNA3.fromJson(x))),
        opcna4:
            List<OPCNA4>.from(json["OPCNA4"].map((x) => OPCNA4.fromJson(x))),
        opocna:
            List<OPOCNA>.from(json["OPOCNA"].map((x) => OPOCNA.fromJson(x))),
        opotre:
            List<OPOTRE>.from(json["OPOTRE"].map((x) => OPOTRE.fromJson(x))),
        opotrp:
            List<OPOTRP>.from(json["OPOTRP"].map((x) => OPOTRP.fromJson(x))),
        optre1:
            List<OPTRE1>.from(json["OPTRE1"].map((x) => OPTRE1.fromJson(x))),
        optrp1:
            List<OPTRP1>.from(json["OPTRP1"].map((x) => OPTRP1.fromJson(x))),
        prinv1:
            List<PRINV1>.from(json["PRINV1"].map((x) => PRINV1.fromJson(x))),
        prinv2:
            List<PRINV2>.from(json["PRINV2"].map((x) => PRINV2.fromJson(x))),
        prinv3:
            List<PRINV3>.from(json["PRINV3"].map((x) => PRINV3.fromJson(x))),
        pritr1:
            List<PRITR1>.from(json["PRITR1"].map((x) => PRITR1.fromJson(x))),
        proinv:
            List<PROINV>.from(json["PROINV"].map((x) => PROINV.fromJson(x))),
        proitr:
            List<PROITR>.from(json["PROITR"].map((x) => PROITR.fromJson(x))),
        propdn:
            List<PROPDN>.from(json["PROPDN"].map((x) => PROPDN.fromJson(x))),
        propor:
            List<PROPOR>.from(json["PROPOR"].map((x) => PROPOR.fromJson(x))),
        proprq:
            List<PROPRQ>.from(json["PROPRQ"].map((x) => PROPRQ.fromJson(x))),
        proqut:
            List<PROQUT>.from(json["PROQUT"].map((x) => PROQUT.fromJson(x))),
        prpdn1:
            List<PRPDN1>.from(json["PRPDN1"].map((x) => PRPDN1.fromJson(x))),
        prpdn2:
            List<PRPDN2>.from(json["PRPDN2"].map((x) => PRPDN2.fromJson(x))),
        prpdn3:
            List<PRPDN3>.from(json["PRPDN3"].map((x) => PRPDN3.fromJson(x))),
        prpor1:
            List<PRPOR1>.from(json["PRPOR1"].map((x) => PRPOR1.fromJson(x))),
        prpor2:
            List<PRPOR2>.from(json["PRPOR2"].map((x) => PRPOR2.fromJson(x))),
        prpor3:
            List<PRPOR3>.from(json["PRPOR3"].map((x) => PRPOR3.fromJson(x))),
        prprq1:
            List<PRPRQ1>.from(json["PRPRQ1"].map((x) => PRPRQ1.fromJson(x))),
        prqut1:
            List<PRQUT1>.from(json["PRQUT1"].map((x) => PRQUT1.fromJson(x))),
        prqut2:
            List<PRQUT2>.from(json["PRQUT2"].map((x) => PRQUT2.fromJson(x))),
        prqut3:
            List<PRQUT3>.from(json["PRQUT3"].map((x) => PRQUT3.fromJson(x))),
      );

//----------- TO JSON ----------
  Map<String, dynamic> toJson() => {
        // "ACT1": List<dynamic>.from(act1 ?? [].map((x) => x.toJson())),
        // "ACT2": List<dynamic>.from(act2 ?? [].map((x) => x.toJson())),
        // "ACT3": List<dynamic>.from(act3 ?? [].map((x) => x.toJson())),
        // "DLN1": List<dynamic>.from(dln1 ?? [].map((x) => x.toJson())),
        // "DLN2": List<dynamic>.from(dln2 ?? [].map((x) => x.toJson())),
        // "DLN3": List<dynamic>.from(dln3 ?? [].map((x) => x.toJson())),
        // "DPT1": List<dynamic>.from(dpt1 ?? [].map((x) => x.toJson())),
        // "DSC1": List<dynamic>.from(dsc1 ?? [].map((x) => x.toJson())),
        // "DSC2": List<dynamic>.from(dsc2 ?? [].map((x) => x.toJson())),
        // "INV1": List<dynamic>.from(inv1 ?? [].map((x) => x.toJson())),
        // "INV2": List<dynamic>.from(inv2 ?? [].map((x) => x.toJson())),
        // "INV3": List<dynamic>.from(inv3 ?? [].map((x) => x.toJson())),
        // "OACT": List<dynamic>.from(oact ?? [].map((x) => x.toJson())),
        // "OCRT": List<dynamic>.from(ocrt ?? [].map((x) => x.toJson())),
        // "OCSH": List<dynamic>.from(ocsh ?? [].map((x) => x.toJson())),
        // "ODLN": List<dynamic>.from(odln ?? [].map((x) => x.toJson())),
        // "ODPT": List<dynamic>.from(odpt ?? [].map((x) => x.toJson())),
        // "ODSC": List<dynamic>.from(odsc ?? [].map((x) => x.toJson())),
        // "OECP": List<dynamic>.from(oecp ?? [].map((x) => x.toJson())),
        // "OEXR": List<dynamic>.from(oexr ?? [].map((x) => x.toJson())),
        // "OINV": List<dynamic>.from(oinv ?? [].map((x) => x.toJson())),
        // "OPTR": List<dynamic>.from(optr ?? [].map((x) => x.toJson())),
        // "OQUT": List<dynamic>.from(oqut ?? [].map((x) => x.toJson())),
        // "ORDR": List<dynamic>.from(ordr ?? [].map((x) => x.toJson())),
        // "ORTP": List<dynamic>.from(ortp ?? [].map((x) => x.toJson())),
        // "OVLD": List<dynamic>.from(ovld ?? [].map((x) => x.toJson())),
        // "QUT1": List<dynamic>.from(qut1 ?? [].map((x) => x.toJson())),
        // "QUT2": List<dynamic>.from(qut2 ?? [].map((x) => x.toJson())),
        // "QUT3": List<dynamic>.from(qut3 ?? [].map((x) => x.toJson())),
        // "RDR1": List<dynamic>.from(rdr1 ?? [].map((x) => x.toJson())),
        // "RDR2": List<dynamic>.from(rdr2 ?? [].map((x) => x.toJson())),
        // "RDR3": List<dynamic>.from(rdr3 ?? [].map((x) => x.toJson())),
        // "RTN1": List<dynamic>.from(rtn1 ?? [].map((x) => x.toJson())),
        // "RTN2": List<dynamic>.from(rtn2 ?? [].map((x) => x.toJson())),
        // "RTN3": List<dynamic>.from(rtn3 ?? [].map((x) => x.toJson())),
        // "RTP1": List<dynamic>.from(rtp1 ?? [].map((x) => x.toJson())),
        // "RTP2": List<dynamic>.from(rtp2 ?? [].map((x) => x.toJson())),
        // "VLD1": List<dynamic>.from(vld1 ?? [].map((x) => x.toJson())),
        // "OSTK": List<dynamic>.from(ostk ?? [].map((x) => x.toJson())),
        // "STK1": List<dynamic>.from(stk1 ?? [].map((x) => x.toJson())),
        // "CVOCVP": List<dynamic>.from(cvocvp ?? [].map((x) => x.toJson())),
        // "CVCVP1": List<dynamic>.from(cvcvp1 ?? [].map((x) => x.toJson())),
        // "SUOITA": List<dynamic>.from(suoita ?? [].map((x) => x.toJson())),
        // "SUITA1": List<dynamic>.from(suita1 ?? [].map((x) => x.toJson())),
        // "SUITA2": List<dynamic>.from(suita2 ?? [].map((x) => x.toJson())),
        // "SUOATP": List<dynamic>.from(suoatp ?? [].map((x) => x.toJson())),
        // "SUATP1": List<dynamic>.from(suatp1 ?? [].map((x) => x.toJson())),
        "MNOCLD": List<dynamic>.from(mnocld ?? [].map((x) => x.toJson())),
        "MNCLD1": List<dynamic>.from(mncld1 ?? [].map((x) => x.toJson())),
        "MNCLD2": List<dynamic>.from(mncld2 ?? [].map((x) => x.toJson())),
        "MNCLD3": List<dynamic>.from(mncld3 ?? [].map((x) => x.toJson())),
        "MNJCD1": List<dynamic>.from(mnjcd1 ?? [].map((x) => x.toJson())),
        "MNJCD2": List<dynamic>.from(mnjcd2 ?? [].map((x) => x.toJson())),
        "MNJCD3": List<dynamic>.from(mnjcd3 ?? [].map((x) => x.toJson())),
        "MNJCD4": List<dynamic>.from(mnjcd4 ?? [].map((x) => x.toJson())),
        "MNOJCD": List<dynamic>.from(mnojcd ?? [].map((x) => x.toJson())),
        "OPCNA1": List<dynamic>.from(opcna1 ?? [].map((x) => x.toJson())),
        "OPCNA2": List<dynamic>.from(opcna2 ?? [].map((x) => x.toJson())),
        "OPCNA3": List<dynamic>.from(opcna3 ?? [].map((x) => x.toJson())),
        "OPCNA4": List<dynamic>.from(opcna4 ?? [].map((x) => x.toJson())),
        "OPOCNA": List<dynamic>.from(opocna ?? [].map((x) => x.toJson())),
        "OPOTRE": List<dynamic>.from(opotre ?? [].map((x) => x.toJson())),
        "OPOTRP": List<dynamic>.from(opotrp ?? [].map((x) => x.toJson())),
        "OPTRE1": List<dynamic>.from(optre1 ?? [].map((x) => x.toJson())),
        "OPTRP1": List<dynamic>.from(optrp1 ?? [].map((x) => x.toJson())),
        "PRINV1": List<dynamic>.from(prinv1 ?? [].map((x) => x.toJson())),
        "PRINV2": List<dynamic>.from(prinv2 ?? [].map((x) => x.toJson())),
        "PRINV3": List<dynamic>.from(prinv3 ?? [].map((x) => x.toJson())),
        "PRITR1": List<dynamic>.from(pritr1 ?? [].map((x) => x.toJson())),
        "PROINV": List<dynamic>.from(proinv ?? [].map((x) => x.toJson())),
        "PROITR": List<dynamic>.from(proitr ?? [].map((x) => x.toJson())),
        "PROPDN": List<dynamic>.from(propdn ?? [].map((x) => x.toJson())),
        "PROPOR": List<dynamic>.from(propor ?? [].map((x) => x.toJson())),
        "PROPRQ": List<dynamic>.from(proprq ?? [].map((x) => x.toJson())),
        "PROQUT": List<dynamic>.from(proqut ?? [].map((x) => x.toJson())),
        "PRPDN1": List<dynamic>.from(prpdn1 ?? [].map((x) => x.toJson())),
        "PRPDN2": List<dynamic>.from(prpdn2 ?? [].map((x) => x.toJson())),
        "PRPDN3": List<dynamic>.from(prpdn3 ?? [].map((x) => x.toJson())),
        "PRPOR1": List<dynamic>.from(prpor1 ?? [].map((x) => x.toJson())),
        "PRPOR2": List<dynamic>.from(prpor2 ?? [].map((x) => x.toJson())),
        "PRPOR3": List<dynamic>.from(prpor3 ?? [].map((x) => x.toJson())),
        "PRPRQ1": List<dynamic>.from(prprq1 ?? [].map((x) => x.toJson())),
        "PRQUT1": List<dynamic>.from(prqut1 ?? [].map((x) => x.toJson())),
        "PRQUT2": List<dynamic>.from(prqut2 ?? [].map((x) => x.toJson())),
        "PRQUT3": List<dynamic>.from(prqut3 ?? [].map((x) => x.toJson())),
      };

//----------- INSERT ----------
  getTransaction1FromWeb(bool isFirstTimeSync) async {
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
    late Transaction1 transactions;
    while (!isSuccess) {
      try {
        var res = await http.get(
            headers: header,
            Uri.parse(isFirstTimeSync
                ? prefix + "CompressedMaster/Transaction_1"
                : prefix + "CompressedMaster/Transaction_Date"));
        // print(res.body);
        // print(res.bodyBytes);
        final xxx = utf8.decode(res.bodyBytes);
        print(xxx);
        transactions = Transaction1.fromJson(jsonDecode(xxx));
        print(transactions.toJson());
        isSuccess = true;
      } catch (e) {
        writeToLogFile(
            text: e.toString(),
            fileName: StackTrace.current.toString(),
            lineNo: 141);
        print(e.toString());
        // getErrorSnackBar(e.toString());
      }
    }

    Database db = await initializeDB(null);
    // await insertACT1(db, list: transactions.act1);
    // await insertACT2(db, list: transactions.act2);
    // await insertACT3(db, list: transactions.act3);
    // await insertDLN1(db, list: transactions.dln1);
    // await insertDLN2(db, list: transactions.dln2);
    // await insertDLN3(db, list: transactions.dln3);
    // await insertDPT1(db, list: transactions.dpt1);
    // await insertDSC1(db, list: transactions.dsc1);
    // await insertDSC2(db, list: transactions.dsc2);
    // await insertINV1(db, list: transactions.inv1);
    // await insertINV2(db, list: transactions.inv2);
    // await insertINV3(db, list: transactions.inv3);
    // await insertOACT(db, list: transactions.oact);
    // await insertOCRT(db, list: transactions.ocrt);
    // await insertOCSH(db, list: transactions.ocsh);
    // await insertODLN(db, list: transactions.odln);
    // await insertODPT(db, list: transactions.odpt);
    // await insertODSC(db, list: transactions.odsc);
    // await insertOECP(db, list: transactions.oecp);
    // await insertOEXR(db, list: transactions.oexr);
    // await insertOINV(db, list: transactions.oinv);
    // await insertOPTR(db, list: transactions.optr);
    // await insertOQUT(db, list: transactions.oqut);
    // await insertORDR(db, list: transactions.ordr);
    // await insertORTP(db, list: transactions.ortp);
    // await insertOVLD(db, list: transactions.ovld);
    // await insertQUT1(db, list: transactions.qut1);
    // await insertQUT2(db, list: transactions.qut2);
    // await insertQUT3(db, list: transactions.qut3);
    // await insertRDR1(db, list: transactions.rdr1);
    // await insertRDR2(db, list: transactions.rdr2);
    // await insertRDR3(db, list: transactions.rdr3);
    // await insertRTN1(db, list: transactions.rtn1);
    // await insertRTN2(db, list: transactions.rtn2);
    // await insertRTN3(db, list: transactions.rtn3);
    // await insertRTP1(db, list: transactions.rtp1);
    // await insertRTP2(db, list: transactions.rtp2);
    // await insertVLD1(db, list: transactions.vld1);
    // await insertOSTK(db, list: transactions.ostk);
    // await insertSTK1(db, list: transactions.stk1);
    // await insertCVOCVP(db, list: transactions.cvocvp);
    // await insertCVCVP1(db, list: transactions.cvcvp1);
    // await insertSUOITA(db, list: transactions.suoita);
    // await insertSUITA1(db, list: transactions.suita1);
    // await insertSUITA2(db, list: transactions.suita2);
    // await insertSUOATP(db, list: transactions.suoatp);
    // await insertSUATP1(db, list: transactions.suatp1);
    await insertMNOCLD(db, list: transactions.mnocld);
    await insertMNCLD1(db, list: transactions.mncld1);
    await insertMNCLD2(db, list: transactions.mncld2);
    await insertMNCLD3(db, list: transactions.mncld3);
    await insertMNJCD1(db, list: transactions.mnjcd1);
    await insertMNJCD2(db, list: transactions.mnjcd2);
    await insertMNJCD3(db, list: transactions.mnjcd3);
    await insertMNJCD4(db, list: transactions.mnjcd4);
    await insertMNOJCD(db, list: transactions.mnojcd);
    await insertOPCNA1(db, list: transactions.opcna1);
    await insertOPCNA2(db, list: transactions.opcna2);
    await insertOPCNA3(db, list: transactions.opcna3);
    await insertOPCNA4(db, list: transactions.opcna4);
    await insertOPOCNA(db, list: transactions.opocna);
    await insertOPOTRE(db, list: transactions.opotre);
    await insertOPOTRP(db, list: transactions.opotrp);
    await insertOPTRE1(db, list: transactions.optre1);
    await insertOPTRP1(db, list: transactions.optrp1);
    await insertPRINV1(db, list: transactions.prinv1);
    await insertPRINV2(db, list: transactions.prinv2);
    await insertPRINV3(db, list: transactions.prinv3);
    await insertPRITR1(db, list: transactions.pritr1);
    await insertPROINV(db, list: transactions.proinv);
    await insertPROITR(db, list: transactions.proitr);
    await insertPROPDN(db, list: transactions.propdn);
    await insertPROPOR(db, list: transactions.propor);
    await insertPROPRQ(db, list: transactions.proprq);
    await insertPROQUT(db, list: transactions.proqut);
    await insertPRPDN1(db, list: transactions.prpdn1);
    await insertPRPDN2(db, list: transactions.prpdn2);
    await insertPRPDN3(db, list: transactions.prpdn3);
    await insertPRPOR1(db, list: transactions.prpor1);
    await insertPRPOR2(db, list: transactions.prpor2);
    await insertPRPOR3(db, list: transactions.prpor3);
    await insertPRPRQ1(db, list: transactions.prprq1);
    await insertPRQUT1(db, list: transactions.prqut1);
    await insertPRQUT2(db, list: transactions.prqut2);
    await insertPRQUT3(db, list: transactions.prqut3);
  }
}
