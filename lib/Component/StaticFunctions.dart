import 'package:maintenance/DatabaseInitialization.dart';
import 'package:maintenance/Sync/SyncModels/MNOTTP.dart';
import 'package:maintenance/Sync/SyncModels/MNTTP1.dart';
import 'package:sqflite/sqflite.dart';

class StaticFunctions {
  static Future<List<MNTTP1>> GetPairedEquipments(String inputValue) async {
    List<MNTTP1> MNTTP1s = [];
    // Get the latest MNOTTP record for the given EquipmentCode
    // MNOTTP mNOTTP = _db.MNOTTPs
    //     .Where(m => m.EquipmentCode == inputValue)
    //     .OrderByDescending(m => m.CreateDate)
    //     .FirstOrDefault();

    MNOTTP? mNOTTP;
    List<MNOTTP> mnotpList = await retrieveMNOTTPById(
        null, 'EquipmentCode = ?', [inputValue],
        orderBy: 'CreateDate DESC', limit: 1);
    if (mnotpList.isNotEmpty) {
      mNOTTP = mnotpList[0];
    }

    if (mNOTTP != null) {
      // Get the associated MNTTP1 records
      // MNTTP1s = _db.MNTTP1
      //     .Where(m => m.TransId == mNOTTP.TransId && m.
      //     StartDate < DateTime.Now && m.EndDate > DateTime.Now)
      //     .ToList();

      MNTTP1s =
          await retrieveMNTTP1ById(null, 'TransId = ? ', [mNOTTP.TransId]);
      MNTTP1s.removeWhere((e) => e.StartDate != null && e.EndDate != null
          ? e.StartDate!.isBefore(DateTime.now()) ||
              e.EndDate!.isAfter(DateTime.now())
          : true);
    }
    return MNTTP1s;
  }

  static Future<double> GetAvailableItemsFromOINM( String ItemCode, String WhsCode)async
  {
    Database db=await initializeDB(null);
    List l=await db.rawQuery('''
    SELECT 
   ( IFNULL(  (SELECT SUM(IFNULL(InQty,0)) FROM OINM WHERE ItemCode = '$ItemCode' AND WhsCode = '$WhsCode'), 0) - 
    IFNULL( (SELECT SUM(IFNULL(OutQty,0)) FROM OINM WHERE ItemCode = '$ItemCode' AND WhsCode = '$WhsCode'), 0 ) ) AS QuantityDifference

    ''');
    // here currency is not applicable becasue we are just getting the available items

    double availableItems = 0;
    if(l.isNotEmpty)
      {
        availableItems=double.tryParse(l[0]['QuantityDifference'].toString())??0;
      }

    return availableItems;
  }
}
