//------------------------------ CREATE PURCHASE ORDER IMPORTS------------
import 'package:get/get.dart';
import 'package:maintenance/Component/GenerateTransId.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/GetLastDocNum.dart';
import 'package:maintenance/Component/IsAvailableTransId.dart';
import 'package:maintenance/Purchase/PurchaseOrder/create/Address/BillingAddress.dart'
as createPurchaseOrderBillAddress;
import 'package:maintenance/Purchase/PurchaseOrder/create/Address/ShippingAddress.dart'
as createPurchaseOrderShippingAddress;
import 'package:maintenance/Purchase/PurchaseOrder/create/GeneralData.dart'
as createPurchaseOrderGenData;
import 'package:maintenance/Purchase/PurchaseOrder/create/ItemDetails/EditItems.dart' as createPurchaseEditItems;
import 'package:maintenance/Purchase/PurchaseOrder/create/ItemDetails/ItemDetails.dart' as createPurchaseOrderItemDetails;
import 'package:maintenance/Purchase/PurchaseOrder/create/PurchaseOrder.dart';
import 'package:maintenance/Purchase/PurchaseOrder/edit/Address/BillingAddress.dart'
as editPurchaseOrderBillAddress;
import 'package:maintenance/Purchase/PurchaseOrder/edit/Address/ShippingAddress.dart'
as editPurchaseOrderShippingAddress;
//------------------------------ EDIT PURCHASE ORDER IMPORTS------------
import 'package:maintenance/Purchase/PurchaseOrder/edit/GeneralData.dart'
as editPurchaseOrderGenData;
import 'package:maintenance/Purchase/PurchaseOrder/edit/ItemDetails/ItemDetails.dart'
as editPurchaseOrderItemDetails;
import 'package:maintenance/Purchase/PurchaseOrder/edit/PurchaseOrder.dart';
import 'package:maintenance/Purchase/PurchaseOrder/view/Address/BillingAddress.dart'
as viewPurchaseOrderBillAddress;
import 'package:maintenance/Purchase/PurchaseOrder/view/Address/ShippingAddress.dart'
as viewPurchaseOrderShippingAddress;
//------------------------------ VIEW PURCHASE ORDER IMPORTS------------
import 'package:maintenance/Purchase/PurchaseOrder/view/GeneralData.dart'
as viewPurchaseOrderGenData;
import 'package:maintenance/Purchase/PurchaseOrder/view/ItemDetails/ItemDetails.dart'
as viewPurchaseOrderItemDetails;
import 'package:maintenance/Purchase/PurchaseOrder/view/PurchaseOrder.dart';
import 'package:maintenance/Sync/SyncModels/PROPOR.dart';
import 'package:maintenance/Sync/SyncModels/PROPRQ.dart';
import 'package:maintenance/Sync/SyncModels/PRPOR1.dart';
import 'package:maintenance/Sync/SyncModels/PRPOR2.dart';
import 'package:maintenance/Sync/SyncModels/PRPOR3.dart';
import 'package:maintenance/main.dart';

class ClearPurchaseOrderDocument {
  static clearGeneralDataTextFields() {
    createPurchaseOrderGenData.GeneralData.iD = '';
    createPurchaseOrderGenData.GeneralData.transId = '';
    createPurchaseOrderGenData.GeneralData.refNo = '';
    createPurchaseOrderGenData.GeneralData.mobileNo = '';
    createPurchaseOrderGenData.GeneralData.postingDate =
        getFormattedDate(DateTime.now());
    createPurchaseOrderGenData.GeneralData.validUntill =
        getFormattedDate(DateTime.now().add(Duration(days: 7)));
    createPurchaseOrderGenData.GeneralData.approvalStatus = 'Pending';
    createPurchaseOrderGenData.GeneralData.docStatus = 'Open';
    createPurchaseOrderGenData.GeneralData.permanentTransId = '';
    createPurchaseOrderGenData.GeneralData.docEntry = '';
    createPurchaseOrderGenData.GeneralData.docNum = '';
    createPurchaseOrderGenData.GeneralData.createdBy = '';
    createPurchaseOrderGenData.GeneralData.createDate = '';
    createPurchaseOrderGenData.GeneralData.updateDate = '';
    createPurchaseOrderGenData.GeneralData.approvedBy = '';
    createPurchaseOrderGenData.GeneralData.error = '';
    createPurchaseOrderGenData.GeneralData.isSelected = false;
    createPurchaseOrderGenData.GeneralData.hasCreated = false;
    createPurchaseOrderGenData.GeneralData.hasUpdated = false;
    createPurchaseOrderGenData.GeneralData.isPosted = false;
    createPurchaseOrderGenData.GeneralData.draftKey = '';
    createPurchaseOrderGenData.GeneralData.latitude = '';
    createPurchaseOrderGenData.GeneralData.longitude = '';
    createPurchaseOrderGenData.GeneralData.objectCode = '';
    createPurchaseOrderGenData.GeneralData.whsCode = '';
    createPurchaseOrderGenData.GeneralData.remarks = '';
    createPurchaseOrderGenData.GeneralData.branchId = '';
    createPurchaseOrderGenData.GeneralData.updatedBy = '';
    createPurchaseOrderGenData.GeneralData.postingAddress = '';
    createPurchaseOrderGenData.GeneralData.tripTransId = '';
    createPurchaseOrderGenData.GeneralData.deptCode = '';
    createPurchaseOrderGenData.GeneralData.deptName = '';
    createPurchaseOrderGenData.GeneralData.supplierCode = '';
    createPurchaseOrderGenData.GeneralData.supplierName = '';
    createPurchaseOrderGenData.GeneralData.contactPersonId = '';
    createPurchaseOrderGenData.GeneralData.contactPersonName = '';

    createPurchaseOrderGenData.GeneralData.isPosted = false;
    createPurchaseOrderGenData.GeneralData.isConsumption = false;
    createPurchaseOrderGenData.GeneralData.isRequest = false;
  }

  static setCreatePurchaseOrderTextFields({required PROPRQ data}) {
    createPurchaseOrderGenData.GeneralData.iD = data.ID?.toString() ?? '';
    createPurchaseOrderGenData.GeneralData.transId = data.TransId ?? '';
    createPurchaseOrderGenData.GeneralData.refNo = data.RefNo ?? '';
    createPurchaseOrderGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    createPurchaseOrderGenData.GeneralData.postingDate =
        getFormattedDate(data.PostingDate);
    createPurchaseOrderGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    createPurchaseOrderGenData.GeneralData.approvalStatus =
        data.ApprovalStatus ?? 'Pending';
    createPurchaseOrderGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    createPurchaseOrderGenData.GeneralData.permanentTransId =
        data.PermanentTransId ?? '';
    createPurchaseOrderGenData.GeneralData.docEntry =
        data.DocEntry?.toString() ?? '';
    createPurchaseOrderGenData.GeneralData.docNum = data.DocNum ?? '';
    createPurchaseOrderGenData.GeneralData.createdBy = data.CreatedBy ?? '';
    createPurchaseOrderGenData.GeneralData.contactPersonId = '';
    createPurchaseOrderGenData.GeneralData.contactPersonName = '';
    // purchaseGenData.GeneralData.createDate = getFormattedDate(data.CreateDate);
    // purchaseGenData.GeneralData.updateDate = data.TransId??'';
    createPurchaseOrderGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    createPurchaseOrderGenData.GeneralData.error = data.Error ?? '';
    createPurchaseOrderGenData.GeneralData.isSelected = true;
    createPurchaseOrderGenData.GeneralData.hasCreated = data.hasCreated;
    createPurchaseOrderGenData.GeneralData.hasUpdated = data.hasUpdated;
    createPurchaseOrderGenData.GeneralData.isPosted = data.IsPosted ?? false;
    createPurchaseOrderGenData.GeneralData.draftKey = data.DraftKey ?? '';
    createPurchaseOrderGenData.GeneralData.latitude = data.Latitude ?? '';
    createPurchaseOrderGenData.GeneralData.longitude = data.Longitude ?? '';
    createPurchaseOrderGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    createPurchaseOrderGenData.GeneralData.whsCode = data.WhsCode ?? '';
    createPurchaseOrderGenData.GeneralData.remarks = data.Remarks ?? '';
    createPurchaseOrderGenData.GeneralData.branchId = data.BranchId ?? '';
    createPurchaseOrderGenData.GeneralData.updatedBy = data.UpdatedBy ?? '';
    createPurchaseOrderGenData.GeneralData.postingAddress =
        data.PostingAddress ?? '';
    createPurchaseOrderGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    createPurchaseOrderGenData.GeneralData.deptCode = data.DeptCode ?? '';
    createPurchaseOrderGenData.GeneralData.deptName = data.DeptName ?? '';
    createPurchaseOrderGenData.GeneralData.supplierName =
        data.RequestedCode ?? '';
    createPurchaseOrderGenData.GeneralData.supplierName =
        data.RequestedName ?? '';

    createPurchaseOrderGenData.GeneralData.isPosted = data.IsPosted ?? false;
  }

  static setViewPurchaseOrderTextFields({required PROPOR data}) {
    viewPurchaseOrderGenData.GeneralData.iD = data.ID?.toString() ?? '';
    viewPurchaseOrderGenData.GeneralData.transId = data.TransId ?? '';
    viewPurchaseOrderGenData.GeneralData.refNo = data.RefNo ?? '';
    viewPurchaseOrderGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    viewPurchaseOrderGenData.GeneralData.postingDate =
        getFormattedDate(data.PostingDate);
    viewPurchaseOrderGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    viewPurchaseOrderGenData.GeneralData.approvalStatus =
        data.ApprovalStatus ?? 'Pending';
    viewPurchaseOrderGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    viewPurchaseOrderGenData.GeneralData.permanentTransId =
        data.PermanentTransId ?? '';
    viewPurchaseOrderGenData.GeneralData.docEntry =
        data.DocEntry?.toString() ?? '';
    viewPurchaseOrderGenData.GeneralData.docNum = data.DocNum ?? '';
    viewPurchaseOrderGenData.GeneralData.createdBy = data.CreatedBy ?? '';
    // purchaseGenData.GeneralData.createDate = getFormattedDate(data.CreateDate);
    // purchaseGenData.GeneralData.updateDate = data.TransId??'';
    viewPurchaseOrderGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    viewPurchaseOrderGenData.GeneralData.error = data.Error ?? '';
    viewPurchaseOrderGenData.GeneralData.isSelected = true;
    viewPurchaseOrderGenData.GeneralData.hasCreated = data.hasCreated;
    viewPurchaseOrderGenData.GeneralData.hasUpdated = data.hasUpdated;
    viewPurchaseOrderGenData.GeneralData.isPosted = data.IsPosted ?? false;
    viewPurchaseOrderGenData.GeneralData.draftKey = data.DraftKey ?? '';
    viewPurchaseOrderGenData.GeneralData.latitude = data.Latitude ?? '';
    viewPurchaseOrderGenData.GeneralData.longitude = data.Longitude ?? '';
    viewPurchaseOrderGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    viewPurchaseOrderGenData.GeneralData.whsCode = data.WhsCode ?? '';
    viewPurchaseOrderGenData.GeneralData.remarks = data.Remarks ?? '';
    viewPurchaseOrderGenData.GeneralData.branchId = data.BranchId ?? '';
    viewPurchaseOrderGenData.GeneralData.updatedBy = data.UpdatedBy ?? '';
    viewPurchaseOrderGenData.GeneralData.postingAddress =
        data.PostingAddress ?? '';
    viewPurchaseOrderGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    viewPurchaseOrderGenData.GeneralData.deptCode = data.DeptCode ?? '';
    viewPurchaseOrderGenData.GeneralData.deptName = data.DeptName ?? '';
    editPurchaseOrderGenData.GeneralData.supplierCode = data.CardCode ?? '';
    editPurchaseOrderGenData.GeneralData.supplierName = data.CardName ?? '';

    viewPurchaseOrderGenData.GeneralData.isPosted = data.IsPosted ?? false;
  }

  static setEditPurchaseOrderTextFields({required PROPOR data}) {
    editPurchaseOrderGenData.GeneralData.iD = data.ID?.toString() ?? '';
    editPurchaseOrderGenData.GeneralData.transId = data.TransId ?? '';
    editPurchaseOrderGenData.GeneralData.refNo = data.RefNo ?? '';
    editPurchaseOrderGenData.GeneralData.mobileNo = data.MobileNo ?? '';
    editPurchaseOrderGenData.GeneralData.postingDate =
        getFormattedDate(data.PostingDate);
    editPurchaseOrderGenData.GeneralData.validUntill =
        getFormattedDate(data.ValidUntill);
    editPurchaseOrderGenData.GeneralData.approvalStatus =
        data.ApprovalStatus ?? 'Pending';
    editPurchaseOrderGenData.GeneralData.docStatus = data.DocStatus ?? 'Open';
    editPurchaseOrderGenData.GeneralData.permanentTransId =
        data.PermanentTransId ?? '';
    editPurchaseOrderGenData.GeneralData.docEntry =
        data.DocEntry?.toString() ?? '';
    editPurchaseOrderGenData.GeneralData.docNum = data.DocNum ?? '';
    editPurchaseOrderGenData.GeneralData.createdBy = data.CreatedBy ?? '';
    // purchaseGenData.GeneralData.createDate = getFormattedDate(data.CreateDate);
    // purchaseGenData.GeneralData.updateDate = data.TransId??'';
    editPurchaseOrderGenData.GeneralData.approvedBy = data.ApprovedBy ?? '';
    editPurchaseOrderGenData.GeneralData.error = data.Error ?? '';
    editPurchaseOrderGenData.GeneralData.isSelected = true;
    editPurchaseOrderGenData.GeneralData.hasCreated = data.hasCreated;
    editPurchaseOrderGenData.GeneralData.hasUpdated = data.hasUpdated;
    editPurchaseOrderGenData.GeneralData.isPosted = data.IsPosted ?? false;
    editPurchaseOrderGenData.GeneralData.draftKey = data.DraftKey ?? '';
    editPurchaseOrderGenData.GeneralData.latitude = data.Latitude ?? '';
    editPurchaseOrderGenData.GeneralData.longitude = data.Longitude ?? '';
    editPurchaseOrderGenData.GeneralData.objectCode = data.ObjectCode ?? '';
    editPurchaseOrderGenData.GeneralData.whsCode = data.WhsCode ?? '';
    editPurchaseOrderGenData.GeneralData.remarks = data.Remarks ?? '';
    editPurchaseOrderGenData.GeneralData.branchId = data.BranchId ?? '';
    editPurchaseOrderGenData.GeneralData.updatedBy = data.UpdatedBy ?? '';
    editPurchaseOrderGenData.GeneralData.postingAddress =
        data.PostingAddress ?? '';
    editPurchaseOrderGenData.GeneralData.tripTransId = data.TripTransId ?? '';
    editPurchaseOrderGenData.GeneralData.deptCode = data.DeptCode ?? '';
    editPurchaseOrderGenData.GeneralData.deptName = data.DeptName ?? '';
    editPurchaseOrderGenData.GeneralData.supplierCode = data.CardCode ?? '';
    editPurchaseOrderGenData.GeneralData.supplierName = data.CardName ?? '';

    editPurchaseOrderGenData.GeneralData.isPosted = data.IsPosted ?? false;
  }

  static setCreateShippingAddressTextFields({required PRPOR2 prpdn2}) {
    createPurchaseOrderShippingAddress.ShippingAddress.CityName =
        prpdn2.CityName.toString();
    createPurchaseOrderShippingAddress.ShippingAddress.hasCreated =
        prpdn2.hasCreated;
    createPurchaseOrderShippingAddress.ShippingAddress.hasUpdated =
        prpdn2.hasUpdated;
    createPurchaseOrderShippingAddress.ShippingAddress.CityCode =
        prpdn2.CityCode.toString();
    createPurchaseOrderShippingAddress.ShippingAddress.Addres =
        prpdn2.Address.toString();
    createPurchaseOrderShippingAddress.ShippingAddress.CountryName =
        prpdn2.CountryName.toString();
    createPurchaseOrderShippingAddress.ShippingAddress.CountryCode =
        prpdn2.CountryCode.toString();
    createPurchaseOrderShippingAddress.ShippingAddress.StateName =
        prpdn2.StateName.toString();
    createPurchaseOrderShippingAddress.ShippingAddress.RouteCode =
        prpdn2.RouteCode.toString();
    createPurchaseOrderShippingAddress.ShippingAddress.StateCode =
        prpdn2.StateCode.toString();
    createPurchaseOrderShippingAddress.ShippingAddress.Latitude =
        double.tryParse(prpdn2.Latitude.toString()) ?? 0.0;
    createPurchaseOrderShippingAddress.ShippingAddress.Longitude =
        double.tryParse(prpdn2.Longitude.toString()) ?? 0.0;
    createPurchaseOrderShippingAddress.ShippingAddress.RowId =
        int.parse(prpdn2.RowId.toString());
    createPurchaseOrderShippingAddress.ShippingAddress.AddCode =
        prpdn2.AddressCode.toString();
  }

  static setCreateBillingAddressTextFields({required PRPOR3 prpdn3}) {
    createPurchaseOrderBillAddress.BillingAddress.CityName =
        prpdn3.CityName.toString();
    createPurchaseOrderBillAddress.BillingAddress.hasCreated =
        prpdn3.hasCreated;
    createPurchaseOrderBillAddress.BillingAddress.hasUpdated =
        prpdn3.hasUpdated;
    createPurchaseOrderBillAddress.BillingAddress.CityCode =
        prpdn3.CityCode.toString();
    createPurchaseOrderBillAddress.BillingAddress.Addres =
        prpdn3.Address.toString();
    createPurchaseOrderBillAddress.BillingAddress.CountryName =
        prpdn3.CountryName.toString();
    createPurchaseOrderBillAddress.BillingAddress.CountryCode =
        prpdn3.CountryCode.toString();
    createPurchaseOrderBillAddress.BillingAddress.StateName =
        prpdn3.StateName.toString();
    createPurchaseOrderBillAddress.BillingAddress.StateCode =
        prpdn3.StateCode.toString();
    createPurchaseOrderBillAddress.BillingAddress.Latitude =
        double.tryParse(prpdn3.Latitude.toString()) ?? 0.0;
    createPurchaseOrderBillAddress.BillingAddress.Longitude =
        double.tryParse(prpdn3.Longitude.toString()) ?? 0.0;
    createPurchaseOrderBillAddress.BillingAddress.RowId =
        int.parse(prpdn3.RowId.toString());
    createPurchaseOrderBillAddress.BillingAddress.AddCode =
        prpdn3.AddressCode.toString();
  }

  static setViewShippingAddressTextFields({required PRPOR2 prpdn2}) {
    viewPurchaseOrderShippingAddress.ShippingAddress.CityName =
        prpdn2.CityName.toString();
    viewPurchaseOrderShippingAddress.ShippingAddress.hasCreated =
        prpdn2.hasCreated;
    viewPurchaseOrderShippingAddress.ShippingAddress.hasUpdated =
        prpdn2.hasUpdated;
    viewPurchaseOrderShippingAddress.ShippingAddress.CityCode =
        prpdn2.CityCode.toString();
    viewPurchaseOrderShippingAddress.ShippingAddress.Addres =
        prpdn2.Address.toString();
    viewPurchaseOrderShippingAddress.ShippingAddress.CountryName =
        prpdn2.CountryName.toString();
    viewPurchaseOrderShippingAddress.ShippingAddress.CountryCode =
        prpdn2.CountryCode.toString();
    viewPurchaseOrderShippingAddress.ShippingAddress.StateName =
        prpdn2.StateName.toString();
    viewPurchaseOrderShippingAddress.ShippingAddress.RouteCode =
        prpdn2.RouteCode.toString();
    viewPurchaseOrderShippingAddress.ShippingAddress.StateCode =
        prpdn2.StateCode.toString();
    viewPurchaseOrderShippingAddress.ShippingAddress.Latitude =
        double.tryParse(prpdn2.Latitude.toString()) ?? 0.0;
    viewPurchaseOrderShippingAddress.ShippingAddress.Longitude =
        double.tryParse(prpdn2.Longitude.toString()) ?? 0.0;
    viewPurchaseOrderShippingAddress.ShippingAddress.RowId =
        int.parse(prpdn2.RowId.toString());
    viewPurchaseOrderShippingAddress.ShippingAddress.AddCode =
        prpdn2.AddressCode.toString();
  }

  static setViewBillingAddressTextFields({required PRPOR3 prpdn3}) {
    viewPurchaseOrderBillAddress.BillingAddress.CityName =
        prpdn3.CityName.toString();
    viewPurchaseOrderBillAddress.BillingAddress.hasCreated = prpdn3.hasCreated;
    viewPurchaseOrderBillAddress.BillingAddress.hasUpdated = prpdn3.hasUpdated;
    viewPurchaseOrderBillAddress.BillingAddress.CityCode =
        prpdn3.CityCode.toString();
    viewPurchaseOrderBillAddress.BillingAddress.Addres =
        prpdn3.Address.toString();
    viewPurchaseOrderBillAddress.BillingAddress.CountryName =
        prpdn3.CountryName.toString();
    viewPurchaseOrderBillAddress.BillingAddress.CountryCode =
        prpdn3.CountryCode.toString();
    viewPurchaseOrderBillAddress.BillingAddress.StateName =
        prpdn3.StateName.toString();
    viewPurchaseOrderBillAddress.BillingAddress.StateCode =
        prpdn3.StateCode.toString();
    viewPurchaseOrderBillAddress.BillingAddress.Latitude =
        double.tryParse(prpdn3.Latitude.toString()) ?? 0.0;
    viewPurchaseOrderBillAddress.BillingAddress.Longitude =
        double.tryParse(prpdn3.Longitude.toString()) ?? 0.0;
    viewPurchaseOrderBillAddress.BillingAddress.RowId =
        int.parse(prpdn3.RowId.toString());
    viewPurchaseOrderBillAddress.BillingAddress.AddCode =
        prpdn3.AddressCode.toString();
  }

  static setEditShippingAddressTextFields({required PRPOR2 prpdn2}) {
    editPurchaseOrderShippingAddress.ShippingAddress.CityName =
        prpdn2.CityName.toString();
    editPurchaseOrderShippingAddress.ShippingAddress.hasCreated =
        prpdn2.hasCreated;
    editPurchaseOrderShippingAddress.ShippingAddress.hasUpdated =
        prpdn2.hasUpdated;
    editPurchaseOrderShippingAddress.ShippingAddress.CityCode =
        prpdn2.CityCode.toString();
    editPurchaseOrderShippingAddress.ShippingAddress.Addres =
        prpdn2.Address.toString();
    editPurchaseOrderShippingAddress.ShippingAddress.CountryName =
        prpdn2.CountryName.toString();
    editPurchaseOrderShippingAddress.ShippingAddress.CountryCode =
        prpdn2.CountryCode.toString();
    editPurchaseOrderShippingAddress.ShippingAddress.StateName =
        prpdn2.StateName.toString();
    editPurchaseOrderShippingAddress.ShippingAddress.RouteCode =
        prpdn2.RouteCode.toString();
    editPurchaseOrderShippingAddress.ShippingAddress.StateCode =
        prpdn2.StateCode.toString();
    editPurchaseOrderShippingAddress.ShippingAddress.Latitude =
        double.tryParse(prpdn2.Latitude.toString()) ?? 0.0;
    editPurchaseOrderShippingAddress.ShippingAddress.Longitude =
        double.tryParse(prpdn2.Longitude.toString()) ?? 0.0;
    editPurchaseOrderShippingAddress.ShippingAddress.RowId =
        int.parse(prpdn2.RowId.toString());
    editPurchaseOrderShippingAddress.ShippingAddress.AddCode =
        prpdn2.AddressCode.toString();
  }

  static setEditBillingAddressTextFields({required PRPOR3 prpdn3}) {
    editPurchaseOrderBillAddress.BillingAddress.CityName =
        prpdn3.CityName.toString();
    editPurchaseOrderBillAddress.BillingAddress.hasCreated = prpdn3.hasCreated;
    editPurchaseOrderBillAddress.BillingAddress.hasUpdated = prpdn3.hasUpdated;
    editPurchaseOrderBillAddress.BillingAddress.CityCode =
        prpdn3.CityCode.toString();
    editPurchaseOrderBillAddress.BillingAddress.Addres =
        prpdn3.Address.toString();
    editPurchaseOrderBillAddress.BillingAddress.CountryName =
        prpdn3.CountryName.toString();
    editPurchaseOrderBillAddress.BillingAddress.CountryCode =
        prpdn3.CountryCode.toString();
    editPurchaseOrderBillAddress.BillingAddress.StateName =
        prpdn3.StateName.toString();
    editPurchaseOrderBillAddress.BillingAddress.StateCode =
        prpdn3.StateCode.toString();
    editPurchaseOrderBillAddress.BillingAddress.Latitude =
        double.tryParse(prpdn3.Latitude.toString()) ?? 0.0;
    editPurchaseOrderBillAddress.BillingAddress.Longitude =
        double.tryParse(prpdn3.Longitude.toString()) ?? 0.0;
    editPurchaseOrderBillAddress.BillingAddress.RowId =
        int.parse(prpdn3.RowId.toString());
    editPurchaseOrderBillAddress.BillingAddress.AddCode =
        prpdn3.AddressCode.toString();
  }

  static clearShippingAddressTextFields() {
    createPurchaseOrderShippingAddress.ShippingAddress.CityName = '';
    createPurchaseOrderShippingAddress.ShippingAddress.hasCreated = false;
    createPurchaseOrderShippingAddress.ShippingAddress.hasUpdated = false;
    createPurchaseOrderShippingAddress.ShippingAddress.CityCode = '';
    createPurchaseOrderShippingAddress.ShippingAddress.Addres = '';
    createPurchaseOrderShippingAddress.ShippingAddress.CountryName = '';
    createPurchaseOrderShippingAddress.ShippingAddress.CountryCode = '';
    createPurchaseOrderShippingAddress.ShippingAddress.StateName = '';
    createPurchaseOrderShippingAddress.ShippingAddress.RouteCode = '';
    createPurchaseOrderShippingAddress.ShippingAddress.StateCode = '';
    createPurchaseOrderShippingAddress.ShippingAddress.Latitude = 0.0;
    createPurchaseOrderShippingAddress.ShippingAddress.Longitude = 0.0;
    createPurchaseOrderShippingAddress.ShippingAddress.RowId = 0;
    createPurchaseOrderShippingAddress.ShippingAddress.AddCode = '';
  }

  static clearBillingAddressTextFields() {
    createPurchaseOrderBillAddress.BillingAddress.CityName = '';
    createPurchaseOrderBillAddress.BillingAddress.hasCreated = false;
    createPurchaseOrderBillAddress.BillingAddress.hasUpdated = false;
    createPurchaseOrderBillAddress.BillingAddress.CityCode = '';
    createPurchaseOrderBillAddress.BillingAddress.Addres = '';
    createPurchaseOrderBillAddress.BillingAddress.CountryName = '';
    createPurchaseOrderBillAddress.BillingAddress.CountryCode = '';
    createPurchaseOrderBillAddress.BillingAddress.StateName = '';
    createPurchaseOrderBillAddress.BillingAddress.StateCode = '';
    createPurchaseOrderBillAddress.BillingAddress.Latitude = 0.0;
    createPurchaseOrderBillAddress.BillingAddress.Longitude = 0.0;
    createPurchaseOrderBillAddress.BillingAddress.RowId = 0;
    createPurchaseOrderBillAddress.BillingAddress.AddCode = '';
  }

  static clearEditItems() {
    createPurchaseEditItems.EditItems.noOfPieces = '';
    createPurchaseEditItems.EditItems.remarks = '';
    createPurchaseEditItems.EditItems.id = '';
    createPurchaseEditItems.EditItems.tripTransId = '';

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

goToNewPurchaseOrderDocument() async {
  await ClearPurchaseOrderDocument.clearGeneralDataTextFields();
  await ClearPurchaseOrderDocument.clearEditItems();
  await ClearPurchaseOrderDocument.clearShippingAddressTextFields();
  await ClearPurchaseOrderDocument.clearBillingAddressTextFields();
  createPurchaseOrderItemDetails.ItemDetails.items.clear();

  String TransId = await GenerateTransId.getTransId(tableName: 'PROPOR', docName: 'PROR');
  createPurchaseOrderGenData.GeneralData.transId=TransId;
  Get.offAll(() => PurchaseOrder(0));
}

navigateToPurchaseOrderDocument(
    {required String TransId, required bool isView}) async {
  if (isView) {
    List<PROPOR> list =
        await retrievePROPORById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearPurchaseOrderDocument.setViewPurchaseOrderTextFields(data: list[0]);
    }
    viewPurchaseOrderItemDetails.ItemDetails.items =
        await retrievePRPOR1ById(null, 'TransId = ?', [TransId]);

    List<PRPOR2> PRPOR2list =
        await retrievePRPOR2ById(null, 'TransId = ?', [TransId]);
    if (PRPOR2list.isNotEmpty) {
      ClearPurchaseOrderDocument.setViewShippingAddressTextFields(
          prpdn2: PRPOR2list[0]);
    }
    List<PRPOR3> PRPOR3list =
        await retrievePRPOR3ById(null, 'TransId = ?', [TransId]);
    if (PRPOR3list.isNotEmpty) {
      ClearPurchaseOrderDocument.setViewBillingAddressTextFields(
          prpdn3: PRPOR3list[0]);
    }

    Get.offAll(() => ViewPurchaseOrder(0));
  } else {
    List<PROPOR> list =
        await retrievePROPORById(null, 'TransId = ?', [TransId]);
    if (list.isNotEmpty) {
      ClearPurchaseOrderDocument.setEditPurchaseOrderTextFields(data: list[0]);
    }
    editPurchaseOrderItemDetails.ItemDetails.items =
        await retrievePRPOR1ById(null, 'TransId = ?', [TransId]);

    List<PRPOR2> PRPOR2list =
        await retrievePRPOR2ById(null, 'TransId = ?', [TransId]);
    if (PRPOR2list.isNotEmpty) {
      ClearPurchaseOrderDocument.setEditShippingAddressTextFields(
          prpdn2: PRPOR2list[0]);
    }
    List<PRPOR3> PRPOR3list =
        await retrievePRPOR3ById(null, 'TransId = ?', [TransId]);
    if (PRPOR3list.isNotEmpty) {
      ClearPurchaseOrderDocument.setEditBillingAddressTextFields(
          prpdn3: PRPOR3list[0]);
    }

    Get.offAll(() => EditPurchaseOrder(0));
  }
}
