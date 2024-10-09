//---------------------------------CREATE JOB CARD IMPORTS
import 'package:get/get.dart';
import 'package:maintenance/Component/CompanyDetails.dart';
import 'package:maintenance/Component/GenerateTransId.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
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
import 'package:maintenance/JobCard/create/WhyWhyAnalysis.dart'
    as jcdCreateWhyWhyAnalysis;
import 'package:maintenance/JobCard/edit/Attachment.dart' as jcdEditAttachment;
//---------------------------------EDIT JOB CARD IMPORTS
import 'package:maintenance/JobCard/edit/GeneralData.dart' as jcdEditGenData;
import 'package:maintenance/JobCard/edit/ItemDetails/ItemDetails.dart'
    as jcdEditItemDetails;
import 'package:maintenance/JobCard/edit/JobCard.dart';
import 'package:maintenance/JobCard/edit/ProblemDetails.dart'
    as jcdEditProblemDetails;
import 'package:maintenance/JobCard/edit/ServiceDetails/ServiceDetails.dart'
    as jcdEditServiceDetails;
import 'package:maintenance/JobCard/edit/WhyWhyAnalysis.dart'
    as jcdEditWhyWhyAnalysis;
import 'package:maintenance/JobCard/view/Attachment.dart' as jcdViewAttachment;
//---------------------------------VIEW JOB CARD IMPORTS
import 'package:maintenance/JobCard/view/GeneralData.dart' as jcdViewGenData;
import 'package:maintenance/JobCard/view/ItemDetails/ItemDetails.dart'
    as jcdViewItemDetails;
import 'package:maintenance/JobCard/view/JobCard.dart';
import 'package:maintenance/JobCard/view/ProblemDetails.dart'
    as jcdViewProblemDetails;
import 'package:maintenance/JobCard/view/ServiceDetails/ServiceDetails.dart'
    as jcdViewServiceDetails;
import 'package:maintenance/JobCard/view/WhyWhyAnalysis.dart'
    as jcdViewWhyWhyAnalysis;
import 'package:maintenance/Sync/SyncModels/MNJCD1.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD2.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD3.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD5.dart';
import 'package:maintenance/Sync/SyncModels/MNJCD6.dart';
import 'package:maintenance/Sync/SyncModels/MNOJCD.dart';
import 'package:maintenance/main.dart';

class ClearJobCardDoc {
  static clearGeneralData() {
    jcdCreateGenData.GeneralData.iD = '';
    jcdCreateGenData.GeneralData.currentReading = '';
    jcdCreateGenData.GeneralData.difference = '';
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
    jcdCreateGenData.GeneralData.subject = '';
    jcdCreateGenData.GeneralData.resolution = '';
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
    jcdCreateGenData.GeneralData.type = 'Breakdown';
    jcdCreateGenData.GeneralData.typeList = ['Breakdown'];
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
        getFormattedDate(mnojcd.LastReadingDate);
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
        getFormattedDate(mnojcd.LastReadingDate);
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


    jcdViewGenData.GeneralData.subject = mnojcd.Subject;
    jcdViewGenData.GeneralData.resolution = mnojcd.Resolution;
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
        getFormattedDate(mnojcd.LastReadingDate);
    jcdEditGenData.GeneralData.subject = mnojcd.Subject;
    jcdEditGenData.GeneralData.resolution = mnojcd.Resolution;
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
    editCreateJCDService.EditService.remarks= '';
    editCreateJCDService.EditService.uom= '';
    editCreateJCDService.EditService.itemCode= '';
    editCreateJCDService.EditService.itemName= '';
    editCreateJCDService.EditService.quantity= '';
    editCreateJCDService.EditService.equipmentCode= '';
    // editCreateJCDService.EditService.equipmentName= '';
    editCreateJCDService.EditService.isUpdating = false;
    editCreateJCDService.EditService.isSendable = false;
    
    editCreateJCDService.EditService.isServiceConfirmation=false;
    editCreateJCDService.EditService.isSendToSupplier= false;
    editCreateJCDService.EditService.isReceiveFromSupplier= false;
    editCreateJCDService.EditService.isPurchaseRequest= false;
    editCreateJCDService.EditService.isPurchaseOrder= false;
  }
}

goToNewJobCardDocument() async {
  await ClearJobCardDoc.clearGeneralData();
  jcdCreateGenData.GeneralData.typeList.clear();
  jcdCreateGenData.GeneralData.typeList = ['Preventive','Breakdown'];
  jcdCreateItemDetails.ItemDetails.items.clear();
  jcdCreateServiceDetails.ServiceDetails.items.clear();
  jcdCreateWhyWhyAnalysis.WhyWhyAnalysis.list.clear();
  double num = double.tryParse(
          CompanyDetails.ocinModel?.NoOfWhyAnalysis?.toString() ?? "") ??
      0.0;
  for (int i = 0; i < num; i++) {
    jcdCreateWhyWhyAnalysis.WhyWhyAnalysis.list
        .add(MNJCD5(insertedIntoDatabase: false));
  }

  String TransId =
      await GenerateTransId.getTransId(tableName: 'MNOJCD', docName: 'MNJC');
  jcdCreateGenData.GeneralData.transId = TransId;
  Get.offAll(() => JobCard(0));
}

navigateToJobCardDocument(
    {required String TransId, required bool isView}) async {
  if (isView) {
    List<MNOJCD> list =
        await retrieveMNOJCDById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearJobCardDoc.setViewJobCardData(mnojcd: list[0]);
    }
    jcdViewItemDetails.ItemDetails.items =
        await retrieveMNJCD1ById(null, 'TransId = ?', [TransId]);
    jcdViewServiceDetails.ServiceDetails.items =
        await retrieveMNJCD2ById(null, 'TransId = ?', [TransId]);
    jcdViewAttachment.Attachments.attachments =
        await retrieveMNJCD3ById(null, 'TransId = ?', [TransId]);
    jcdViewWhyWhyAnalysis.WhyWhyAnalysis.list =
        await retrieveMNJCD5ById(null, 'Code = ?', [TransId]);
    jcdViewProblemDetails.ProblemDetails.list =
        await retrieveMNJCD6ById(null, 'TransId = ?', [TransId]);
    // jcdViewSectionDetails.SectionDetails.list =
    //     await retrieveMNJCD7ById(null, 'TransId = ?', [TransId]);

    Get.offAll(() => ViewJobCard(0));
  } else {
    List<MNOJCD> list =
        await retrieveMNOJCDById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearJobCardDoc.setEditJobCardData(mnojcd: list[0]);
    }
    jcdEditItemDetails.ItemDetails.items =
        await retrieveMNJCD1ById(null, 'TransId = ?', [TransId]);
    jcdEditServiceDetails.ServiceDetails.items =
        await retrieveMNJCD2ById(null, 'TransId = ?', [TransId]);
    jcdEditAttachment.Attachments.attachments =
        await retrieveMNJCD3ById(null, 'TransId = ?', [TransId]);

    jcdEditWhyWhyAnalysis.WhyWhyAnalysis.list =
        await retrieveMNJCD5ById(null, 'Code = ?', [TransId]);
    jcdEditProblemDetails.ProblemDetails.list =
        await retrieveMNJCD6ById(null, 'TransId = ?', [TransId]);
    // jcdEditSectionDetails.SectionDetails.list =
    //     await retrieveMNJCD7ById(null, 'TransId = ?', [TransId]);

    Get.offAll(() => EditJobCard(0));
  }
}
