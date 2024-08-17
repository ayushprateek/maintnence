///------------------------------ CREATE ------------------------------
///------------------------------ OTHER ------------------------------
import 'package:get/get.dart';
import 'package:maintenance/CheckListDocument/create/Attachments.dart'
    as createAttachments;
import 'package:maintenance/CheckListDocument/create/CheckListDetails/CheckListDetails.dart'
    as createCheckListDetails;
import 'package:maintenance/CheckListDocument/create/CheckListDetails/EditCheckList.dart'
    as createEditCheckList;
import 'package:maintenance/CheckListDocument/create/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/create/GeneralData.dart'
    as createGeneralData;
///------------------------------ EDIT ------------------------------
import 'package:maintenance/CheckListDocument/edit/CheckListDetails/CheckListDetails.dart'
    as editCheckListDetails;
import 'package:maintenance/CheckListDocument/edit/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/edit/GeneralData.dart'
    as editGeneralData;
///------------------------------ VIEW ------------------------------
import 'package:maintenance/CheckListDocument/view/CheckListDetails/CheckListDetails.dart'
    as viewCheckListDetails;
import 'package:maintenance/CheckListDocument/view/CheckListDocument.dart';
import 'package:maintenance/CheckListDocument/view/GeneralData.dart'
    as viewGeneralData;
import 'package:maintenance/Component/GenerateTransId.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetLastDocNum.dart';
import 'package:maintenance/Component/IsAvailableTransId.dart';
import 'package:maintenance/Sync/SyncModels/MNCLD1.dart';
import 'package:maintenance/Sync/SyncModels/MNOCLD.dart';
import 'package:maintenance/main.dart';

class ClearCreateCheckListDoc {
  static clearGeneralData() {
    CheckListDocument.numOfTabs.value = 3;
    createGeneralData.GeneralData.TripTransId = '';
    createGeneralData.GeneralData.iD = '';
    createGeneralData.GeneralData.permanentTransId = '';
    createGeneralData.GeneralData.transId = '';
    createGeneralData.GeneralData.docEntry = '';
    createGeneralData.GeneralData.docNum = '';
    createGeneralData.GeneralData.canceled = '';
    createGeneralData.GeneralData.docStatus = 'Open';
    createGeneralData.GeneralData.approvalStatus = 'Pending';
    createGeneralData.GeneralData.checkListStatus = 'WIP';
    createGeneralData.GeneralData.tyreMaintenance = 'No';
    createGeneralData.GeneralData.objectCode = '';
    createGeneralData.GeneralData.equipmentCode = '';
    createGeneralData.GeneralData.equipmentName = '';
    createGeneralData.GeneralData.checkListCode = '';
    createGeneralData.GeneralData.checkListName = '';
    createGeneralData.GeneralData.workCenterCode = '';
    createGeneralData.GeneralData.workCenterName = '';
    createGeneralData.GeneralData.openDate = getFormattedDate(DateTime.now());
    createGeneralData.GeneralData.closeDate = getFormattedDate(DateTime.now());
    createGeneralData.GeneralData.postingDate =
        getFormattedDate(DateTime.now());
    createGeneralData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    createGeneralData.GeneralData.lastReadingDate =
        getFormattedDate(DateTime.now());
    createGeneralData.GeneralData.lastReading = '';
    createGeneralData.GeneralData.assignedUserCode = '';
    createGeneralData.GeneralData.assignedUserName = '';
    createGeneralData.GeneralData.mNJCTransId = '';
    createGeneralData.GeneralData.remarks = '';
    createGeneralData.GeneralData.createdBy = '';
    createGeneralData.GeneralData.updatedBy = '';
    createGeneralData.GeneralData.branchId = '';
    createGeneralData.GeneralData.createDate = getFormattedDate(DateTime.now());
    createGeneralData.GeneralData.updateDate = getFormattedDate(DateTime.now());
    createGeneralData.GeneralData.currentReading = '';
    createGeneralData.GeneralData.isConsumption = false;
    createGeneralData.GeneralData.isRequest = false;
    createGeneralData.GeneralData.isSelected = false;
    createGeneralData.GeneralData.hasCreated = false;
    createGeneralData.GeneralData.hasUpdated = false;
  }

  static clearEditCheckList() {
    createEditCheckList.EditCheckList.id = '';
    createEditCheckList.EditCheckList.description = '';
    createEditCheckList.EditCheckList.transId = '';
    createEditCheckList.EditCheckList.rowId = '';
    createEditCheckList.EditCheckList.itemCode = '';
    createEditCheckList.EditCheckList.itemName = '';
    createEditCheckList.EditCheckList.consumptionQty = '';
    createEditCheckList.EditCheckList.uomCode = '';
    createEditCheckList.EditCheckList.uomName = '';
    createEditCheckList.EditCheckList.supplierName = '';
    createEditCheckList.EditCheckList.supplierCode = '';
    createEditCheckList.EditCheckList.userRemarks = '';
    createEditCheckList.EditCheckList.requiredDate = '';
    createEditCheckList.EditCheckList.remark = '';
    createEditCheckList.EditCheckList.isChecked = false;
    createEditCheckList.EditCheckList.fromStock = false;
    createEditCheckList.EditCheckList.consumption = false;
    createEditCheckList.EditCheckList.request = false;
    createEditCheckList.EditCheckList.isUpdating = false;
  }

  static setGeneralData({required MNOCLD mnocld}) {
    CheckListDocument.numOfTabs.value = 3;
    createGeneralData.GeneralData.iD = mnocld.ID?.toString() ?? '0';
    createGeneralData.GeneralData.permanentTransId =
        mnocld.PermanentTransId ?? "";
    createGeneralData.GeneralData.TripTransId = mnocld.TripTransId ?? '';
    createGeneralData.GeneralData.transId = mnocld.TransId ?? '';
    createGeneralData.GeneralData.docEntry = mnocld.DocEntry?.toString() ?? '';
    createGeneralData.GeneralData.docNum = mnocld.DocNum ?? '';
    createGeneralData.GeneralData.canceled = mnocld.Canceled ?? '';
    createGeneralData.GeneralData.docStatus = mnocld.DocStatus ?? 'Open';
    createGeneralData.GeneralData.approvalStatus =
        mnocld.ApprovalStatus ?? 'Pending';
    createGeneralData.GeneralData.checkListStatus =
        mnocld.CheckListStatus ?? 'WIP';
    createGeneralData.GeneralData.tyreMaintenance = 'No';
    createGeneralData.GeneralData.objectCode = mnocld.ObjectCode ?? '';
    createGeneralData.GeneralData.equipmentCode = mnocld.EquipmentCode ?? '';
    createGeneralData.GeneralData.equipmentName = mnocld.EquipmentName ?? '';
    createGeneralData.GeneralData.checkListCode = mnocld.CheckListCode ?? '';
    createGeneralData.GeneralData.checkListName = mnocld.CheckListName ?? '';
    createGeneralData.GeneralData.workCenterCode = mnocld.WorkCenterCode ?? '';
    createGeneralData.GeneralData.workCenterName = mnocld.WorkCenterName ?? '';
    createGeneralData.GeneralData.openDate = getFormattedDate(mnocld.OpenDate);
    createGeneralData.GeneralData.closeDate =
        getFormattedDate(mnocld.CloseDate);
    createGeneralData.GeneralData.postingDate =
        getFormattedDate(mnocld.PostingDate);
    createGeneralData.GeneralData.validUntill =
        getFormattedDate(mnocld.ValidUntill);
    createGeneralData.GeneralData.lastReadingDate =
        getFormattedDate(mnocld.LastReadingDate);
    createGeneralData.GeneralData.lastReading = mnocld.LastReading ?? '';
    createGeneralData.GeneralData.assignedUserCode =
        mnocld.AssignedUserCode ?? '';
    createGeneralData.GeneralData.assignedUserName =
        mnocld.AssignedUserName ?? '';
    createGeneralData.GeneralData.mNJCTransId = mnocld.MNJCTransId ?? '';
    createGeneralData.GeneralData.remarks = mnocld.Remarks ?? '';
    createGeneralData.GeneralData.createdBy = mnocld.CreatedBy ?? '';
    createGeneralData.GeneralData.updatedBy = mnocld.UpdatedBy ?? '';
    createGeneralData.GeneralData.branchId = mnocld.BranchId ?? '';
    createGeneralData.GeneralData.createDate =
        getFormattedDate(mnocld.CreateDate);
    createGeneralData.GeneralData.updateDate =
        getFormattedDate(mnocld.UpdateDate);
    createGeneralData.GeneralData.currentReading = mnocld.CurrentReading ?? '';
    createGeneralData.GeneralData.isConsumption = mnocld.IsConsumption ?? false;
    createGeneralData.GeneralData.isRequest = mnocld.IsRequest ?? false;
    createGeneralData.GeneralData.isSelected = true;
    createGeneralData.GeneralData.hasCreated = mnocld.hasCreated;
    createGeneralData.GeneralData.hasUpdated = mnocld.hasUpdated;
  }

  static clearCheckListAttachments() {
    createAttachments.Attachments.attachments.clear();
    createAttachments.Attachments.imageFile = null;
    createAttachments.Attachments.attachment = '';
    createAttachments.Attachments.docName = '';
    createAttachments.Attachments.rowId = '';
    createAttachments.Attachments.Remarks = '';
  }
}

class ClearEditCheckListDoc {
  static clearGeneralData() {
    CheckListDocument.numOfTabs.value = 3;
    editGeneralData.GeneralData.iD = '';
    editGeneralData.GeneralData.tripTransId = '';
    editGeneralData.GeneralData.permanentTransId = '';
    editGeneralData.GeneralData.transId = '';
    editGeneralData.GeneralData.docEntry = '';
    editGeneralData.GeneralData.docNum = '';
    editGeneralData.GeneralData.canceled = '';
    editGeneralData.GeneralData.docStatus = 'Open';
    editGeneralData.GeneralData.approvalStatus = 'Pending';
    editGeneralData.GeneralData.checkListStatus = 'WIP';
    editGeneralData.GeneralData.tyreMaintenance = 'No';
    editGeneralData.GeneralData.objectCode = '';
    editGeneralData.GeneralData.equipmentCode = '';
    editGeneralData.GeneralData.equipmentName = '';
    editGeneralData.GeneralData.checkListCode = '';
    editGeneralData.GeneralData.checkListName = '';
    editGeneralData.GeneralData.workCenterCode = '';
    editGeneralData.GeneralData.workCenterName = '';
    editGeneralData.GeneralData.openDate = getFormattedDate(DateTime.now());
    editGeneralData.GeneralData.closeDate = getFormattedDate(DateTime.now());
    editGeneralData.GeneralData.postingDate = getFormattedDate(DateTime.now());
    editGeneralData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    editGeneralData.GeneralData.lastReadingDate =
        getFormattedDate(DateTime.now());
    editGeneralData.GeneralData.lastReading = '';
    editGeneralData.GeneralData.assignedUserCode = '';
    editGeneralData.GeneralData.assignedUserName = '';
    editGeneralData.GeneralData.mNJCTransId = '';
    editGeneralData.GeneralData.remarks = '';
    editGeneralData.GeneralData.createdBy = '';
    editGeneralData.GeneralData.updatedBy = '';
    editGeneralData.GeneralData.branchId = '';
    editGeneralData.GeneralData.createDate = getFormattedDate(DateTime.now());
    editGeneralData.GeneralData.updateDate = getFormattedDate(DateTime.now());
    editGeneralData.GeneralData.currentReading = '';
    editGeneralData.GeneralData.isConsumption = false;
    editGeneralData.GeneralData.isRequest = false;
    editGeneralData.GeneralData.isSelected = false;
    editGeneralData.GeneralData.hasCreated = false;
    editGeneralData.GeneralData.hasUpdated = false;
  }

  static setGeneralData({required MNOCLD mnocld}) {
    CheckListDocument.numOfTabs.value = 3;
    editGeneralData.GeneralData.iD = mnocld.ID?.toString() ?? '0';
    editGeneralData.GeneralData.permanentTransId =
        mnocld.PermanentTransId ?? "";
    editGeneralData.GeneralData.tripTransId = mnocld.TripTransId ?? '';
    editGeneralData.GeneralData.transId = mnocld.TransId ?? '';
    editGeneralData.GeneralData.docEntry = mnocld.DocEntry?.toString() ?? '';
    editGeneralData.GeneralData.docNum = mnocld.DocNum ?? '';
    editGeneralData.GeneralData.canceled = mnocld.Canceled ?? '';
    editGeneralData.GeneralData.docStatus = mnocld.DocStatus ?? 'Open';
    editGeneralData.GeneralData.approvalStatus =
        mnocld.ApprovalStatus ?? 'Pending';
    editGeneralData.GeneralData.checkListStatus =
        mnocld.CheckListStatus ?? 'WIP';
    editGeneralData.GeneralData.tyreMaintenance = 'No';
    editGeneralData.GeneralData.objectCode = mnocld.ObjectCode ?? '';
    editGeneralData.GeneralData.equipmentCode = mnocld.EquipmentCode ?? '';
    editGeneralData.GeneralData.equipmentName = mnocld.EquipmentName ?? '';
    editGeneralData.GeneralData.checkListCode = mnocld.CheckListCode ?? '';
    editGeneralData.GeneralData.checkListName = mnocld.CheckListName ?? '';
    editGeneralData.GeneralData.workCenterCode = mnocld.WorkCenterCode ?? '';
    editGeneralData.GeneralData.workCenterName = mnocld.WorkCenterName ?? '';
    editGeneralData.GeneralData.openDate = getFormattedDate(mnocld.OpenDate);
    editGeneralData.GeneralData.closeDate = getFormattedDate(mnocld.CloseDate);
    editGeneralData.GeneralData.postingDate =
        getFormattedDate(mnocld.PostingDate);
    editGeneralData.GeneralData.validUntill =
        getFormattedDate(mnocld.ValidUntill);
    editGeneralData.GeneralData.lastReadingDate =
        getFormattedDate(mnocld.LastReadingDate);
    editGeneralData.GeneralData.lastReading = mnocld.LastReading ?? '';
    editGeneralData.GeneralData.assignedUserCode =
        mnocld.AssignedUserCode ?? '';
    editGeneralData.GeneralData.assignedUserName =
        mnocld.AssignedUserName ?? '';
    editGeneralData.GeneralData.mNJCTransId = mnocld.MNJCTransId ?? '';
    editGeneralData.GeneralData.remarks = mnocld.Remarks ?? '';
    editGeneralData.GeneralData.createdBy = mnocld.CreatedBy ?? '';
    editGeneralData.GeneralData.updatedBy = mnocld.UpdatedBy ?? '';
    editGeneralData.GeneralData.branchId = mnocld.BranchId ?? '';
    editGeneralData.GeneralData.createDate =
        getFormattedDate(mnocld.CreateDate);
    editGeneralData.GeneralData.updateDate =
        getFormattedDate(mnocld.UpdateDate);
    editGeneralData.GeneralData.currentReading = mnocld.CurrentReading ?? '';
    editGeneralData.GeneralData.isConsumption = mnocld.IsConsumption ?? false;
    editGeneralData.GeneralData.isRequest = mnocld.IsRequest ?? false;
    editGeneralData.GeneralData.isSelected = true;
    editGeneralData.GeneralData.hasCreated = mnocld.hasCreated;
    editGeneralData.GeneralData.hasUpdated = mnocld.hasUpdated;
  }

  static setEditCheckListDocTextFields({required MNOCLD mnocld}) {
    CheckListDocument.numOfTabs.value = 3;
    editGeneralData.GeneralData.iD = mnocld.ID?.toString() ?? '0';
    editGeneralData.GeneralData.permanentTransId =
        mnocld.PermanentTransId ?? "";
    editGeneralData.GeneralData.transId = mnocld.TransId ?? '';
    editGeneralData.GeneralData.docEntry = mnocld.DocEntry?.toString() ?? '';
    editGeneralData.GeneralData.docNum = mnocld.DocNum ?? '';
    editGeneralData.GeneralData.canceled = mnocld.Canceled ?? '';
    editGeneralData.GeneralData.docStatus = mnocld.DocStatus ?? 'Open';
    editGeneralData.GeneralData.approvalStatus =
        mnocld.ApprovalStatus ?? 'Pending';
    editGeneralData.GeneralData.checkListStatus =
        mnocld.CheckListStatus ?? 'WIP';
    editGeneralData.GeneralData.tyreMaintenance = 'No';
    editGeneralData.GeneralData.objectCode = mnocld.ObjectCode ?? '';
    editGeneralData.GeneralData.equipmentCode = mnocld.EquipmentCode ?? '';
    editGeneralData.GeneralData.equipmentName = mnocld.EquipmentName ?? '';
    editGeneralData.GeneralData.checkListCode = mnocld.CheckListCode ?? '';
    editGeneralData.GeneralData.checkListName = mnocld.CheckListName ?? '';
    editGeneralData.GeneralData.workCenterCode = mnocld.WorkCenterCode ?? '';
    editGeneralData.GeneralData.workCenterName = mnocld.WorkCenterName ?? '';
    editGeneralData.GeneralData.openDate = getFormattedDate(mnocld.OpenDate);
    editGeneralData.GeneralData.closeDate = getFormattedDate(mnocld.CloseDate);
    editGeneralData.GeneralData.postingDate =
        getFormattedDate(mnocld.PostingDate);
    editGeneralData.GeneralData.validUntill =
        getFormattedDate(mnocld.ValidUntill);
    editGeneralData.GeneralData.lastReadingDate =
        getFormattedDate(mnocld.LastReadingDate);
    editGeneralData.GeneralData.lastReading = mnocld.LastReading ?? '';
    editGeneralData.GeneralData.assignedUserCode =
        mnocld.AssignedUserCode ?? '';
    editGeneralData.GeneralData.assignedUserName =
        mnocld.AssignedUserName ?? '';
    editGeneralData.GeneralData.mNJCTransId = mnocld.MNJCTransId ?? '';
    editGeneralData.GeneralData.remarks = mnocld.Remarks ?? '';
    editGeneralData.GeneralData.createdBy = mnocld.CreatedBy ?? '';
    editGeneralData.GeneralData.updatedBy = mnocld.UpdatedBy ?? '';
    editGeneralData.GeneralData.branchId = mnocld.BranchId ?? '';
    editGeneralData.GeneralData.createDate =
        getFormattedDate(mnocld.CreateDate);
    editGeneralData.GeneralData.updateDate =
        getFormattedDate(mnocld.UpdateDate);
    editGeneralData.GeneralData.currentReading = mnocld.CurrentReading ?? '';
    editGeneralData.GeneralData.isConsumption = mnocld.IsConsumption ?? false;
    editGeneralData.GeneralData.isRequest = mnocld.IsRequest ?? false;
    editGeneralData.GeneralData.isSelected = true;
    editGeneralData.GeneralData.hasCreated = mnocld.hasCreated;
    editGeneralData.GeneralData.hasUpdated = mnocld.hasUpdated;
  }
}

class ClearViewCheckListDoc {
  static clearGeneralData() {
    CheckListDocument.numOfTabs.value = 3;
    viewGeneralData.GeneralData.iD = '';
    viewGeneralData.GeneralData.TripTransId = '';
    viewGeneralData.GeneralData.permanentTransId = '';
    viewGeneralData.GeneralData.transId = '';
    viewGeneralData.GeneralData.docEntry = '';
    viewGeneralData.GeneralData.docNum = '';
    viewGeneralData.GeneralData.canceled = '';
    viewGeneralData.GeneralData.docStatus = 'Open';
    viewGeneralData.GeneralData.approvalStatus = 'Pending';
    viewGeneralData.GeneralData.checkListStatus = 'WIP';
    viewGeneralData.GeneralData.tyreMaintenance = 'No';
    viewGeneralData.GeneralData.objectCode = '';
    viewGeneralData.GeneralData.equipmentCode = '';
    viewGeneralData.GeneralData.equipmentName = '';
    viewGeneralData.GeneralData.checkListCode = '';
    viewGeneralData.GeneralData.checkListName = '';
    viewGeneralData.GeneralData.workCenterCode = '';
    viewGeneralData.GeneralData.workCenterName = '';
    viewGeneralData.GeneralData.openDate = getFormattedDate(DateTime.now());
    viewGeneralData.GeneralData.closeDate = getFormattedDate(DateTime.now());
    viewGeneralData.GeneralData.postingDate = getFormattedDate(DateTime.now());
    viewGeneralData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    viewGeneralData.GeneralData.lastReadingDate =
        getFormattedDate(DateTime.now());
    viewGeneralData.GeneralData.lastReading = '';
    viewGeneralData.GeneralData.assignedUserCode = '';
    viewGeneralData.GeneralData.assignedUserName = '';
    viewGeneralData.GeneralData.mNJCTransId = '';
    viewGeneralData.GeneralData.remarks = '';
    viewGeneralData.GeneralData.createdBy = '';
    viewGeneralData.GeneralData.updatedBy = '';
    viewGeneralData.GeneralData.branchId = '';
    viewGeneralData.GeneralData.createDate = getFormattedDate(DateTime.now());
    viewGeneralData.GeneralData.updateDate = getFormattedDate(DateTime.now());
    viewGeneralData.GeneralData.currentReading = '';
    viewGeneralData.GeneralData.isConsumption = false;
    viewGeneralData.GeneralData.isRequest = false;
    viewGeneralData.GeneralData.isSelected = false;
    viewGeneralData.GeneralData.hasCreated = false;
    viewGeneralData.GeneralData.hasUpdated = false;
  }

  static setGeneralData({required MNOCLD mnocld}) {
    CheckListDocument.numOfTabs.value = 3;
    viewGeneralData.GeneralData.iD = mnocld.ID?.toString() ?? '0';
    viewGeneralData.GeneralData.permanentTransId =
        mnocld.PermanentTransId ?? "";
    viewGeneralData.GeneralData.TripTransId = mnocld.TripTransId ?? '';
    viewGeneralData.GeneralData.transId = mnocld.TransId ?? '';
    viewGeneralData.GeneralData.docEntry = mnocld.DocEntry?.toString() ?? '';
    viewGeneralData.GeneralData.docNum = mnocld.DocNum ?? '';
    viewGeneralData.GeneralData.canceled = mnocld.Canceled ?? '';
    viewGeneralData.GeneralData.docStatus = mnocld.DocStatus ?? 'Open';
    viewGeneralData.GeneralData.approvalStatus =
        mnocld.ApprovalStatus ?? 'Pending';
    viewGeneralData.GeneralData.checkListStatus =
        mnocld.CheckListStatus ?? 'WIP';
    viewGeneralData.GeneralData.tyreMaintenance = 'No';
    viewGeneralData.GeneralData.objectCode = mnocld.ObjectCode ?? '';
    viewGeneralData.GeneralData.equipmentCode = mnocld.EquipmentCode ?? '';
    viewGeneralData.GeneralData.equipmentName = mnocld.EquipmentName ?? '';
    viewGeneralData.GeneralData.checkListCode = mnocld.CheckListCode ?? '';
    viewGeneralData.GeneralData.checkListName = mnocld.CheckListName ?? '';
    viewGeneralData.GeneralData.workCenterCode = mnocld.WorkCenterCode ?? '';
    viewGeneralData.GeneralData.workCenterName = mnocld.WorkCenterName ?? '';
    viewGeneralData.GeneralData.openDate = getFormattedDate(mnocld.OpenDate);
    viewGeneralData.GeneralData.closeDate = getFormattedDate(mnocld.CloseDate);
    viewGeneralData.GeneralData.postingDate =
        getFormattedDate(mnocld.PostingDate);
    viewGeneralData.GeneralData.validUntill =
        getFormattedDate(mnocld.ValidUntill);
    viewGeneralData.GeneralData.lastReadingDate =
        getFormattedDate(mnocld.LastReadingDate);
    viewGeneralData.GeneralData.lastReading = mnocld.LastReading ?? '';
    viewGeneralData.GeneralData.assignedUserCode =
        mnocld.AssignedUserCode ?? '';
    viewGeneralData.GeneralData.assignedUserName =
        mnocld.AssignedUserName ?? '';
    viewGeneralData.GeneralData.mNJCTransId = mnocld.MNJCTransId ?? '';
    viewGeneralData.GeneralData.remarks = mnocld.Remarks ?? '';
    viewGeneralData.GeneralData.createdBy = mnocld.CreatedBy ?? '';
    viewGeneralData.GeneralData.updatedBy = mnocld.UpdatedBy ?? '';
    viewGeneralData.GeneralData.branchId = mnocld.BranchId ?? '';
    viewGeneralData.GeneralData.createDate =
        getFormattedDate(mnocld.CreateDate);
    viewGeneralData.GeneralData.updateDate =
        getFormattedDate(mnocld.UpdateDate);
    viewGeneralData.GeneralData.currentReading = mnocld.CurrentReading ?? '';
    viewGeneralData.GeneralData.isConsumption = mnocld.IsConsumption ?? false;
    viewGeneralData.GeneralData.isRequest = mnocld.IsRequest ?? false;
    viewGeneralData.GeneralData.isSelected = true;
    viewGeneralData.GeneralData.hasCreated = mnocld.hasCreated;
    viewGeneralData.GeneralData.hasUpdated = mnocld.hasUpdated;
  }

  static setViewCheckListDocTextFields({required MNOCLD mnocld}) {
    CheckListDocument.numOfTabs.value = 3;
    viewGeneralData.GeneralData.iD = mnocld.ID?.toString() ?? '0';
    viewGeneralData.GeneralData.permanentTransId =
        mnocld.PermanentTransId ?? "";
    viewGeneralData.GeneralData.transId = mnocld.TransId ?? '';
    viewGeneralData.GeneralData.docEntry = mnocld.DocEntry?.toString() ?? '';
    viewGeneralData.GeneralData.docNum = mnocld.DocNum ?? '';
    viewGeneralData.GeneralData.canceled = mnocld.Canceled ?? '';
    viewGeneralData.GeneralData.docStatus = mnocld.DocStatus ?? 'Open';
    viewGeneralData.GeneralData.approvalStatus =
        mnocld.ApprovalStatus ?? 'Pending';
    viewGeneralData.GeneralData.checkListStatus =
        mnocld.CheckListStatus ?? 'WIP';
    viewGeneralData.GeneralData.tyreMaintenance = 'No';
    viewGeneralData.GeneralData.objectCode = mnocld.ObjectCode ?? '';
    viewGeneralData.GeneralData.equipmentCode = mnocld.EquipmentCode ?? '';
    viewGeneralData.GeneralData.equipmentName = mnocld.EquipmentName ?? '';
    viewGeneralData.GeneralData.checkListCode = mnocld.CheckListCode ?? '';
    viewGeneralData.GeneralData.checkListName = mnocld.CheckListName ?? '';
    viewGeneralData.GeneralData.workCenterCode = mnocld.WorkCenterCode ?? '';
    viewGeneralData.GeneralData.workCenterName = mnocld.WorkCenterName ?? '';
    viewGeneralData.GeneralData.openDate = getFormattedDate(mnocld.OpenDate);
    viewGeneralData.GeneralData.closeDate = getFormattedDate(mnocld.CloseDate);
    viewGeneralData.GeneralData.postingDate =
        getFormattedDate(mnocld.PostingDate);
    viewGeneralData.GeneralData.validUntill =
        getFormattedDate(mnocld.ValidUntill);
    viewGeneralData.GeneralData.lastReadingDate =
        getFormattedDate(mnocld.LastReadingDate);
    viewGeneralData.GeneralData.lastReading = mnocld.LastReading ?? '';
    viewGeneralData.GeneralData.assignedUserCode =
        mnocld.AssignedUserCode ?? '';
    viewGeneralData.GeneralData.assignedUserName =
        mnocld.AssignedUserName ?? '';
    viewGeneralData.GeneralData.mNJCTransId = mnocld.MNJCTransId ?? '';
    viewGeneralData.GeneralData.remarks = mnocld.Remarks ?? '';
    viewGeneralData.GeneralData.createdBy = mnocld.CreatedBy ?? '';
    viewGeneralData.GeneralData.updatedBy = mnocld.UpdatedBy ?? '';
    viewGeneralData.GeneralData.branchId = mnocld.BranchId ?? '';
    viewGeneralData.GeneralData.createDate =
        getFormattedDate(mnocld.CreateDate);
    viewGeneralData.GeneralData.updateDate =
        getFormattedDate(mnocld.UpdateDate);
    viewGeneralData.GeneralData.currentReading = mnocld.CurrentReading ?? '';
    viewGeneralData.GeneralData.isConsumption = mnocld.IsConsumption ?? false;
    viewGeneralData.GeneralData.isRequest = mnocld.IsRequest ?? false;
    viewGeneralData.GeneralData.isSelected = true;
    viewGeneralData.GeneralData.hasCreated = mnocld.hasCreated;
    viewGeneralData.GeneralData.hasUpdated = mnocld.hasUpdated;
  }
}

goToNewCheckListDocument() async {
  await ClearCreateCheckListDoc.clearGeneralData();
  await ClearCreateCheckListDoc.clearEditCheckList();
  await ClearCreateCheckListDoc.clearCheckListAttachments();
  createCheckListDetails.CheckListDetails.items.clear();
  String TransId=await GenerateTransId.getTransId(tableName: 'MNOCLD',
  docName: 'MNCL');
  print(TransId);
  createGeneralData.GeneralData.transId =TransId;
  Get.offAll(() => CheckListDocument(0));
}

navigateToCheckListDocument(
    {required String TransId, required bool isView}) async {
  if (isView) {
    List<MNOCLD> list =
        await retrieveMNOCLDById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearViewCheckListDoc.setViewCheckListDocTextFields(mnocld: list[0]);
    }
    viewCheckListDetails.CheckListDetails.items =
        await retrieveMNCLD1ById(null, 'TransId = ?', [TransId]);
    Get.offAll(() => ViewCheckListDocument(0));
  } else {
    List<MNOCLD> list =
        await retrieveMNOCLDById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearEditCheckListDoc.setEditCheckListDocTextFields(mnocld: list[0]);
    }
    editCheckListDetails.CheckListDetails.items =
        await retrieveMNCLD1ById(null, 'TransId = ?', [TransId]);
    Get.offAll(() => EditCheckListDocument(0));
  }
}
