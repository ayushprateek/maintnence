//------------------------------ CREATE GOODS ISSUE IMPORTS------------
import 'package:get/get.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetLastDocNum.dart';
import 'package:maintenance/Component/IsAvailableTransId.dart';
import 'package:maintenance/GoodsIssue/create/GeneralData.dart'
as goodsIssueCreateGenData;
import 'package:maintenance/GoodsIssue/create/GoodsIssue.dart';
import 'package:maintenance/GoodsIssue/create/ItemDetails/EditItems.dart'
as goodsIssueCreateEditItems;
import 'package:maintenance/GoodsIssue/create/ItemDetails/ItemDetails.dart'
as goodsIssueCreateDetails;
//------------------------------ EDIT GOODS ISSUE IMPORTS------------
import 'package:maintenance/GoodsIssue/edit/GeneralData.dart'
as goodsIssueEditGenData;
import 'package:maintenance/GoodsIssue/edit/GoodsIssue.dart';
import 'package:maintenance/GoodsIssue/edit/ItemDetails/ItemDetails.dart'
as goodsIssueEditDetails;
//------------------------------ VIEW GOODS ISSUE IMPORTS------------
import 'package:maintenance/GoodsIssue/view/GeneralData.dart'
as goodsIssueViewGenData;
import 'package:maintenance/GoodsIssue/view/GoodsIssue.dart';
import 'package:maintenance/GoodsIssue/view/ItemDetails/ItemDetails.dart'
as goodsIssueViewDetails;

import 'package:maintenance/Sync/SyncModels/IMGDI1.dart';
import 'package:maintenance/Sync/SyncModels/IMOGDI.dart';
import 'package:maintenance/main.dart';

navigateToGoodsIssueDocument(
    {required String TransId, required bool isView}) async {
  if (isView) {
    List<IMOGDI> list =
        await retrieveIMOGDIById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearGoodsIssueDocument.setViewData(imogdi: list[0]);
    }
    goodsIssueViewDetails.ItemDetails.items =
        await retrieveIMGDI1ById(null, 'TransId = ?', [TransId]);
    print(goodsIssueViewDetails.ItemDetails.items);

    Get.offAll(() => ViewGoodsIssue(0));
  } else {
    List<IMOGDI> list =
        await retrieveIMOGDIById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearGoodsIssueDocument.setEditData(imogdi: list[0]);
    }
    goodsIssueEditDetails.ItemDetails.items =
        await retrieveIMGDI1ById(null, 'TransId = ?', [TransId]);
    print(goodsIssueEditDetails.ItemDetails.items);
    Get.offAll(() => EditGoodsIssue(0));
  }
}

class ClearGoodsIssueDocument {
  static clearGeneralDataTextFields() {
    goodsIssueCreateGenData.GeneralData.iD = '';
    goodsIssueCreateGenData.GeneralData.transId = '';
    goodsIssueCreateGenData.GeneralData.priceListCode = '';
    goodsIssueCreateGenData.GeneralData.requestedCode = '';
    goodsIssueCreateGenData.GeneralData.requestedName = '';
    goodsIssueCreateGenData.GeneralData.refNo = '';
    goodsIssueCreateGenData.GeneralData.mobileNo = '';
    goodsIssueCreateGenData.GeneralData.postingDate =
        getFormattedDate(DateTime.now());
    goodsIssueCreateGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    goodsIssueCreateGenData.GeneralData.currency = userModel.Currency;
    goodsIssueCreateGenData.GeneralData.currRate = userModel.Rate;
    goodsIssueCreateGenData.GeneralData.approvalStatus = 'Pending';
    goodsIssueCreateGenData.GeneralData.docStatus = 'Open';
    goodsIssueCreateGenData.GeneralData.totBDisc = '';
    goodsIssueCreateGenData.GeneralData.discPer = '';
    goodsIssueCreateGenData.GeneralData.discVal = '';
    goodsIssueCreateGenData.GeneralData.taxVal = '';
    goodsIssueCreateGenData.GeneralData.docTotal = '';
    goodsIssueCreateGenData.GeneralData.permanentTransId = '';
    goodsIssueCreateGenData.GeneralData.docEntry = '';
    goodsIssueCreateGenData.GeneralData.docNum = '';
    goodsIssueCreateGenData.GeneralData.createdBy = '';
    goodsIssueCreateGenData.GeneralData.createDate =
        getFormattedDate(DateTime.now());
    goodsIssueCreateGenData.GeneralData.updateDate =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    goodsIssueCreateGenData.GeneralData.approvedBy = '';
    goodsIssueCreateGenData.GeneralData.error = '';
    goodsIssueCreateGenData.GeneralData.isPosted = false;
    goodsIssueCreateGenData.GeneralData.draftKey = '';
    goodsIssueCreateGenData.GeneralData.latitude = '';
    goodsIssueCreateGenData.GeneralData.longitude = '';
    goodsIssueCreateGenData.GeneralData.objectCode = '';
    goodsIssueCreateGenData.GeneralData.toWhsCode = '';
    goodsIssueCreateGenData.GeneralData.remarks = '';
    goodsIssueCreateGenData.GeneralData.branchId = '';
    goodsIssueCreateGenData.GeneralData.updatedBy = '';
    goodsIssueCreateGenData.GeneralData.postingAddress = '';
    goodsIssueCreateGenData.GeneralData.tripTransId = '';
    goodsIssueCreateGenData.GeneralData.deptCode = '';
    goodsIssueCreateGenData.GeneralData.deptName = '';
    goodsIssueCreateGenData.GeneralData.isSelected = false;
    goodsIssueCreateGenData.GeneralData.hasCreated = false;
    goodsIssueCreateGenData.GeneralData.hasUpdated = false;
  }

  static setViewData({required IMOGDI imogdi}) {
    goodsIssueViewGenData.GeneralData.iD = imogdi.ID?.toString();
    goodsIssueViewGenData.GeneralData.transId = imogdi.TransId;
    goodsIssueViewGenData.GeneralData.priceListCode = '';
    goodsIssueViewGenData.GeneralData.requestedCode = imogdi.RequestedCode;
    goodsIssueViewGenData.GeneralData.requestedName = imogdi.RequestedName;
    goodsIssueViewGenData.GeneralData.refNo = imogdi.RefNo;
    goodsIssueViewGenData.GeneralData.mobileNo = imogdi.MobileNo;
    goodsIssueViewGenData.GeneralData.postingDate =
        getFormattedDate(imogdi.PostingDate);
    goodsIssueViewGenData.GeneralData.validUntill =
        getFormattedDate(imogdi.ValidUntill);
    goodsIssueViewGenData.GeneralData.currency = imogdi.Currency;
    goodsIssueViewGenData.GeneralData.currRate =
        imogdi.CurrRate?.toStringAsFixed(2);
    goodsIssueViewGenData.GeneralData.approvalStatus = imogdi.ApprovalStatus;
    goodsIssueViewGenData.GeneralData.docStatus = imogdi.DocStatus;
    goodsIssueViewGenData.GeneralData.totBDisc =
        imogdi.TotBDisc?.toStringAsFixed(2);
    goodsIssueViewGenData.GeneralData.discPer =
        imogdi.DiscPer?.toStringAsFixed(2);
    goodsIssueViewGenData.GeneralData.discVal =
        imogdi.DiscVal?.toStringAsFixed(2);
    goodsIssueViewGenData.GeneralData.taxVal =
        imogdi.TaxVal?.toStringAsFixed(2);
    goodsIssueViewGenData.GeneralData.docTotal =
        imogdi.DocTotal?.toStringAsFixed(2);
    goodsIssueViewGenData.GeneralData.permanentTransId =
        imogdi.PermanentTransId;
    goodsIssueViewGenData.GeneralData.docEntry = imogdi.DocEntry?.toString();
    goodsIssueViewGenData.GeneralData.docNum = imogdi.DocNum;
    goodsIssueViewGenData.GeneralData.createdBy = imogdi.CreatedBy;
    goodsIssueViewGenData.GeneralData.createDate =
        getFormattedDate(imogdi.CreateDate);
    goodsIssueViewGenData.GeneralData.updateDate =
        getFormattedDate(imogdi.UpdateDate);
    goodsIssueViewGenData.GeneralData.approvedBy = imogdi.ApprovedBy;
    goodsIssueViewGenData.GeneralData.error = imogdi.Error;
    goodsIssueViewGenData.GeneralData.isPosted = imogdi.IsPosted;
    goodsIssueViewGenData.GeneralData.draftKey = imogdi.DraftKey;
    goodsIssueViewGenData.GeneralData.latitude = imogdi.Latitude;
    goodsIssueViewGenData.GeneralData.longitude = imogdi.Longitude;
    goodsIssueViewGenData.GeneralData.objectCode = imogdi.ObjectCode;
    goodsIssueViewGenData.GeneralData.toWhsCode = imogdi.ToWhsCode;
    goodsIssueViewGenData.GeneralData.remarks = imogdi.Remarks;
    goodsIssueViewGenData.GeneralData.branchId = imogdi.BranchId;
    goodsIssueViewGenData.GeneralData.updatedBy = imogdi.UpdatedBy;
    goodsIssueViewGenData.GeneralData.postingAddress = imogdi.PostingAddress;
    goodsIssueViewGenData.GeneralData.tripTransId = imogdi.TripTransId;
    goodsIssueViewGenData.GeneralData.deptCode = imogdi.DeptCode;
    goodsIssueViewGenData.GeneralData.deptName = imogdi.DeptName;
    goodsIssueViewGenData.GeneralData.isSelected = true;
    goodsIssueViewGenData.GeneralData.hasCreated = imogdi.hasCreated;
    goodsIssueViewGenData.GeneralData.hasUpdated = imogdi.hasUpdated;
  }

  static setEditData({required IMOGDI imogdi}) {
    goodsIssueEditGenData.GeneralData.iD = imogdi.ID?.toString();
    goodsIssueEditGenData.GeneralData.transId = imogdi.TransId;
    goodsIssueEditGenData.GeneralData.priceListCode = '';
    goodsIssueEditGenData.GeneralData.requestedCode = imogdi.RequestedCode;
    goodsIssueEditGenData.GeneralData.requestedName = imogdi.RequestedName;
    goodsIssueEditGenData.GeneralData.refNo = imogdi.RefNo;
    goodsIssueEditGenData.GeneralData.mobileNo = imogdi.MobileNo;
    goodsIssueEditGenData.GeneralData.postingDate =
        getFormattedDate(imogdi.PostingDate);
    goodsIssueEditGenData.GeneralData.validUntill =
        getFormattedDate(imogdi.ValidUntill);
    goodsIssueEditGenData.GeneralData.currency = imogdi.Currency;
    goodsIssueEditGenData.GeneralData.currRate =
        imogdi.CurrRate?.toStringAsFixed(2);
    goodsIssueEditGenData.GeneralData.approvalStatus = imogdi.ApprovalStatus;
    goodsIssueEditGenData.GeneralData.docStatus = imogdi.DocStatus;
    goodsIssueEditGenData.GeneralData.totBDisc =
        imogdi.TotBDisc?.toStringAsFixed(2);
    goodsIssueEditGenData.GeneralData.discPer =
        imogdi.DiscPer?.toStringAsFixed(2);
    goodsIssueEditGenData.GeneralData.discVal =
        imogdi.DiscVal?.toStringAsFixed(2);
    goodsIssueEditGenData.GeneralData.taxVal =
        imogdi.TaxVal?.toStringAsFixed(2);
    goodsIssueEditGenData.GeneralData.docTotal =
        imogdi.DocTotal?.toStringAsFixed(2);
    goodsIssueEditGenData.GeneralData.permanentTransId =
        imogdi.PermanentTransId;
    goodsIssueEditGenData.GeneralData.docEntry = imogdi.DocEntry?.toString();
    goodsIssueEditGenData.GeneralData.docNum = imogdi.DocNum;
    goodsIssueEditGenData.GeneralData.createdBy = imogdi.CreatedBy;
    goodsIssueEditGenData.GeneralData.createDate =
        getFormattedDate(imogdi.CreateDate);
    goodsIssueEditGenData.GeneralData.updateDate =
        getFormattedDate(imogdi.UpdateDate);
    goodsIssueEditGenData.GeneralData.approvedBy = imogdi.ApprovedBy;
    goodsIssueEditGenData.GeneralData.error = imogdi.Error;
    goodsIssueEditGenData.GeneralData.isPosted = imogdi.IsPosted;
    goodsIssueEditGenData.GeneralData.draftKey = imogdi.DraftKey;
    goodsIssueEditGenData.GeneralData.latitude = imogdi.Latitude;
    goodsIssueEditGenData.GeneralData.longitude = imogdi.Longitude;
    goodsIssueEditGenData.GeneralData.objectCode = imogdi.ObjectCode;
    goodsIssueEditGenData.GeneralData.toWhsCode = imogdi.ToWhsCode;
    goodsIssueEditGenData.GeneralData.remarks = imogdi.Remarks;
    goodsIssueEditGenData.GeneralData.branchId = imogdi.BranchId;
    goodsIssueEditGenData.GeneralData.updatedBy = imogdi.UpdatedBy;
    goodsIssueEditGenData.GeneralData.postingAddress = imogdi.PostingAddress;
    goodsIssueEditGenData.GeneralData.tripTransId = imogdi.TripTransId;
    goodsIssueEditGenData.GeneralData.deptCode = imogdi.DeptCode;
    goodsIssueEditGenData.GeneralData.deptName = imogdi.DeptName;
    goodsIssueEditGenData.GeneralData.isSelected = true;
    goodsIssueEditGenData.GeneralData.hasCreated = imogdi.hasCreated;
    goodsIssueEditGenData.GeneralData.hasUpdated = imogdi.hasUpdated;
  }

  static clearEditItems() {
    goodsIssueCreateEditItems.EditItems.tripTransId = '';
    goodsIssueCreateEditItems.EditItems.id = '';
    goodsIssueCreateEditItems.EditItems.truckNo = '';
    goodsIssueCreateEditItems.EditItems.toWhsCode = '';
    goodsIssueCreateEditItems.EditItems.toWhsName = '';
    goodsIssueCreateEditItems.EditItems.driverCode = '';
    goodsIssueCreateEditItems.EditItems.driverName = '';
    goodsIssueCreateEditItems.EditItems.routeCode = '';
    goodsIssueCreateEditItems.EditItems.routeName = '';
    goodsIssueCreateEditItems.EditItems.transId = '';
    goodsIssueCreateEditItems.EditItems.rowId = '';
    goodsIssueCreateEditItems.EditItems.itemCode = '';
    goodsIssueCreateEditItems.EditItems.itemName = '';
    goodsIssueCreateEditItems.EditItems.consumptionQty = '';
    goodsIssueCreateEditItems.EditItems.uomCode = '';
    goodsIssueCreateEditItems.EditItems.uomName = '';
    goodsIssueCreateEditItems.EditItems.deptCode = '';
    goodsIssueCreateEditItems.EditItems.deptName = '';
    goodsIssueCreateEditItems.EditItems.price = '';
    goodsIssueCreateEditItems.EditItems.mtv = '';
    goodsIssueCreateEditItems.EditItems.taxCode = '';
    goodsIssueCreateEditItems.EditItems.taxRate = '';
    goodsIssueCreateEditItems.EditItems.lineDiscount = '';
    goodsIssueCreateEditItems.EditItems.lineTotal = '';
    goodsIssueCreateEditItems.EditItems.isUpdating = false;
  }
}

goToNewGoodsIssueDocument() async {
  await ClearGoodsIssueDocument.clearGeneralDataTextFields();
  await ClearGoodsIssueDocument.clearEditItems();
  goodsIssueCreateDetails.ItemDetails.items.clear();

  getLastDocNum("MNGI", null).then((snapshot) async {
    int DocNum = snapshot[0].DocNumber - 1;

    do {
      DocNum += 1;
      goodsIssueCreateGenData.GeneralData.transId =
          DateTime.now().millisecondsSinceEpoch.toString() +
              "U0" +
              userModel.ID.toString() +
              "_" +
              snapshot[0].DocName +
              "/" +
              DocNum.toString();
    } while (await isMNCLTransIdAvailable(
        null, goodsIssueCreateGenData.GeneralData.transId ?? ""));
    print(goodsIssueCreateGenData.GeneralData.transId);

    Get.offAll(() => GoodsIssue(0));
  });
}
