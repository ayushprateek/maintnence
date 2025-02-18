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
import 'package:maintenance/GoodsIssue/GoodsIssue.dart';
import 'package:maintenance/GoodsReceiptNote/GoodsReceiptNote.dart';
import 'package:maintenance/InternalRequest/InternalRequest.dart';

//---------------------------------JOB CARD IMPORTS
import 'package:maintenance/JobCard/GeneralData.dart' as jcdGenData;
import 'package:maintenance/JobCard/ItemDetails/EditJobCardItem.dart'
    as editJCDItems;
import 'package:maintenance/JobCard/ServiceDetails/EditService.dart'
    as editJCDService;
import 'package:maintenance/JobCard/ItemDetails/ItemDetails.dart'
    as jcdItemDetails;
import 'package:maintenance/JobCard/ServiceDetails/ServiceDetails.dart'
    as jcdServiceDetails;
import 'package:maintenance/JobCard/JobCard.dart';
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

//------------------------------ GOODS ISSUE IMPORTS------------
import 'package:maintenance/GoodsIssue/GeneralData.dart' as goodsGenData;
import 'package:maintenance/GoodsIssue/ItemDetails/EditItems.dart'
    as goodsEditItems;
import 'package:maintenance/GoodsIssue/ItemDetails/ItemDetails.dart'
    as goodsItemDetails;

//------------------------------ PURCHASE REQUEST IMPORTS------------
import 'package:maintenance/Purchase/PurchaseRequest/GeneralData.dart'
    as purchaseGenData;
import 'package:maintenance/Purchase/PurchaseRequest/ItemDetails/EditItems.dart'
    as purchaseEditItems;
import 'package:maintenance/Purchase/PurchaseRequest/ItemDetails/ItemDetails.dart'
    as purchaseItemDetails;

//------------------------------ GOODS RECEIPT NOTES------------
import 'package:maintenance/GoodsReceiptNote/GeneralData.dart' as grnGenData;
import 'package:maintenance/GoodsReceiptNote/Address/ShippingAddress.dart' as grnShipAddress;
import 'package:maintenance/GoodsReceiptNote/Address/BillingAddress.dart' as grnBillAddress;
import 'package:maintenance/Purchase/PurchaseRequest/ItemDetails/EditItems.dart' as grnEditItems;
import 'package:maintenance/GoodsReceiptNote/ItemDetails/ItemDetails.dart'
    as grnItemDetails;

//------------------------------ INTERNAL REQUEST------------
import 'package:maintenance/InternalRequest/GeneralData.dart'
    as internalGenData;
import 'package:maintenance/InternalRequest/ItemDetails/EditItems.dart'
    as internalEditItems;
import 'package:maintenance/InternalRequest/ItemDetails/ItemDetails.dart'
    as internalItemDetails;

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
    checkListDoc.GeneralData.isSelected = false;
    checkListDoc.GeneralData.hasCreated = false;
    checkListDoc.GeneralData.hasUpdated = false;
  }

  static setCheckListDocTextFields({required MNOCLD mnocld}) {
    CheckListDocument.numOfTabs.value = 3;
    checkListDoc.GeneralData.iD = mnocld.ID?.toString()??'0';
    checkListDoc.GeneralData.permanentTransId = mnocld.PermanentTransId??"";
    checkListDoc.GeneralData.transId = mnocld.TransId??'';
    checkListDoc.GeneralData.docEntry = mnocld.DocEntry?.toString()??'';
    checkListDoc.GeneralData.docNum = mnocld.DocNum??'';
    checkListDoc.GeneralData.canceled = mnocld.Canceled??'';
    checkListDoc.GeneralData.docStatus = mnocld.DocStatus??'Open';
    checkListDoc.GeneralData.approvalStatus = mnocld.ApprovalStatus??'Pending';
    checkListDoc.GeneralData.checkListStatus = mnocld.CheckListStatus??'WIP';
    checkListDoc.GeneralData.tyreMaintenance = 'No';
    checkListDoc.GeneralData.objectCode = mnocld.ObjectCode??'';
    checkListDoc.GeneralData.equipmentCode = mnocld.EquipmentCode??'';
    checkListDoc.GeneralData.equipmentName = mnocld.EquipmentName??'';
    checkListDoc.GeneralData.checkListCode = mnocld.CheckListCode??'';
    checkListDoc.GeneralData.checkListName = mnocld.CheckListName??'';
    checkListDoc.GeneralData.workCenterCode = mnocld.WorkCenterCode??'';
    checkListDoc.GeneralData.workCenterName =mnocld.WorkCenterName?? '';
    checkListDoc.GeneralData.openDate = getFormattedDate(mnocld.OpenDate);
    checkListDoc.GeneralData.closeDate = getFormattedDate(mnocld.CloseDate);
    checkListDoc.GeneralData.postingDate = getFormattedDate(mnocld.PostingDate);
    checkListDoc.GeneralData.validUntill =
        getFormattedDate(mnocld.ValidUntill);
    checkListDoc.GeneralData.lastReadingDate = getFormattedDate(mnocld.LastReadingDate);
    checkListDoc.GeneralData.lastReading = mnocld.LastReading??'';
    checkListDoc.GeneralData.assignedUserCode = mnocld.AssignedUserCode??'';
    checkListDoc.GeneralData.assignedUserName = mnocld.AssignedUserName??'';
    checkListDoc.GeneralData.mNJCTransId = mnocld.MNJCTransId??'';
    checkListDoc.GeneralData.remarks = mnocld.Remarks??'';
    checkListDoc.GeneralData.createdBy = mnocld.CreatedBy??'';
    checkListDoc.GeneralData.updatedBy = mnocld.UpdatedBy??'';
    checkListDoc.GeneralData.branchId = mnocld.BranchId??'';
    checkListDoc.GeneralData.createDate = getFormattedDate(mnocld.CreateDate);
    checkListDoc.GeneralData.updateDate = getFormattedDate(mnocld.UpdateDate);
    checkListDoc.GeneralData.currentReading = mnocld.CurrentReading??'';
    checkListDoc.GeneralData.isConsumption = mnocld.IsConsumption??false;
    checkListDoc.GeneralData.isRequest = mnocld.IsRequest??false;
    checkListDoc.GeneralData.isSelected = true;
    checkListDoc.GeneralData.hasCreated = mnocld.hasCreated;
    checkListDoc.GeneralData.hasUpdated = mnocld.hasUpdated;
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

navigateToCheckListDocument({required String TransId}) async {
  List<MNOCLD> list = await retrieveMNOCLDById(null, 'TransId = ?', [TransId]);
  if (list.isNotEmpty) {
    ClearCheckListDoc.setCheckListDocTextFields(mnocld: list[0]);
  }
  checkListDetails.CheckListDetails.items=await retrieveMNCLD1ById(null, 'TransId = ?', [TransId]);
  Get.offAll(()=>CheckListDocument(0));
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
    jcdGenData.GeneralData.isSelected = false;
    jcdGenData.GeneralData.hasCreated = false;
    jcdGenData.GeneralData.hasUpdated = false;
    jcdGenData.GeneralData.warranty = 'Yes';
    jcdGenData.GeneralData.type = 'Preventive';
  }
  static setGeneralData({
    required MNOJCD mnojcd
}) {
    jcdGenData.GeneralData.iD = mnojcd.ID?.toString()??'';
    jcdGenData.GeneralData.permanentTransId = mnojcd.PermanentTransId??'';
    jcdGenData.GeneralData.transId = mnojcd.TransId??'';
    jcdGenData.GeneralData.docEntry = mnojcd.DocEntry?.toString()??'';
    jcdGenData.GeneralData.docNum =mnojcd.DocNum?.toString()?? '';
    jcdGenData.GeneralData.canceled = mnojcd.Canceled??'';
    jcdGenData.GeneralData.docStatus = mnojcd.DocStatus??'Open';
    jcdGenData.GeneralData.approvalStatus = mnojcd.ApprovalStatus??'Pending';
    //todo: SET CHECK LIST STATUS
    jcdGenData.GeneralData.checkListStatus = 'WIP';
    jcdGenData.GeneralData.objectCode = mnojcd.ObjectCode??'';
    jcdGenData.GeneralData.equipmentCode = mnojcd.EquipmentCode??'';
    jcdGenData.GeneralData.equipmentName = mnojcd.EquipmentName??'';
    jcdGenData.GeneralData.checkListCode = mnojcd.CheckListCode??'';
    jcdGenData.GeneralData.checkListName = mnojcd.CheckListName??'';
    jcdGenData.GeneralData.workCenterCode = mnojcd.WorkCenterCode??'';
    jcdGenData.GeneralData.workCenterName = mnojcd.WorkCenterName??'';
    jcdGenData.GeneralData.openDate = getFormattedDate(mnojcd.OpenDate);
    jcdGenData.GeneralData.closeDate = getFormattedDate(mnojcd.CloseDate);
    jcdGenData.GeneralData.postingDate = getFormattedDate(mnojcd.PostingDate);
    jcdGenData.GeneralData.validUntill =
        getFormattedDate(mnojcd.ValidUntill);
    jcdGenData.GeneralData.lastReadingDate = getFormattedDate(mnojcd.LastReading);
    // jcdGenData.GeneralData.lastReading = mnojcd.LastReading??'';
    jcdGenData.GeneralData.assignedUserCode = mnojcd.AssignedUserCode??'';
    jcdGenData.GeneralData.assignedUserName = mnojcd.AssignedUserName??'';
    // jcdGenData.GeneralData.mNJCTransId = mnojcd.MNJ??'';
    jcdGenData.GeneralData.remarks = mnojcd.Remarks??'';
    jcdGenData.GeneralData.createdBy = mnojcd.CreatedBy??'';
    jcdGenData.GeneralData.updatedBy = mnojcd.UpdatedBy??'';
    jcdGenData.GeneralData.branchId = mnojcd.BranchId??'';
    jcdGenData.GeneralData.createDate = getFormattedDate(mnojcd.CreateDate);
    jcdGenData.GeneralData.updateDate = getFormattedDate(mnojcd.UpdateDate);

    jcdGenData.GeneralData.isConsumption =mnojcd.IsConsumption?? false;
    jcdGenData.GeneralData.isRequest = mnojcd.IsRequest??false;
    jcdGenData.GeneralData.isSelected = true;
    jcdGenData.GeneralData.hasCreated = mnojcd.hasCreated;
    jcdGenData.GeneralData.hasUpdated = mnojcd.hasUpdated;
    jcdGenData.GeneralData.warranty = mnojcd.WarrentyApplicable==true?'Yes':'No';
    jcdGenData.GeneralData.type = mnojcd.Type??'Preventive';
    if(mnojcd.Type=='True')
    {
      jcdGenData.GeneralData.type='Preventive';
    }
    else if(mnojcd.Type=='False')
    {
      jcdGenData.GeneralData.type='Breakdown';
    }
  }

  static clearEditItems() {
    editJCDItems.EditJobCardItem.id = '';
    editJCDItems.EditJobCardItem.transId = '';
    editJCDItems.EditJobCardItem.rowId = '';
    editJCDItems.EditJobCardItem.itemCode = '';
    editJCDItems.EditJobCardItem.itemName = '';
    editJCDItems.EditJobCardItem.quantity = '';
    editJCDItems.EditJobCardItem.uomCode = '';
    editJCDItems.EditJobCardItem.uomName = '';
    editJCDItems.EditJobCardItem.supplierName = '';
    editJCDItems.EditJobCardItem.supplierCode = '';
    editJCDItems.EditJobCardItem.requiredDate = '';
    editJCDItems.EditJobCardItem.isChecked = false;
    editJCDItems.EditJobCardItem.fromStock = false;
    editJCDItems.EditJobCardItem.consumption = false;
    editJCDItems.EditJobCardItem.request = false;
    editJCDItems.EditJobCardItem.isUpdating = false;
  }

  static clearEditService() {
    editJCDService.EditService.id = '';
    editJCDService.EditService.transId = '';
    editJCDService.EditService.rowId = '';
    editJCDService.EditService.serviceCode = '';
    editJCDService.EditService.serviceName = '';
    editJCDService.EditService.infoPrice = '';
    editJCDService.EditService.supplierName = '';
    editJCDService.EditService.supplierCode = '';
    editJCDService.EditService.isUpdating = false;
    editJCDService.EditService.isSendable = false;
  }
}

goToNewJobCardDocument() async {
  await ClearJobCardDoc.clearGeneralData();
  jcdItemDetails.ItemDetails.items.clear();
  jcdServiceDetails.ServiceDetails.items.clear();
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
navigateToJobCardDocument({required String TransId}) async {
  List<MNOJCD> list = await retrieveMNOJCDById(null, 'TransId = ?', [TransId]);
  if (list.isNotEmpty) {
    ClearJobCardDoc.setGeneralData(mnojcd: list[0]);
  }
  jcdItemDetails.ItemDetails.items=await retrieveMNJCD1ById(null, 'TransId = ?', [TransId]);
  jcdServiceDetails.ServiceDetails.items=await retrieveMNJCD2ById(null, 'TransId = ?', [TransId]);

  Get.offAll(()=>JobCard(0));
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
  static setGeneralDataTextFields({
    required PROPRQ data
}) {
    purchaseGenData.GeneralData.iD = data.ID?.toString()??'';
    purchaseGenData.GeneralData.transId = data.TransId??'';
    purchaseGenData.GeneralData.refNo = data.RefNo??'';
    purchaseGenData.GeneralData.mobileNo = data.MobileNo??'';
    purchaseGenData.GeneralData.postingDate = getFormattedDate(data.PostingDate);
    purchaseGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    purchaseGenData.GeneralData.approvalStatus = data.ApprovalStatus??'Pending';
    purchaseGenData.GeneralData.docStatus = data.DocStatus??'Open';
    purchaseGenData.GeneralData.permanentTransId = data.PermanentTransId??'';
    purchaseGenData.GeneralData.docEntry = data.DocEntry?.toString()??'';
    purchaseGenData.GeneralData.docNum = data.DocNum??'';
    purchaseGenData.GeneralData.createdBy = data.CreatedBy??'';
    // purchaseGenData.GeneralData.createDate = getFormattedDate(data.CreateDate);
    // purchaseGenData.GeneralData.updateDate = data.TransId??'';
    purchaseGenData.GeneralData.approvedBy = data.ApprovedBy??'';
    purchaseGenData.GeneralData.error = data.Error??'';
    purchaseGenData.GeneralData.isSelected = true;
    purchaseGenData.GeneralData.hasCreated = data.hasCreated;
    purchaseGenData.GeneralData.hasUpdated = data.hasUpdated;
    purchaseGenData.GeneralData.isPosted = data.IsPosted??false;
    purchaseGenData.GeneralData.draftKey = data.DraftKey??'';
    purchaseGenData.GeneralData.latitude = data.Latitude??'';
    purchaseGenData.GeneralData.longitude = data.Longitude??'';
    purchaseGenData.GeneralData.objectCode = data.ObjectCode??'';
    purchaseGenData.GeneralData.whsCode = data.WhsCode??'';
    purchaseGenData.GeneralData.remarks = data.Remarks??'';
    purchaseGenData.GeneralData.branchId = data.BranchId??'';
    purchaseGenData.GeneralData.updatedBy = data.UpdatedBy??'';
    purchaseGenData.GeneralData.postingAddress = data.PostingAddress??'';
    purchaseGenData.GeneralData.tripTransId = data.TripTransId??'';
    purchaseGenData.GeneralData.deptCode = data.DeptCode??'';
    purchaseGenData.GeneralData.deptName = data.DeptName??'';
    purchaseGenData.GeneralData.requestedCode = data.RequestedCode??'';
    purchaseGenData.GeneralData.requestedName = data.RequestedName??'';

    purchaseGenData.GeneralData.isPosted = data.IsPosted??false;

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
  purchaseItemDetails.ItemDetails.items=await retrievePRPRQ1ById(null, 'TransId = ?', [TransId]);

  Get.offAll(()=>PurchaseRequest(0));
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
  static setGeneralDataTextFields({
    required PROPDN data
}) {
    grnGenData.GeneralData.iD = data.ID?.toString()??'';
    grnGenData.GeneralData.transId = data.TransId??'';
    grnGenData.GeneralData.cardCode = data.CardCode??'';
    grnGenData.GeneralData.cardName = data.CardName??'';
    grnGenData.GeneralData.refNo = data.RefNo??'';
    grnGenData.GeneralData.contactPersonId = data.ContactPersonId?.toString()??'';
    grnGenData.GeneralData.contactPersonName = data.ContactPersonName??'';
    grnGenData.GeneralData.mobileNo = data.MobileNo??'';
    grnGenData.GeneralData.postingDate = getFormattedDate(data.PostingDate);
    grnGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    grnGenData.GeneralData.currency = data.Currency??'';
    grnGenData.GeneralData.currRate = data.CurrRate?.toStringAsFixed(2)??'1';
    grnGenData.GeneralData.paymentTermCode = data.PaymentTermCode??'';
    grnGenData.GeneralData.paymentTermName = data.PaymentTermName??'';
    grnGenData.GeneralData.paymentTermDays = data.PaymentTermDays?.toString()??'';
    grnGenData.GeneralData.approvalStatus = data.ApprovalStatus??'Pending';
    grnGenData.GeneralData.docStatus = data.DocStatus??'Open';
    grnGenData.GeneralData.rPTransId = data.RPTransId??'';
    grnGenData.GeneralData.dSTranId = data.DSTranId??'';
    grnGenData.GeneralData.cRTransId = data.CRTransId??'';
    grnGenData.GeneralData.baseTab = data.BaseTab??'';
    grnGenData.GeneralData.totBDisc = data.TotBDisc?.toStringAsFixed(2)??'';
    grnGenData.GeneralData.discPer = data.DiscPer?.toStringAsFixed(2)??'';
    grnGenData.GeneralData.discVal = data.DiscVal?.toStringAsFixed(2)??'';
    grnGenData.GeneralData.taxVal = data.TaxVal?.toStringAsFixed(2)??'';
    grnGenData.GeneralData.docTotal = data.DocTotal?.toStringAsFixed(2)??'';
    grnGenData.GeneralData.permanentTransId = data.PermanentTransId??'';
    grnGenData.GeneralData.docEntry = data.DocEntry?.toString()??'';
    grnGenData.GeneralData.docNum = data.DocNum??'';
    grnGenData.GeneralData.createdBy = data.CreatedBy??'';
    grnGenData.GeneralData.createDate = getFormattedDate(data.CreateDate);
    grnGenData.GeneralData.updateDate = data.UpdatedBy??'';
    grnGenData.GeneralData.approvedBy = data.ApprovedBy??'';
    grnGenData.GeneralData.latitude = data.TransId??'';
    grnGenData.GeneralData.longitude = data.Latitude??'';
    grnGenData.GeneralData.updatedBy = data.Longitude??'';
    grnGenData.GeneralData.branchId = data.BranchId??'';
    grnGenData.GeneralData.remarks = data.Remarks??'';
    grnGenData.GeneralData.localDate = data.LocalDate??'';
    grnGenData.GeneralData.whsCode = data.WhsCode??'';
    grnGenData.GeneralData.objectCode = data.ObjectCode??'';
    grnGenData.GeneralData.error = data.Error??'';
    grnGenData.GeneralData.postingAddress = data.PostingAddress??'';
    grnGenData.GeneralData.tripTransId = data.TripTransId??'';
    grnGenData.GeneralData.deptCode = data.DeptCode??'';
    grnGenData.GeneralData.deptName = data.DeptName??'';
    grnGenData.GeneralData.isSelected = true;
    grnGenData.GeneralData.hasCreated = data.hasCreated;
    grnGenData.GeneralData.hasUpdated = data.hasUpdated;
  }
  static clearShippingAddressTextFields(){
//todo:
  }
  static clearBillingAddressTextFields(){
//todo:
  }
  
  static setShippingAddressTextFields({
    required PRPDN2 prpdn2
}) {


    grnShipAddress.ShippingAddress.CityName =
    prpdn2.CityName.toString();
    grnShipAddress.ShippingAddress.hasCreated = prpdn2.hasCreated;
    grnShipAddress.ShippingAddress.hasUpdated = prpdn2.hasUpdated;
    grnShipAddress.ShippingAddress.CityCode =
    prpdn2.CityCode.toString();
    grnShipAddress.ShippingAddress.Addres = prpdn2.Address.toString();
    grnShipAddress.ShippingAddress.CountryName =
    prpdn2.CountryName.toString();
    grnShipAddress.ShippingAddress.CountryCode =
    prpdn2.CountryCode.toString();
    grnShipAddress.ShippingAddress.StateName =
    prpdn2.StateName.toString();
    grnShipAddress.ShippingAddress.RouteCode =
    prpdn2.RouteCode.toString();
    grnShipAddress.ShippingAddress.StateCode =
    prpdn2.StateCode.toString();
    grnShipAddress.ShippingAddress.Latitude =
    double.tryParse(prpdn2.Latitude.toString()) ??
    0.0;
    grnShipAddress.ShippingAddress.Longitude =
    double.tryParse(prpdn2.Longitude.toString()) ??
    0.0;
    grnShipAddress.ShippingAddress.RowId =
    int.parse(prpdn2.RowId.toString());
    grnShipAddress.ShippingAddress.AddCode =
    prpdn2.AddressCode.toString();
    
  }
  
  static setBillingAddressTextFields({
    required PRPDN3 prpdn3
}) {
    

    grnBillAddress.BillingAddress.CityName =
    prpdn3.CityName.toString();
    grnBillAddress.BillingAddress.hasCreated = prpdn3.hasCreated;
    grnBillAddress.BillingAddress.hasUpdated = prpdn3.hasUpdated;
    grnBillAddress.BillingAddress.CityCode =
    prpdn3.CityCode.toString();
    grnBillAddress.BillingAddress.Addres = prpdn3.Address.toString();
    grnBillAddress.BillingAddress.CountryName =
    prpdn3.CountryName.toString();
    grnBillAddress.BillingAddress.CountryCode =
    prpdn3.CountryCode.toString();
    grnBillAddress.BillingAddress.StateName =
    prpdn3.StateName.toString();
    grnBillAddress.BillingAddress.StateCode =
    prpdn3.StateCode.toString();
    grnBillAddress.BillingAddress.Latitude =
    double.tryParse(prpdn3.Latitude.toString()) ??
    0.0;
    grnBillAddress.BillingAddress.Longitude =
    double.tryParse(prpdn3.Longitude.toString()) ??
    0.0;
    grnBillAddress.BillingAddress.RowId =
    int.parse(prpdn3.RowId.toString());
    grnBillAddress.BillingAddress.AddCode =
    prpdn3.AddressCode.toString();
    
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
  List<PRPDN2> PRPDN2List = await retrievePRPDN2ById(null, 'TransId = ?', [TransId]);
  if (PRPDN2List.isNotEmpty) {
    ClearGRNDocument.setShippingAddressTextFields(prpdn2: PRPDN2List[0]);
  }
  List<PRPDN3> PRPDN3List = await retrievePRPDN3ById(null, 'TransId = ?', [TransId]);
  if (PRPDN3List.isNotEmpty) {
    ClearGRNDocument.setBillingAddressTextFields(prpdn3: PRPDN3List[0]);
  }
  grnItemDetails.ItemDetails.items=await retrievePRPDN1ById(null, 'TransId = ?', [TransId]);


  Get.offAll(()=>GoodsRecepitNote(0));
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
  static setGeneralDataTextFields({
    required PROITR data
}) {
    internalGenData.GeneralData.iD = data.ID?.toString()??'';
    internalGenData.GeneralData.transId = data.TransId??'';
    internalGenData.GeneralData.requestedCode = data.RequestedCode;
    internalGenData.GeneralData.requestedName = data.RequestedName;
    internalGenData.GeneralData.refNo = data.RefNo??'';
    internalGenData.GeneralData.mobileNo = data.MobileNo??'';
    internalGenData.GeneralData.postingDate = getFormattedDate(data.PostingDate);
    internalGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    internalGenData.GeneralData.currency = data.Currency;
    internalGenData.GeneralData.currRate = data.CurrRate?.toString()??'1';
    internalGenData.GeneralData.approvalStatus = data.ApprovalStatus??'Pending';
    internalGenData.GeneralData.docStatus =data.DocStatus?? 'Open';
    internalGenData.GeneralData.permanentTransId = data.PermanentTransId??'';
    internalGenData.GeneralData.docEntry = data.DocEntry?.toString()??'';
    internalGenData.GeneralData.docNum = data.DocNum??'';
    internalGenData.GeneralData.createdBy = data.CreatedBy??'';

    internalGenData.GeneralData.approvedBy = data.ApprovedBy??'';
    internalGenData.GeneralData.error = data.Error??'';
    internalGenData.GeneralData.isPosted = data.IsPosted??false;
    internalGenData.GeneralData.draftKey = data.DraftKey??'';
    internalGenData.GeneralData.latitude = data.Latitude??'';
    internalGenData.GeneralData.longitude = data.Longitude??'';
    internalGenData.GeneralData.objectCode = data.ObjectCode??'';
    internalGenData.GeneralData.fromWhsCode = data.FromWhsCode??'';
    internalGenData.GeneralData.toWhsCode = data.ToWhsCode??'';
    internalGenData.GeneralData.remarks = data.Remarks??'';
    internalGenData.GeneralData.branchId = data.BranchId??'';
    internalGenData.GeneralData.updatedBy = data.UpdatedBy??'';
    internalGenData.GeneralData.postingAddress = data.PostingAddress??'';
    internalGenData.GeneralData.tripTransId = data.TripTransId??'';
    internalGenData.GeneralData.deptCode = data.DeptCode??'';
    internalGenData.GeneralData.deptName = data.DeptName??'';
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
  internalItemDetails.ItemDetails.items=await retrievePRITR1ById(null, 'TransId = ?', [TransId]);


  Get.offAll(()=>InternalRequest(0));
}
