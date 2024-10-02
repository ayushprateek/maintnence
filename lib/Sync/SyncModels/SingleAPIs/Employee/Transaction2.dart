import 'package:maintenance/Sync/SyncModels/CRT1.dart';
import 'package:maintenance/Sync/SyncModels/ECP1.dart';
import 'package:maintenance/Sync/SyncModels/ORCT.dart';
import 'package:maintenance/Sync/SyncModels/OVUL.dart';
import 'package:maintenance/Sync/SyncModels/RCT1.dart';
import 'package:maintenance/Sync/SyncModels/SUISU1.dart';
import 'package:maintenance/Sync/SyncModels/SUOATE.dart';
import 'package:maintenance/Sync/SyncModels/SUOISU.dart';
import 'package:maintenance/Sync/SyncModels/SUOORGS.dart';
import 'package:maintenance/Sync/SyncModels/SUOPDT.dart';
import 'package:maintenance/Sync/SyncModels/SUOPRC.dart';
import 'package:maintenance/Sync/SyncModels/SUOPRM.dart';
import 'package:maintenance/Sync/SyncModels/SUOPRP.dart';
import 'package:maintenance/Sync/SyncModels/SUOPRU.dart';
import 'package:maintenance/Sync/SyncModels/SUOTSL.dart';
import 'package:maintenance/Sync/SyncModels/SUPRM1.dart';
import 'package:maintenance/Sync/SyncModels/SUPRP1.dart';
import 'package:maintenance/Sync/SyncModels/SUPRU1.dart';
import 'package:maintenance/Sync/SyncModels/VUL1.dart';

class Transaction2 {
  // static bool isFirstTimeSync = false;
  List<RCT1>? rct1;
  List<ORCT>? orct;
  List<ECP1>? ecp1;
  List<OVULModel>? ovul;
  List<VUL1Model>? vul1;
  List<CRT1>? crt1;

  // List<SUAOPC>? suaopc;
  // List<SUAPC1>? suapc1;
  List<SUISU1>? suisu1;
  List<SUOATE>? suoate;
  List<SUOISU>? suoisu;
  List<SUOORG>? suoorg;
  List<SUOPDT>? suopdt;
  List<SUOPRC>? suoprc;
  List<SUOPRM>? suoprm;
  List<SUOPRP>? suoprp;
  List<SUOPRU>? suopru;
  List<SUOTSL>? suotsl;
  List<SUPRM1>? suprm1;
  List<SUPRP1>? suprp1;
  List<SUPRU1>? supru1;

  Transaction2({
    this.rct1,
    this.orct,
    this.ecp1,
    this.ovul,
    this.vul1,
    this.crt1,
    // this.suaopc,
    // this.suapc1,
    this.suisu1,
    this.suoate,
    this.suoisu,
    this.suoorg,
    this.suopdt,
    this.suoprc,
    this.suoprm,
    this.suoprp,
    this.suopru,
    this.suotsl,
    this.suprm1,
    this.suprp1,
    this.supru1,
  });

  factory Transaction2.fromJson(Map json) => Transaction2(
        rct1: List<RCT1>.from(json["RCT1"].map((x) => RCT1.fromJson(x))),
        orct: List<ORCT>.from(json["ORCT"].map((x) => ORCT.fromJson(x))),
        ecp1: List<ECP1>.from(json["ECP1"].map((x) => ECP1.fromJson(x))),
        ovul: List<OVULModel>.from(
            json["OVUL"].map((x) => OVULModel.fromJson(x))),
        vul1: List<VUL1Model>.from(
            json["VUL1"].map((x) => VUL1Model.fromJson(x))),
        crt1: List<CRT1>.from(json["CRT1"].map((x) => CRT1.fromJson(x))),
        suoisu:
            List<SUOISU>.from(json["SUOISU"].map((x) => SUOISU.fromJson(x))),
        suisu1:
            List<SUISU1>.from(json["SUISU1"].map((x) => SUISU1.fromJson(x))),
        suotsl:
            List<SUOTSL>.from(json["SUOTSL"].map((x) => SUOTSL.fromJson(x))),
        // suaopc:
        //     List<SUAOPC>.from(json["SUAOPC"].map((x) => SUAOPC.fromJson(x))),
        // suapc1:
        //     List<SUAPC1>.from(json["SUAPC1"].map((x) => SUAPC1.fromJson(x))),
        suoate:
            List<SUOATE>.from(json["SUOATE"].map((x) => SUOATE.fromJson(x))),
        suoorg:
            List<SUOORG>.from(json["SUOORG"].map((x) => SUOORG.fromJson(x))),
        suopdt:
            List<SUOPDT>.from(json["SUOPDT"].map((x) => SUOPDT.fromJson(x))),
        suoprc:
            List<SUOPRC>.from(json["SUOPRC"].map((x) => SUOPRC.fromJson(x))),
        suoprm:
            List<SUOPRM>.from(json["SUOPRM"].map((x) => SUOPRM.fromJson(x))),
        suoprp:
            List<SUOPRP>.from(json["SUOPRP"].map((x) => SUOPRP.fromJson(x))),
        suopru:
            List<SUOPRU>.from(json["SUOPRU"].map((x) => SUOPRU.fromJson(x))),
        suprm1:
            List<SUPRM1>.from(json["SUPRM1"].map((x) => SUPRM1.fromJson(x))),
        suprp1:
            List<SUPRP1>.from(json["SUPRP1"].map((x) => SUPRP1.fromJson(x))),
        supru1:
            List<SUPRU1>.from(json["SUPRU1"].map((x) => SUPRU1.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "RCT1": List<dynamic>.from(rct1 ?? [].map((x) => x.toJson())),
        "ORCT": List<dynamic>.from(orct ?? [].map((x) => x.toJson())),
        "ECP1": List<dynamic>.from(ecp1 ?? [].map((x) => x.toJson())),
        "OVUL": List<dynamic>.from(ovul ?? [].map((x) => x.toJson())),
        "VUL1": List<dynamic>.from(vul1 ?? [].map((x) => x.toJson())),
        "CRT1": List<dynamic>.from(crt1 ?? [].map((x) => x.toJson())),
        "SUOISU": List<dynamic>.from(suoisu ?? [].map((x) => x.toJson())),
        "SUISU1": List<dynamic>.from(suisu1 ?? [].map((x) => x.toJson())),
        "SUOTSL": List<dynamic>.from(suotsl ?? [].map((x) => x.toJson())),
        // "SUAOPC": List<dynamic>.from(suaopc ?? [].map((x) => x.toJson())),
        // "SUAPC1": List<dynamic>.from(suapc1 ?? [].map((x) => x.toJson())),
        "SUOATE": List<dynamic>.from(suoate ?? [].map((x) => x.toJson())),
        "SUOORG": List<dynamic>.from(suoorg ?? [].map((x) => x.toJson())),
        "SUOPDT": List<dynamic>.from(suopdt ?? [].map((x) => x.toJson())),
        "SUOPRC": List<dynamic>.from(suoprc ?? [].map((x) => x.toJson())),
        "SUOPRM": List<dynamic>.from(suoprm ?? [].map((x) => x.toJson())),
        "SUOPRP": List<dynamic>.from(suoprp ?? [].map((x) => x.toJson())),
        "SUOPRU": List<dynamic>.from(suopru ?? [].map((x) => x.toJson())),
        "SUPRM1": List<dynamic>.from(suprm1 ?? [].map((x) => x.toJson())),
        "SUPRP1": List<dynamic>.from(suprp1 ?? [].map((x) => x.toJson())),
        "SUPRU1": List<dynamic>.from(supru1 ?? [].map((x) => x.toJson())),
      };

  //todo:
  // getTransaction2FromWeb(bool isFirstTimeSync)
  // async {
  //   if (isFirstTimeSync) {
  //     print("Syncing First Time");
  //   } else {
  //     print("Not Syncing First Time");
  //   }
  //   credentials = getCredentials();
  //   String encoded = stringToBase64.encode(credentials+secretKey);
  //   header = {
  //     'Authorization': 'Basic $encoded',
  //     "content-type": "application/json",
  //     "connection": "keep-alive"
  //   };
  //   bool isSuccess = false;
  //   late Transaction2 transactions;
  //   while (!isSuccess) {
  //     try {
  //       var res = await http.get(
  //           headers: header,
  //           Uri.parse(isFirstTimeSync
  //               ? prefix + "CompressedMaster/Transaction_2"
  //               : prefix + "CompressedMaster/Transaction_Date_2"));
  //       // print(res.body);
  //       // print(res.bodyBytes);
  //       final xxx = utf8.decode(res.bodyBytes);
  //       print(xxx);
  //       transactions = Transaction2.fromJson(jsonDecode(xxx));
  //       print(transactions.toJson());
  //       isSuccess = true;
  //     } catch (e) {
  //       writeToLogFile(
  //           text: e.toString(),
  //           fileName: StackTrace.current.toString(),
  //           lineNo: 141);
  //       print(e.toString());
  //       // getErrorSnackBar(e.toString());
  //     }
  //   }
  //
  //   Database db = await initializeDB(null);
  //   await insertRCT1(db, list: transactions.rct1);
  //   await insertORCT(db, list: transactions.orct);
  //   await insertECP1(db, list: transactions.ecp1);
  //   await insertOCRO(db, list: transactions.ocro);
  //   await insertOVUL(db, list: transactions.ovul);
  //   await insertVUL1(db, list: transactions.vul1);
  //   await insertCRT1(db, list: transactions.crt1);
  //   await insertSUOISU(db, list: transactions.suoisu);
  //   await insertSUISU1(db, list: transactions.suisu1);
  //   await insertSUOTSL(db, list: transactions.suotsl);
  //   // await insertSUAOPC(db, list: transactions.suaopc);
  //   // await insertSUAPC1(db, list: transactions.suapc1);
  //   await insertSUISU1(db, list: transactions.suisu1);
  //   await insertSUOATE(db, list: transactions.suoate);
  //   await insertSUOISU(db, list: transactions.suoisu);
  //   await insertSUOORG(db, list: transactions.suoorg);
  //   await insertSUOPDT(db, list: transactions.suopdt);
  //   await insertSUOPRC(db, list: transactions.suoprc);
  //   await insertSUOPRM(db, list: transactions.suoprm);
  //   await insertSUOPRP(db, list: transactions.suoprp);
  //   await insertSUOPRU(db, list: transactions.suopru);
  //   await insertSUOTSL(db, list: transactions.suotsl);
  //   await insertSUPRM1(db, list: transactions.suprm1);
  //   await insertSUPRP1(db, list: transactions.suprp1);
  //   await insertSUPRU1(db, list: transactions.supru1);
  // }

  getTransaction2FromWeb(bool isFirstTimeSync) async {}
}
