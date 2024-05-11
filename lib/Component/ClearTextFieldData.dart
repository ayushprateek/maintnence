import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/Attachments.dart'
    as checkListAttachments;
import 'package:maintenance/CheckListDocument/CheckListDetails/CheckListDetails.dart'
    as checkListDetails;
import 'package:maintenance/CheckListDocument/CheckListDetails/EditCheckList.dart'
    as editCheckList;
import 'package:maintenance/CheckListDocument/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/GeneralData.dart' as checkListDoc;
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetLastDocNum.dart';
import 'package:maintenance/Component/IsAvailableTransId.dart';

//---------------------------------JOB CARD IMPORTS
import 'package:maintenance/JobCard/GeneralData.dart' as jcdGenData;
import 'package:maintenance/JobCard/JobCard.dart';
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
    CheckListDocument.numOfTabs.value = 3;
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
    checkListDoc.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
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

class ClearJobCardDoc {
  static clearGeneralData() {
    jcdGenData.GeneralData.iD = '';
    jcdGenData.GeneralData.permanentTransId = '';
    jcdGenData.GeneralData.transId = '';
    jcdGenData.GeneralData.docEntry = '';
    jcdGenData.GeneralData.docNum = '';
    jcdGenData.GeneralData.canceled = '';
    jcdGenData.GeneralData.docStatus = 'Open';
    jcdGenData.GeneralData.approvalStatus = 'Pending';
    jcdGenData.GeneralData.checkListStatus = 'WIP';
    jcdGenData.GeneralData.objectCode = '';
    jcdGenData.GeneralData.equipmentCode = '';
    jcdGenData.GeneralData.equipmentName = '';
    jcdGenData.GeneralData.checkListCode = '';
    jcdGenData.GeneralData.checkListName = '';
    jcdGenData.GeneralData.workCenterCode = '';
    jcdGenData.GeneralData.workCenterName = '';
    jcdGenData.GeneralData.openDate = getFormattedDate(DateTime.now());
    jcdGenData.GeneralData.closeDate = getFormattedDate(DateTime.now());
    jcdGenData.GeneralData.postingDate = getFormattedDate(DateTime.now());
    jcdGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    jcdGenData.GeneralData.lastReadingDate = getFormattedDate(DateTime.now());
    jcdGenData.GeneralData.lastReading = '';
    jcdGenData.GeneralData.assignedUserCode = '';
    jcdGenData.GeneralData.assignedUserName = '';
    jcdGenData.GeneralData.mNJCTransId = '';
    jcdGenData.GeneralData.remarks = '';
    jcdGenData.GeneralData.createdBy = '';
    jcdGenData.GeneralData.updatedBy = '';
    jcdGenData.GeneralData.branchId = userModel.BranchId.toString();
    jcdGenData.GeneralData.createDate = '';
    jcdGenData.GeneralData.updateDate = '';

    jcdGenData.GeneralData.isConsumption = false;
    jcdGenData.GeneralData.isRequest = false;
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

goToNewJobCardDocument() async {
  await ClearJobCardDoc.clearGeneralData();
  ;

  getLastDocNum("MNJC", null).then((snapshot) async {
    int DocNum = snapshot[0].DocNumber - 1;

    do {
      DocNum += 1;
      jcdGenData.GeneralData.transId =
          DateTime.now().millisecondsSinceEpoch.toString() +
              "U0" +
              userModel.ID.toString() +
              "_" +
              snapshot[0].DocName +
              "/" +
              DocNum.toString();
    } while (await isMNCLTransIdAvailable(
        null, jcdGenData.GeneralData.transId ?? ""));
    print(jcdGenData.GeneralData.transId);

    Get.offAll(() => JobCard(0));
  });
}
