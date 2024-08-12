import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/create/Attachments.dart'
    as checkListAttachments;
import 'package:maintenance/CheckListDocument/create/CheckListDetails/CheckListDetails.dart'
    as checkListDetails;
import 'package:maintenance/CheckListDocument/create/CheckListDetails/EditCheckList.dart'
    as editCheckList;
import 'package:maintenance/CheckListDocument/create/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/create/GeneralData.dart'
    as createCheckListDoc;
import 'package:maintenance/CheckListDocument/edit/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/edit/GeneralData.dart'
    as editCheckListDoc;
import 'package:maintenance/CheckListDocument/view/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/view/GeneralData.dart'
    as viewCheckListDoc;
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetLastDocNum.dart';
import 'package:maintenance/Component/IsAvailableTransId.dart';
//------------------------------ GOODS ISSUE IMPORTS------------
import 'package:maintenance/GoodsIssue/create/GeneralData.dart' as goodsGenData;
import 'package:maintenance/GoodsIssue/create/GoodsIssue.dart';
import 'package:maintenance/GoodsIssue/create/ItemDetails/EditItems.dart'
    as goodsEditItems;
import 'package:maintenance/GoodsIssue/create/ItemDetails/ItemDetails.dart'
    as goodsItemDetails;
import 'package:maintenance/GoodsReceiptNote/Address/BillingAddress.dart'
    as grnBillAddress;
import 'package:maintenance/GoodsReceiptNote/Address/ShippingAddress.dart'
    as grnShipAddress;
//------------------------------ GOODS RECEIPT NOTES------------
import 'package:maintenance/GoodsReceiptNote/GeneralData.dart' as grnGenData;
import 'package:maintenance/GoodsReceiptNote/GoodsReceiptNote.dart';
import 'package:maintenance/GoodsReceiptNote/ItemDetails/ItemDetails.dart'
    as grnItemDetails;
//------------------------------ INTERNAL REQUEST------------
import 'package:maintenance/InternalRequest/GeneralData.dart'
    as internalGenData;
import 'package:maintenance/InternalRequest/InternalRequest.dart';
import 'package:maintenance/InternalRequest/ItemDetails/EditItems.dart'
    as internalEditItems;
import 'package:maintenance/InternalRequest/ItemDetails/ItemDetails.dart'
    as internalItemDetails;
//---------------------------------CREATE JOB CARD IMPORTS
import 'package:maintenance/JobCard/create/GeneralData.dart' as jcdCreateGenData;
import 'package:maintenance/JobCard/create/ItemDetails/EditJobCardItem.dart' as editCreateJCDItems;
import 'package:maintenance/JobCard/create/ItemDetails/ItemDetails.dart' as jcdCreateItemDetails;
import 'package:maintenance/JobCard/create/JobCard.dart';
import 'package:maintenance/JobCard/create/ServiceDetails/EditService.dart' as editCreateJCDService;
import 'package:maintenance/JobCard/create/ServiceDetails/ServiceDetails.dart' as jcdCreateServiceDetails;
import 'package:maintenance/JobCard/edit/JobCard.dart';

//---------------------------------VIEW JOB CARD IMPORTS
import 'package:maintenance/JobCard/view/GeneralData.dart' as jcdViewGenData;
import 'package:maintenance/JobCard/view/ItemDetails/EditJobCardItem.dart' as editViewJCDItems;
import 'package:maintenance/JobCard/view/ItemDetails/ItemDetails.dart' as jcdViewItemDetails;
import 'package:maintenance/JobCard/view/JobCard.dart';

import 'package:maintenance/JobCard/view/ServiceDetails/EditService.dart' as editViewJCDService;
import 'package:maintenance/JobCard/view/ServiceDetails/ServiceDetails.dart' as jcdViewServiceDetails;

//---------------------------------EDIT JOB CARD IMPORTS
import 'package:maintenance/JobCard/edit/GeneralData.dart' as jcdEditGenData;
import 'package:maintenance/JobCard/edit/ItemDetails/EditJobCardItem.dart' as editEditJCDItems;
import 'package:maintenance/JobCard/edit/ItemDetails/ItemDetails.dart' as jcdEditItemDetails;
import 'package:maintenance/JobCard/edit/ServiceDetails/EditService.dart' as editEditJCDService;
import 'package:maintenance/JobCard/edit/ServiceDetails/ServiceDetails.dart' as jcdEditServiceDetails;

//------------------------------ PURCHASE REQUEST IMPORTS------------
import 'package:maintenance/Purchase/PurchaseRequest/GeneralData.dart'
    as purchaseGenData;
import 'package:maintenance/Purchase/PurchaseRequest/ItemDetails/EditItems.dart'
    as grnEditItems;
import 'package:maintenance/Purchase/PurchaseRequest/ItemDetails/EditItems.dart'
    as purchaseEditItems;
import 'package:maintenance/Purchase/PurchaseRequest/ItemDetails/ItemDetails.dart'
    as purchaseItemDetails;
import 'package:maintenance/Purchase/PurchaseRequest/PurchaseRequest.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD1.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD1.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD2.dart';
import 'package:maintenance/Sync/SyncModels/MNOCLD.dart';
import 'package:maintenance/Sync/SyncModels/MNOJCD.dart';
import 'package:maintenance/Sync/SyncModels/PRITR1.dart';
import 'package:maintenance/Sync/SyncModels/PROITR.dart';
import 'package:maintenance/Sync/SyncModels/PROPDN.dart';
import 'package:maintenance/Sync/SyncModels/PROPRQ.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN1.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN2.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN3.dart';
import 'package:maintenance/Sync/SyncModels/PRPRQ1.dart';
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
  checkListDetails.CheckListDetails.items.clear();

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
    checkListDetails.CheckListDetails.items =
        await retrieveMNCLD1ById(null, 'TransId = ?', [TransId]);
    Get.offAll(() => ViewCheckListDocument(0));
  } else {
    List<MNOCLD> list =
        await retrieveMNOCLDById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearCheckListDoc.setEditCheckListDocTextFields(mnocld: list[0]);
    }
    Get.offAll(() => EditCheckListDocument(0));
  }
}

class ClearJobCardDoc {
  static clearGeneralData() {
    jcdCreateGenData.GeneralData.iD = '';
    jcdCreateGenData.GeneralData.permanentTransId = '';
    jcdCreateGenData.GeneralData.transId = '';
    jcdCreateGenData.GeneralData.docEntry = '';
    jcdCreateGenData.GeneralData.docNum = '';
    jcdCreateGenData.GeneralData.canceled = '';
    jcdCreateGenData.GeneralData.docStatus = 'Open';
    jcdCreateGenData.GeneralData.approvalStatus = 'Pending';
    jcdCreateGenData.GeneralData.checkListStatus = 'WIP';
    jcdCreateGenData.GeneralData.objectCode = '';
    jcdCreateGenData.GeneralData.equipmentCode = '';
    jcdCreateGenData.GeneralData.equipmentName = '';
    jcdCreateGenData.GeneralData.checkListCode = '';
    jcdCreateGenData.GeneralData.checkListName = '';
    jcdCreateGenData.GeneralData.workCenterCode = '';
    jcdCreateGenData.GeneralData.workCenterName = '';
    jcdCreateGenData.GeneralData.openDate = getFormattedDate(DateTime.now());
    jcdCreateGenData.GeneralData.closeDate = getFormattedDate(DateTime.now());
    jcdCreateGenData.GeneralData.postingDate = getFormattedDate(DateTime.now());
    jcdCreateGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    jcdCreateGenData.GeneralData.lastReadingDate = getFormattedDate(DateTime.now());
    jcdCreateGenData.GeneralData.lastReading = '';
    jcdCreateGenData.GeneralData.assignedUserCode = '';
    jcdCreateGenData.GeneralData.assignedUserName = '';
    jcdCreateGenData.GeneralData.mNJCTransId = '';
    jcdCreateGenData.GeneralData.remarks = '';
    jcdCreateGenData.GeneralData.createdBy = '';
    jcdCreateGenData.GeneralData.updatedBy = '';
    jcdCreateGenData.GeneralData.branchId = userModel.BranchId.toString();
    jcdCreateGenData.GeneralData.createDate = '';
    jcdCreateGenData.GeneralData.updateDate = '';

    jcdCreateGenData.GeneralData.isConsumption = false;
    jcdCreateGenData.GeneralData.isRequest = false;
    jcdCreateGenData.GeneralData.isSelected = false;
    jcdCreateGenData.GeneralData.hasCreated = false;
    jcdCreateGenData.GeneralData.hasUpdated = false;
    jcdCreateGenData.GeneralData.warranty = 'Yes';
    jcdCreateGenData.GeneralData.type = 'Preventive';
  }

  static setCreateJobCardData({required MNOJCD mnojcd}) {
    jcdCreateGenData.GeneralData.iD = mnojcd.ID?.toString() ?? '';
    jcdCreateGenData.GeneralData.permanentTransId = mnojcd.PermanentTransId ?? '';
    jcdCreateGenData.GeneralData.transId = mnojcd.TransId ?? '';
    jcdCreateGenData.GeneralData.docEntry = mnojcd.DocEntry?.toString() ?? '';
    jcdCreateGenData.GeneralData.docNum = mnojcd.DocNum?.toString() ?? '';
    jcdCreateGenData.GeneralData.canceled = mnojcd.Canceled ?? '';
    jcdCreateGenData.GeneralData.docStatus = mnojcd.DocStatus ?? 'Open';
    jcdCreateGenData.GeneralData.approvalStatus = mnojcd.ApprovalStatus ?? 'Pending';
    //todo: SET CHECK LIST STATUS
    jcdCreateGenData.GeneralData.checkListStatus = 'WIP';
    jcdCreateGenData.GeneralData.objectCode = mnojcd.ObjectCode ?? '';
    jcdCreateGenData.GeneralData.equipmentCode = mnojcd.EquipmentCode ?? '';
    jcdCreateGenData.GeneralData.equipmentName = mnojcd.EquipmentName ?? '';
    jcdCreateGenData.GeneralData.checkListCode = mnojcd.CheckListCode ?? '';
    jcdCreateGenData.GeneralData.checkListName = mnojcd.CheckListName ?? '';
    jcdCreateGenData.GeneralData.workCenterCode = mnojcd.WorkCenterCode ?? '';
    jcdCreateGenData.GeneralData.workCenterName = mnojcd.WorkCenterName ?? '';
    jcdCreateGenData.GeneralData.openDate = getFormattedDate(mnojcd.OpenDate);
    jcdCreateGenData.GeneralData.closeDate = getFormattedDate(mnojcd.CloseDate);
    jcdCreateGenData.GeneralData.postingDate = getFormattedDate(mnojcd.PostingDate);
    jcdCreateGenData.GeneralData.validUntill = getFormattedDate(mnojcd.ValidUntill);
    jcdCreateGenData.GeneralData.lastReadingDate =
        getFormattedDate(mnojcd.LastReading);
    // jcdGenData.GeneralData.lastReading = mnojcd.LastReading??'';
    jcdCreateGenData.GeneralData.assignedUserCode = mnojcd.AssignedUserCode ?? '';
    jcdCreateGenData.GeneralData.assignedUserName = mnojcd.AssignedUserName ?? '';
    // jcdGenData.GeneralData.mNJCTransId = mnojcd.MNJ??'';
    jcdCreateGenData.GeneralData.remarks = mnojcd.Remarks ?? '';
    jcdCreateGenData.GeneralData.createdBy = mnojcd.CreatedBy ?? '';
    jcdCreateGenData.GeneralData.updatedBy = mnojcd.UpdatedBy ?? '';
    jcdCreateGenData.GeneralData.branchId = mnojcd.BranchId ?? '';
    jcdCreateGenData.GeneralData.createDate = getFormattedDate(mnojcd.CreateDate);
    jcdCreateGenData.GeneralData.updateDate = getFormattedDate(mnojcd.UpdateDate);

    jcdCreateGenData.GeneralData.isConsumption = mnojcd.IsConsumption ?? false;
    jcdCreateGenData.GeneralData.isRequest = mnojcd.IsRequest ?? false;
    jcdCreateGenData.GeneralData.isSelected = true;
    jcdCreateGenData.GeneralData.hasCreated = mnojcd.hasCreated;
    jcdCreateGenData.GeneralData.hasUpdated = mnojcd.hasUpdated;
    jcdCreateGenData.GeneralData.warranty =
        mnojcd.WarrentyApplicable == true ? 'Yes' : 'No';
    jcdCreateGenData.GeneralData.type = mnojcd.Type ?? 'Preventive';
    if (mnojcd.Type == 'True') {
      jcdCreateGenData.GeneralData.type = 'Preventive';
    } else if (mnojcd.Type == 'False') {
      jcdCreateGenData.GeneralData.type = 'Breakdown';
    }
  }
  static setViewJobCardData({required MNOJCD mnojcd}) {
    jcdViewGenData.GeneralData.iD = mnojcd.ID?.toString() ?? '';
    jcdViewGenData.GeneralData.permanentTransId = mnojcd.PermanentTransId ?? '';
    jcdViewGenData.GeneralData.transId = mnojcd.TransId ?? '';
    jcdViewGenData.GeneralData.docEntry = mnojcd.DocEntry?.toString() ?? '';
    jcdViewGenData.GeneralData.docNum = mnojcd.DocNum?.toString() ?? '';
    jcdViewGenData.GeneralData.canceled = mnojcd.Canceled ?? '';
    jcdViewGenData.GeneralData.docStatus = mnojcd.DocStatus ?? 'Open';
    jcdViewGenData.GeneralData.approvalStatus = mnojcd.ApprovalStatus ?? 'Pending';
    //todo: SET CHECK LIST STATUS
    jcdViewGenData.GeneralData.checkListStatus = 'WIP';
    jcdViewGenData.GeneralData.objectCode = mnojcd.ObjectCode ?? '';
    jcdViewGenData.GeneralData.equipmentCode = mnojcd.EquipmentCode ?? '';
    jcdViewGenData.GeneralData.equipmentName = mnojcd.EquipmentName ?? '';
    jcdViewGenData.GeneralData.checkListCode = mnojcd.CheckListCode ?? '';
    jcdViewGenData.GeneralData.checkListName = mnojcd.CheckListName ?? '';
    jcdViewGenData.GeneralData.workCenterCode = mnojcd.WorkCenterCode ?? '';
    jcdViewGenData.GeneralData.workCenterName = mnojcd.WorkCenterName ?? '';
    jcdViewGenData.GeneralData.openDate = getFormattedDate(mnojcd.OpenDate);
    jcdViewGenData.GeneralData.closeDate = getFormattedDate(mnojcd.CloseDate);
    jcdViewGenData.GeneralData.postingDate = getFormattedDate(mnojcd.PostingDate);
    jcdViewGenData.GeneralData.validUntill = getFormattedDate(mnojcd.ValidUntill);
    jcdViewGenData.GeneralData.lastReadingDate =
        getFormattedDate(mnojcd.LastReading);
    // jcdGenData.GeneralData.lastReading = mnojcd.LastReading??'';
    jcdViewGenData.GeneralData.assignedUserCode = mnojcd.AssignedUserCode ?? '';
    jcdViewGenData.GeneralData.assignedUserName = mnojcd.AssignedUserName ?? '';
    // jcdGenData.GeneralData.mNJCTransId = mnojcd.MNJ??'';
    jcdViewGenData.GeneralData.remarks = mnojcd.Remarks ?? '';
    jcdViewGenData.GeneralData.createdBy = mnojcd.CreatedBy ?? '';
    jcdViewGenData.GeneralData.updatedBy = mnojcd.UpdatedBy ?? '';
    jcdViewGenData.GeneralData.branchId = mnojcd.BranchId ?? '';
    jcdViewGenData.GeneralData.createDate = getFormattedDate(mnojcd.CreateDate);
    jcdViewGenData.GeneralData.updateDate = getFormattedDate(mnojcd.UpdateDate);

    jcdViewGenData.GeneralData.isConsumption = mnojcd.IsConsumption ?? false;
    jcdViewGenData.GeneralData.isRequest = mnojcd.IsRequest ?? false;
    jcdViewGenData.GeneralData.isSelected = true;
    jcdViewGenData.GeneralData.hasCreated = mnojcd.hasCreated;
    jcdViewGenData.GeneralData.hasUpdated = mnojcd.hasUpdated;
    jcdViewGenData.GeneralData.warranty =
        mnojcd.WarrentyApplicable == true ? 'Yes' : 'No';
    jcdViewGenData.GeneralData.type = mnojcd.Type ?? 'Preventive';
    if (mnojcd.Type == 'True') {
      jcdViewGenData.GeneralData.type = 'Preventive';
    } else if (mnojcd.Type == 'False') {
      jcdViewGenData.GeneralData.type = 'Breakdown';
    }
  }
  static setEditJobCardData({required MNOJCD mnojcd}) {
    jcdEditGenData.GeneralData.iD = mnojcd.ID?.toString() ?? '';
    jcdEditGenData.GeneralData.permanentTransId = mnojcd.PermanentTransId ?? '';
    jcdEditGenData.GeneralData.transId = mnojcd.TransId ?? '';
    jcdEditGenData.GeneralData.docEntry = mnojcd.DocEntry?.toString() ?? '';
    jcdEditGenData.GeneralData.docNum = mnojcd.DocNum?.toString() ?? '';
    jcdEditGenData.GeneralData.canceled = mnojcd.Canceled ?? '';
    jcdEditGenData.GeneralData.docStatus = mnojcd.DocStatus ?? 'Open';
    jcdEditGenData.GeneralData.approvalStatus = mnojcd.ApprovalStatus ?? 'Pending';
    //todo: SET CHECK LIST STATUS
    jcdEditGenData.GeneralData.checkListStatus = 'WIP';
    jcdEditGenData.GeneralData.objectCode = mnojcd.ObjectCode ?? '';
    jcdEditGenData.GeneralData.equipmentCode = mnojcd.EquipmentCode ?? '';
    jcdEditGenData.GeneralData.equipmentName = mnojcd.EquipmentName ?? '';
    jcdEditGenData.GeneralData.checkListCode = mnojcd.CheckListCode ?? '';
    jcdEditGenData.GeneralData.checkListName = mnojcd.CheckListName ?? '';
    jcdEditGenData.GeneralData.workCenterCode = mnojcd.WorkCenterCode ?? '';
    jcdEditGenData.GeneralData.workCenterName = mnojcd.WorkCenterName ?? '';
    jcdEditGenData.GeneralData.openDate = getFormattedDate(mnojcd.OpenDate);
    jcdEditGenData.GeneralData.closeDate = getFormattedDate(mnojcd.CloseDate);
    jcdEditGenData.GeneralData.postingDate = getFormattedDate(mnojcd.PostingDate);
    jcdEditGenData.GeneralData.validUntill = getFormattedDate(mnojcd.ValidUntill);
    jcdEditGenData.GeneralData.lastReadingDate =
        getFormattedDate(mnojcd.LastReading);
    // jcdGenData.GeneralData.lastReading = mnojcd.LastReading??'';
    jcdEditGenData.GeneralData.assignedUserCode = mnojcd.AssignedUserCode ?? '';
    jcdEditGenData.GeneralData.assignedUserName = mnojcd.AssignedUserName ?? '';
    // jcdGenData.GeneralData.mNJCTransId = mnojcd.MNJ??'';
    jcdEditGenData.GeneralData.remarks = mnojcd.Remarks ?? '';
    jcdEditGenData.GeneralData.createdBy = mnojcd.CreatedBy ?? '';
    jcdEditGenData.GeneralData.updatedBy = mnojcd.UpdatedBy ?? '';
    jcdEditGenData.GeneralData.branchId = mnojcd.BranchId ?? '';
    jcdEditGenData.GeneralData.createDate = getFormattedDate(mnojcd.CreateDate);
    jcdEditGenData.GeneralData.updateDate = getFormattedDate(mnojcd.UpdateDate);

    jcdEditGenData.GeneralData.isConsumption = mnojcd.IsConsumption ?? false;
    jcdEditGenData.GeneralData.isRequest = mnojcd.IsRequest ?? false;
    jcdEditGenData.GeneralData.isSelected = true;
    jcdEditGenData.GeneralData.hasCreated = mnojcd.hasCreated;
    jcdEditGenData.GeneralData.hasUpdated = mnojcd.hasUpdated;
    jcdEditGenData.GeneralData.warranty =
        mnojcd.WarrentyApplicable == true ? 'Yes' : 'No';
    jcdEditGenData.GeneralData.type = mnojcd.Type ?? 'Preventive';
    if (mnojcd.Type == 'True') {
      jcdEditGenData.GeneralData.type = 'Preventive';
    } else if (mnojcd.Type == 'False') {
      jcdEditGenData.GeneralData.type = 'Breakdown';
    }
  }

  static clearEditItems() {
    editCreateJCDItems.EditJobCardItem.id = '';
    editCreateJCDItems.EditJobCardItem.transId = '';
    editCreateJCDItems.EditJobCardItem.rowId = '';
    editCreateJCDItems.EditJobCardItem.itemCode = '';
    editCreateJCDItems.EditJobCardItem.itemName = '';
    editCreateJCDItems.EditJobCardItem.quantity = '';
    editCreateJCDItems.EditJobCardItem.uomCode = '';
    editCreateJCDItems.EditJobCardItem.uomName = '';
    editCreateJCDItems.EditJobCardItem.supplierName = '';
    editCreateJCDItems.EditJobCardItem.supplierCode = '';
    editCreateJCDItems.EditJobCardItem.requiredDate = '';
    editCreateJCDItems.EditJobCardItem.isChecked = false;
    editCreateJCDItems.EditJobCardItem.fromStock = false;
    editCreateJCDItems.EditJobCardItem.consumption = false;
    editCreateJCDItems.EditJobCardItem.request = false;
    editCreateJCDItems.EditJobCardItem.isUpdating = false;
  }

  static clearEditService() {
    editCreateJCDService.EditService.id = '';
    editCreateJCDService.EditService.transId = '';
    editCreateJCDService.EditService.rowId = '';
    editCreateJCDService.EditService.serviceCode = '';
    editCreateJCDService.EditService.serviceName = '';
    editCreateJCDService.EditService.infoPrice = '';
    editCreateJCDService.EditService.supplierName = '';
    editCreateJCDService.EditService.supplierCode = '';
    editCreateJCDService.EditService.isUpdating = false;
    editCreateJCDService.EditService.isSendable = false;
  }
}

goToNewJobCardDocument() async {
  await ClearJobCardDoc.clearGeneralData();
  jcdCreateItemDetails.ItemDetails.items.clear();
  jcdCreateServiceDetails.ServiceDetails.items.clear();
  getLastDocNum("MNJC", null).then((snapshot) async {
    int DocNum = snapshot[0].DocNumber - 1;

    do {
      DocNum += 1;
      jcdCreateGenData.GeneralData.transId =
          DateTime.now().millisecondsSinceEpoch.toString() +
              "U0" +
              userModel.ID.toString() +
              "_" +
              snapshot[0].DocName +
              "/" +
              DocNum.toString();
    } while (await isMNCLTransIdAvailable(
        null, jcdCreateGenData.GeneralData.transId ?? ""));
    print(jcdCreateGenData.GeneralData.transId);

    Get.offAll(() => JobCard(0));
  });
}

navigateToJobCardDocument({required String TransId,
required bool isView}) async {
  if(isView)
    {
      List<MNOJCD> list = await retrieveMNOJCDById(null, 'TransId = ?', [TransId]);
      if (list.isNotEmpty) {
        ClearJobCardDoc.setViewJobCardData(mnojcd: list[0]);
      }
      jcdCreateItemDetails.ItemDetails.items =
      await retrieveMNJCD1ById(null, 'TransId = ?', [TransId]);
      jcdCreateServiceDetails.ServiceDetails.items =
      await retrieveMNJCD2ById(null, 'TransId = ?', [TransId]);

      Get.offAll(() => ViewJobCard(0));
    }
  else{
    List<MNOJCD> list = await retrieveMNOJCDById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearJobCardDoc.setEditJobCardData(mnojcd: list[0]);
    }
    jcdCreateItemDetails.ItemDetails.items =
    await retrieveMNJCD1ById(null, 'TransId = ?', [TransId]);
    jcdCreateServiceDetails.ServiceDetails.items =
    await retrieveMNJCD2ById(null, 'TransId = ?', [TransId]);

    Get.offAll(() => EditJobCard(0));
  }
  
}

class ClearGoodsIssueDocument {
  static clearGeneralDataTextFields() {
    goodsGenData.GeneralData.iD = '';
    goodsGenData.GeneralData.transId = '';
    goodsGenData.GeneralData.priceListCode = '';
    goodsGenData.GeneralData.requestedCode = '';
    goodsGenData.GeneralData.requestedName = '';
    goodsGenData.GeneralData.refNo = '';
    goodsGenData.GeneralData.mobileNo = '';
    goodsGenData.GeneralData.postingDate = getFormattedDate(DateTime.now());
    goodsGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    goodsGenData.GeneralData.currency = userModel.Currency;
    goodsGenData.GeneralData.currRate = userModel.Rate;
    goodsGenData.GeneralData.approvalStatus = 'Pending';
    goodsGenData.GeneralData.docStatus = 'Open';
    goodsGenData.GeneralData.totBDisc = '';
    goodsGenData.GeneralData.discPer = '';
    goodsGenData.GeneralData.discVal = '';
    goodsGenData.GeneralData.taxVal = '';
    goodsGenData.GeneralData.docTotal = '';
    goodsGenData.GeneralData.permanentTransId = '';
    goodsGenData.GeneralData.docEntry = '';
    goodsGenData.GeneralData.docNum = '';
    goodsGenData.GeneralData.createdBy = '';
    goodsGenData.GeneralData.createDate = getFormattedDate(DateTime.now());
    goodsGenData.GeneralData.updateDate =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    goodsGenData.GeneralData.approvedBy = '';
    goodsGenData.GeneralData.error = '';
    goodsGenData.GeneralData.isPosted = false;
    goodsGenData.GeneralData.draftKey = '';
    goodsGenData.GeneralData.latitude = '';
    goodsGenData.GeneralData.longitude = '';
    goodsGenData.GeneralData.objectCode = '';
    goodsGenData.GeneralData.toWhsCode = '';
    goodsGenData.GeneralData.remarks = '';
    goodsGenData.GeneralData.branchId = '';
    goodsGenData.GeneralData.updatedBy = '';
    goodsGenData.GeneralData.postingAddress = '';
    goodsGenData.GeneralData.tripTransId = '';
    goodsGenData.GeneralData.deptCode = '';
    goodsGenData.GeneralData.deptName = '';
    goodsGenData.GeneralData.isSelected = false;
    goodsGenData.GeneralData.hasCreated = false;
    goodsGenData.GeneralData.hasUpdated = false;
  }

  static clearEditItems() {
    goodsEditItems.EditItems.id = '';
    goodsEditItems.EditItems.truckNo = '';
    goodsEditItems.EditItems.toWhsCode = '';
    goodsEditItems.EditItems.toWhsName = '';
    goodsEditItems.EditItems.driverCode = '';
    goodsEditItems.EditItems.driverName = '';
    goodsEditItems.EditItems.routeCode = '';
    goodsEditItems.EditItems.routeName = '';
    goodsEditItems.EditItems.transId = '';
    goodsEditItems.EditItems.rowId = '';
    goodsEditItems.EditItems.itemCode = '';
    goodsEditItems.EditItems.itemName = '';
    goodsEditItems.EditItems.consumptionQty = '';
    goodsEditItems.EditItems.uomCode = '';
    goodsEditItems.EditItems.uomName = '';
    goodsEditItems.EditItems.deptCode = '';
    goodsEditItems.EditItems.deptName = '';
    goodsEditItems.EditItems.price = '';
    goodsEditItems.EditItems.mtv = '';
    goodsEditItems.EditItems.taxCode = '';
    goodsEditItems.EditItems.taxRate = '';
    goodsEditItems.EditItems.lineDiscount = '';
    goodsEditItems.EditItems.lineTotal = '';
    goodsEditItems.EditItems.isUpdating = false;
  }
}

goToNewGoodsIssueDocument() async {
  await ClearGoodsIssueDocument.clearGeneralDataTextFields();
  await ClearGoodsIssueDocument.clearEditItems();
  goodsItemDetails.ItemDetails.items.clear();

  getLastDocNum("MNGI", null).then((snapshot) async {
    int DocNum = snapshot[0].DocNumber - 1;

    do {
      DocNum += 1;
      goodsGenData.GeneralData.transId =
          DateTime.now().millisecondsSinceEpoch.toString() +
              "U0" +
              userModel.ID.toString() +
              "_" +
              snapshot[0].DocName +
              "/" +
              DocNum.toString();
    } while (await isMNCLTransIdAvailable(
        null, goodsGenData.GeneralData.transId ?? ""));
    print(goodsGenData.GeneralData.transId);

    Get.offAll(() => GoodsIssue(0));
  });
}

class ClearPurchaseRequestDocument {
  static clearGeneralDataTextFields() {
    purchaseGenData.GeneralData.iD = '';
    purchaseGenData.GeneralData.transId = '';
    purchaseGenData.GeneralData.refNo = '';
    purchaseGenData.GeneralData.mobileNo = '';
    purchaseGenData.GeneralData.postingDate = getFormattedDate(DateTime.now());
    purchaseGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    purchaseGenData.GeneralData.approvalStatus = 'Pending';
    purchaseGenData.GeneralData.docStatus = 'Open';
    purchaseGenData.GeneralData.permanentTransId = '';
    purchaseGenData.GeneralData.docEntry = '';
    purchaseGenData.GeneralData.docNum = '';
    purchaseGenData.GeneralData.createdBy = '';
    purchaseGenData.GeneralData.createDate = '';
    purchaseGenData.GeneralData.updateDate = '';
    purchaseGenData.GeneralData.approvedBy = '';
    purchaseGenData.GeneralData.error = '';
    purchaseGenData.GeneralData.isSelected = false;
    purchaseGenData.GeneralData.hasCreated = false;
    purchaseGenData.GeneralData.hasUpdated = false;
    purchaseGenData.GeneralData.isPosted = false;
    purchaseGenData.GeneralData.draftKey = '';
    purchaseGenData.GeneralData.latitude = '';
    purchaseGenData.GeneralData.longitude = '';
    purchaseGenData.GeneralData.objectCode = '';
    purchaseGenData.GeneralData.whsCode = '';
    purchaseGenData.GeneralData.remarks = '';
    purchaseGenData.GeneralData.branchId = '';
    purchaseGenData.GeneralData.updatedBy = '';
    purchaseGenData.GeneralData.postingAddress = '';
    purchaseGenData.GeneralData.tripTransId = '';
    purchaseGenData.GeneralData.deptCode = '';
    purchaseGenData.GeneralData.deptName = '';
    purchaseGenData.GeneralData.requestedCode = '';
    purchaseGenData.GeneralData.requestedName = '';

    purchaseGenData.GeneralData.isPosted = false;
    purchaseGenData.GeneralData.isConsumption = false;
    purchaseGenData.GeneralData.isRequest = false;
  }

  static setGeneralDataTextFields({required PROPRQ data}) {
    purchaseGenData.GeneralData.iD = data.ID?.toString() ?? '';
    purchaseGenData.GeneralData.transId = data.TransId ?? '';
    purchaseGenData.GeneralData.refNo = data.RefNo ?? '';
    purchaseGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    purchaseGenData.GeneralData.postingDate =
        getFormattedDate(data.PostingDate);
    purchaseGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    purchaseGenData.GeneralData.approvalStatus =
        data.ApprovalStatus ?? 'Pending';
    purchaseGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    purchaseGenData.GeneralData.permanentTransId = data.PermanentTransId ?? '';
    purchaseGenData.GeneralData.docEntry = data.DocEntry?.toString() ?? '';
    purchaseGenData.GeneralData.docNum = data.DocNum ?? '';
    purchaseGenData.GeneralData.createdBy = data.CreatedBy ?? '';
    // purchaseGenData.GeneralData.createDate = getFormattedDate(data.CreateDate);
    // purchaseGenData.GeneralData.updateDate = data.TransId??'';
    purchaseGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    purchaseGenData.GeneralData.error = data.Error ?? '';
    purchaseGenData.GeneralData.isSelected = true;
    purchaseGenData.GeneralData.hasCreated = data.hasCreated;
    purchaseGenData.GeneralData.hasUpdated = data.hasUpdated;
    purchaseGenData.GeneralData.isPosted = data.IsPosted ?? false;
    purchaseGenData.GeneralData.draftKey = data.DraftKey ?? '';
    purchaseGenData.GeneralData.latitude = data.Latitude ?? '';
    purchaseGenData.GeneralData.longitude = data.Longitude ?? '';
    purchaseGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    purchaseGenData.GeneralData.whsCode = data.WhsCode ?? '';
    purchaseGenData.GeneralData.remarks = data.Remarks ?? '';
    purchaseGenData.GeneralData.branchId = data.BranchId ?? '';
    purchaseGenData.GeneralData.updatedBy = data.UpdatedBy ?? '';
    purchaseGenData.GeneralData.postingAddress = data.PostingAddress ?? '';
    purchaseGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    purchaseGenData.GeneralData.deptCode = data.DeptCode ?? '';
    purchaseGenData.GeneralData.deptName = data.DeptName ?? '';
    purchaseGenData.GeneralData.requestedCode = data.RequestedCode ?? '';
    purchaseGenData.GeneralData.requestedName = data.RequestedName ?? '';

    purchaseGenData.GeneralData.isPosted = data.IsPosted ?? false;
  }

  static clearEditItems() {
    purchaseEditItems.EditItems.id = '';
    purchaseEditItems.EditItems.tripTransId = '';
    purchaseEditItems.EditItems.supplierCode = '';
    purchaseEditItems.EditItems.supplierName = '';
    purchaseEditItems.EditItems.truckNo = '';
    purchaseEditItems.EditItems.toWhsCode = '';
    purchaseEditItems.EditItems.toWhsName = '';
    purchaseEditItems.EditItems.driverCode = '';
    purchaseEditItems.EditItems.driverName = '';
    purchaseEditItems.EditItems.routeCode = '';
    purchaseEditItems.EditItems.routeName = '';
    purchaseEditItems.EditItems.transId = '';
    purchaseEditItems.EditItems.rowId = '';
    purchaseEditItems.EditItems.itemCode = '';
    purchaseEditItems.EditItems.itemName = '';
    purchaseEditItems.EditItems.consumptionQty = '';
    purchaseEditItems.EditItems.uomCode = '';
    purchaseEditItems.EditItems.uomName = '';
    purchaseEditItems.EditItems.deptCode = '';
    purchaseEditItems.EditItems.deptName = '';
    purchaseEditItems.EditItems.price = '';
    purchaseEditItems.EditItems.mtv = '';
    purchaseEditItems.EditItems.taxCode = '';
    purchaseEditItems.EditItems.taxRate = '';
    purchaseEditItems.EditItems.lineDiscount = '';
    purchaseEditItems.EditItems.lineTotal = '';
    purchaseEditItems.EditItems.isUpdating = false;
    purchaseEditItems.EditItems.isInserted = false;
  }
}

goToNewPurchaseRequestDocument() async {
  await ClearPurchaseRequestDocument.clearGeneralDataTextFields();
  await ClearPurchaseRequestDocument.clearEditItems();
  purchaseItemDetails.ItemDetails.items.clear();

  getLastDocNum("PR", null).then((snapshot) async {
    int DocNum = snapshot[0].DocNumber - 1;

    do {
      DocNum += 1;
      purchaseGenData.GeneralData.transId =
          DateTime.now().millisecondsSinceEpoch.toString() +
              "U0" +
              userModel.ID.toString() +
              "_" +
              snapshot[0].DocName +
              "PR" +
              "/" +
              DocNum.toString();
    } while (await isPROPRQTransIdAvailable(
        null, purchaseGenData.GeneralData.transId ?? ""));
    print(purchaseGenData.GeneralData.transId);

    Get.offAll(() => PurchaseRequest(0));
  });
}

navigateToPurchaseRequestDocument({required String TransId}) async {
  List<PROPRQ> list = await retrievePROPRQById(null, 'TransId = ?', [TransId]);
  if (list.isNotEmpty) {
    ClearPurchaseRequestDocument.setGeneralDataTextFields(data: list[0]);
  }
  purchaseItemDetails.ItemDetails.items =
      await retrievePRPRQ1ById(null, 'TransId = ?', [TransId]);

  Get.offAll(() => PurchaseRequest(0));
}

class ClearGRNDocument {
  static clearGeneralDataTextFields() {
    grnGenData.GeneralData.iD = '';
    grnGenData.GeneralData.transId = '';
    grnGenData.GeneralData.cardCode = '';
    grnGenData.GeneralData.cardName = '';
    grnGenData.GeneralData.refNo = '';
    grnGenData.GeneralData.contactPersonId = '';
    grnGenData.GeneralData.contactPersonName = '';
    grnGenData.GeneralData.mobileNo = '';
    grnGenData.GeneralData.postingDate = getFormattedDate(DateTime.now());
    grnGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    grnGenData.GeneralData.currency = userModel.Currency;
    grnGenData.GeneralData.currRate = userModel.Rate;
    grnGenData.GeneralData.paymentTermCode = '';
    grnGenData.GeneralData.paymentTermName = '';
    grnGenData.GeneralData.paymentTermDays = '';
    grnGenData.GeneralData.approvalStatus = 'Pending';
    grnGenData.GeneralData.docStatus = 'Open';
    grnGenData.GeneralData.rPTransId = '';
    grnGenData.GeneralData.dSTranId = '';
    grnGenData.GeneralData.cRTransId = '';
    grnGenData.GeneralData.baseTab = '';
    grnGenData.GeneralData.totBDisc = '';
    grnGenData.GeneralData.discPer = '';
    grnGenData.GeneralData.discVal = '';
    grnGenData.GeneralData.taxVal = '';
    grnGenData.GeneralData.docTotal = '';
    grnGenData.GeneralData.permanentTransId = '';
    grnGenData.GeneralData.docEntry = '';
    grnGenData.GeneralData.docNum = '';
    grnGenData.GeneralData.createdBy = '';
    grnGenData.GeneralData.createDate = '';
    grnGenData.GeneralData.updateDate = '';
    grnGenData.GeneralData.approvedBy = '';
    grnGenData.GeneralData.latitude = '';
    grnGenData.GeneralData.longitude = '';
    grnGenData.GeneralData.updatedBy = '';
    grnGenData.GeneralData.branchId = '';
    grnGenData.GeneralData.remarks = '';
    grnGenData.GeneralData.localDate = '';
    grnGenData.GeneralData.whsCode = '';
    grnGenData.GeneralData.objectCode = '';
    grnGenData.GeneralData.error = '';
    grnGenData.GeneralData.postingAddress = '';
    grnGenData.GeneralData.tripTransId = '';
    grnGenData.GeneralData.deptCode = '';
    grnGenData.GeneralData.deptName = '';
    grnGenData.GeneralData.isSelected = false;
    grnGenData.GeneralData.hasCreated = false;
    grnGenData.GeneralData.hasUpdated = false;
  }

  static setGeneralDataTextFields({required PROPDN data}) {
    grnGenData.GeneralData.iD = data.ID?.toString() ?? '';
    grnGenData.GeneralData.transId = data.TransId ?? '';
    grnGenData.GeneralData.cardCode = data.CardCode ?? '';
    grnGenData.GeneralData.cardName = data.CardName ?? '';
    grnGenData.GeneralData.refNo = data.RefNo ?? '';
    grnGenData.GeneralData.contactPersonId =
        data.ContactPersonId?.toString() ?? '';
    grnGenData.GeneralData.contactPersonName = data.ContactPersonName ?? '';
    grnGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    grnGenData.GeneralData.postingDate = getFormattedDate(data.PostingDate);
    grnGenData.GeneralData.validUntill = getFormattedDate(data.ValidUntill);
    grnGenData.GeneralData.currency = data.Currency ?? '';
    grnGenData.GeneralData.currRate = data.CurrRate?.toStringAsFixed(2) ?? '1';
    grnGenData.GeneralData.paymentTermCode = data.PaymentTermCode ?? '';
    grnGenData.GeneralData.paymentTermName = data.PaymentTermName ?? '';
    grnGenData.GeneralData.paymentTermDays =
        data.PaymentTermDays?.toString() ?? '';
    grnGenData.GeneralData.approvalStatus = data.ApprovalStatus ?? 'Pending';
    grnGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    grnGenData.GeneralData.rPTransId = data.RPTransId ?? '';
    grnGenData.GeneralData.dSTranId = data.DSTranId ?? '';
    grnGenData.GeneralData.cRTransId = data.CRTransId ?? '';
    grnGenData.GeneralData.baseTab = data.BaseTab ?? '';
    grnGenData.GeneralData.totBDisc = data.TotBDisc?.toStringAsFixed(2) ?? '';
    grnGenData.GeneralData.discPer = data.DiscPer?.toStringAsFixed(2) ?? '';
    grnGenData.GeneralData.discVal = data.DiscVal?.toStringAsFixed(2) ?? '';
    grnGenData.GeneralData.taxVal = data.TaxVal?.toStringAsFixed(2) ?? '';
    grnGenData.GeneralData.docTotal = data.DocTotal?.toStringAsFixed(2) ?? '';
    grnGenData.GeneralData.permanentTransId = data.PermanentTransId ?? '';
    grnGenData.GeneralData.docEntry = data.DocEntry?.toString() ?? '';
    grnGenData.GeneralData.docNum = data.DocNum ?? '';
    grnGenData.GeneralData.createdBy = data.CreatedBy ?? '';
    grnGenData.GeneralData.createDate = getFormattedDate(data.CreateDate);
    grnGenData.GeneralData.updateDate = data.UpdatedBy ?? '';
    grnGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    grnGenData.GeneralData.latitude = data.TransId ?? '';
    grnGenData.GeneralData.longitude = data.Latitude ?? '';
    grnGenData.GeneralData.updatedBy = data.Longitude ?? '';
    grnGenData.GeneralData.branchId = data.BranchId ?? '';
    grnGenData.GeneralData.remarks = data.Remarks ?? '';
    grnGenData.GeneralData.localDate = data.LocalDate ?? '';
    grnGenData.GeneralData.whsCode = data.WhsCode ?? '';
    grnGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    grnGenData.GeneralData.error = data.Error ?? '';
    grnGenData.GeneralData.postingAddress = data.PostingAddress ?? '';
    grnGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    grnGenData.GeneralData.deptCode = data.DeptCode ?? '';
    grnGenData.GeneralData.deptName = data.DeptName ?? '';
    grnGenData.GeneralData.isSelected = true;
    grnGenData.GeneralData.hasCreated = data.hasCreated;
    grnGenData.GeneralData.hasUpdated = data.hasUpdated;
  }

  static clearShippingAddressTextFields() {
//todo:
  }

  static clearBillingAddressTextFields() {
//todo:
  }

  static setShippingAddressTextFields({required PRPDN2 prpdn2}) {
    grnShipAddress.ShippingAddress.CityName = prpdn2.CityName.toString();
    grnShipAddress.ShippingAddress.hasCreated = prpdn2.hasCreated;
    grnShipAddress.ShippingAddress.hasUpdated = prpdn2.hasUpdated;
    grnShipAddress.ShippingAddress.CityCode = prpdn2.CityCode.toString();
    grnShipAddress.ShippingAddress.Addres = prpdn2.Address.toString();
    grnShipAddress.ShippingAddress.CountryName = prpdn2.CountryName.toString();
    grnShipAddress.ShippingAddress.CountryCode = prpdn2.CountryCode.toString();
    grnShipAddress.ShippingAddress.StateName = prpdn2.StateName.toString();
    grnShipAddress.ShippingAddress.RouteCode = prpdn2.RouteCode.toString();
    grnShipAddress.ShippingAddress.StateCode = prpdn2.StateCode.toString();
    grnShipAddress.ShippingAddress.Latitude =
        double.tryParse(prpdn2.Latitude.toString()) ?? 0.0;
    grnShipAddress.ShippingAddress.Longitude =
        double.tryParse(prpdn2.Longitude.toString()) ?? 0.0;
    grnShipAddress.ShippingAddress.RowId = int.parse(prpdn2.RowId.toString());
    grnShipAddress.ShippingAddress.AddCode = prpdn2.AddressCode.toString();
  }

  static setBillingAddressTextFields({required PRPDN3 prpdn3}) {
    grnBillAddress.BillingAddress.CityName = prpdn3.CityName.toString();
    grnBillAddress.BillingAddress.hasCreated = prpdn3.hasCreated;
    grnBillAddress.BillingAddress.hasUpdated = prpdn3.hasUpdated;
    grnBillAddress.BillingAddress.CityCode = prpdn3.CityCode.toString();
    grnBillAddress.BillingAddress.Addres = prpdn3.Address.toString();
    grnBillAddress.BillingAddress.CountryName = prpdn3.CountryName.toString();
    grnBillAddress.BillingAddress.CountryCode = prpdn3.CountryCode.toString();
    grnBillAddress.BillingAddress.StateName = prpdn3.StateName.toString();
    grnBillAddress.BillingAddress.StateCode = prpdn3.StateCode.toString();
    grnBillAddress.BillingAddress.Latitude =
        double.tryParse(prpdn3.Latitude.toString()) ?? 0.0;
    grnBillAddress.BillingAddress.Longitude =
        double.tryParse(prpdn3.Longitude.toString()) ?? 0.0;
    grnBillAddress.BillingAddress.RowId = int.parse(prpdn3.RowId.toString());
    grnBillAddress.BillingAddress.AddCode = prpdn3.AddressCode.toString();
  }

  static clearEditItems() {
    grnEditItems.EditItems.id = '';
    grnEditItems.EditItems.tripTransId = '';
    grnEditItems.EditItems.supplierCode = '';
    grnEditItems.EditItems.supplierName = '';
    grnEditItems.EditItems.truckNo = '';
    grnEditItems.EditItems.toWhsCode = '';
    grnEditItems.EditItems.toWhsName = '';
    grnEditItems.EditItems.driverCode = '';
    grnEditItems.EditItems.driverName = '';
    grnEditItems.EditItems.routeCode = '';
    grnEditItems.EditItems.routeName = '';
    grnEditItems.EditItems.transId = '';
    grnEditItems.EditItems.rowId = '';
    grnEditItems.EditItems.itemCode = '';
    grnEditItems.EditItems.itemName = '';
    grnEditItems.EditItems.consumptionQty = '';
    grnEditItems.EditItems.uomCode = '';
    grnEditItems.EditItems.uomName = '';
    grnEditItems.EditItems.deptCode = '';
    grnEditItems.EditItems.deptName = '';
    grnEditItems.EditItems.price = '';
    grnEditItems.EditItems.mtv = '';
    grnEditItems.EditItems.taxCode = '';
    grnEditItems.EditItems.taxRate = '';
    grnEditItems.EditItems.lineDiscount = '';
    grnEditItems.EditItems.lineTotal = '';
    grnEditItems.EditItems.isUpdating = false;
  }
}

goToNewGRNDocument() async {
  await ClearGRNDocument.clearGeneralDataTextFields();
  await ClearGRNDocument.clearEditItems();
  grnItemDetails.ItemDetails.items.clear();

  getLastDocNum("PR", null).then((snapshot) async {
    int DocNum = snapshot[0].DocNumber - 1;

    do {
      DocNum += 1;
      grnGenData.GeneralData.transId =
          DateTime.now().millisecondsSinceEpoch.toString() +
              "U0" +
              userModel.ID.toString() +
              "_" +
              snapshot[0].DocName +
              "GR" +
              "/" +
              DocNum.toString();
    } while (await isPROPRQTransIdAvailable(
        null, grnGenData.GeneralData.transId ?? ""));
    print(grnGenData.GeneralData.transId);
    Get.offAll(() => GoodsRecepitNote(0));
  });
}

navigateToGoodsReceiptNoteDocument({required String TransId}) async {
  List<PROPDN> list = await retrievePROPDNById(null, 'TransId = ?', [TransId]);
  if (list.isNotEmpty) {
    ClearGRNDocument.setGeneralDataTextFields(data: list[0]);
  }
  List<PRPDN2> PRPDN2List =
      await retrievePRPDN2ById(null, 'TransId = ?', [TransId]);
  if (PRPDN2List.isNotEmpty) {
    ClearGRNDocument.setShippingAddressTextFields(prpdn2: PRPDN2List[0]);
  }
  List<PRPDN3> PRPDN3List =
      await retrievePRPDN3ById(null, 'TransId = ?', [TransId]);
  if (PRPDN3List.isNotEmpty) {
    ClearGRNDocument.setBillingAddressTextFields(prpdn3: PRPDN3List[0]);
  }
  grnItemDetails.ItemDetails.items =
      await retrievePRPDN1ById(null, 'TransId = ?', [TransId]);

  Get.offAll(() => GoodsRecepitNote(0));
}

class ClearInternalRequestDocument {
  static clearGeneralDataTextFields() {
    internalGenData.GeneralData.iD = '';
    internalGenData.GeneralData.transId = '';
    internalGenData.GeneralData.requestedCode = userModel.EmpCode;
    internalGenData.GeneralData.requestedName = userModel.EmpName;
    internalGenData.GeneralData.refNo = '';
    internalGenData.GeneralData.mobileNo = userModel.MobileNo;
    internalGenData.GeneralData.postingDate = getFormattedDate(DateTime.now());
    internalGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    internalGenData.GeneralData.currency = userModel.Currency;
    internalGenData.GeneralData.currRate = userModel.Rate;
    internalGenData.GeneralData.approvalStatus = 'Pending';
    internalGenData.GeneralData.docStatus = 'Open';
    internalGenData.GeneralData.permanentTransId = '';
    internalGenData.GeneralData.docEntry = '';
    internalGenData.GeneralData.docNum = '';
    internalGenData.GeneralData.createdBy = '';

    internalGenData.GeneralData.approvedBy = '';
    internalGenData.GeneralData.error = '';
    internalGenData.GeneralData.isPosted = false;
    internalGenData.GeneralData.draftKey = '';
    internalGenData.GeneralData.latitude = '';
    internalGenData.GeneralData.longitude = '';
    internalGenData.GeneralData.objectCode = '';
    internalGenData.GeneralData.fromWhsCode = '';
    internalGenData.GeneralData.toWhsCode = '';
    internalGenData.GeneralData.remarks = '';
    internalGenData.GeneralData.branchId = '';
    internalGenData.GeneralData.updatedBy = '';
    internalGenData.GeneralData.postingAddress = '';
    internalGenData.GeneralData.tripTransId = '';
    internalGenData.GeneralData.deptCode = '';
    internalGenData.GeneralData.deptName = '';
    internalGenData.GeneralData.isSelected = false;
    internalGenData.GeneralData.hasCreated = false;
    internalGenData.GeneralData.hasUpdated = false;
  }

  static setGeneralDataTextFields({required PROITR data}) {
    internalGenData.GeneralData.iD = data.ID?.toString() ?? '';
    internalGenData.GeneralData.transId = data.TransId ?? '';
    internalGenData.GeneralData.requestedCode = data.RequestedCode;
    internalGenData.GeneralData.requestedName = data.RequestedName;
    internalGenData.GeneralData.refNo = data.RefNo ?? '';
    internalGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    internalGenData.GeneralData.postingDate =
        getFormattedDate(data.PostingDate);
    internalGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    internalGenData.GeneralData.currency = data.Currency;
    internalGenData.GeneralData.currRate = data.CurrRate?.toString() ?? '1';
    internalGenData.GeneralData.approvalStatus =
        data.ApprovalStatus ?? 'Pending';
    internalGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    internalGenData.GeneralData.permanentTransId = data.PermanentTransId ?? '';
    internalGenData.GeneralData.docEntry = data.DocEntry?.toString() ?? '';
    internalGenData.GeneralData.docNum = data.DocNum ?? '';
    internalGenData.GeneralData.createdBy = data.CreatedBy ?? '';

    internalGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    internalGenData.GeneralData.error = data.Error ?? '';
    internalGenData.GeneralData.isPosted = data.IsPosted ?? false;
    internalGenData.GeneralData.draftKey = data.DraftKey ?? '';
    internalGenData.GeneralData.latitude = data.Latitude ?? '';
    internalGenData.GeneralData.longitude = data.Longitude ?? '';
    internalGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    internalGenData.GeneralData.fromWhsCode = data.FromWhsCode ?? '';
    internalGenData.GeneralData.toWhsCode = data.ToWhsCode ?? '';
    internalGenData.GeneralData.remarks = data.Remarks ?? '';
    internalGenData.GeneralData.branchId = data.BranchId ?? '';
    internalGenData.GeneralData.updatedBy = data.UpdatedBy ?? '';
    internalGenData.GeneralData.postingAddress = data.PostingAddress ?? '';
    internalGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    internalGenData.GeneralData.deptCode = data.DeptCode ?? '';
    internalGenData.GeneralData.deptName = data.DeptName ?? '';
    internalGenData.GeneralData.isSelected = true;
    internalGenData.GeneralData.hasCreated = data.hasCreated;
    internalGenData.GeneralData.hasUpdated = data.hasUpdated;
  }

  static clearEditItems() {
    internalEditItems.EditItems.id = '';
    internalEditItems.EditItems.tripTransId = '';
    internalEditItems.EditItems.fromWhsCode = '';

    internalEditItems.EditItems.truckNo = '';
    internalEditItems.EditItems.toWhsCode = '';
    internalEditItems.EditItems.toWhsName = '';
    internalEditItems.EditItems.driverCode = '';
    internalEditItems.EditItems.driverName = '';
    internalEditItems.EditItems.routeCode = '';
    internalEditItems.EditItems.routeName = '';
    internalEditItems.EditItems.transId = '';
    internalEditItems.EditItems.rowId = '';
    internalEditItems.EditItems.itemCode = '';
    internalEditItems.EditItems.itemName = '';
    internalEditItems.EditItems.consumptionQty = '';
    internalEditItems.EditItems.uomCode = '';
    internalEditItems.EditItems.uomName = '';
    internalEditItems.EditItems.deptCode = '';
    internalEditItems.EditItems.deptName = '';
    internalEditItems.EditItems.price = '';
    internalEditItems.EditItems.mtv = '';
    internalEditItems.EditItems.taxCode = '';
    internalEditItems.EditItems.taxRate = '';
    internalEditItems.EditItems.lineDiscount = '';
    internalEditItems.EditItems.lineTotal = '';
    internalEditItems.EditItems.isUpdating = false;
  }
}

goToNewInternalRequestDocument() async {
  await ClearInternalRequestDocument.clearGeneralDataTextFields();
  await ClearInternalRequestDocument.clearEditItems();
  internalItemDetails.ItemDetails.items.clear();
  getLastDocNum("PRST", null).then((snapshot) async {
    int DocNum = snapshot[0].DocNumber - 1;
    do {
      DocNum += 1;
      internalGenData.GeneralData.transId =
          DateTime.now().millisecondsSinceEpoch.toString() +
              "U0" +
              userModel.ID.toString() +
              "_" +
              snapshot[0].DocName +
              "/" +
              DocNum.toString();
    } while (await isPROPRQTransIdAvailable(
        null, internalGenData.GeneralData.transId ?? ""));
    print(internalGenData.GeneralData.transId);
    Get.offAll(() => InternalRequest(0));
  });
}

navigateToInternalRequestDocument({required String TransId}) async {
  await ClearInternalRequestDocument.clearGeneralDataTextFields();
  await ClearInternalRequestDocument.clearEditItems();
  List<PROITR> list = await retrievePROITRById(null, 'TransId = ?', [TransId]);
  if (list.isNotEmpty) {
    ClearInternalRequestDocument.setGeneralDataTextFields(data: list[0]);
  }
  internalItemDetails.ItemDetails.items =
      await retrievePRITR1ById(null, 'TransId = ?', [TransId]);

  Get.offAll(() => InternalRequest(0));
}
