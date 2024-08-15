import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Sync/SyncModels/OCIN.dart';

class CompanyDetails {
  static OCINModel? ocinModel;

  static loadCompanyDetails() async {
    try {
      ocinModel = (await retrieveOCIN(null))[0];
      dateFormat = ocinModel?.DateFormat ?? dateFormat;
    } catch (e) {
      // writeToLogFile(
      //     text: e.toString(), fileName: StackTrace.current.toString(), lineNo: 141);
    }
  }
}
