import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/GeneralData.dart' as checkListDoc;
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetLastDocNum.dart';
import 'package:maintenance/Component/IsAvailableTransId.dart';
import 'package:maintenance/main.dart';

clearCheckListDocTextFields() {
  checkListDoc.GeneralData.iD = '';
  checkListDoc.GeneralData.permanentTransId = '';
  checkListDoc.GeneralData.transId = '';
  checkListDoc.GeneralData.docEntry = '';
  checkListDoc.GeneralData.docNum = '';
  checkListDoc.GeneralData.canceled = '';
  checkListDoc.GeneralData.docStatus = 'Open';
  checkListDoc.GeneralData.approvalStatus = '';
  checkListDoc.GeneralData.checkListStatus = '';
  checkListDoc.GeneralData.objectCode = '';
  checkListDoc.GeneralData.equipmentCode = '';
  checkListDoc.GeneralData.equipmentName = '';
  checkListDoc.GeneralData.checkListCode = '';
  checkListDoc.GeneralData.checkListName = '';
  checkListDoc.GeneralData.workCenterCode = '';
  checkListDoc.GeneralData.workCenterName = '';
  checkListDoc.GeneralData.openDate = getFormattedDate(DateTime.now());
  checkListDoc.GeneralData.closeDate = getFormattedDate(DateTime.now());
  checkListDoc.GeneralData.postingDate = getFormattedDate(DateTime.now());
  checkListDoc.GeneralData.validUntill = getFormattedDate(DateTime.now());
  checkListDoc.GeneralData.lastReadingDate = getFormattedDate(DateTime.now());
  checkListDoc.GeneralData.lastReading = '';
  checkListDoc.GeneralData.assignedUserCode = '';
  checkListDoc.GeneralData.assignedUserName = '';
  checkListDoc.GeneralData.mNJCTransId = '';
  checkListDoc.GeneralData.remarks = '';
  checkListDoc.GeneralData.createdBy = '';
  checkListDoc.GeneralData.updatedBy = '';
  checkListDoc.GeneralData.branchId = '';
  checkListDoc.GeneralData.createDate = getFormattedDate(DateTime.now());
  checkListDoc.GeneralData.updateDate = getFormattedDate(DateTime.now());
  checkListDoc.GeneralData.currentReading = '';
  checkListDoc.GeneralData.isConsumption = false;
  checkListDoc.GeneralData.isRequest = false;
}

goToNewCheckListDocument() async {
  await clearCheckListDocTextFields();
  getLastDocNum("MNCL", null).then((snapshot) async {
    int DocNum = snapshot[0].DocNumber - 1;

    do {
      DocNum += 1;
      checkListDoc.GeneralData.transId =
          DateTime.now().millisecondsSinceEpoch.toString() +
              "U0" +
              userModel.ID.toString() +
              "_" +
              snapshot[0].DocName +
              "/" +
              DocNum.toString();
    } while (await isMNCLTransIdAvailable(
        null, checkListDoc.GeneralData.transId ?? ""));
    print(checkListDoc.GeneralData.transId);

    Get.offAll(() => CheckListDocument(0));
  });
}
