import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maintenance/Component/GetCredentials.dart';
import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/CustomURL.dart';
import 'package:maintenance/Sync/SyncModels/BPMG.dart';
import 'package:maintenance/Sync/SyncModels/BPSG.dart';
import 'package:maintenance/Sync/SyncModels/CRD1.dart';
import 'package:maintenance/Sync/SyncModels/CRD2.dart';
import 'package:maintenance/Sync/SyncModels/CRD3.dart';
import 'package:maintenance/Sync/SyncModels/CVMTP1.dart';
import 'package:maintenance/Sync/SyncModels/CVOMTP.dart';
import 'package:maintenance/Sync/SyncModels/ITMP.dart';
import 'package:maintenance/Sync/SyncModels/IUOM.dart';
import 'package:maintenance/Sync/SyncModels/IWHS.dart';
import 'package:maintenance/Sync/SyncModels/LITPL_OAC1.dart';
import 'package:maintenance/Sync/SyncModels/LITPL_OAC2.dart';
import 'package:maintenance/Sync/SyncModels/LITPL_OADM.dart';
import 'package:maintenance/Sync/SyncModels/LITPL_OOAC.dart';
import 'package:maintenance/Sync/SyncModels/LITPL_OOAL.dart';
import 'package:maintenance/Sync/SyncModels/OCDC.dart';
import 'package:maintenance/Sync/SyncModels/OCINP.dart';
import 'package:maintenance/Sync/SyncModels/OEJT.dart';
import 'package:maintenance/Sync/SyncModels/OEPO.dart';
import 'package:maintenance/Sync/SyncModels/OPRF.dart';
import 'package:maintenance/Sync/SyncModels/ORTU.dart';
import 'package:maintenance/Sync/SyncModels/OTRM.dart';
import 'package:maintenance/Sync/SyncModels/OTRNS.dart';
import 'package:maintenance/Sync/SyncModels/OUDA.dart';
import 'package:maintenance/Sync/SyncModels/OUDAR.dart';
import 'package:maintenance/Sync/SyncModels/OUOM.dart';
import 'package:maintenance/Sync/SyncModels/OVCL.dart';
import 'package:maintenance/Sync/SyncModels/PRF1.dart';
import 'package:maintenance/Sync/SyncModels/SecondaryCalendar.dart';
import 'package:maintenance/Sync/SyncModels/SecondaryCalendarYears.dart';
import 'package:sqflite/sqlite_api.dart';

GetAllMaster2 GetAllMaster1FromJson(String str) =>
    GetAllMaster2.fromJson(json.decode(str));

String GetAllMaster1ToJson(GetAllMaster2 data) => json.encode(data.toJson());

class GetAllMaster2 {
  // static bool isFirstTimeSync = false;

//----------- CONSTRUCTOR ----------
  GetAllMaster2({
    this.crd1,
    this.crd2,
    this.crd3,
    // this.orol,
    this.ortu,
    this.ovcl,
    this.iuom,
    this.iwhs,
    // this.ouom,
    // this.ecp1,
    this.ooal,
    this.oac1,
    this.oac2,
    this.ooac,
    this.itmp,
    this.oudar,
    this.bpmg,
    // this.owhs,
    this.otrns,
    this.ouda,
    this.ocinp,
    this.oadm,
    this.secondaryCalendar,
    this.secondaryCalendarYears,
    this.cvomtp,
    this.cvmtp1,
    this.bpsg,
    this.oejt,
    this.oepo,
    this.ocdc,
    this.otrm,
    this.oprf,
    // this.prf1,
  });

//----------- VARIABLES ----------
  List<OEJT>? oejt;
  List<OEPO>? oepo;
  List<OCDC>? ocdc;
  List<OTRM>? otrm;
  List<OPRF>? oprf;
  List<CRD1Model>? crd1;
  List<CRD2Model>? crd2;
  List<CRD3Model>? crd3;
  // List<PRF1>? prf1;

  // List<OROLModel>? orol;
  List<ORTUModel>? ortu;
  List<OVCLModel>? ovcl;
  List<IUOM>? iuom;
  List<IWHS>? iwhs;
  // List<OUOMModel>? ouom;
  List<BPSG>? bpsg;

  // List<ECP1>? ecp1;
  List<LITPL_OOAL>? ooal;
  List<LITPL_OAC1>? oac1;
  List<LITPL_OAC2>? oac2;
  List<LITPL_OADM>? oadm;
  List<LITPL_OOAC>? ooac;

  List<ITMP>? itmp;
  List<OUDAR>? oudar;
  List<BPMG>? bpmg;
  List<CVOMTP>? cvomtp;
  List<CVMTP1>? cvmtp1;

  // List<OWHS>? owhs;
  List<OTRNSModel>? otrns;
  List<OUDA>? ouda;
  List<OCINP>? ocinp;
  List<SecondaryCalendar>? secondaryCalendar;
  List<SecondaryCalendarYears>? secondaryCalendarYears;

//----------- FROM JSON ----------
  factory GetAllMaster2.fromJson(Map<String, dynamic> json) => GetAllMaster2(
        crd1: List<CRD1Model>.from(
            json["CRD1"].map((x) => CRD1Model.fromJson(x))),
        crd2: List<CRD2Model>.from(
            json["CRD2"].map((x) => CRD2Model.fromJson(x))),
        crd3: List<CRD3Model>.from(
            json["CRD3"].map((x) => CRD3Model.fromJson(x))),

        // orol: List<OROLModel>.from(
        //     json["OROL"].map((x) => OROLModel.fromJson(x))),
        ortu: List<ORTUModel>.from(
            json["ORTU"].map((x) => ORTUModel.fromJson(x))),
        ovcl: List<OVCLModel>.from(
            json["OVCL"].map((x) => OVCLModel.fromJson(x))),
        iuom: List<IUOM>.from(json["IUOM"].map((x) => IUOM.fromJson(x))),
        iwhs: List<IWHS>.from(json["IWHS"].map((x) => IWHS.fromJson(x))),
        oepo: List<OEPO>.from(json["OEPO"].map((x) => OEPO.fromJson(x))),
        ocdc: List<OCDC>.from(json["OCDC"].map((x) => OCDC.fromJson(x))),
        // prf1: List<PRF1>.from(json["PRF1"].map((x) => PRF1.fromJson(x))),
        // ouom: List<OUOMModel>.from(
        //     json["OUOM"].map((x) => OUOMModel.fromJson(x))),
        // ecp1: List<ECP1>.from(json["ECP1"].map((x) => ECP1.fromJson(x))),
        ooal: List<LITPL_OOAL>.from(
            json["LITPL_OOAL"].map((x) => LITPL_OOAL.fromJson(x))),
        oac1: List<LITPL_OAC1>.from(
            json["LITPL_OAC1"].map((x) => LITPL_OAC1.fromJson(x))),
        ooac: List<LITPL_OOAC>.from(
            json["LITPL_OOAC"].map((x) => LITPL_OOAC.fromJson(x))),
        oprf: List<OPRF>.from(json["OPRF"].map((x) => OPRF.fromJson(x))),
        itmp: List<ITMP>.from(json["ITMP"].map((x) => ITMP.fromJson(x))),
        oudar: List<OUDAR>.from(json["OUDAR"].map((x) => OUDAR.fromJson(x))),
        bpmg: List<BPMG>.from(json["BPMG"].map((x) => BPMG.fromJson(x))),
        otrm: List<OTRM>.from(json["OTRM"].map((x) => OTRM.fromJson(x))),
        // owhs: List<OWHS>.from(json["OWHS"].map((x) => OWHS.fromJson(x))),
        otrns: List<OTRNSModel>.from(
            json["OTRNS"].map((x) => OTRNSModel.fromJson(x))),
        ouda: List<OUDA>.from(json["OUDA"].map((x) => OUDA.fromJson(x))),
        oejt: List<OEJT>.from(json["OEJT"].map((x) => OEJT.fromJson(x))),
        cvomtp:
            List<CVOMTP>.from(json["CVOMTP"].map((x) => CVOMTP.fromJson(x))),
        cvmtp1:
            List<CVMTP1>.from(json["CVMTP1"].map((x) => CVMTP1.fromJson(x))),
        ocinp: List<OCINP>.from(json["OCINP"].map((x) => OCINP.fromJson(x))),
        bpsg: List<BPSG>.from(json["BPSG"].map((x) => BPSG.fromJson(x))),
        oac2: List<LITPL_OAC2>.from(
            json["LITPL_OAC2"].map((x) => LITPL_OAC2.fromJson(x))),
        oadm: List<LITPL_OADM>.from(
            json["LITPL_OADM"].map((x) => LITPL_OADM.fromJson(x))),
        secondaryCalendar: List<SecondaryCalendar>.from(
            json["SecondaryCalendar"]
                .map((x) => SecondaryCalendar.fromJson(x))),
        secondaryCalendarYears: List<SecondaryCalendarYears>.from(
            json["SecondaryCalendarYears"]
                .map((x) => SecondaryCalendarYears.fromJson(x))),
      );

//----------- TO JSON ----------
  Map<String, dynamic> toJson() => {
        "CRD1": List<dynamic>.from(crd1 ?? [].map((x) => x.toJson())),
        "CRD2": List<dynamic>.from(crd2 ?? [].map((x) => x.toJson())),
        "CRD3": List<dynamic>.from(crd3 ?? [].map((x) => x.toJson())),
        // "OROL": List<dynamic>.from(orol ?? [].map((x) => x.toJson())),
        "ORTU": List<dynamic>.from(ortu ?? [].map((x) => x.toJson())),
        "BPSG": List<dynamic>.from(bpsg ?? [].map((x) => x.toJson())),
        "OVCL": List<dynamic>.from(ovcl ?? [].map((x) => x.toJson())),
        "IUOM": List<dynamic>.from(iuom ?? [].map((x) => x.toJson())),
        "IWHS": List<dynamic>.from(iwhs ?? [].map((x) => x.toJson())),
        // "OUOM": List<dynamic>.from(ouom ?? [].map((x) => x.toJson())),
        "CVOMTP": List<dynamic>.from(cvomtp ?? [].map((x) => x.toJson())),
        "CVMTP1": List<dynamic>.from(cvmtp1 ?? [].map((x) => x.toJson())),
        "OEPO": List<dynamic>.from(oepo ?? [].map((x) => x.toJson())),
        "OCDC": List<dynamic>.from(ocdc ?? [].map((x) => x.toJson())),
        // "ECP1": List<dynamic>.from(ecp1 ?? [].map((x) => x.toJson())),
        "LITPL_OOAL": List<dynamic>.from(ooal ?? [].map((x) => x.toJson())),
        "LITPL_OAC2": List<dynamic>.from(oac2 ?? [].map((x) => x.toJson())),
        "LITPL_OAC1": List<dynamic>.from(oac1 ?? [].map((x) => x.toJson())),
        "LITPL_OADM": List<dynamic>.from(oadm ?? [].map((x) => x.toJson())),
        "LITPL_OOAC": List<dynamic>.from(ooac ?? [].map((x) => x.toJson())),
        "OPRF": List<dynamic>.from(oprf ?? [].map((x) => x.toJson())),
        "ITMP": List<dynamic>.from(itmp ?? [].map((x) => x.toJson())),
        "OUDAR": List<dynamic>.from(oudar ?? [].map((x) => x.toJson())),
        "BPMG": List<dynamic>.from(bpmg ?? [].map((x) => x.toJson())),
        // "OWHS": List<dynamic>.from(owhs ?? [].map((x) => x.toJson())),
        "OTRNS": List<dynamic>.from(otrns ?? [].map((x) => x.toJson())),
        "OUDA": List<dynamic>.from(ouda ?? [].map((x) => x.toJson())),
        "OCINP": List<dynamic>.from(ocinp ?? [].map((x) => x.toJson())),
        "OTRM": List<dynamic>.from(otrm ?? [].map((x) => x.toJson())),
        "OEJT": List<dynamic>.from(oejt ?? [].map((x) => x.toJson())),
        // "PRF1": List<dynamic>.from(prf1 ?? [].map((x) => x.toJson())),
        "SecondaryCalendar":
            List<dynamic>.from(secondaryCalendar ?? [].map((x) => x.toJson())),
        "SecondaryCalendarYears": List<dynamic>.from(
            secondaryCalendarYears ?? [].map((x) => x.toJson())),
      };

//----------- INSERT ----------
  getGetAllMaster2FromWeb(bool isFirstTimeSync) async {
    if (isFirstTimeSync) {
      print("Syncing First Time");
    } else {
      print("Not Syncing First Time");
    }
    credentials = getCredentials();
    String encoded = stringToBase64.encode(credentials+secretKey);
    header = {
      'Authorization': 'Basic $encoded',
      "content-type": "application/json",
      "connection": "keep-alive"
    };
    bool isSuccess = false;
    late GetAllMaster2 getAll;
    while (!isSuccess) {
      try {
        var res = await http.get(
            headers: header,
            Uri.parse(isFirstTimeSync
                ? prefix + "CompressedMaster/Master_2"
                : prefix + "CompressedMaster/Master_Date_2"));
        // print(res.body);
        // print(res.bodyBytes);
        final xxx = utf8.decode(res.bodyBytes);
        print(xxx);
        getAll = GetAllMaster2.fromJson(jsonDecode(xxx));
        print(getAll.toJson());
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
    await insertCRD1(db, list: getAll.crd1);
    await insertCRD2(db, list: getAll.crd2);
    await insertCRD3(db, list: getAll.crd3);
    // await insertOROL(db, list: getAll.orol);
    await insertORTU(db, list: getAll.ortu);
    await insertOVCL(db, list: getAll.ovcl);
    await insertIUOM(db, list: getAll.iuom);
    await insertIWHS(db, list: getAll.iwhs);
    // await insertOUOM(db, list: getAll.ouom);
    await insertCVOMTP(db, list: getAll.cvomtp);
    await insertCVMTP1(db, list: getAll.cvmtp1);
    await insertBPSG(db, list: getAll.bpsg);
    // await insertECP1(db, list: getAll.ecp1);
    await insertLITPL_OOAL(db, list: getAll.ooal);
    await insertLITPL_OAC1(db, list: getAll.oac1);
    await insertLITPL_OAC2(db, list: getAll.oac2);
    await insertLITPL_OOAC(db, list: getAll.ooac);
    await insertLITPL_OADM(db, list: getAll.oadm);
    await insertITMP(db, list: getAll.itmp);
    await insertOUDAR(db, list: getAll.oudar);
    await insertBPMG(db, list: getAll.bpmg);
    // await insertOWHS(db, list: getAll.owhs);
    await insertOTRNS(db, list: getAll.otrns);
    await insertOUDA(db, list: getAll.ouda);
    await insertOCINP(db, list: getAll.ocinp);
    await insertOEJT(db, list: getAll.oejt);
    await insertOEPO(db, list: getAll.oepo);
    await insertOCDC(db, list: getAll.ocdc);
    await insertOTRM(db, list: getAll.otrm);
    await insertOPRF(db, list: getAll.oprf);
    // await insertPRF1(db, list: getAll.prf1);
    await insertSecondaryCalendar(db, list: getAll.secondaryCalendar);
    await insertSecondaryCalendarYears(db, list: getAll.secondaryCalendarYears);
  }
}
