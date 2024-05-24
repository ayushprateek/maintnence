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
import 'package:maintenance/main.dart';
//------------------------------ GOODS ISSUE IMPORTS------------
import 'package:maintenance/GoodsIssue/GeneralData.dart' as goodsGenData;
import 'package:maintenance/GoodsIssue/ItemDetails/ItemDetails.dart' as goodsItemDetails;


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

class ClearGoodsIssueDocument{
  static clearGeneralDataTextFields(){
    goodsGenData.GeneralData.iD='';
    goodsGenData.GeneralData.transId='';
    goodsGenData.GeneralData.requestedCode='';
    goodsGenData.GeneralData.requestedName='';
    goodsGenData.GeneralData.refNo='';
    goodsGenData.GeneralData.mobileNo='';
    goodsGenData.GeneralData.postingDate=getFormattedDate(DateTime.now());
    goodsGenData.GeneralData.validUntill=getFormattedDate(DateTime.now().add(Duration(days: 7)));
    goodsGenData.GeneralData.currency=userModel.Currency;
    goodsGenData.GeneralData.currRate=userModel.Rate;
    goodsGenData.GeneralData.approvalStatus='Pending';
    goodsGenData.GeneralData.docStatus='Open';
    goodsGenData.GeneralData.totBDisc='';
    goodsGenData.GeneralData.discPer='';
    goodsGenData.GeneralData.discVal='';
    goodsGenData.GeneralData.taxVal='';
    goodsGenData.GeneralData.docTotal='';
    goodsGenData.GeneralData.permanentTransId='';
    goodsGenData.GeneralData.docEntry='';
    goodsGenData.GeneralData.docNum='';
    goodsGenData.GeneralData.createdBy='';
    goodsGenData.GeneralData.createDate=getFormattedDate(DateTime.now());
    goodsGenData.GeneralData.updateDate=getFormattedDate(DateTime.now().add(Duration(days: 7)));
    goodsGenData.GeneralData.approvedBy='';
    goodsGenData.GeneralData.error='';
    goodsGenData.GeneralData.isPosted=false;
    goodsGenData.GeneralData.draftKey='';
    goodsGenData.GeneralData.latitude='';
    goodsGenData.GeneralData.longitude='';
    goodsGenData.GeneralData.objectCode='';
    goodsGenData.GeneralData.toWhsCode='';
    goodsGenData.GeneralData.remarks='';
    goodsGenData.GeneralData.branchId='';
    goodsGenData.GeneralData.updatedBy='';
    goodsGenData.GeneralData.postingAddress='';
    goodsGenData.GeneralData.tripTransId='';
    goodsGenData.GeneralData.deptCode='';
    goodsGenData.GeneralData.deptName='';
    goodsGenData.GeneralData.isSelected = false;
    goodsGenData.GeneralData.hasCreated = false;
    goodsGenData.GeneralData.hasUpdated = false;
  }
}
goToNewGoodsIssueDocument() async {
  await ClearGoodsIssueDocument.clearGeneralDataTextFields();
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
