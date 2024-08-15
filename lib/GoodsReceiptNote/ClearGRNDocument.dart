//------------------------------CREATE GOODS RECEIPT NOTES------------
import 'package:get/get.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetLastDocNum.dart';
import 'package:maintenance/Component/IsAvailableTransId.dart';
import 'package:maintenance/GoodsReceiptNote/create/Address/BillingAddress.dart'
as createGrnBillAddress;
import 'package:maintenance/GoodsReceiptNote/create/Address/ShippingAddress.dart'
as createGrnShipAddress;
import 'package:maintenance/GoodsReceiptNote/create/GeneralData.dart'
as createGrnGenData;
import 'package:maintenance/GoodsReceiptNote/create/GoodsReceiptNote.dart';
import 'package:maintenance/GoodsReceiptNote/create/ItemDetails/EditItems.dart'
as createGrnEditItems;
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
import 'package:maintenance/GoodsReceiptNote/edit/ItemDetails/EditItems.dart'
as editGrnEditItems;
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
import 'package:maintenance/Sync/SyncModels/PROPDN.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN1.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN2.dart';
import 'package:maintenance/Sync/SyncModels/PRPDN3.dart';
import 'package:maintenance/main.dart';

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
    createGrnShipAddress.ShippingAddress.CityName = '';
    createGrnShipAddress.ShippingAddress.hasCreated = false;
    createGrnShipAddress.ShippingAddress.hasUpdated = false;
    createGrnShipAddress.ShippingAddress.CityCode = '';
    createGrnShipAddress.ShippingAddress.Addres = '';
    createGrnShipAddress.ShippingAddress.CountryName = '';
    createGrnShipAddress.ShippingAddress.CountryCode = '';
    createGrnShipAddress.ShippingAddress.StateName = '';
    createGrnShipAddress.ShippingAddress.RouteCode = '';
    createGrnShipAddress.ShippingAddress.StateCode = '';
    createGrnShipAddress.ShippingAddress.Latitude = 0.0;
    createGrnShipAddress.ShippingAddress.Longitude = 0.0;
    createGrnShipAddress.ShippingAddress.RowId = 0;
    createGrnShipAddress.ShippingAddress.AddCode = '';
  }

  static clearBillingAddressTextFields() {
    createGrnBillAddress.BillingAddress.CityName = '';
    createGrnBillAddress.BillingAddress.hasCreated = false;
    createGrnBillAddress.BillingAddress.hasUpdated = false;
    createGrnBillAddress.BillingAddress.CityCode = '';
    createGrnBillAddress.BillingAddress.Addres = '';
    createGrnBillAddress.BillingAddress.CountryName = '';
    createGrnBillAddress.BillingAddress.CountryCode = '';
    createGrnBillAddress.BillingAddress.StateName = '';
    createGrnBillAddress.BillingAddress.StateCode = '';
    createGrnBillAddress.BillingAddress.Latitude = 0.0;
    createGrnBillAddress.BillingAddress.Longitude = 0.0;
    createGrnBillAddress.BillingAddress.RowId = 0;
    createGrnBillAddress.BillingAddress.AddCode = '';
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
  await ClearGRNDocument.clearBillingAddressTextFields();
  await ClearGRNDocument.clearShippingAddressTextFields();
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
