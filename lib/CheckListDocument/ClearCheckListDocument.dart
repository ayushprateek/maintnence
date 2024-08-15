import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/create/Attachments.dart'
    as checkListAttachments;
import 'package:maintenance/CheckListDocument/create/CheckListDetails/CheckListDetails.dart'
    as checkListCreateDetails;
import 'package:maintenance/CheckListDocument/create/CheckListDetails/EditCheckList.dart'
    as editCheckList;
import 'package:maintenance/CheckListDocument/create/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/create/GeneralData.dart'
    as createCheckListDoc;
import 'package:maintenance/CheckListDocument/edit/CheckListDetails/CheckListDetails.dart'
    as checkListEditDetails;
import 'package:maintenance/CheckListDocument/edit/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/edit/GeneralData.dart'
    as editCheckListDoc;
import 'package:maintenance/CheckListDocument/view/CheckListDetails/CheckListDetails.dart'
    as checkListViewDetails;
import 'package:maintenance/CheckListDocument/view/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/view/GeneralData.dart'
    as viewCheckListDoc;
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetLastDocNum.dart';
import 'package:maintenance/Component/IsAvailableTransId.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD1.dart';
import 'package:maintenance/Sync/SyncModels/MNOCLD.dart';
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
    createCheckListDoc.GeneralData.iD = '';
    createCheckListDoc.GeneralData.permanentTransId = '';
    createCheckListDoc.GeneralData.transId = '';
    createCheckListDoc.GeneralData.docEntry = '';
    createCheckListDoc.GeneralData.docNum = '';
    createCheckListDoc.GeneralData.canceled = '';
    createCheckListDoc.GeneralData.docStatus = 'Open';
    createCheckListDoc.GeneralData.approvalStatus = 'Pending';
    createCheckListDoc.GeneralData.checkListStatus = 'WIP';
    createCheckListDoc.GeneralData.tyreMaintenance = 'No';
    createCheckListDoc.GeneralData.objectCode = '';
    createCheckListDoc.GeneralData.equipmentCode = '';
    createCheckListDoc.GeneralData.equipmentName = '';
    createCheckListDoc.GeneralData.checkListCode = '';
    createCheckListDoc.GeneralData.checkListName = '';
    createCheckListDoc.GeneralData.workCenterCode = '';
    createCheckListDoc.GeneralData.workCenterName = '';
    createCheckListDoc.GeneralData.openDate = getFormattedDate(DateTime.now());
    createCheckListDoc.GeneralData.closeDate = getFormattedDate(DateTime.now());
    createCheckListDoc.GeneralData.postingDate =
        getFormattedDate(DateTime.now());
    createCheckListDoc.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    createCheckListDoc.GeneralData.lastReadingDate =
        getFormattedDate(DateTime.now());
    createCheckListDoc.GeneralData.lastReading = '';
    createCheckListDoc.GeneralData.assignedUserCode = '';
    createCheckListDoc.GeneralData.assignedUserName = '';
    createCheckListDoc.GeneralData.mNJCTransId = '';
    createCheckListDoc.GeneralData.remarks = '';
    createCheckListDoc.GeneralData.createdBy = '';
    createCheckListDoc.GeneralData.updatedBy = '';
    createCheckListDoc.GeneralData.branchId = '';
    createCheckListDoc.GeneralData.createDate =
        getFormattedDate(DateTime.now());
    createCheckListDoc.GeneralData.updateDate =
        getFormattedDate(DateTime.now());
    createCheckListDoc.GeneralData.currentReading = '';
    createCheckListDoc.GeneralData.isConsumption = false;
    createCheckListDoc.GeneralData.isRequest = false;
    createCheckListDoc.GeneralData.isSelected = false;
    createCheckListDoc.GeneralData.hasCreated = false;
    createCheckListDoc.GeneralData.hasUpdated = false;
  }

  static setCreateCheckListDocTextFields({required MNOCLD mnocld}) {
    CheckListDocument.numOfTabs.value = 3;
    createCheckListDoc.GeneralData.iD = mnocld.ID?.toString() ?? '0';
    createCheckListDoc.GeneralData.permanentTransId =
        mnocld.PermanentTransId ?? "";
    createCheckListDoc.GeneralData.transId = mnocld.TransId ?? '';
    createCheckListDoc.GeneralData.docEntry = mnocld.DocEntry?.toString() ?? '';
    createCheckListDoc.GeneralData.docNum = mnocld.DocNum ?? '';
    createCheckListDoc.GeneralData.canceled = mnocld.Canceled ?? '';
    createCheckListDoc.GeneralData.docStatus = mnocld.DocStatus ?? 'Open';
    createCheckListDoc.GeneralData.approvalStatus =
        mnocld.ApprovalStatus ?? 'Pending';
    createCheckListDoc.GeneralData.checkListStatus =
        mnocld.CheckListStatus ?? 'WIP';
    createCheckListDoc.GeneralData.tyreMaintenance = 'No';
    createCheckListDoc.GeneralData.objectCode = mnocld.ObjectCode ?? '';
    createCheckListDoc.GeneralData.equipmentCode = mnocld.EquipmentCode ?? '';
    createCheckListDoc.GeneralData.equipmentName = mnocld.EquipmentName ?? '';
    createCheckListDoc.GeneralData.checkListCode = mnocld.CheckListCode ?? '';
    createCheckListDoc.GeneralData.checkListName = mnocld.CheckListName ?? '';
    createCheckListDoc.GeneralData.workCenterCode = mnocld.WorkCenterCode ?? '';
    createCheckListDoc.GeneralData.workCenterName = mnocld.WorkCenterName ?? '';
    createCheckListDoc.GeneralData.openDate = getFormattedDate(mnocld.OpenDate);
    createCheckListDoc.GeneralData.closeDate =
        getFormattedDate(mnocld.CloseDate);
    createCheckListDoc.GeneralData.postingDate =
        getFormattedDate(mnocld.PostingDate);
    createCheckListDoc.GeneralData.validUntill =
        getFormattedDate(mnocld.ValidUntill);
    createCheckListDoc.GeneralData.lastReadingDate =
        getFormattedDate(mnocld.LastReadingDate);
    createCheckListDoc.GeneralData.lastReading = mnocld.LastReading ?? '';
    createCheckListDoc.GeneralData.assignedUserCode =
        mnocld.AssignedUserCode ?? '';
    createCheckListDoc.GeneralData.assignedUserName =
        mnocld.AssignedUserName ?? '';
    createCheckListDoc.GeneralData.mNJCTransId = mnocld.MNJCTransId ?? '';
    createCheckListDoc.GeneralData.remarks = mnocld.Remarks ?? '';
    createCheckListDoc.GeneralData.createdBy = mnocld.CreatedBy ?? '';
    createCheckListDoc.GeneralData.updatedBy = mnocld.UpdatedBy ?? '';
    createCheckListDoc.GeneralData.branchId = mnocld.BranchId ?? '';
    createCheckListDoc.GeneralData.createDate =
        getFormattedDate(mnocld.CreateDate);
    createCheckListDoc.GeneralData.updateDate =
        getFormattedDate(mnocld.UpdateDate);
    createCheckListDoc.GeneralData.currentReading = mnocld.CurrentReading ?? '';
    createCheckListDoc.GeneralData.isConsumption =
        mnocld.IsConsumption ?? false;
    createCheckListDoc.GeneralData.isRequest = mnocld.IsRequest ?? false;
    createCheckListDoc.GeneralData.isSelected = true;
    createCheckListDoc.GeneralData.hasCreated = mnocld.hasCreated;
    createCheckListDoc.GeneralData.hasUpdated = mnocld.hasUpdated;
  }

  static setViewCheckListDocTextFields({required MNOCLD mnocld}) {
    CheckListDocument.numOfTabs.value = 3;
    viewCheckListDoc.GeneralData.iD = mnocld.ID?.toString() ?? '0';
    viewCheckListDoc.GeneralData.permanentTransId =
        mnocld.PermanentTransId ?? "";
    viewCheckListDoc.GeneralData.transId = mnocld.TransId ?? '';
    viewCheckListDoc.GeneralData.docEntry = mnocld.DocEntry?.toString() ?? '';
    viewCheckListDoc.GeneralData.docNum = mnocld.DocNum ?? '';
    viewCheckListDoc.GeneralData.canceled = mnocld.Canceled ?? '';
    viewCheckListDoc.GeneralData.docStatus = mnocld.DocStatus ?? 'Open';
    viewCheckListDoc.GeneralData.approvalStatus =
        mnocld.ApprovalStatus ?? 'Pending';
    viewCheckListDoc.GeneralData.checkListStatus =
        mnocld.CheckListStatus ?? 'WIP';
    viewCheckListDoc.GeneralData.tyreMaintenance = 'No';
    viewCheckListDoc.GeneralData.objectCode = mnocld.ObjectCode ?? '';
    viewCheckListDoc.GeneralData.equipmentCode = mnocld.EquipmentCode ?? '';
    viewCheckListDoc.GeneralData.equipmentName = mnocld.EquipmentName ?? '';
    viewCheckListDoc.GeneralData.checkListCode = mnocld.CheckListCode ?? '';
    viewCheckListDoc.GeneralData.checkListName = mnocld.CheckListName ?? '';
    viewCheckListDoc.GeneralData.workCenterCode = mnocld.WorkCenterCode ?? '';
    viewCheckListDoc.GeneralData.workCenterName = mnocld.WorkCenterName ?? '';
    viewCheckListDoc.GeneralData.openDate = getFormattedDate(mnocld.OpenDate);
    viewCheckListDoc.GeneralData.closeDate = getFormattedDate(mnocld.CloseDate);
    viewCheckListDoc.GeneralData.postingDate =
        getFormattedDate(mnocld.PostingDate);
    viewCheckListDoc.GeneralData.validUntill =
        getFormattedDate(mnocld.ValidUntill);
    viewCheckListDoc.GeneralData.lastReadingDate =
        getFormattedDate(mnocld.LastReadingDate);
    viewCheckListDoc.GeneralData.lastReading = mnocld.LastReading ?? '';
    viewCheckListDoc.GeneralData.assignedUserCode =
        mnocld.AssignedUserCode ?? '';
    viewCheckListDoc.GeneralData.assignedUserName =
        mnocld.AssignedUserName ?? '';
    viewCheckListDoc.GeneralData.mNJCTransId = mnocld.MNJCTransId ?? '';
    viewCheckListDoc.GeneralData.remarks = mnocld.Remarks ?? '';
    viewCheckListDoc.GeneralData.createdBy = mnocld.CreatedBy ?? '';
    viewCheckListDoc.GeneralData.updatedBy = mnocld.UpdatedBy ?? '';
    viewCheckListDoc.GeneralData.branchId = mnocld.BranchId ?? '';
    viewCheckListDoc.GeneralData.createDate =
        getFormattedDate(mnocld.CreateDate);
    viewCheckListDoc.GeneralData.updateDate =
        getFormattedDate(mnocld.UpdateDate);
    viewCheckListDoc.GeneralData.currentReading = mnocld.CurrentReading ?? '';
    viewCheckListDoc.GeneralData.isConsumption = mnocld.IsConsumption ?? false;
    viewCheckListDoc.GeneralData.isRequest = mnocld.IsRequest ?? false;
    viewCheckListDoc.GeneralData.isSelected = true;
    viewCheckListDoc.GeneralData.hasCreated = mnocld.hasCreated;
    viewCheckListDoc.GeneralData.hasUpdated = mnocld.hasUpdated;
  }

  static setEditCheckListDocTextFields({required MNOCLD mnocld}) {
    CheckListDocument.numOfTabs.value = 3;
    editCheckListDoc.GeneralData.iD = mnocld.ID?.toString() ?? '0';
    editCheckListDoc.GeneralData.permanentTransId =
        mnocld.PermanentTransId ?? "";
    editCheckListDoc.GeneralData.transId = mnocld.TransId ?? '';
    editCheckListDoc.GeneralData.docEntry = mnocld.DocEntry?.toString() ?? '';
    editCheckListDoc.GeneralData.docNum = mnocld.DocNum ?? '';
    editCheckListDoc.GeneralData.canceled = mnocld.Canceled ?? '';
    editCheckListDoc.GeneralData.docStatus = mnocld.DocStatus ?? 'Open';
    editCheckListDoc.GeneralData.approvalStatus =
        mnocld.ApprovalStatus ?? 'Pending';
    editCheckListDoc.GeneralData.checkListStatus =
        mnocld.CheckListStatus ?? 'WIP';
    editCheckListDoc.GeneralData.tyreMaintenance = 'No';
    editCheckListDoc.GeneralData.objectCode = mnocld.ObjectCode ?? '';
    editCheckListDoc.GeneralData.equipmentCode = mnocld.EquipmentCode ?? '';
    editCheckListDoc.GeneralData.equipmentName = mnocld.EquipmentName ?? '';
    editCheckListDoc.GeneralData.checkListCode = mnocld.CheckListCode ?? '';
    editCheckListDoc.GeneralData.checkListName = mnocld.CheckListName ?? '';
    editCheckListDoc.GeneralData.workCenterCode = mnocld.WorkCenterCode ?? '';
    editCheckListDoc.GeneralData.workCenterName = mnocld.WorkCenterName ?? '';
    editCheckListDoc.GeneralData.openDate = getFormattedDate(mnocld.OpenDate);
    editCheckListDoc.GeneralData.closeDate = getFormattedDate(mnocld.CloseDate);
    editCheckListDoc.GeneralData.postingDate =
        getFormattedDate(mnocld.PostingDate);
    editCheckListDoc.GeneralData.validUntill =
        getFormattedDate(mnocld.ValidUntill);
    editCheckListDoc.GeneralData.lastReadingDate =
        getFormattedDate(mnocld.LastReadingDate);
    editCheckListDoc.GeneralData.lastReading = mnocld.LastReading ?? '';
    editCheckListDoc.GeneralData.assignedUserCode =
        mnocld.AssignedUserCode ?? '';
    editCheckListDoc.GeneralData.assignedUserName =
        mnocld.AssignedUserName ?? '';
    editCheckListDoc.GeneralData.mNJCTransId = mnocld.MNJCTransId ?? '';
    editCheckListDoc.GeneralData.remarks = mnocld.Remarks ?? '';
    editCheckListDoc.GeneralData.createdBy = mnocld.CreatedBy ?? '';
    editCheckListDoc.GeneralData.updatedBy = mnocld.UpdatedBy ?? '';
    editCheckListDoc.GeneralData.branchId = mnocld.BranchId ?? '';
    editCheckListDoc.GeneralData.createDate =
        getFormattedDate(mnocld.CreateDate);
    editCheckListDoc.GeneralData.updateDate =
        getFormattedDate(mnocld.UpdateDate);
    editCheckListDoc.GeneralData.currentReading = mnocld.CurrentReading ?? '';
    editCheckListDoc.GeneralData.isConsumption = mnocld.IsConsumption ?? false;
    editCheckListDoc.GeneralData.isRequest = mnocld.IsRequest ?? false;
    editCheckListDoc.GeneralData.isSelected = true;
    editCheckListDoc.GeneralData.hasCreated = mnocld.hasCreated;
    editCheckListDoc.GeneralData.hasUpdated = mnocld.hasUpdated;
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
  checkListCreateDetails.CheckListDetails.items.clear();

  getLastDocNum("MNCL", null).then((snapshot) async {
    int DocNum = snapshot[0].DocNumber - 1;

    do {
      DocNum += 1;
      createCheckListDoc.GeneralData.transId =
          DateTime.now().millisecondsSinceEpoch.toString() +
              "U0" +
              userModel.ID.toString() +
              "_" +
              snapshot[0].DocName +
              "/" +
              DocNum.toString();
    } while (await isMNCLTransIdAvailable(
        null, createCheckListDoc.GeneralData.transId ?? ""));
    print(createCheckListDoc.GeneralData.transId);

    Get.offAll(() => CheckListDocument(0));
  });
}

navigateToCheckListDocument(
    {required String TransId, required bool isView}) async {
  if (isView) {
    List<MNOCLD> list =
        await retrieveMNOCLDById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearCheckListDoc.setViewCheckListDocTextFields(mnocld: list[0]);
    }
    checkListViewDetails.CheckListDetails.items =
        await retrieveMNCLD1ById(null, 'TransId = ?', [TransId]);
    Get.offAll(() => ViewCheckListDocument(0));
  } else {
    List<MNOCLD> list =
        await retrieveMNOCLDById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearCheckListDoc.setEditCheckListDocTextFields(mnocld: list[0]);
    }
    checkListEditDetails.CheckListDetails.items =
        await retrieveMNCLD1ById(null, 'TransId = ?', [TransId]);
    Get.offAll(() => EditCheckListDocument(0));
  }
}
