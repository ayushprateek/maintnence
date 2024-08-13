import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/create/Attachments.dart'
    as checkListAttachments;
import 'package:maintenance/CheckListDocument/create/CheckListDetails/CheckListDetails.dart' as checkListCreateDetails;
import 'package:maintenance/CheckListDocument/view/CheckListDetails/CheckListDetails.dart' as checkListViewDetails;
import 'package:maintenance/CheckListDocument/edit/CheckListDetails/CheckListDetails.dart' as checkListEditDetails;
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
import 'package:maintenance/GoodsReceiptNote/create/Address/BillingAddress.dart'
    as createGrnBillAddress;
import 'package:maintenance/GoodsReceiptNote/create/Address/ShippingAddress.dart'
    as createGrnShipAddress;
//------------------------------CREATE GOODS RECEIPT NOTES------------
import 'package:maintenance/GoodsReceiptNote/create/GeneralData.dart'
    as createGrnGenData;
import 'package:maintenance/GoodsReceiptNote/create/GoodsReceiptNote.dart';
import 'package:maintenance/GoodsReceiptNote/create/ItemDetails/ItemDetails.dart'
    as createGrnItemDetails;
import 'package:maintenance/GoodsReceiptNote/edit/Address/BillingAddress.dart'
    as editGrnBillAddress;
import 'package:maintenance/GoodsReceiptNote/edit/Address/ShippingAddress.dart'
    as editGrnShipAddress;
//------------------------------EDIT GOODS RECEIPT NOTES------------
import 'package:maintenance/GoodsReceiptNote/edit/GeneralData.dart'
    as editGrnGenData;
import 'package:maintenance/GoodsReceiptNote/edit/GoodsReceiptNote.dart';
import 'package:maintenance/GoodsReceiptNote/edit/ItemDetails/ItemDetails.dart'
    as editGrnItemDetails;
import 'package:maintenance/GoodsReceiptNote/view/Address/BillingAddress.dart'
    as viewGrnBillAddress;
import 'package:maintenance/GoodsReceiptNote/view/Address/ShippingAddress.dart'
    as viewGrnShipAddress;
//------------------------------VIEW GOODS RECEIPT NOTES------------
import 'package:maintenance/GoodsReceiptNote/view/GeneralData.dart'
    as viewGrnGenData;
import 'package:maintenance/GoodsReceiptNote/view/GoodsReceiptNote.dart';
import 'package:maintenance/GoodsReceiptNote/view/ItemDetails/ItemDetails.dart'
    as viewGrnItemDetails;
//------------------------------ CREATE INTERNAL REQUEST------------
import 'package:maintenance/InternalRequest/create/GeneralData.dart'
    as createInternalGenData;
import 'package:maintenance/InternalRequest/create/InternalRequest.dart';
import 'package:maintenance/InternalRequest/create/ItemDetails/EditItems.dart'
    as createInternalEditItems;
import 'package:maintenance/InternalRequest/create/ItemDetails/ItemDetails.dart'
    as createInternalItemDetails;
import 'package:maintenance/InternalRequest/edit/InternalRequest.dart';
import 'package:maintenance/InternalRequest/edit/ItemDetails/ItemDetails.dart'
    as editInternalItemDetails;
import 'package:maintenance/InternalRequest/view/InternalRequest.dart';
import 'package:maintenance/InternalRequest/view/ItemDetails/ItemDetails.dart'
    as viewInternalItemDetails;
//---------------------------------CREATE JOB CARD IMPORTS
import 'package:maintenance/JobCard/create/GeneralData.dart'
    as jcdCreateGenData;
import 'package:maintenance/JobCard/create/ItemDetails/EditJobCardItem.dart'
    as editCreateJCDItems;
import 'package:maintenance/JobCard/create/ItemDetails/ItemDetails.dart'
    as jcdCreateItemDetails;
import 'package:maintenance/JobCard/create/JobCard.dart';
import 'package:maintenance/JobCard/create/ServiceDetails/EditService.dart'
    as editCreateJCDService;
import 'package:maintenance/JobCard/create/ServiceDetails/ServiceDetails.dart'
    as jcdCreateServiceDetails;
//---------------------------------EDIT JOB CARD IMPORTS
import 'package:maintenance/JobCard/edit/GeneralData.dart' as jcdEditGenData;
import 'package:maintenance/JobCard/edit/JobCard.dart';
//---------------------------------VIEW JOB CARD IMPORTS
import 'package:maintenance/JobCard/view/GeneralData.dart' as jcdViewGenData;
import 'package:maintenance/JobCard/view/JobCard.dart';
//------------------------------ CREATE PURCHASE REQUEST IMPORTS------------
import 'package:maintenance/Purchase/PurchaseRequest/create/GeneralData.dart'
    as createPurchaseGenData;
import 'package:maintenance/Purchase/PurchaseRequest/create/ItemDetails/EditItems.dart'
    as createGrnEditItems;
import 'package:maintenance/Purchase/PurchaseRequest/create/ItemDetails/EditItems.dart'
    as createPurchaseEditItems;
import 'package:maintenance/Purchase/PurchaseRequest/create/ItemDetails/ItemDetails.dart'
    as createPurchaseItemDetails;
import 'package:maintenance/Purchase/PurchaseRequest/create/PurchaseRequest.dart';
//------------------------------ EDIT PURCHASE REQUEST IMPORTS------------
import 'package:maintenance/Purchase/PurchaseRequest/edit/GeneralData.dart'
    as editPurchaseGenData;
import 'package:maintenance/Purchase/PurchaseRequest/edit/ItemDetails/EditItems.dart'
    as editGrnEditItems;
import 'package:maintenance/Purchase/PurchaseRequest/edit/PurchaseRequest.dart';
//------------------------------ VIEW PURCHASE REQUEST IMPORTS------------
import 'package:maintenance/Purchase/PurchaseRequest/view/GeneralData.dart'
    as viewPurchaseGenData;
import 'package:maintenance/Purchase/PurchaseRequest/view/PurchaseRequest.dart';
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
    jcdCreateGenData.GeneralData.lastReadingDate =
        getFormattedDate(DateTime.now());
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
    jcdCreateGenData.GeneralData.permanentTransId =
        mnojcd.PermanentTransId ?? '';
    jcdCreateGenData.GeneralData.transId = mnojcd.TransId ?? '';
    jcdCreateGenData.GeneralData.docEntry = mnojcd.DocEntry?.toString() ?? '';
    jcdCreateGenData.GeneralData.docNum = mnojcd.DocNum?.toString() ?? '';
    jcdCreateGenData.GeneralData.canceled = mnojcd.Canceled ?? '';
    jcdCreateGenData.GeneralData.docStatus = mnojcd.DocStatus ?? 'Open';
    jcdCreateGenData.GeneralData.approvalStatus =
        mnojcd.ApprovalStatus ?? 'Pending';
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
    jcdCreateGenData.GeneralData.postingDate =
        getFormattedDate(mnojcd.PostingDate);
    jcdCreateGenData.GeneralData.validUntill =
        getFormattedDate(mnojcd.ValidUntill);
    jcdCreateGenData.GeneralData.lastReadingDate =
        getFormattedDate(mnojcd.LastReading);
    // jcdGenData.GeneralData.lastReading = mnojcd.LastReading??'';
    jcdCreateGenData.GeneralData.assignedUserCode =
        mnojcd.AssignedUserCode ?? '';
    jcdCreateGenData.GeneralData.assignedUserName =
        mnojcd.AssignedUserName ?? '';
    // jcdGenData.GeneralData.mNJCTransId = mnojcd.MNJ??'';
    jcdCreateGenData.GeneralData.remarks = mnojcd.Remarks ?? '';
    jcdCreateGenData.GeneralData.createdBy = mnojcd.CreatedBy ?? '';
    jcdCreateGenData.GeneralData.updatedBy = mnojcd.UpdatedBy ?? '';
    jcdCreateGenData.GeneralData.branchId = mnojcd.BranchId ?? '';
    jcdCreateGenData.GeneralData.createDate =
        getFormattedDate(mnojcd.CreateDate);
    jcdCreateGenData.GeneralData.updateDate =
        getFormattedDate(mnojcd.UpdateDate);

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
    jcdViewGenData.GeneralData.approvalStatus =
        mnojcd.ApprovalStatus ?? 'Pending';
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
    jcdViewGenData.GeneralData.postingDate =
        getFormattedDate(mnojcd.PostingDate);
    jcdViewGenData.GeneralData.validUntill =
        getFormattedDate(mnojcd.ValidUntill);
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
    jcdEditGenData.GeneralData.approvalStatus =
        mnojcd.ApprovalStatus ?? 'Pending';
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
    jcdEditGenData.GeneralData.postingDate =
        getFormattedDate(mnojcd.PostingDate);
    jcdEditGenData.GeneralData.validUntill =
        getFormattedDate(mnojcd.ValidUntill);
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

navigateToJobCardDocument(
    {required String TransId, required bool isView}) async {
  if (isView) {
    List<MNOJCD> list =
        await retrieveMNOJCDById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearJobCardDoc.setViewJobCardData(mnojcd: list[0]);
    }
    jcdCreateItemDetails.ItemDetails.items =
        await retrieveMNJCD1ById(null, 'TransId = ?', [TransId]);
    jcdCreateServiceDetails.ServiceDetails.items =
        await retrieveMNJCD2ById(null, 'TransId = ?', [TransId]);

    Get.offAll(() => ViewJobCard(0));
  } else {
    List<MNOJCD> list =
        await retrieveMNOJCDById(null, 'TransId = ?', [TransId]);
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
    createPurchaseGenData.GeneralData.iD = '';
    createPurchaseGenData.GeneralData.transId = '';
    createPurchaseGenData.GeneralData.refNo = '';
    createPurchaseGenData.GeneralData.mobileNo = '';
    createPurchaseGenData.GeneralData.postingDate =
        getFormattedDate(DateTime.now());
    createPurchaseGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    createPurchaseGenData.GeneralData.approvalStatus = 'Pending';
    createPurchaseGenData.GeneralData.docStatus = 'Open';
    createPurchaseGenData.GeneralData.permanentTransId = '';
    createPurchaseGenData.GeneralData.docEntry = '';
    createPurchaseGenData.GeneralData.docNum = '';
    createPurchaseGenData.GeneralData.createdBy = '';
    createPurchaseGenData.GeneralData.createDate = '';
    createPurchaseGenData.GeneralData.updateDate = '';
    createPurchaseGenData.GeneralData.approvedBy = '';
    createPurchaseGenData.GeneralData.error = '';
    createPurchaseGenData.GeneralData.isSelected = false;
    createPurchaseGenData.GeneralData.hasCreated = false;
    createPurchaseGenData.GeneralData.hasUpdated = false;
    createPurchaseGenData.GeneralData.isPosted = false;
    createPurchaseGenData.GeneralData.draftKey = '';
    createPurchaseGenData.GeneralData.latitude = '';
    createPurchaseGenData.GeneralData.longitude = '';
    createPurchaseGenData.GeneralData.objectCode = '';
    createPurchaseGenData.GeneralData.whsCode = '';
    createPurchaseGenData.GeneralData.remarks = '';
    createPurchaseGenData.GeneralData.branchId = '';
    createPurchaseGenData.GeneralData.updatedBy = '';
    createPurchaseGenData.GeneralData.postingAddress = '';
    createPurchaseGenData.GeneralData.tripTransId = '';
    createPurchaseGenData.GeneralData.deptCode = '';
    createPurchaseGenData.GeneralData.deptName = '';
    createPurchaseGenData.GeneralData.requestedCode = '';
    createPurchaseGenData.GeneralData.requestedName = '';

    createPurchaseGenData.GeneralData.isPosted = false;
    createPurchaseGenData.GeneralData.isConsumption = false;
    createPurchaseGenData.GeneralData.isRequest = false;
  }

  static setCreatePurchaseRequestTextFields({required PROPRQ data}) {
    createPurchaseGenData.GeneralData.iD = data.ID?.toString() ?? '';
    createPurchaseGenData.GeneralData.transId = data.TransId ?? '';
    createPurchaseGenData.GeneralData.refNo = data.RefNo ?? '';
    createPurchaseGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    createPurchaseGenData.GeneralData.postingDate =
        getFormattedDate(data.PostingDate);
    createPurchaseGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    createPurchaseGenData.GeneralData.approvalStatus =
        data.ApprovalStatus ?? 'Pending';
    createPurchaseGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    createPurchaseGenData.GeneralData.permanentTransId =
        data.PermanentTransId ?? '';
    createPurchaseGenData.GeneralData.docEntry =
        data.DocEntry?.toString() ?? '';
    createPurchaseGenData.GeneralData.docNum = data.DocNum ?? '';
    createPurchaseGenData.GeneralData.createdBy = data.CreatedBy ?? '';
    // purchaseGenData.GeneralData.createDate = getFormattedDate(data.CreateDate);
    // purchaseGenData.GeneralData.updateDate = data.TransId??'';
    createPurchaseGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    createPurchaseGenData.GeneralData.error = data.Error ?? '';
    createPurchaseGenData.GeneralData.isSelected = true;
    createPurchaseGenData.GeneralData.hasCreated = data.hasCreated;
    createPurchaseGenData.GeneralData.hasUpdated = data.hasUpdated;
    createPurchaseGenData.GeneralData.isPosted = data.IsPosted ?? false;
    createPurchaseGenData.GeneralData.draftKey = data.DraftKey ?? '';
    createPurchaseGenData.GeneralData.latitude = data.Latitude ?? '';
    createPurchaseGenData.GeneralData.longitude = data.Longitude ?? '';
    createPurchaseGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    createPurchaseGenData.GeneralData.whsCode = data.WhsCode ?? '';
    createPurchaseGenData.GeneralData.remarks = data.Remarks ?? '';
    createPurchaseGenData.GeneralData.branchId = data.BranchId ?? '';
    createPurchaseGenData.GeneralData.updatedBy = data.UpdatedBy ?? '';
    createPurchaseGenData.GeneralData.postingAddress =
        data.PostingAddress ?? '';
    createPurchaseGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    createPurchaseGenData.GeneralData.deptCode = data.DeptCode ?? '';
    createPurchaseGenData.GeneralData.deptName = data.DeptName ?? '';
    createPurchaseGenData.GeneralData.requestedCode = data.RequestedCode ?? '';
    createPurchaseGenData.GeneralData.requestedName = data.RequestedName ?? '';

    createPurchaseGenData.GeneralData.isPosted = data.IsPosted ?? false;
  }

  static setViewPurchaseRequestTextFields({required PROPRQ data}) {
    viewPurchaseGenData.GeneralData.iD = data.ID?.toString() ?? '';
    viewPurchaseGenData.GeneralData.transId = data.TransId ?? '';
    viewPurchaseGenData.GeneralData.refNo = data.RefNo ?? '';
    viewPurchaseGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    viewPurchaseGenData.GeneralData.postingDate =
        getFormattedDate(data.PostingDate);
    viewPurchaseGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    viewPurchaseGenData.GeneralData.approvalStatus =
        data.ApprovalStatus ?? 'Pending';
    viewPurchaseGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    viewPurchaseGenData.GeneralData.permanentTransId =
        data.PermanentTransId ?? '';
    viewPurchaseGenData.GeneralData.docEntry = data.DocEntry?.toString() ?? '';
    viewPurchaseGenData.GeneralData.docNum = data.DocNum ?? '';
    viewPurchaseGenData.GeneralData.createdBy = data.CreatedBy ?? '';
    // purchaseGenData.GeneralData.createDate = getFormattedDate(data.CreateDate);
    // purchaseGenData.GeneralData.updateDate = data.TransId??'';
    viewPurchaseGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    viewPurchaseGenData.GeneralData.error = data.Error ?? '';
    viewPurchaseGenData.GeneralData.isSelected = true;
    viewPurchaseGenData.GeneralData.hasCreated = data.hasCreated;
    viewPurchaseGenData.GeneralData.hasUpdated = data.hasUpdated;
    viewPurchaseGenData.GeneralData.isPosted = data.IsPosted ?? false;
    viewPurchaseGenData.GeneralData.draftKey = data.DraftKey ?? '';
    viewPurchaseGenData.GeneralData.latitude = data.Latitude ?? '';
    viewPurchaseGenData.GeneralData.longitude = data.Longitude ?? '';
    viewPurchaseGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    viewPurchaseGenData.GeneralData.whsCode = data.WhsCode ?? '';
    viewPurchaseGenData.GeneralData.remarks = data.Remarks ?? '';
    viewPurchaseGenData.GeneralData.branchId = data.BranchId ?? '';
    viewPurchaseGenData.GeneralData.updatedBy = data.UpdatedBy ?? '';
    viewPurchaseGenData.GeneralData.postingAddress = data.PostingAddress ?? '';
    viewPurchaseGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    viewPurchaseGenData.GeneralData.deptCode = data.DeptCode ?? '';
    viewPurchaseGenData.GeneralData.deptName = data.DeptName ?? '';
    viewPurchaseGenData.GeneralData.requestedCode = data.RequestedCode ?? '';
    viewPurchaseGenData.GeneralData.requestedName = data.RequestedName ?? '';

    viewPurchaseGenData.GeneralData.isPosted = data.IsPosted ?? false;
  }

  static setEditPurchaseRequestTextFields({required PROPRQ data}) {
    editPurchaseGenData.GeneralData.iD = data.ID?.toString() ?? '';
    editPurchaseGenData.GeneralData.transId = data.TransId ?? '';
    editPurchaseGenData.GeneralData.refNo = data.RefNo ?? '';
    editPurchaseGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    editPurchaseGenData.GeneralData.postingDate =
        getFormattedDate(data.PostingDate);
    editPurchaseGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    editPurchaseGenData.GeneralData.approvalStatus =
        data.ApprovalStatus ?? 'Pending';
    editPurchaseGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    editPurchaseGenData.GeneralData.permanentTransId =
        data.PermanentTransId ?? '';
    editPurchaseGenData.GeneralData.docEntry = data.DocEntry?.toString() ?? '';
    editPurchaseGenData.GeneralData.docNum = data.DocNum ?? '';
    editPurchaseGenData.GeneralData.createdBy = data.CreatedBy ?? '';
    // purchaseGenData.GeneralData.createDate = getFormattedDate(data.CreateDate);
    // purchaseGenData.GeneralData.updateDate = data.TransId??'';
    editPurchaseGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    editPurchaseGenData.GeneralData.error = data.Error ?? '';
    editPurchaseGenData.GeneralData.isSelected = true;
    editPurchaseGenData.GeneralData.hasCreated = data.hasCreated;
    editPurchaseGenData.GeneralData.hasUpdated = data.hasUpdated;
    editPurchaseGenData.GeneralData.isPosted = data.IsPosted ?? false;
    editPurchaseGenData.GeneralData.draftKey = data.DraftKey ?? '';
    editPurchaseGenData.GeneralData.latitude = data.Latitude ?? '';
    editPurchaseGenData.GeneralData.longitude = data.Longitude ?? '';
    editPurchaseGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    editPurchaseGenData.GeneralData.whsCode = data.WhsCode ?? '';
    editPurchaseGenData.GeneralData.remarks = data.Remarks ?? '';
    editPurchaseGenData.GeneralData.branchId = data.BranchId ?? '';
    editPurchaseGenData.GeneralData.updatedBy = data.UpdatedBy ?? '';
    editPurchaseGenData.GeneralData.postingAddress = data.PostingAddress ?? '';
    editPurchaseGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    editPurchaseGenData.GeneralData.deptCode = data.DeptCode ?? '';
    editPurchaseGenData.GeneralData.deptName = data.DeptName ?? '';
    editPurchaseGenData.GeneralData.requestedCode = data.RequestedCode ?? '';
    editPurchaseGenData.GeneralData.requestedName = data.RequestedName ?? '';

    editPurchaseGenData.GeneralData.isPosted = data.IsPosted ?? false;
  }

  static clearEditItems() {
    createPurchaseEditItems.EditItems.id = '';
    createPurchaseEditItems.EditItems.tripTransId = '';
    createPurchaseEditItems.EditItems.supplierCode = '';
    createPurchaseEditItems.EditItems.supplierName = '';
    createPurchaseEditItems.EditItems.truckNo = '';
    createPurchaseEditItems.EditItems.toWhsCode = '';
    createPurchaseEditItems.EditItems.toWhsName = '';
    createPurchaseEditItems.EditItems.driverCode = '';
    createPurchaseEditItems.EditItems.driverName = '';
    createPurchaseEditItems.EditItems.routeCode = '';
    createPurchaseEditItems.EditItems.routeName = '';
    createPurchaseEditItems.EditItems.transId = '';
    createPurchaseEditItems.EditItems.rowId = '';
    createPurchaseEditItems.EditItems.itemCode = '';
    createPurchaseEditItems.EditItems.itemName = '';
    createPurchaseEditItems.EditItems.consumptionQty = '';
    createPurchaseEditItems.EditItems.uomCode = '';
    createPurchaseEditItems.EditItems.uomName = '';
    createPurchaseEditItems.EditItems.deptCode = '';
    createPurchaseEditItems.EditItems.deptName = '';
    createPurchaseEditItems.EditItems.price = '';
    createPurchaseEditItems.EditItems.mtv = '';
    createPurchaseEditItems.EditItems.taxCode = '';
    createPurchaseEditItems.EditItems.taxRate = '';
    createPurchaseEditItems.EditItems.lineDiscount = '';
    createPurchaseEditItems.EditItems.lineTotal = '';
    createPurchaseEditItems.EditItems.isUpdating = false;
    createPurchaseEditItems.EditItems.isInserted = false;
  }
}

goToNewPurchaseRequestDocument() async {
  await ClearPurchaseRequestDocument.clearGeneralDataTextFields();
  await ClearPurchaseRequestDocument.clearEditItems();
  createPurchaseItemDetails.ItemDetails.items.clear();

  getLastDocNum("PR", null).then((snapshot) async {
    int DocNum = snapshot[0].DocNumber - 1;

    do {
      DocNum += 1;
      createPurchaseGenData.GeneralData.transId =
          DateTime.now().millisecondsSinceEpoch.toString() +
              "U0" +
              userModel.ID.toString() +
              "_" +
              snapshot[0].DocName +
              "PR" +
              "/" +
              DocNum.toString();
    } while (await isPROPRQTransIdAvailable(
        null, createPurchaseGenData.GeneralData.transId ?? ""));
    print(createPurchaseGenData.GeneralData.transId);

    Get.offAll(() => PurchaseRequest(0));
  });
}

navigateToPurchaseRequestDocument(
    {required String TransId, required bool isView}) async {
  if (isView) {
    List<PROPRQ> list =
        await retrievePROPRQById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearPurchaseRequestDocument.setViewPurchaseRequestTextFields(
          data: list[0]);
    }
    createPurchaseItemDetails.ItemDetails.items =
        await retrievePRPRQ1ById(null, 'TransId = ?', [TransId]);

    Get.offAll(() => ViewPurchaseRequest(0));
  } else {
    List<PROPRQ> list =
        await retrievePROPRQById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearPurchaseRequestDocument.setEditPurchaseRequestTextFields(
          data: list[0]);
    }
    createPurchaseItemDetails.ItemDetails.items =
        await retrievePRPRQ1ById(null, 'TransId = ?', [TransId]);

    Get.offAll(() => EditPurchaseRequest(0));
  }
}

class ClearGRNDocument {
  static clearGeneralDataTextFields() {
    createGrnGenData.GeneralData.iD = '';
    createGrnGenData.GeneralData.transId = '';
    createGrnGenData.GeneralData.cardCode = '';
    createGrnGenData.GeneralData.cardName = '';
    createGrnGenData.GeneralData.refNo = '';
    createGrnGenData.GeneralData.contactPersonId = '';
    createGrnGenData.GeneralData.contactPersonName = '';
    createGrnGenData.GeneralData.mobileNo = '';
    createGrnGenData.GeneralData.postingDate = getFormattedDate(DateTime.now());
    createGrnGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    createGrnGenData.GeneralData.currency = userModel.Currency;
    createGrnGenData.GeneralData.currRate = userModel.Rate;
    createGrnGenData.GeneralData.paymentTermCode = '';
    createGrnGenData.GeneralData.paymentTermName = '';
    createGrnGenData.GeneralData.paymentTermDays = '';
    createGrnGenData.GeneralData.approvalStatus = 'Pending';
    createGrnGenData.GeneralData.docStatus = 'Open';
    createGrnGenData.GeneralData.rPTransId = '';
    createGrnGenData.GeneralData.dSTranId = '';
    createGrnGenData.GeneralData.cRTransId = '';
    createGrnGenData.GeneralData.baseTab = '';
    createGrnGenData.GeneralData.totBDisc = '';
    createGrnGenData.GeneralData.discPer = '';
    createGrnGenData.GeneralData.discVal = '';
    createGrnGenData.GeneralData.taxVal = '';
    createGrnGenData.GeneralData.docTotal = '';
    createGrnGenData.GeneralData.permanentTransId = '';
    createGrnGenData.GeneralData.docEntry = '';
    createGrnGenData.GeneralData.docNum = '';
    createGrnGenData.GeneralData.createdBy = '';
    createGrnGenData.GeneralData.createDate = '';
    createGrnGenData.GeneralData.updateDate = '';
    createGrnGenData.GeneralData.approvedBy = '';
    createGrnGenData.GeneralData.latitude = '';
    createGrnGenData.GeneralData.longitude = '';
    createGrnGenData.GeneralData.updatedBy = '';
    createGrnGenData.GeneralData.branchId = '';
    createGrnGenData.GeneralData.remarks = '';
    createGrnGenData.GeneralData.localDate = '';
    createGrnGenData.GeneralData.whsCode = '';
    createGrnGenData.GeneralData.objectCode = '';
    createGrnGenData.GeneralData.error = '';
    createGrnGenData.GeneralData.postingAddress = '';
    createGrnGenData.GeneralData.tripTransId = '';
    createGrnGenData.GeneralData.deptCode = '';
    createGrnGenData.GeneralData.deptName = '';
    createGrnGenData.GeneralData.isSelected = false;
    createGrnGenData.GeneralData.hasCreated = false;
    createGrnGenData.GeneralData.hasUpdated = false;
  }

  static setGeneralDataTextFields({required PROPDN data}) {
    createGrnGenData.GeneralData.iD = data.ID?.toString() ?? '';
    createGrnGenData.GeneralData.transId = data.TransId ?? '';
    createGrnGenData.GeneralData.cardCode = data.CardCode ?? '';
    createGrnGenData.GeneralData.cardName = data.CardName ?? '';
    createGrnGenData.GeneralData.refNo = data.RefNo ?? '';
    createGrnGenData.GeneralData.contactPersonId =
        data.ContactPersonId?.toString() ?? '';
    createGrnGenData.GeneralData.contactPersonName =
        data.ContactPersonName ?? '';
    createGrnGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    createGrnGenData.GeneralData.postingDate =
        getFormattedDate(data.PostingDate);
    createGrnGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    createGrnGenData.GeneralData.currency = data.Currency ?? '';
    createGrnGenData.GeneralData.currRate =
        data.CurrRate?.toStringAsFixed(2) ?? '1';
    createGrnGenData.GeneralData.paymentTermCode = data.PaymentTermCode ?? '';
    createGrnGenData.GeneralData.paymentTermName = data.PaymentTermName ?? '';
    createGrnGenData.GeneralData.paymentTermDays =
        data.PaymentTermDays?.toString() ?? '';
    createGrnGenData.GeneralData.approvalStatus =
        data.ApprovalStatus ?? 'Pending';
    createGrnGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    createGrnGenData.GeneralData.rPTransId = data.RPTransId ?? '';
    createGrnGenData.GeneralData.dSTranId = data.DSTranId ?? '';
    createGrnGenData.GeneralData.cRTransId = data.CRTransId ?? '';
    createGrnGenData.GeneralData.baseTab = data.BaseTab ?? '';
    createGrnGenData.GeneralData.totBDisc =
        data.TotBDisc?.toStringAsFixed(2) ?? '';
    createGrnGenData.GeneralData.discPer =
        data.DiscPer?.toStringAsFixed(2) ?? '';
    createGrnGenData.GeneralData.discVal =
        data.DiscVal?.toStringAsFixed(2) ?? '';
    createGrnGenData.GeneralData.taxVal = data.TaxVal?.toStringAsFixed(2) ?? '';
    createGrnGenData.GeneralData.docTotal =
        data.DocTotal?.toStringAsFixed(2) ?? '';
    createGrnGenData.GeneralData.permanentTransId = data.PermanentTransId ?? '';
    createGrnGenData.GeneralData.docEntry = data.DocEntry?.toString() ?? '';
    createGrnGenData.GeneralData.docNum = data.DocNum ?? '';
    createGrnGenData.GeneralData.createdBy = data.CreatedBy ?? '';
    createGrnGenData.GeneralData.createDate = getFormattedDate(data.CreateDate);
    createGrnGenData.GeneralData.updateDate = data.UpdatedBy ?? '';
    createGrnGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    createGrnGenData.GeneralData.latitude = data.TransId ?? '';
    createGrnGenData.GeneralData.longitude = data.Latitude ?? '';
    createGrnGenData.GeneralData.updatedBy = data.Longitude ?? '';
    createGrnGenData.GeneralData.branchId = data.BranchId ?? '';
    createGrnGenData.GeneralData.remarks = data.Remarks ?? '';
    createGrnGenData.GeneralData.localDate = data.LocalDate ?? '';
    createGrnGenData.GeneralData.whsCode = data.WhsCode ?? '';
    createGrnGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    createGrnGenData.GeneralData.error = data.Error ?? '';
    createGrnGenData.GeneralData.postingAddress = data.PostingAddress ?? '';
    createGrnGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    createGrnGenData.GeneralData.deptCode = data.DeptCode ?? '';
    createGrnGenData.GeneralData.deptName = data.DeptName ?? '';
    createGrnGenData.GeneralData.isSelected = true;
    createGrnGenData.GeneralData.hasCreated = data.hasCreated;
    createGrnGenData.GeneralData.hasUpdated = data.hasUpdated;
  }

  static clearShippingAddressTextFields() {
//todo:
  }

  static clearBillingAddressTextFields() {
//todo:
  }

  static setShippingAddressTextFields({required PRPDN2 prpdn2}) {
    createGrnShipAddress.ShippingAddress.CityName = prpdn2.CityName.toString();
    createGrnShipAddress.ShippingAddress.hasCreated = prpdn2.hasCreated;
    createGrnShipAddress.ShippingAddress.hasUpdated = prpdn2.hasUpdated;
    createGrnShipAddress.ShippingAddress.CityCode = prpdn2.CityCode.toString();
    createGrnShipAddress.ShippingAddress.Addres = prpdn2.Address.toString();
    createGrnShipAddress.ShippingAddress.CountryName =
        prpdn2.CountryName.toString();
    createGrnShipAddress.ShippingAddress.CountryCode =
        prpdn2.CountryCode.toString();
    createGrnShipAddress.ShippingAddress.StateName =
        prpdn2.StateName.toString();
    createGrnShipAddress.ShippingAddress.RouteCode =
        prpdn2.RouteCode.toString();
    createGrnShipAddress.ShippingAddress.StateCode =
        prpdn2.StateCode.toString();
    createGrnShipAddress.ShippingAddress.Latitude =
        double.tryParse(prpdn2.Latitude.toString()) ?? 0.0;
    createGrnShipAddress.ShippingAddress.Longitude =
        double.tryParse(prpdn2.Longitude.toString()) ?? 0.0;
    createGrnShipAddress.ShippingAddress.RowId =
        int.parse(prpdn2.RowId.toString());
    createGrnShipAddress.ShippingAddress.AddCode =
        prpdn2.AddressCode.toString();
  }

  static setBillingAddressTextFields({required PRPDN3 prpdn3}) {
    createGrnBillAddress.BillingAddress.CityName = prpdn3.CityName.toString();
    createGrnBillAddress.BillingAddress.hasCreated = prpdn3.hasCreated;
    createGrnBillAddress.BillingAddress.hasUpdated = prpdn3.hasUpdated;
    createGrnBillAddress.BillingAddress.CityCode = prpdn3.CityCode.toString();
    createGrnBillAddress.BillingAddress.Addres = prpdn3.Address.toString();
    createGrnBillAddress.BillingAddress.CountryName =
        prpdn3.CountryName.toString();
    createGrnBillAddress.BillingAddress.CountryCode =
        prpdn3.CountryCode.toString();
    createGrnBillAddress.BillingAddress.StateName = prpdn3.StateName.toString();
    createGrnBillAddress.BillingAddress.StateCode = prpdn3.StateCode.toString();
    createGrnBillAddress.BillingAddress.Latitude =
        double.tryParse(prpdn3.Latitude.toString()) ?? 0.0;
    createGrnBillAddress.BillingAddress.Longitude =
        double.tryParse(prpdn3.Longitude.toString()) ?? 0.0;
    createGrnBillAddress.BillingAddress.RowId =
        int.parse(prpdn3.RowId.toString());
    createGrnBillAddress.BillingAddress.AddCode = prpdn3.AddressCode.toString();
  }

  static clearEditItems() {
    createGrnEditItems.EditItems.id = '';
    createGrnEditItems.EditItems.tripTransId = '';
    createGrnEditItems.EditItems.supplierCode = '';
    createGrnEditItems.EditItems.supplierName = '';
    createGrnEditItems.EditItems.truckNo = '';
    createGrnEditItems.EditItems.toWhsCode = '';
    createGrnEditItems.EditItems.toWhsName = '';
    createGrnEditItems.EditItems.driverCode = '';
    createGrnEditItems.EditItems.driverName = '';
    createGrnEditItems.EditItems.routeCode = '';
    createGrnEditItems.EditItems.routeName = '';
    createGrnEditItems.EditItems.transId = '';
    createGrnEditItems.EditItems.rowId = '';
    createGrnEditItems.EditItems.itemCode = '';
    createGrnEditItems.EditItems.itemName = '';
    createGrnEditItems.EditItems.consumptionQty = '';
    createGrnEditItems.EditItems.uomCode = '';
    createGrnEditItems.EditItems.uomName = '';
    createGrnEditItems.EditItems.deptCode = '';
    createGrnEditItems.EditItems.deptName = '';
    createGrnEditItems.EditItems.price = '';
    createGrnEditItems.EditItems.mtv = '';
    createGrnEditItems.EditItems.taxCode = '';
    createGrnEditItems.EditItems.taxRate = '';
    createGrnEditItems.EditItems.lineDiscount = '';
    createGrnEditItems.EditItems.lineTotal = '';
    createGrnEditItems.EditItems.isUpdating = false;
  }
}

class ClearCreateGRNDocument {
  static clearGeneralDataTextFields() {
    createGrnGenData.GeneralData.iD = '';
    createGrnGenData.GeneralData.transId = '';
    createGrnGenData.GeneralData.cardCode = '';
    createGrnGenData.GeneralData.cardName = '';
    createGrnGenData.GeneralData.refNo = '';
    createGrnGenData.GeneralData.contactPersonId = '';
    createGrnGenData.GeneralData.contactPersonName = '';
    createGrnGenData.GeneralData.mobileNo = '';
    createGrnGenData.GeneralData.postingDate = getFormattedDate(DateTime.now());
    createGrnGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    createGrnGenData.GeneralData.currency = userModel.Currency;
    createGrnGenData.GeneralData.currRate = userModel.Rate;
    createGrnGenData.GeneralData.paymentTermCode = '';
    createGrnGenData.GeneralData.paymentTermName = '';
    createGrnGenData.GeneralData.paymentTermDays = '';
    createGrnGenData.GeneralData.approvalStatus = 'Pending';
    createGrnGenData.GeneralData.docStatus = 'Open';
    createGrnGenData.GeneralData.rPTransId = '';
    createGrnGenData.GeneralData.dSTranId = '';
    createGrnGenData.GeneralData.cRTransId = '';
    createGrnGenData.GeneralData.baseTab = '';
    createGrnGenData.GeneralData.totBDisc = '';
    createGrnGenData.GeneralData.discPer = '';
    createGrnGenData.GeneralData.discVal = '';
    createGrnGenData.GeneralData.taxVal = '';
    createGrnGenData.GeneralData.docTotal = '';
    createGrnGenData.GeneralData.permanentTransId = '';
    createGrnGenData.GeneralData.docEntry = '';
    createGrnGenData.GeneralData.docNum = '';
    createGrnGenData.GeneralData.createdBy = '';
    createGrnGenData.GeneralData.createDate = '';
    createGrnGenData.GeneralData.updateDate = '';
    createGrnGenData.GeneralData.approvedBy = '';
    createGrnGenData.GeneralData.latitude = '';
    createGrnGenData.GeneralData.longitude = '';
    createGrnGenData.GeneralData.updatedBy = '';
    createGrnGenData.GeneralData.branchId = '';
    createGrnGenData.GeneralData.remarks = '';
    createGrnGenData.GeneralData.localDate = '';
    createGrnGenData.GeneralData.whsCode = '';
    createGrnGenData.GeneralData.objectCode = '';
    createGrnGenData.GeneralData.error = '';
    createGrnGenData.GeneralData.postingAddress = '';
    createGrnGenData.GeneralData.tripTransId = '';
    createGrnGenData.GeneralData.deptCode = '';
    createGrnGenData.GeneralData.deptName = '';
    createGrnGenData.GeneralData.isSelected = false;
    createGrnGenData.GeneralData.hasCreated = false;
    createGrnGenData.GeneralData.hasUpdated = false;
  }

  static setGeneralDataTextFields({required PROPDN data}) {
    createGrnGenData.GeneralData.iD = data.ID?.toString() ?? '';
    createGrnGenData.GeneralData.transId = data.TransId ?? '';
    createGrnGenData.GeneralData.cardCode = data.CardCode ?? '';
    createGrnGenData.GeneralData.cardName = data.CardName ?? '';
    createGrnGenData.GeneralData.refNo = data.RefNo ?? '';
    createGrnGenData.GeneralData.contactPersonId =
        data.ContactPersonId?.toString() ?? '';
    createGrnGenData.GeneralData.contactPersonName =
        data.ContactPersonName ?? '';
    createGrnGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    createGrnGenData.GeneralData.postingDate =
        getFormattedDate(data.PostingDate);
    createGrnGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    createGrnGenData.GeneralData.currency = data.Currency ?? '';
    createGrnGenData.GeneralData.currRate =
        data.CurrRate?.toStringAsFixed(2) ?? '1';
    createGrnGenData.GeneralData.paymentTermCode = data.PaymentTermCode ?? '';
    createGrnGenData.GeneralData.paymentTermName = data.PaymentTermName ?? '';
    createGrnGenData.GeneralData.paymentTermDays =
        data.PaymentTermDays?.toString() ?? '';
    createGrnGenData.GeneralData.approvalStatus =
        data.ApprovalStatus ?? 'Pending';
    createGrnGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    createGrnGenData.GeneralData.rPTransId = data.RPTransId ?? '';
    createGrnGenData.GeneralData.dSTranId = data.DSTranId ?? '';
    createGrnGenData.GeneralData.cRTransId = data.CRTransId ?? '';
    createGrnGenData.GeneralData.baseTab = data.BaseTab ?? '';
    createGrnGenData.GeneralData.totBDisc =
        data.TotBDisc?.toStringAsFixed(2) ?? '';
    createGrnGenData.GeneralData.discPer =
        data.DiscPer?.toStringAsFixed(2) ?? '';
    createGrnGenData.GeneralData.discVal =
        data.DiscVal?.toStringAsFixed(2) ?? '';
    createGrnGenData.GeneralData.taxVal = data.TaxVal?.toStringAsFixed(2) ?? '';
    createGrnGenData.GeneralData.docTotal =
        data.DocTotal?.toStringAsFixed(2) ?? '';
    createGrnGenData.GeneralData.permanentTransId = data.PermanentTransId ?? '';
    createGrnGenData.GeneralData.docEntry = data.DocEntry?.toString() ?? '';
    createGrnGenData.GeneralData.docNum = data.DocNum ?? '';
    createGrnGenData.GeneralData.createdBy = data.CreatedBy ?? '';
    createGrnGenData.GeneralData.createDate = getFormattedDate(data.CreateDate);
    createGrnGenData.GeneralData.updateDate = data.UpdatedBy ?? '';
    createGrnGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    createGrnGenData.GeneralData.latitude = data.TransId ?? '';
    createGrnGenData.GeneralData.longitude = data.Latitude ?? '';
    createGrnGenData.GeneralData.updatedBy = data.Longitude ?? '';
    createGrnGenData.GeneralData.branchId = data.BranchId ?? '';
    createGrnGenData.GeneralData.remarks = data.Remarks ?? '';
    createGrnGenData.GeneralData.localDate = data.LocalDate ?? '';
    createGrnGenData.GeneralData.whsCode = data.WhsCode ?? '';
    createGrnGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    createGrnGenData.GeneralData.error = data.Error ?? '';
    createGrnGenData.GeneralData.postingAddress = data.PostingAddress ?? '';
    createGrnGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    createGrnGenData.GeneralData.deptCode = data.DeptCode ?? '';
    createGrnGenData.GeneralData.deptName = data.DeptName ?? '';
    createGrnGenData.GeneralData.isSelected = true;
    createGrnGenData.GeneralData.hasCreated = data.hasCreated;
    createGrnGenData.GeneralData.hasUpdated = data.hasUpdated;
  }

  static clearShippingAddressTextFields() {
//todo:
  }

  static clearBillingAddressTextFields() {
//todo:
  }

  static setShippingAddressTextFields({required PRPDN2 prpdn2}) {
    createGrnShipAddress.ShippingAddress.CityName = prpdn2.CityName.toString();
    createGrnShipAddress.ShippingAddress.hasCreated = prpdn2.hasCreated;
    createGrnShipAddress.ShippingAddress.hasUpdated = prpdn2.hasUpdated;
    createGrnShipAddress.ShippingAddress.CityCode = prpdn2.CityCode.toString();
    createGrnShipAddress.ShippingAddress.Addres = prpdn2.Address.toString();
    createGrnShipAddress.ShippingAddress.CountryName =
        prpdn2.CountryName.toString();
    createGrnShipAddress.ShippingAddress.CountryCode =
        prpdn2.CountryCode.toString();
    createGrnShipAddress.ShippingAddress.StateName =
        prpdn2.StateName.toString();
    createGrnShipAddress.ShippingAddress.RouteCode =
        prpdn2.RouteCode.toString();
    createGrnShipAddress.ShippingAddress.StateCode =
        prpdn2.StateCode.toString();
    createGrnShipAddress.ShippingAddress.Latitude =
        double.tryParse(prpdn2.Latitude.toString()) ?? 0.0;
    createGrnShipAddress.ShippingAddress.Longitude =
        double.tryParse(prpdn2.Longitude.toString()) ?? 0.0;
    createGrnShipAddress.ShippingAddress.RowId =
        int.parse(prpdn2.RowId.toString());
    createGrnShipAddress.ShippingAddress.AddCode =
        prpdn2.AddressCode.toString();
  }

  static setBillingAddressTextFields({required PRPDN3 prpdn3}) {
    createGrnBillAddress.BillingAddress.CityName = prpdn3.CityName.toString();
    createGrnBillAddress.BillingAddress.hasCreated = prpdn3.hasCreated;
    createGrnBillAddress.BillingAddress.hasUpdated = prpdn3.hasUpdated;
    createGrnBillAddress.BillingAddress.CityCode = prpdn3.CityCode.toString();
    createGrnBillAddress.BillingAddress.Addres = prpdn3.Address.toString();
    createGrnBillAddress.BillingAddress.CountryName =
        prpdn3.CountryName.toString();
    createGrnBillAddress.BillingAddress.CountryCode =
        prpdn3.CountryCode.toString();
    createGrnBillAddress.BillingAddress.StateName = prpdn3.StateName.toString();
    createGrnBillAddress.BillingAddress.StateCode = prpdn3.StateCode.toString();
    createGrnBillAddress.BillingAddress.Latitude =
        double.tryParse(prpdn3.Latitude.toString()) ?? 0.0;
    createGrnBillAddress.BillingAddress.Longitude =
        double.tryParse(prpdn3.Longitude.toString()) ?? 0.0;
    createGrnBillAddress.BillingAddress.RowId =
        int.parse(prpdn3.RowId.toString());
    createGrnBillAddress.BillingAddress.AddCode = prpdn3.AddressCode.toString();
  }

  static clearEditItems() {
    createGrnEditItems.EditItems.id = '';
    createGrnEditItems.EditItems.tripTransId = '';
    createGrnEditItems.EditItems.supplierCode = '';
    createGrnEditItems.EditItems.supplierName = '';
    createGrnEditItems.EditItems.truckNo = '';
    createGrnEditItems.EditItems.toWhsCode = '';
    createGrnEditItems.EditItems.toWhsName = '';
    createGrnEditItems.EditItems.driverCode = '';
    createGrnEditItems.EditItems.driverName = '';
    createGrnEditItems.EditItems.routeCode = '';
    createGrnEditItems.EditItems.routeName = '';
    createGrnEditItems.EditItems.transId = '';
    createGrnEditItems.EditItems.rowId = '';
    createGrnEditItems.EditItems.itemCode = '';
    createGrnEditItems.EditItems.itemName = '';
    createGrnEditItems.EditItems.consumptionQty = '';
    createGrnEditItems.EditItems.uomCode = '';
    createGrnEditItems.EditItems.uomName = '';
    createGrnEditItems.EditItems.deptCode = '';
    createGrnEditItems.EditItems.deptName = '';
    createGrnEditItems.EditItems.price = '';
    createGrnEditItems.EditItems.mtv = '';
    createGrnEditItems.EditItems.taxCode = '';
    createGrnEditItems.EditItems.taxRate = '';
    createGrnEditItems.EditItems.lineDiscount = '';
    createGrnEditItems.EditItems.lineTotal = '';
    createGrnEditItems.EditItems.isUpdating = false;
  }
}

class ClearEditGRNDocument {
  static clearGeneralDataTextFields() {
    editGrnGenData.GeneralData.iD = '';
    editGrnGenData.GeneralData.transId = '';
    editGrnGenData.GeneralData.cardCode = '';
    editGrnGenData.GeneralData.cardName = '';
    editGrnGenData.GeneralData.refNo = '';
    editGrnGenData.GeneralData.contactPersonId = '';
    editGrnGenData.GeneralData.contactPersonName = '';
    editGrnGenData.GeneralData.mobileNo = '';
    editGrnGenData.GeneralData.postingDate = getFormattedDate(DateTime.now());
    editGrnGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    editGrnGenData.GeneralData.currency = userModel.Currency;
    editGrnGenData.GeneralData.currRate = userModel.Rate;
    editGrnGenData.GeneralData.paymentTermCode = '';
    editGrnGenData.GeneralData.paymentTermName = '';
    editGrnGenData.GeneralData.paymentTermDays = '';
    editGrnGenData.GeneralData.approvalStatus = 'Pending';
    editGrnGenData.GeneralData.docStatus = 'Open';
    editGrnGenData.GeneralData.rPTransId = '';
    editGrnGenData.GeneralData.dSTranId = '';
    editGrnGenData.GeneralData.cRTransId = '';
    editGrnGenData.GeneralData.baseTab = '';
    editGrnGenData.GeneralData.totBDisc = '';
    editGrnGenData.GeneralData.discPer = '';
    editGrnGenData.GeneralData.discVal = '';
    editGrnGenData.GeneralData.taxVal = '';
    editGrnGenData.GeneralData.docTotal = '';
    editGrnGenData.GeneralData.permanentTransId = '';
    editGrnGenData.GeneralData.docEntry = '';
    editGrnGenData.GeneralData.docNum = '';
    editGrnGenData.GeneralData.createdBy = '';
    editGrnGenData.GeneralData.createDate = '';
    editGrnGenData.GeneralData.updateDate = '';
    editGrnGenData.GeneralData.approvedBy = '';
    editGrnGenData.GeneralData.latitude = '';
    editGrnGenData.GeneralData.longitude = '';
    editGrnGenData.GeneralData.updatedBy = '';
    editGrnGenData.GeneralData.branchId = '';
    editGrnGenData.GeneralData.remarks = '';
    editGrnGenData.GeneralData.localDate = '';
    editGrnGenData.GeneralData.whsCode = '';
    editGrnGenData.GeneralData.objectCode = '';
    editGrnGenData.GeneralData.error = '';
    editGrnGenData.GeneralData.postingAddress = '';
    editGrnGenData.GeneralData.tripTransId = '';
    editGrnGenData.GeneralData.deptCode = '';
    editGrnGenData.GeneralData.deptName = '';
    editGrnGenData.GeneralData.isSelected = false;
    editGrnGenData.GeneralData.hasCreated = false;
    editGrnGenData.GeneralData.hasUpdated = false;
  }

  static setGeneralDataTextFields({required PROPDN data}) {
    editGrnGenData.GeneralData.iD = data.ID?.toString() ?? '';
    editGrnGenData.GeneralData.transId = data.TransId ?? '';
    editGrnGenData.GeneralData.cardCode = data.CardCode ?? '';
    editGrnGenData.GeneralData.cardName = data.CardName ?? '';
    editGrnGenData.GeneralData.refNo = data.RefNo ?? '';
    editGrnGenData.GeneralData.contactPersonId =
        data.ContactPersonId?.toString() ?? '';
    editGrnGenData.GeneralData.contactPersonName = data.ContactPersonName ?? '';
    editGrnGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    editGrnGenData.GeneralData.postingDate = getFormattedDate(data.PostingDate);
    editGrnGenData.GeneralData.validUntill = getFormattedDate(data.ValidUntill);
    editGrnGenData.GeneralData.currency = data.Currency ?? '';
    editGrnGenData.GeneralData.currRate =
        data.CurrRate?.toStringAsFixed(2) ?? '1';
    editGrnGenData.GeneralData.paymentTermCode = data.PaymentTermCode ?? '';
    editGrnGenData.GeneralData.paymentTermName = data.PaymentTermName ?? '';
    editGrnGenData.GeneralData.paymentTermDays =
        data.PaymentTermDays?.toString() ?? '';
    editGrnGenData.GeneralData.approvalStatus =
        data.ApprovalStatus ?? 'Pending';
    editGrnGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    editGrnGenData.GeneralData.rPTransId = data.RPTransId ?? '';
    editGrnGenData.GeneralData.dSTranId = data.DSTranId ?? '';
    editGrnGenData.GeneralData.cRTransId = data.CRTransId ?? '';
    editGrnGenData.GeneralData.baseTab = data.BaseTab ?? '';
    editGrnGenData.GeneralData.totBDisc =
        data.TotBDisc?.toStringAsFixed(2) ?? '';
    editGrnGenData.GeneralData.discPer = data.DiscPer?.toStringAsFixed(2) ?? '';
    editGrnGenData.GeneralData.discVal = data.DiscVal?.toStringAsFixed(2) ?? '';
    editGrnGenData.GeneralData.taxVal = data.TaxVal?.toStringAsFixed(2) ?? '';
    editGrnGenData.GeneralData.docTotal =
        data.DocTotal?.toStringAsFixed(2) ?? '';
    editGrnGenData.GeneralData.permanentTransId = data.PermanentTransId ?? '';
    editGrnGenData.GeneralData.docEntry = data.DocEntry?.toString() ?? '';
    editGrnGenData.GeneralData.docNum = data.DocNum ?? '';
    editGrnGenData.GeneralData.createdBy = data.CreatedBy ?? '';
    editGrnGenData.GeneralData.createDate = getFormattedDate(data.CreateDate);
    editGrnGenData.GeneralData.updateDate = data.UpdatedBy ?? '';
    editGrnGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    editGrnGenData.GeneralData.latitude = data.TransId ?? '';
    editGrnGenData.GeneralData.longitude = data.Latitude ?? '';
    editGrnGenData.GeneralData.updatedBy = data.Longitude ?? '';
    editGrnGenData.GeneralData.branchId = data.BranchId ?? '';
    editGrnGenData.GeneralData.remarks = data.Remarks ?? '';
    editGrnGenData.GeneralData.localDate = data.LocalDate ?? '';
    editGrnGenData.GeneralData.whsCode = data.WhsCode ?? '';
    editGrnGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    editGrnGenData.GeneralData.error = data.Error ?? '';
    editGrnGenData.GeneralData.postingAddress = data.PostingAddress ?? '';
    editGrnGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    editGrnGenData.GeneralData.deptCode = data.DeptCode ?? '';
    editGrnGenData.GeneralData.deptName = data.DeptName ?? '';
    editGrnGenData.GeneralData.isSelected = true;
    editGrnGenData.GeneralData.hasCreated = data.hasCreated;
    editGrnGenData.GeneralData.hasUpdated = data.hasUpdated;
  }

  static clearShippingAddressTextFields() {
//todo:
  }

  static clearBillingAddressTextFields() {
//todo:
  }

  static setShippingAddressTextFields({required PRPDN2 prpdn2}) {
    editGrnShipAddress.ShippingAddress.CityName = prpdn2.CityName.toString();
    editGrnShipAddress.ShippingAddress.hasCreated = prpdn2.hasCreated;
    editGrnShipAddress.ShippingAddress.hasUpdated = prpdn2.hasUpdated;
    editGrnShipAddress.ShippingAddress.CityCode = prpdn2.CityCode.toString();
    editGrnShipAddress.ShippingAddress.Addres = prpdn2.Address.toString();
    editGrnShipAddress.ShippingAddress.CountryName =
        prpdn2.CountryName.toString();
    editGrnShipAddress.ShippingAddress.CountryCode =
        prpdn2.CountryCode.toString();
    editGrnShipAddress.ShippingAddress.StateName = prpdn2.StateName.toString();
    editGrnShipAddress.ShippingAddress.RouteCode = prpdn2.RouteCode.toString();
    editGrnShipAddress.ShippingAddress.StateCode = prpdn2.StateCode.toString();
    editGrnShipAddress.ShippingAddress.Latitude =
        double.tryParse(prpdn2.Latitude.toString()) ?? 0.0;
    editGrnShipAddress.ShippingAddress.Longitude =
        double.tryParse(prpdn2.Longitude.toString()) ?? 0.0;
    editGrnShipAddress.ShippingAddress.RowId =
        int.parse(prpdn2.RowId.toString());
    editGrnShipAddress.ShippingAddress.AddCode = prpdn2.AddressCode.toString();
  }

  static setBillingAddressTextFields({required PRPDN3 prpdn3}) {
    editGrnBillAddress.BillingAddress.CityName = prpdn3.CityName.toString();
    editGrnBillAddress.BillingAddress.hasCreated = prpdn3.hasCreated;
    editGrnBillAddress.BillingAddress.hasUpdated = prpdn3.hasUpdated;
    editGrnBillAddress.BillingAddress.CityCode = prpdn3.CityCode.toString();
    editGrnBillAddress.BillingAddress.Addres = prpdn3.Address.toString();
    editGrnBillAddress.BillingAddress.CountryName =
        prpdn3.CountryName.toString();
    editGrnBillAddress.BillingAddress.CountryCode =
        prpdn3.CountryCode.toString();
    editGrnBillAddress.BillingAddress.StateName = prpdn3.StateName.toString();
    editGrnBillAddress.BillingAddress.StateCode = prpdn3.StateCode.toString();
    editGrnBillAddress.BillingAddress.Latitude =
        double.tryParse(prpdn3.Latitude.toString()) ?? 0.0;
    editGrnBillAddress.BillingAddress.Longitude =
        double.tryParse(prpdn3.Longitude.toString()) ?? 0.0;
    editGrnBillAddress.BillingAddress.RowId =
        int.parse(prpdn3.RowId.toString());
    editGrnBillAddress.BillingAddress.AddCode = prpdn3.AddressCode.toString();
  }

  static clearEditItems() {
    editGrnEditItems.EditItems.id = '';
    editGrnEditItems.EditItems.tripTransId = '';
    editGrnEditItems.EditItems.supplierCode = '';
    editGrnEditItems.EditItems.supplierName = '';
    editGrnEditItems.EditItems.truckNo = '';
    editGrnEditItems.EditItems.toWhsCode = '';
    editGrnEditItems.EditItems.toWhsName = '';
    editGrnEditItems.EditItems.driverCode = '';
    editGrnEditItems.EditItems.driverName = '';
    editGrnEditItems.EditItems.routeCode = '';
    editGrnEditItems.EditItems.routeName = '';
    editGrnEditItems.EditItems.transId = '';
    editGrnEditItems.EditItems.rowId = '';
    editGrnEditItems.EditItems.itemCode = '';
    editGrnEditItems.EditItems.itemName = '';
    editGrnEditItems.EditItems.consumptionQty = '';
    editGrnEditItems.EditItems.uomCode = '';
    editGrnEditItems.EditItems.uomName = '';
    editGrnEditItems.EditItems.deptCode = '';
    editGrnEditItems.EditItems.deptName = '';
    editGrnEditItems.EditItems.price = '';
    editGrnEditItems.EditItems.mtv = '';
    editGrnEditItems.EditItems.taxCode = '';
    editGrnEditItems.EditItems.taxRate = '';
    editGrnEditItems.EditItems.lineDiscount = '';
    editGrnEditItems.EditItems.lineTotal = '';
    editGrnEditItems.EditItems.isUpdating = false;
  }
}

class ClearViewGRNDocument {
  static clearGeneralDataTextFields() {
    viewGrnGenData.GeneralData.iD = '';
    viewGrnGenData.GeneralData.transId = '';
    viewGrnGenData.GeneralData.cardCode = '';
    viewGrnGenData.GeneralData.cardName = '';
    viewGrnGenData.GeneralData.refNo = '';
    viewGrnGenData.GeneralData.contactPersonId = '';
    viewGrnGenData.GeneralData.contactPersonName = '';
    viewGrnGenData.GeneralData.mobileNo = '';
    viewGrnGenData.GeneralData.postingDate = getFormattedDate(DateTime.now());
    viewGrnGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    viewGrnGenData.GeneralData.currency = userModel.Currency;
    viewGrnGenData.GeneralData.currRate = userModel.Rate;
    viewGrnGenData.GeneralData.paymentTermCode = '';
    viewGrnGenData.GeneralData.paymentTermName = '';
    viewGrnGenData.GeneralData.paymentTermDays = '';
    viewGrnGenData.GeneralData.approvalStatus = 'Pending';
    viewGrnGenData.GeneralData.docStatus = 'Open';
    viewGrnGenData.GeneralData.rPTransId = '';
    viewGrnGenData.GeneralData.dSTranId = '';
    viewGrnGenData.GeneralData.cRTransId = '';
    viewGrnGenData.GeneralData.baseTab = '';
    viewGrnGenData.GeneralData.totBDisc = '';
    viewGrnGenData.GeneralData.discPer = '';
    viewGrnGenData.GeneralData.discVal = '';
    viewGrnGenData.GeneralData.taxVal = '';
    viewGrnGenData.GeneralData.docTotal = '';
    viewGrnGenData.GeneralData.permanentTransId = '';
    viewGrnGenData.GeneralData.docEntry = '';
    viewGrnGenData.GeneralData.docNum = '';
    viewGrnGenData.GeneralData.createdBy = '';
    viewGrnGenData.GeneralData.createDate = '';
    viewGrnGenData.GeneralData.updateDate = '';
    viewGrnGenData.GeneralData.approvedBy = '';
    viewGrnGenData.GeneralData.latitude = '';
    viewGrnGenData.GeneralData.longitude = '';
    viewGrnGenData.GeneralData.updatedBy = '';
    viewGrnGenData.GeneralData.branchId = '';
    viewGrnGenData.GeneralData.remarks = '';
    viewGrnGenData.GeneralData.localDate = '';
    viewGrnGenData.GeneralData.whsCode = '';
    viewGrnGenData.GeneralData.objectCode = '';
    viewGrnGenData.GeneralData.error = '';
    viewGrnGenData.GeneralData.postingAddress = '';
    viewGrnGenData.GeneralData.tripTransId = '';
    viewGrnGenData.GeneralData.deptCode = '';
    viewGrnGenData.GeneralData.deptName = '';
    viewGrnGenData.GeneralData.isSelected = false;
    viewGrnGenData.GeneralData.hasCreated = false;
    viewGrnGenData.GeneralData.hasUpdated = false;
  }

  static setGeneralDataTextFields({required PROPDN data}) {
    viewGrnGenData.GeneralData.iD = data.ID?.toString() ?? '';
    viewGrnGenData.GeneralData.transId = data.TransId ?? '';
    viewGrnGenData.GeneralData.cardCode = data.CardCode ?? '';
    viewGrnGenData.GeneralData.cardName = data.CardName ?? '';
    viewGrnGenData.GeneralData.refNo = data.RefNo ?? '';
    viewGrnGenData.GeneralData.contactPersonId =
        data.ContactPersonId?.toString() ?? '';
    viewGrnGenData.GeneralData.contactPersonName = data.ContactPersonName ?? '';
    viewGrnGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    viewGrnGenData.GeneralData.postingDate = getFormattedDate(data.PostingDate);
    viewGrnGenData.GeneralData.validUntill = getFormattedDate(data.ValidUntill);
    viewGrnGenData.GeneralData.currency = data.Currency ?? '';
    viewGrnGenData.GeneralData.currRate =
        data.CurrRate?.toStringAsFixed(2) ?? '1';
    viewGrnGenData.GeneralData.paymentTermCode = data.PaymentTermCode ?? '';
    viewGrnGenData.GeneralData.paymentTermName = data.PaymentTermName ?? '';
    viewGrnGenData.GeneralData.paymentTermDays =
        data.PaymentTermDays?.toString() ?? '';
    viewGrnGenData.GeneralData.approvalStatus =
        data.ApprovalStatus ?? 'Pending';
    viewGrnGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    viewGrnGenData.GeneralData.rPTransId = data.RPTransId ?? '';
    viewGrnGenData.GeneralData.dSTranId = data.DSTranId ?? '';
    viewGrnGenData.GeneralData.cRTransId = data.CRTransId ?? '';
    viewGrnGenData.GeneralData.baseTab = data.BaseTab ?? '';
    viewGrnGenData.GeneralData.totBDisc =
        data.TotBDisc?.toStringAsFixed(2) ?? '';
    viewGrnGenData.GeneralData.discPer = data.DiscPer?.toStringAsFixed(2) ?? '';
    viewGrnGenData.GeneralData.discVal = data.DiscVal?.toStringAsFixed(2) ?? '';
    viewGrnGenData.GeneralData.taxVal = data.TaxVal?.toStringAsFixed(2) ?? '';
    viewGrnGenData.GeneralData.docTotal =
        data.DocTotal?.toStringAsFixed(2) ?? '';
    viewGrnGenData.GeneralData.permanentTransId = data.PermanentTransId ?? '';
    viewGrnGenData.GeneralData.docEntry = data.DocEntry?.toString() ?? '';
    viewGrnGenData.GeneralData.docNum = data.DocNum ?? '';
    viewGrnGenData.GeneralData.createdBy = data.CreatedBy ?? '';
    viewGrnGenData.GeneralData.createDate = getFormattedDate(data.CreateDate);
    viewGrnGenData.GeneralData.updateDate = data.UpdatedBy ?? '';
    viewGrnGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    viewGrnGenData.GeneralData.latitude = data.TransId ?? '';
    viewGrnGenData.GeneralData.longitude = data.Latitude ?? '';
    viewGrnGenData.GeneralData.updatedBy = data.Longitude ?? '';
    viewGrnGenData.GeneralData.branchId = data.BranchId ?? '';
    viewGrnGenData.GeneralData.remarks = data.Remarks ?? '';
    viewGrnGenData.GeneralData.localDate = data.LocalDate ?? '';
    viewGrnGenData.GeneralData.whsCode = data.WhsCode ?? '';
    viewGrnGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    viewGrnGenData.GeneralData.error = data.Error ?? '';
    viewGrnGenData.GeneralData.postingAddress = data.PostingAddress ?? '';
    viewGrnGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    viewGrnGenData.GeneralData.deptCode = data.DeptCode ?? '';
    viewGrnGenData.GeneralData.deptName = data.DeptName ?? '';
    viewGrnGenData.GeneralData.isSelected = true;
    viewGrnGenData.GeneralData.hasCreated = data.hasCreated;
    viewGrnGenData.GeneralData.hasUpdated = data.hasUpdated;
  }

  static clearShippingAddressTextFields() {
//todo:
  }

  static clearBillingAddressTextFields() {
//todo:
  }

  static setShippingAddressTextFields({required PRPDN2 prpdn2}) {
    viewGrnShipAddress.ShippingAddress.CityName = prpdn2.CityName.toString();
    viewGrnShipAddress.ShippingAddress.hasCreated = prpdn2.hasCreated;
    viewGrnShipAddress.ShippingAddress.hasUpdated = prpdn2.hasUpdated;
    viewGrnShipAddress.ShippingAddress.CityCode = prpdn2.CityCode.toString();
    viewGrnShipAddress.ShippingAddress.Addres = prpdn2.Address.toString();
    viewGrnShipAddress.ShippingAddress.CountryName =
        prpdn2.CountryName.toString();
    viewGrnShipAddress.ShippingAddress.CountryCode =
        prpdn2.CountryCode.toString();
    viewGrnShipAddress.ShippingAddress.StateName = prpdn2.StateName.toString();
    viewGrnShipAddress.ShippingAddress.RouteCode = prpdn2.RouteCode.toString();
    viewGrnShipAddress.ShippingAddress.StateCode = prpdn2.StateCode.toString();
    viewGrnShipAddress.ShippingAddress.Latitude =
        double.tryParse(prpdn2.Latitude.toString()) ?? 0.0;
    viewGrnShipAddress.ShippingAddress.Longitude =
        double.tryParse(prpdn2.Longitude.toString()) ?? 0.0;
    viewGrnShipAddress.ShippingAddress.RowId =
        int.parse(prpdn2.RowId.toString());
    viewGrnShipAddress.ShippingAddress.AddCode = prpdn2.AddressCode.toString();
  }

  static setBillingAddressTextFields({required PRPDN3 prpdn3}) {
    viewGrnBillAddress.BillingAddress.CityName = prpdn3.CityName.toString();
    viewGrnBillAddress.BillingAddress.hasCreated = prpdn3.hasCreated;
    viewGrnBillAddress.BillingAddress.hasUpdated = prpdn3.hasUpdated;
    viewGrnBillAddress.BillingAddress.CityCode = prpdn3.CityCode.toString();
    viewGrnBillAddress.BillingAddress.Addres = prpdn3.Address.toString();
    viewGrnBillAddress.BillingAddress.CountryName =
        prpdn3.CountryName.toString();
    viewGrnBillAddress.BillingAddress.CountryCode =
        prpdn3.CountryCode.toString();
    viewGrnBillAddress.BillingAddress.StateName = prpdn3.StateName.toString();
    viewGrnBillAddress.BillingAddress.StateCode = prpdn3.StateCode.toString();
    viewGrnBillAddress.BillingAddress.Latitude =
        double.tryParse(prpdn3.Latitude.toString()) ?? 0.0;
    viewGrnBillAddress.BillingAddress.Longitude =
        double.tryParse(prpdn3.Longitude.toString()) ?? 0.0;
    viewGrnBillAddress.BillingAddress.RowId =
        int.parse(prpdn3.RowId.toString());
    viewGrnBillAddress.BillingAddress.AddCode = prpdn3.AddressCode.toString();
  }
}

goToNewGRNDocument() async {
  await ClearGRNDocument.clearGeneralDataTextFields();
  await ClearGRNDocument.clearEditItems();
  createGrnItemDetails.ItemDetails.items.clear();

  getLastDocNum("PR", null).then((snapshot) async {
    int DocNum = snapshot[0].DocNumber - 1;

    do {
      DocNum += 1;
      createGrnGenData.GeneralData.transId =
          DateTime.now().millisecondsSinceEpoch.toString() +
              "U0" +
              userModel.ID.toString() +
              "_" +
              snapshot[0].DocName +
              "GR" +
              "/" +
              DocNum.toString();
    } while (await isPROPRQTransIdAvailable(
        null, createGrnGenData.GeneralData.transId ?? ""));
    print(createGrnGenData.GeneralData.transId);
    Get.offAll(() => GoodsRecepitNote(0));
  });
}

navigateToGoodsReceiptNoteDocument(
    {required String TransId, required bool isView}) async {
  if (isView) {
    List<PROPDN> list =
        await retrievePROPDNById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearViewGRNDocument.setGeneralDataTextFields(data: list[0]);
    }
    List<PRPDN2> PRPDN2List =
        await retrievePRPDN2ById(null, 'TransId = ?', [TransId]);
    if (PRPDN2List.isNotEmpty) {
      ClearViewGRNDocument.setShippingAddressTextFields(prpdn2: PRPDN2List[0]);
    }
    List<PRPDN3> PRPDN3List =
        await retrievePRPDN3ById(null, 'TransId = ?', [TransId]);
    if (PRPDN3List.isNotEmpty) {
      ClearViewGRNDocument.setBillingAddressTextFields(prpdn3: PRPDN3List[0]);
    }
    viewGrnItemDetails.ItemDetails.items =
        await retrievePRPDN1ById(null, 'TransId = ?', [TransId]);

    Get.offAll(() => ViewGoodsRecepitNote(0));
  } else {
    List<PROPDN> list =
        await retrievePROPDNById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearEditGRNDocument.setGeneralDataTextFields(data: list[0]);
    }
    List<PRPDN2> PRPDN2List =
        await retrievePRPDN2ById(null, 'TransId = ?', [TransId]);
    if (PRPDN2List.isNotEmpty) {
      ClearEditGRNDocument.setShippingAddressTextFields(prpdn2: PRPDN2List[0]);
    }
    List<PRPDN3> PRPDN3List =
        await retrievePRPDN3ById(null, 'TransId = ?', [TransId]);
    if (PRPDN3List.isNotEmpty) {
      ClearEditGRNDocument.setBillingAddressTextFields(prpdn3: PRPDN3List[0]);
    }
    editGrnItemDetails.ItemDetails.items =
        await retrievePRPDN1ById(null, 'TransId = ?', [TransId]);

    Get.offAll(() => EditGoodsRecepitNote(0));
  }
}

class ClearCreateInternalRequestDocument {
  static clearGeneralDataTextFields() {
    createInternalGenData.GeneralData.iD = '';
    createInternalGenData.GeneralData.transId = '';
    createInternalGenData.GeneralData.requestedCode = userModel.EmpCode;
    createInternalGenData.GeneralData.requestedName = userModel.EmpName;
    createInternalGenData.GeneralData.refNo = '';
    createInternalGenData.GeneralData.mobileNo = userModel.MobileNo;
    createInternalGenData.GeneralData.postingDate =
        getFormattedDate(DateTime.now());
    createInternalGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    createInternalGenData.GeneralData.currency = userModel.Currency;
    createInternalGenData.GeneralData.currRate = userModel.Rate;
    createInternalGenData.GeneralData.approvalStatus = 'Pending';
    createInternalGenData.GeneralData.docStatus = 'Open';
    createInternalGenData.GeneralData.permanentTransId = '';
    createInternalGenData.GeneralData.docEntry = '';
    createInternalGenData.GeneralData.docNum = '';
    createInternalGenData.GeneralData.createdBy = '';

    createInternalGenData.GeneralData.approvedBy = '';
    createInternalGenData.GeneralData.error = '';
    createInternalGenData.GeneralData.isPosted = false;
    createInternalGenData.GeneralData.draftKey = '';
    createInternalGenData.GeneralData.latitude = '';
    createInternalGenData.GeneralData.longitude = '';
    createInternalGenData.GeneralData.objectCode = '';
    createInternalGenData.GeneralData.fromWhsCode = '';
    createInternalGenData.GeneralData.toWhsCode = '';
    createInternalGenData.GeneralData.remarks = '';
    createInternalGenData.GeneralData.branchId = '';
    createInternalGenData.GeneralData.updatedBy = '';
    createInternalGenData.GeneralData.postingAddress = '';
    createInternalGenData.GeneralData.tripTransId = '';
    createInternalGenData.GeneralData.deptCode = '';
    createInternalGenData.GeneralData.deptName = '';
    createInternalGenData.GeneralData.isSelected = false;
    createInternalGenData.GeneralData.hasCreated = false;
    createInternalGenData.GeneralData.hasUpdated = false;
  }

  static setGeneralDataTextFields({required PROITR data}) {
    createInternalGenData.GeneralData.iD = data.ID?.toString() ?? '';
    createInternalGenData.GeneralData.transId = data.TransId ?? '';
    createInternalGenData.GeneralData.requestedCode = data.RequestedCode;
    createInternalGenData.GeneralData.requestedName = data.RequestedName;
    createInternalGenData.GeneralData.refNo = data.RefNo ?? '';
    createInternalGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    createInternalGenData.GeneralData.postingDate =
        getFormattedDate(data.PostingDate);
    createInternalGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    createInternalGenData.GeneralData.currency = data.Currency;
    createInternalGenData.GeneralData.currRate =
        data.CurrRate?.toString() ?? '1';
    createInternalGenData.GeneralData.approvalStatus =
        data.ApprovalStatus ?? 'Pending';
    createInternalGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    createInternalGenData.GeneralData.permanentTransId =
        data.PermanentTransId ?? '';
    createInternalGenData.GeneralData.docEntry =
        data.DocEntry?.toString() ?? '';
    createInternalGenData.GeneralData.docNum = data.DocNum ?? '';
    createInternalGenData.GeneralData.createdBy = data.CreatedBy ?? '';

    createInternalGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    createInternalGenData.GeneralData.error = data.Error ?? '';
    createInternalGenData.GeneralData.isPosted = data.IsPosted ?? false;
    createInternalGenData.GeneralData.draftKey = data.DraftKey ?? '';
    createInternalGenData.GeneralData.latitude = data.Latitude ?? '';
    createInternalGenData.GeneralData.longitude = data.Longitude ?? '';
    createInternalGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    createInternalGenData.GeneralData.fromWhsCode = data.FromWhsCode ?? '';
    createInternalGenData.GeneralData.toWhsCode = data.ToWhsCode ?? '';
    createInternalGenData.GeneralData.remarks = data.Remarks ?? '';
    createInternalGenData.GeneralData.branchId = data.BranchId ?? '';
    createInternalGenData.GeneralData.updatedBy = data.UpdatedBy ?? '';
    createInternalGenData.GeneralData.postingAddress =
        data.PostingAddress ?? '';
    createInternalGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    createInternalGenData.GeneralData.deptCode = data.DeptCode ?? '';
    createInternalGenData.GeneralData.deptName = data.DeptName ?? '';
    createInternalGenData.GeneralData.isSelected = true;
    createInternalGenData.GeneralData.hasCreated = data.hasCreated;
    createInternalGenData.GeneralData.hasUpdated = data.hasUpdated;
  }

  static clearEditItems() {
    createInternalEditItems.EditItems.id = '';
    createInternalEditItems.EditItems.tripTransId = '';
    createInternalEditItems.EditItems.fromWhsCode = '';

    createInternalEditItems.EditItems.truckNo = '';
    createInternalEditItems.EditItems.toWhsCode = '';
    createInternalEditItems.EditItems.toWhsName = '';
    createInternalEditItems.EditItems.driverCode = '';
    createInternalEditItems.EditItems.driverName = '';
    createInternalEditItems.EditItems.routeCode = '';
    createInternalEditItems.EditItems.routeName = '';
    createInternalEditItems.EditItems.transId = '';
    createInternalEditItems.EditItems.rowId = '';
    createInternalEditItems.EditItems.itemCode = '';
    createInternalEditItems.EditItems.itemName = '';
    createInternalEditItems.EditItems.consumptionQty = '';
    createInternalEditItems.EditItems.uomCode = '';
    createInternalEditItems.EditItems.uomName = '';
    createInternalEditItems.EditItems.deptCode = '';
    createInternalEditItems.EditItems.deptName = '';
    createInternalEditItems.EditItems.price = '';
    createInternalEditItems.EditItems.mtv = '';
    createInternalEditItems.EditItems.taxCode = '';
    createInternalEditItems.EditItems.taxRate = '';
    createInternalEditItems.EditItems.lineDiscount = '';
    createInternalEditItems.EditItems.lineTotal = '';
    createInternalEditItems.EditItems.isUpdating = false;
  }
}

class ClearViewInternalRequestDocument {
  static clearGeneralDataTextFields() {
    createInternalGenData.GeneralData.iD = '';
    createInternalGenData.GeneralData.transId = '';
    createInternalGenData.GeneralData.requestedCode = userModel.EmpCode;
    createInternalGenData.GeneralData.requestedName = userModel.EmpName;
    createInternalGenData.GeneralData.refNo = '';
    createInternalGenData.GeneralData.mobileNo = userModel.MobileNo;
    createInternalGenData.GeneralData.postingDate =
        getFormattedDate(DateTime.now());
    createInternalGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    createInternalGenData.GeneralData.currency = userModel.Currency;
    createInternalGenData.GeneralData.currRate = userModel.Rate;
    createInternalGenData.GeneralData.approvalStatus = 'Pending';
    createInternalGenData.GeneralData.docStatus = 'Open';
    createInternalGenData.GeneralData.permanentTransId = '';
    createInternalGenData.GeneralData.docEntry = '';
    createInternalGenData.GeneralData.docNum = '';
    createInternalGenData.GeneralData.createdBy = '';

    createInternalGenData.GeneralData.approvedBy = '';
    createInternalGenData.GeneralData.error = '';
    createInternalGenData.GeneralData.isPosted = false;
    createInternalGenData.GeneralData.draftKey = '';
    createInternalGenData.GeneralData.latitude = '';
    createInternalGenData.GeneralData.longitude = '';
    createInternalGenData.GeneralData.objectCode = '';
    createInternalGenData.GeneralData.fromWhsCode = '';
    createInternalGenData.GeneralData.toWhsCode = '';
    createInternalGenData.GeneralData.remarks = '';
    createInternalGenData.GeneralData.branchId = '';
    createInternalGenData.GeneralData.updatedBy = '';
    createInternalGenData.GeneralData.postingAddress = '';
    createInternalGenData.GeneralData.tripTransId = '';
    createInternalGenData.GeneralData.deptCode = '';
    createInternalGenData.GeneralData.deptName = '';
    createInternalGenData.GeneralData.isSelected = false;
    createInternalGenData.GeneralData.hasCreated = false;
    createInternalGenData.GeneralData.hasUpdated = false;
  }

  static setGeneralDataTextFields({required PROITR data}) {
    createInternalGenData.GeneralData.iD = data.ID?.toString() ?? '';
    createInternalGenData.GeneralData.transId = data.TransId ?? '';
    createInternalGenData.GeneralData.requestedCode = data.RequestedCode;
    createInternalGenData.GeneralData.requestedName = data.RequestedName;
    createInternalGenData.GeneralData.refNo = data.RefNo ?? '';
    createInternalGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    createInternalGenData.GeneralData.postingDate =
        getFormattedDate(data.PostingDate);
    createInternalGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    createInternalGenData.GeneralData.currency = data.Currency;
    createInternalGenData.GeneralData.currRate =
        data.CurrRate?.toString() ?? '1';
    createInternalGenData.GeneralData.approvalStatus =
        data.ApprovalStatus ?? 'Pending';
    createInternalGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    createInternalGenData.GeneralData.permanentTransId =
        data.PermanentTransId ?? '';
    createInternalGenData.GeneralData.docEntry =
        data.DocEntry?.toString() ?? '';
    createInternalGenData.GeneralData.docNum = data.DocNum ?? '';
    createInternalGenData.GeneralData.createdBy = data.CreatedBy ?? '';

    createInternalGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    createInternalGenData.GeneralData.error = data.Error ?? '';
    createInternalGenData.GeneralData.isPosted = data.IsPosted ?? false;
    createInternalGenData.GeneralData.draftKey = data.DraftKey ?? '';
    createInternalGenData.GeneralData.latitude = data.Latitude ?? '';
    createInternalGenData.GeneralData.longitude = data.Longitude ?? '';
    createInternalGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    createInternalGenData.GeneralData.fromWhsCode = data.FromWhsCode ?? '';
    createInternalGenData.GeneralData.toWhsCode = data.ToWhsCode ?? '';
    createInternalGenData.GeneralData.remarks = data.Remarks ?? '';
    createInternalGenData.GeneralData.branchId = data.BranchId ?? '';
    createInternalGenData.GeneralData.updatedBy = data.UpdatedBy ?? '';
    createInternalGenData.GeneralData.postingAddress =
        data.PostingAddress ?? '';
    createInternalGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    createInternalGenData.GeneralData.deptCode = data.DeptCode ?? '';
    createInternalGenData.GeneralData.deptName = data.DeptName ?? '';
    createInternalGenData.GeneralData.isSelected = true;
    createInternalGenData.GeneralData.hasCreated = data.hasCreated;
    createInternalGenData.GeneralData.hasUpdated = data.hasUpdated;
  }

  static clearEditItems() {
    createInternalEditItems.EditItems.id = '';
    createInternalEditItems.EditItems.tripTransId = '';
    createInternalEditItems.EditItems.fromWhsCode = '';

    createInternalEditItems.EditItems.truckNo = '';
    createInternalEditItems.EditItems.toWhsCode = '';
    createInternalEditItems.EditItems.toWhsName = '';
    createInternalEditItems.EditItems.driverCode = '';
    createInternalEditItems.EditItems.driverName = '';
    createInternalEditItems.EditItems.routeCode = '';
    createInternalEditItems.EditItems.routeName = '';
    createInternalEditItems.EditItems.transId = '';
    createInternalEditItems.EditItems.rowId = '';
    createInternalEditItems.EditItems.itemCode = '';
    createInternalEditItems.EditItems.itemName = '';
    createInternalEditItems.EditItems.consumptionQty = '';
    createInternalEditItems.EditItems.uomCode = '';
    createInternalEditItems.EditItems.uomName = '';
    createInternalEditItems.EditItems.deptCode = '';
    createInternalEditItems.EditItems.deptName = '';
    createInternalEditItems.EditItems.price = '';
    createInternalEditItems.EditItems.mtv = '';
    createInternalEditItems.EditItems.taxCode = '';
    createInternalEditItems.EditItems.taxRate = '';
    createInternalEditItems.EditItems.lineDiscount = '';
    createInternalEditItems.EditItems.lineTotal = '';
    createInternalEditItems.EditItems.isUpdating = false;
  }
}

class ClearEditInternalRequestDocument {
  static clearGeneralDataTextFields() {
    createInternalGenData.GeneralData.iD = '';
    createInternalGenData.GeneralData.transId = '';
    createInternalGenData.GeneralData.requestedCode = userModel.EmpCode;
    createInternalGenData.GeneralData.requestedName = userModel.EmpName;
    createInternalGenData.GeneralData.refNo = '';
    createInternalGenData.GeneralData.mobileNo = userModel.MobileNo;
    createInternalGenData.GeneralData.postingDate =
        getFormattedDate(DateTime.now());
    createInternalGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    createInternalGenData.GeneralData.currency = userModel.Currency;
    createInternalGenData.GeneralData.currRate = userModel.Rate;
    createInternalGenData.GeneralData.approvalStatus = 'Pending';
    createInternalGenData.GeneralData.docStatus = 'Open';
    createInternalGenData.GeneralData.permanentTransId = '';
    createInternalGenData.GeneralData.docEntry = '';
    createInternalGenData.GeneralData.docNum = '';
    createInternalGenData.GeneralData.createdBy = '';

    createInternalGenData.GeneralData.approvedBy = '';
    createInternalGenData.GeneralData.error = '';
    createInternalGenData.GeneralData.isPosted = false;
    createInternalGenData.GeneralData.draftKey = '';
    createInternalGenData.GeneralData.latitude = '';
    createInternalGenData.GeneralData.longitude = '';
    createInternalGenData.GeneralData.objectCode = '';
    createInternalGenData.GeneralData.fromWhsCode = '';
    createInternalGenData.GeneralData.toWhsCode = '';
    createInternalGenData.GeneralData.remarks = '';
    createInternalGenData.GeneralData.branchId = '';
    createInternalGenData.GeneralData.updatedBy = '';
    createInternalGenData.GeneralData.postingAddress = '';
    createInternalGenData.GeneralData.tripTransId = '';
    createInternalGenData.GeneralData.deptCode = '';
    createInternalGenData.GeneralData.deptName = '';
    createInternalGenData.GeneralData.isSelected = false;
    createInternalGenData.GeneralData.hasCreated = false;
    createInternalGenData.GeneralData.hasUpdated = false;
  }

  static setGeneralDataTextFields({required PROITR data}) {
    createInternalGenData.GeneralData.iD = data.ID?.toString() ?? '';
    createInternalGenData.GeneralData.transId = data.TransId ?? '';
    createInternalGenData.GeneralData.requestedCode = data.RequestedCode;
    createInternalGenData.GeneralData.requestedName = data.RequestedName;
    createInternalGenData.GeneralData.refNo = data.RefNo ?? '';
    createInternalGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    createInternalGenData.GeneralData.postingDate =
        getFormattedDate(data.PostingDate);
    createInternalGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    createInternalGenData.GeneralData.currency = data.Currency;
    createInternalGenData.GeneralData.currRate =
        data.CurrRate?.toString() ?? '1';
    createInternalGenData.GeneralData.approvalStatus =
        data.ApprovalStatus ?? 'Pending';
    createInternalGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    createInternalGenData.GeneralData.permanentTransId =
        data.PermanentTransId ?? '';
    createInternalGenData.GeneralData.docEntry =
        data.DocEntry?.toString() ?? '';
    createInternalGenData.GeneralData.docNum = data.DocNum ?? '';
    createInternalGenData.GeneralData.createdBy = data.CreatedBy ?? '';

    createInternalGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    createInternalGenData.GeneralData.error = data.Error ?? '';
    createInternalGenData.GeneralData.isPosted = data.IsPosted ?? false;
    createInternalGenData.GeneralData.draftKey = data.DraftKey ?? '';
    createInternalGenData.GeneralData.latitude = data.Latitude ?? '';
    createInternalGenData.GeneralData.longitude = data.Longitude ?? '';
    createInternalGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    createInternalGenData.GeneralData.fromWhsCode = data.FromWhsCode ?? '';
    createInternalGenData.GeneralData.toWhsCode = data.ToWhsCode ?? '';
    createInternalGenData.GeneralData.remarks = data.Remarks ?? '';
    createInternalGenData.GeneralData.branchId = data.BranchId ?? '';
    createInternalGenData.GeneralData.updatedBy = data.UpdatedBy ?? '';
    createInternalGenData.GeneralData.postingAddress =
        data.PostingAddress ?? '';
    createInternalGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    createInternalGenData.GeneralData.deptCode = data.DeptCode ?? '';
    createInternalGenData.GeneralData.deptName = data.DeptName ?? '';
    createInternalGenData.GeneralData.isSelected = true;
    createInternalGenData.GeneralData.hasCreated = data.hasCreated;
    createInternalGenData.GeneralData.hasUpdated = data.hasUpdated;
  }

  static clearEditItems() {
    createInternalEditItems.EditItems.id = '';
    createInternalEditItems.EditItems.tripTransId = '';
    createInternalEditItems.EditItems.fromWhsCode = '';

    createInternalEditItems.EditItems.truckNo = '';
    createInternalEditItems.EditItems.toWhsCode = '';
    createInternalEditItems.EditItems.toWhsName = '';
    createInternalEditItems.EditItems.driverCode = '';
    createInternalEditItems.EditItems.driverName = '';
    createInternalEditItems.EditItems.routeCode = '';
    createInternalEditItems.EditItems.routeName = '';
    createInternalEditItems.EditItems.transId = '';
    createInternalEditItems.EditItems.rowId = '';
    createInternalEditItems.EditItems.itemCode = '';
    createInternalEditItems.EditItems.itemName = '';
    createInternalEditItems.EditItems.consumptionQty = '';
    createInternalEditItems.EditItems.uomCode = '';
    createInternalEditItems.EditItems.uomName = '';
    createInternalEditItems.EditItems.deptCode = '';
    createInternalEditItems.EditItems.deptName = '';
    createInternalEditItems.EditItems.price = '';
    createInternalEditItems.EditItems.mtv = '';
    createInternalEditItems.EditItems.taxCode = '';
    createInternalEditItems.EditItems.taxRate = '';
    createInternalEditItems.EditItems.lineDiscount = '';
    createInternalEditItems.EditItems.lineTotal = '';
    createInternalEditItems.EditItems.isUpdating = false;
  }
}

goToNewInternalRequestDocument() async {
  await ClearCreateInternalRequestDocument.clearGeneralDataTextFields();
  await ClearCreateInternalRequestDocument.clearEditItems();
  createInternalItemDetails.ItemDetails.items.clear();
  getLastDocNum("PRST", null).then((snapshot) async {
    int DocNum = snapshot[0].DocNumber - 1;
    do {
      DocNum += 1;
      createInternalGenData.GeneralData.transId =
          DateTime.now().millisecondsSinceEpoch.toString() +
              "U0" +
              userModel.ID.toString() +
              "_" +
              snapshot[0].DocName +
              "/" +
              DocNum.toString();
    } while (await isPROPRQTransIdAvailable(
        null, createInternalGenData.GeneralData.transId ?? ""));
    print(createInternalGenData.GeneralData.transId);
    Get.offAll(() => InternalRequest(0));
  });
}

navigateToInternalRequestDocument(
    {required String TransId, required bool isView}) async {
  if (isView) {
    await ClearViewInternalRequestDocument.clearGeneralDataTextFields();
    await ClearViewInternalRequestDocument.clearEditItems();
    List<PROITR> list =
        await retrievePROITRById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearViewInternalRequestDocument.setGeneralDataTextFields(data: list[0]);
    }
    viewInternalItemDetails.ItemDetails.items =
        await retrievePRITR1ById(null, 'TransId = ?', [TransId]);

    Get.offAll(() => ViewInternalRequest(0));
  } else {
    await ClearEditInternalRequestDocument.clearGeneralDataTextFields();
    await ClearEditInternalRequestDocument.clearEditItems();
    List<PROITR> list =
        await retrievePROITRById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearEditInternalRequestDocument.setGeneralDataTextFields(data: list[0]);
    }
    editInternalItemDetails.ItemDetails.items =
        await retrievePRITR1ById(null, 'TransId = ?', [TransId]);

    Get.offAll(() => EditInternalRequest(0));
  }
}
