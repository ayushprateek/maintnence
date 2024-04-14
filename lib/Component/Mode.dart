import 'package:maintenance/Component/LogFileFunctions.dart';
import 'package:maintenance/Sync/SyncModels/ORTU.dart';

class Mode {
  static Future<bool> isSelf(String controllerName) async {
    try {
      List<ORTUModel> list =
          await retrieveFormVisibilityData(ControllerName: controllerName);
      if (list.isEmpty) {
        return true;
      } else {
        return list[0].Company == false && list[0].Self == true;
      }
    } catch (e) {
      writeToLogFile(
          text: e.toString(),
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      return true;
    }
  }

  static Future<bool> isReadOnly(String controllerName) async {
    try {
      List<ORTUModel> list =
          await retrieveFormVisibilityData(ControllerName: controllerName);
      if (list.isEmpty) {
        return true;
      } else {
        return list[0].FullAuth == false && list[0].ReadOnly == true;
      }
    } catch (e) {
      writeToLogFile(
          text: e.toString(),
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      return true;
    }
  }

  static Future<bool> isCreate(String controllerName) async {
    try {
      List<ORTUModel> list =
          await retrieveFormVisibilityData(ControllerName: controllerName);
      if (list.isEmpty) {
        return true;
      } else {
        if (list[0].FullAuth == true) {
          return true;
        } else if (list[0].CreateAuth == true) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      writeToLogFile(
          text: e.toString(),
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      return true;
    }
  }

  static Future<bool> isEdit(String controllerName) async {
    try {
      List<ORTUModel> list =
          await retrieveFormVisibilityData(ControllerName: controllerName);
      if (list.isEmpty) {
        return true;
      } else {
        if (list[0].FullAuth == true) {
          return true;
        } else if (list[0].EditAuth == true) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      writeToLogFile(
          text: e.toString(),
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      return true;
    }
  }

  static Future<bool> isBranch(String controllerName) async {
    try {
      List<ORTUModel> list =
          await retrieveFormVisibilityData(ControllerName: controllerName);
      if (list.isEmpty) {
        return true;
      } else {
        return list[0].Company == false && list[0].BranchName == true;
      }
    } catch (e) {
      writeToLogFile(
          text: e.toString(),
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      return true;
    }
  }

  static Future<bool> isCompany(String controllerName) async {
    try {
      List<ORTUModel> list =
          await retrieveFormVisibilityData(ControllerName: controllerName);
      if (list.isEmpty) {
        return true;
      } else {
        return list[0].Company == true;
      }
    } catch (e) {
      writeToLogFile(
          text: e.toString(),
          fileName: StackTrace.current.toString(),
          lineNo: 141);
      return true;
    }
  }
}
