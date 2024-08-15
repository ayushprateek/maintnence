//------------------------------ CREATE PURCHASE REQUEST IMPORTS------------
import 'package:get/get.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetLastDocNum.dart';
import 'package:maintenance/Component/IsAvailableTransId.dart';
import 'package:maintenance/Purchase/PurchaseRequest/create/GeneralData.dart'
as createPurchaseGenData;
import 'package:maintenance/Purchase/PurchaseRequest/create/ItemDetails/EditItems.dart'
as createPurchaseEditItems;
import 'package:maintenance/Purchase/PurchaseRequest/create/ItemDetails/ItemDetails.dart'
as createPurchaseItemDetails;
import 'package:maintenance/Purchase/PurchaseRequest/create/PurchaseRequest.dart';
//------------------------------ EDIT PURCHASE REQUEST IMPORTS------------
import 'package:maintenance/Purchase/PurchaseRequest/edit/GeneralData.dart'
as editPurchaseGenData;
import 'package:maintenance/Purchase/PurchaseRequest/edit/ItemDetails/ItemDetails.dart'
as editPurchaseItemDetails;
import 'package:maintenance/Purchase/PurchaseRequest/edit/PurchaseRequest.dart';

//------------------------------ VIEW PURCHASE REQUEST IMPORTS------------
import 'package:maintenance/Purchase/PurchaseRequest/view/GeneralData.dart'
    as viewPurchaseGenData;
import 'package:maintenance/Purchase/PurchaseRequest/view/ItemDetails/ItemDetails.dart'
    as viewPurchaseItemDetails;
import 'package:maintenance/Purchase/PurchaseRequest/view/PurchaseRequest.dart';
import 'package:maintenance/Sync/SyncModels/PROPRQ.dart';
import 'package:maintenance/Sync/SyncModels/PRPRQ1.dart';
import 'package:maintenance/main.dart';

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
    createPurchaseEditItems.EditItems.noOfPieces = '';
    createPurchaseEditItems.EditItems.remarks = '';
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
    viewPurchaseItemDetails.ItemDetails.items =
        await retrievePRPRQ1ById(null, 'TransId = ?', [TransId]);

    Get.offAll(() => ViewPurchaseRequest(0));
  } else {
    List<PROPRQ> list =
        await retrievePROPRQById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearPurchaseRequestDocument.setEditPurchaseRequestTextFields(
          data: list[0]);
    }
    editPurchaseItemDetails.ItemDetails.items =
        await retrievePRPRQ1ById(null, 'TransId = ?', [TransId]);

    Get.offAll(() => EditPurchaseRequest(0));
  }
}
