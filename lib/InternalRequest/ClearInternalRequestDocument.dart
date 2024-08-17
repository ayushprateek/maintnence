import 'package:get/get.dart';
import 'package:maintenance/Component/GenerateTransId.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetLastDocNum.dart';
import 'package:maintenance/Component/IsAvailableTransId.dart';
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
import 'package:maintenance/Sync/SyncModels/PRITR1.dart';
import 'package:maintenance/Sync/SyncModels/PROITR.dart';
import 'package:maintenance/main.dart';

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
  static setGeneralData({
    required PROITR data
}) {
    createInternalGenData.GeneralData.iD = data.ID?.toString();
    createInternalGenData.GeneralData.transId = data.TransId;
    createInternalGenData.GeneralData.requestedCode = data.RequestedCode;
    createInternalGenData.GeneralData.requestedName = data.RequestedName;
    createInternalGenData.GeneralData.refNo = data.RefNo;
    createInternalGenData.GeneralData.mobileNo = data.MobileNo;
    createInternalGenData.GeneralData.postingDate =
        getFormattedDate(data.PostingDate);
    createInternalGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    createInternalGenData.GeneralData.currency = data.Currency;
    createInternalGenData.GeneralData.currRate = data.CurrRate?.toStringAsFixed(2);
    createInternalGenData.GeneralData.approvalStatus = data.ApprovalStatus;
    createInternalGenData.GeneralData.docStatus = data.DocStatus;
    createInternalGenData.GeneralData.permanentTransId = data.PermanentTransId;
    createInternalGenData.GeneralData.docEntry = data.DocEntry?.toString();
    createInternalGenData.GeneralData.docNum = data.DocNum;
    createInternalGenData.GeneralData.createdBy = data.CreatedBy;

    createInternalGenData.GeneralData.approvedBy = data.ApprovedBy;
    createInternalGenData.GeneralData.error = data.Error;
    createInternalGenData.GeneralData.isPosted = data.IsPosted;
    createInternalGenData.GeneralData.draftKey = data.DraftKey;
    createInternalGenData.GeneralData.latitude = data.Latitude;
    createInternalGenData.GeneralData.longitude = data.Longitude;
    createInternalGenData.GeneralData.objectCode = data.ObjectCode;
    createInternalGenData.GeneralData.fromWhsCode = data.FromWhsCode;
    createInternalGenData.GeneralData.toWhsCode = data.ToWhsCode;
    createInternalGenData.GeneralData.remarks = data.Remarks;
    createInternalGenData.GeneralData.branchId = data.BranchId;
    createInternalGenData.GeneralData.updatedBy = data.UpdatedBy;
    createInternalGenData.GeneralData.postingAddress = data.PostingAddress;
    createInternalGenData.GeneralData.tripTransId = data.TripTransId;
    createInternalGenData.GeneralData.deptCode = data.DeptCode;
    createInternalGenData.GeneralData.deptName = data.DeptName;
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
  String TransId = await GenerateTransId.getTransId(tableName: 'PROPDN', docName: 'PRGR');
  createInternalGenData.GeneralData.transId = TransId;
  Get.offAll(() => InternalRequest(0));
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
