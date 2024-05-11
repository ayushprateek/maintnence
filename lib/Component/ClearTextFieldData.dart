import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/GeneralData.dart' as checkListDoc;
import 'package:maintenance/CheckListDocument/CheckListDetails/EditCheckList.dart'
    as editCheckList;
import 'package:maintenance/CheckListDocument/CheckListDetails/CheckListDetails.dart'
    as checkListDetails;
import 'package:maintenance/CheckListDocument/Attachments.dart'
    as checkListAttachments;
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetLastDocNum.dart';
import 'package:maintenance/Component/IsAvailableTransId.dart';
import 'package:maintenance/main.dart';

class ClearCheckListDoc {
  static clearEditCheckList() {
    editCheckList.EditCheckList.id = '';
    editCheckList.EditCheckList.description = '';
    editCheckList.EditCheckList.transId = '';
    editCheckList.EditCheckList.rowId = '';
    editCheckList.EditCheckList.itemCode = '';
    editCheckList.EditCheckList.itemName = '';
    editCheckList.EditCheckList.consumptionQty = '';
    editCheckList.EditCheckList.uomCode = '';
    editCheckList.EditCheckList.uomName = '';
    editCheckList.EditCheckList.supplierName = '';
    editCheckList.EditCheckList.supplierCode = '';
    editCheckList.EditCheckList.userRemarks = '';
    editCheckList.EditCheckList.requiredDate = '';
    editCheckList.EditCheckList.remark = '';
    editCheckList.EditCheckList.isChecked = false;
    editCheckList.EditCheckList.fromStock = false;
    editCheckList.EditCheckList.consumption = false;
    editCheckList.EditCheckList.request = false;
    editCheckList.EditCheckList.isUpdating = false;
  }

  static clearCheckListDocTextFields() {
    CheckListDocument.numOfTabs.value=3;
    checkListDoc.GeneralData.iD = '';
    checkListDoc.GeneralData.permanentTransId = '';
    checkListDoc.GeneralData.transId = '';
    checkListDoc.GeneralData.docEntry = '';
    checkListDoc.GeneralData.docNum = '';
    checkListDoc.GeneralData.canceled = '';
    checkListDoc.GeneralData.docStatus = 'Open';
    checkListDoc.GeneralData.approvalStatus = 'Pending';
    checkListDoc.GeneralData.checkListStatus = 'WIP';
    checkListDoc.GeneralData.tyreMaintenance = 'No';
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

  static clearCheckListAttachments() {
    checkListAttachments.Attachments.attachments.clear();
    checkListAttachments.Attachments.imageFile = null;
    checkListAttachments.Attachments.attachment = '';
    checkListAttachments.Attachments.docName = '';
    checkListAttachments.Attachments.rowId = '';
    checkListAttachments.Attachments.Remarks = '';
  }
}

goToNewCheckListDocument() async {
  await ClearCheckListDoc.clearCheckListDocTextFields();
  await ClearCheckListDoc.clearEditCheckList();
  await ClearCheckListDoc.clearCheckListAttachments();
  checkListDetails.CheckListDetails.items.clear();

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
