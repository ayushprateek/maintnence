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
import 'package:maintenance/JobCard/ServiceDetails/EditService.dart' as editJCDService;
import 'package:maintenance/JobCard/ItemDetails/ItemDetails.dart'
as jcdItemDetails;
import 'package:maintenance/JobCard/ServiceDetails/ServiceDetails.dart'
as jcdServiceDetails;
import 'package:maintenance/JobCard/JobCard.dart';
import 'package:maintenance/Purchase/PurchaseRequest/PurchaseRequest.dart';
import 'package:maintenance/main.dart';
//------------------------------ GOODS ISSUE IMPORTS------------
import 'package:maintenance/GoodsIssue/GeneralData.dart' as goodsGenData;
import 'package:maintenance/GoodsIssue/ItemDetails/EditItems.dart' as goodsEditItems;
import 'package:maintenance/GoodsIssue/ItemDetails/ItemDetails.dart' as goodsItemDetails;

//------------------------------ PURCHASE REQUEST IMPORTS------------
import 'package:maintenance/Purchase/PurchaseRequest/GeneralData.dart' as purchaseGenData;
import 'package:maintenance/Purchase/PurchaseRequest/ItemDetails/EditItems.dart' as purchaseEditItems;
import 'package:maintenance/Purchase/PurchaseRequest/ItemDetails/ItemDetails.dart' as purchaseItemDetails;


//------------------------------ GOODS RECEIPT NOTES------------
import 'package:maintenance/GoodsReceiptNote/GeneralData.dart' as grnGenData;
import 'package:maintenance/Purchase/PurchaseRequest/ItemDetails/EditItems.dart' as grnEditItems;
import 'package:maintenance/GoodsReceiptNote/ItemDetails/ItemDetails.dart' as grnItemDetails;


//------------------------------ INTERNAL REQUEST------------
import 'package:maintenance/InternalRequest/GeneralData.dart' as internalGenData;
import 'package:maintenance/InternalRequest/ItemDetails/EditItems.dart' as internalEditItems;
import 'package:maintenance/InternalRequest/ItemDetails/ItemDetails.dart' as internalItemDetails;

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
    jcdGenData.GeneralData.isSelected = false;
    jcdGenData.GeneralData.hasCreated = false;
    jcdGenData.GeneralData.hasUpdated = false;
    jcdGenData.GeneralData.warranty = 'Yes';
    jcdGenData.GeneralData.type = 'Preventive';
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

class ClearGoodsIssueDocument {
  static clearGeneralDataTextFields() {
    goodsGenData.GeneralData.iD = '';
    goodsGenData.GeneralData.transId = '';
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
  static clearEditItems() {
    purchaseEditItems.EditItems.id='';
    purchaseEditItems.EditItems.tripTransId='';
    purchaseEditItems.EditItems.supplierCode='';
    purchaseEditItems.EditItems.supplierName='';
    purchaseEditItems.EditItems.truckNo='';
    purchaseEditItems.EditItems.toWhsCode='';
    purchaseEditItems.EditItems.toWhsName='';
    purchaseEditItems.EditItems.driverCode='';
    purchaseEditItems.EditItems.driverName='';
    purchaseEditItems.EditItems.routeCode='';
    purchaseEditItems.EditItems.routeName='';
    purchaseEditItems.EditItems.transId='';
    purchaseEditItems.EditItems.rowId='';
    purchaseEditItems.EditItems.itemCode='';
    purchaseEditItems.EditItems.itemName='';
    purchaseEditItems.EditItems.consumptionQty='';
    purchaseEditItems.EditItems.uomCode='';
    purchaseEditItems.EditItems.uomName='';
    purchaseEditItems.EditItems.deptCode='';
    purchaseEditItems.EditItems.deptName='';
    purchaseEditItems.EditItems.price='';
    purchaseEditItems.EditItems.mtv='';
    purchaseEditItems.EditItems.taxCode='';
    purchaseEditItems.EditItems.taxRate='';
    purchaseEditItems.EditItems.lineDiscount='';
    purchaseEditItems.EditItems.lineTotal='';
    purchaseEditItems.EditItems.isUpdating = false;
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
              snapshot[0].DocName+"PR" +
              "/" +
              DocNum.toString();
    } while (await isPROPRQTransIdAvailable(
        null, purchaseGenData.GeneralData.transId ?? ""));
    print(purchaseGenData.GeneralData.transId);

    Get.offAll(() => PurchaseRequest(0));
  });
}


class ClearGRNDocument {

  static clearGeneralDataTextFields(){
    grnGenData.GeneralData.iD='';
    grnGenData.GeneralData.transId='';
    grnGenData.GeneralData.cardCode='';
    grnGenData.GeneralData.cardName='';
    grnGenData.GeneralData.refNo='';
    grnGenData.GeneralData.contactPersonId='';
    grnGenData.GeneralData.contactPersonName='';
    grnGenData.GeneralData.mobileNo='';
    grnGenData.GeneralData.postingDate=getFormattedDate(DateTime.now());
    grnGenData.GeneralData.validUntill=getFormattedDate(DateTime.now().add(Duration(days: 7)));
    grnGenData.GeneralData.currency=userModel.Currency;
    grnGenData.GeneralData.currRate=userModel.Rate;
    grnGenData.GeneralData.paymentTermCode='';
    grnGenData.GeneralData.paymentTermName='';
    grnGenData.GeneralData.paymentTermDays='';
    grnGenData.GeneralData.approvalStatus='Pending';
    grnGenData.GeneralData.docStatus='Open';
    grnGenData.GeneralData.rPTransId='';
    grnGenData.GeneralData.dSTranId='';
    grnGenData.GeneralData.cRTransId='';
    grnGenData.GeneralData.baseTab='';
    grnGenData.GeneralData.totBDisc='';
    grnGenData.GeneralData.discPer='';
    grnGenData.GeneralData.discVal='';
    grnGenData.GeneralData.taxVal='';
    grnGenData.GeneralData.docTotal='';
    grnGenData.GeneralData.permanentTransId='';
    grnGenData.GeneralData.docEntry='';
    grnGenData.GeneralData.docNum='';
    grnGenData.GeneralData.createdBy='';
    grnGenData.GeneralData.createDate='';
    grnGenData.GeneralData.updateDate='';
    grnGenData.GeneralData.approvedBy='';
    grnGenData.GeneralData.latitude='';
    grnGenData.GeneralData.longitude='';
    grnGenData.GeneralData.updatedBy='';
    grnGenData.GeneralData.branchId='';
    grnGenData.GeneralData.remarks='';
    grnGenData.GeneralData.localDate='';
    grnGenData.GeneralData.whsCode='';
    grnGenData.GeneralData.objectCode='';
    grnGenData.GeneralData.error='';
    grnGenData.GeneralData.postingAddress='';
    grnGenData.GeneralData.tripTransId='';
    grnGenData.GeneralData.deptCode='';
    grnGenData.GeneralData.deptName='';
    grnGenData.GeneralData.isSelected = false;
    grnGenData.GeneralData.hasCreated = false;
    grnGenData.GeneralData.hasUpdated = false;
  }
  static clearEditItems() {
    grnEditItems.EditItems.id='';
    grnEditItems.EditItems.tripTransId='';
    grnEditItems.EditItems.supplierCode='';
    grnEditItems.EditItems.supplierName='';
    grnEditItems.EditItems.truckNo='';
    grnEditItems.EditItems.toWhsCode='';
    grnEditItems.EditItems.toWhsName='';
    grnEditItems.EditItems.driverCode='';
    grnEditItems.EditItems.driverName='';
    grnEditItems.EditItems.routeCode='';
    grnEditItems.EditItems.routeName='';
    grnEditItems.EditItems.transId='';
    grnEditItems.EditItems.rowId='';
    grnEditItems.EditItems.itemCode='';
    grnEditItems.EditItems.itemName='';
    grnEditItems.EditItems.consumptionQty='';
    grnEditItems.EditItems.uomCode='';
    grnEditItems.EditItems.uomName='';
    grnEditItems.EditItems.deptCode='';
    grnEditItems.EditItems.deptName='';
    grnEditItems.EditItems.price='';
    grnEditItems.EditItems.mtv='';
    grnEditItems.EditItems.taxCode='';
    grnEditItems.EditItems.taxRate='';
    grnEditItems.EditItems.lineDiscount='';
    grnEditItems.EditItems.lineTotal='';
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
              snapshot[0].DocName+"GR" +
              "/" +
              DocNum.toString();
    } while (await isPROPRQTransIdAvailable(
        null, grnGenData.GeneralData.transId ?? ""));
    print(grnGenData.GeneralData.transId);
    Get.offAll(() => GoodsRecepitNote(0));
  });
}


class ClearSTRDocument {
  static clearGeneralDataTextFields(){
    internalGenData.GeneralData.iD='';
    internalGenData.GeneralData.transId='';
    internalGenData.GeneralData.requestedCode='';
    internalGenData.GeneralData.requestedName='';
    internalGenData.GeneralData.refNo='';
    internalGenData.GeneralData.mobileNo='';
    internalGenData.GeneralData.postingDate=getFormattedDate(DateTime.now());
    internalGenData.GeneralData.validUntill=getFormattedDate(DateTime.now().add(Duration(days: 7)));
    internalGenData.GeneralData.currency=userModel.Currency;
    internalGenData.GeneralData.currRate=userModel.Rate;
    internalGenData.GeneralData.approvalStatus='Pending';
    internalGenData.GeneralData.docStatus='Open';
    internalGenData.GeneralData.permanentTransId='';
    internalGenData.GeneralData.docEntry='';
    internalGenData.GeneralData.docNum='';
    internalGenData.GeneralData.createdBy='';

    internalGenData.GeneralData.approvedBy='';
    internalGenData.GeneralData.error='';
    internalGenData.GeneralData.isPosted=false;
    internalGenData.GeneralData.draftKey='';
    internalGenData.GeneralData.latitude='';
    internalGenData.GeneralData.longitude='';
    internalGenData.GeneralData.objectCode='';
    internalGenData.GeneralData.fromWhsCode='';
    internalGenData.GeneralData.toWhsCode='';
    internalGenData.GeneralData.remarks='';
    internalGenData.GeneralData.branchId='';
    internalGenData.GeneralData.updatedBy='';
    internalGenData.GeneralData.postingAddress='';
    internalGenData.GeneralData.tripTransId='';
    internalGenData.GeneralData.deptCode='';
    internalGenData.GeneralData.deptName='';
    internalGenData.GeneralData.isSelected = false;
    internalGenData.GeneralData.hasCreated = false;
    internalGenData.GeneralData.hasUpdated = false;
  }


  static clearEditItems() {
    internalEditItems.EditItems.id='';
    internalEditItems.EditItems.tripTransId='';
    internalEditItems.EditItems.fromWhsCode='';

    internalEditItems.EditItems.truckNo='';
    internalEditItems.EditItems.toWhsCode='';
    internalEditItems.EditItems.toWhsName='';
    internalEditItems.EditItems.driverCode='';
    internalEditItems.EditItems.driverName='';
    internalEditItems.EditItems.routeCode='';
    internalEditItems.EditItems.routeName='';
    internalEditItems.EditItems.transId='';
    internalEditItems.EditItems.rowId='';
    internalEditItems.EditItems.itemCode='';
    internalEditItems.EditItems.itemName='';
    internalEditItems.EditItems.consumptionQty='';
    internalEditItems.EditItems.uomCode='';
    internalEditItems.EditItems.uomName='';
    internalEditItems.EditItems.deptCode='';
    internalEditItems.EditItems.deptName='';
    internalEditItems.EditItems.price='';
    internalEditItems.EditItems.mtv='';
    internalEditItems.EditItems.taxCode='';
    internalEditItems.EditItems.taxRate='';
    internalEditItems.EditItems.lineDiscount='';
    internalEditItems.EditItems.lineTotal='';
    internalEditItems.EditItems.isUpdating = false;
  }
}

goToNewSTRDocument() async {
  await ClearSTRDocument.clearGeneralDataTextFields();
  await ClearSTRDocument.clearEditItems();
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
              snapshot[0].DocName+
              "/" +
              DocNum.toString();
    } while (await isPROPRQTransIdAvailable(
        null, internalGenData.GeneralData.transId ?? ""));
    print(internalGenData.GeneralData.transId);
    Get.offAll(() => InternalRequest(0));
  });
}
