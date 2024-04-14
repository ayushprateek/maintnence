// import 'package:get/get.dart';
// import 'package:maintenance/ARInvoice/ARInvoice.dart';
// import 'package:maintenance/Sync/SyncModels/OWHS.dart';
// import 'package:maintenance/ARInvoice/Addresses/BillingAddress.dart'
//     as ARInvoiceBill;
// import 'package:maintenance/ARInvoice/Addresses/ShippingAddress.dart'
//     as ARInvoiceShip;
// import 'package:maintenance/ARInvoice/GeneralData.dart' as ARInvoiceGen;
// import 'package:maintenance/ARInvoice/ItemDetails/ItemDetails.dart'
//     as ARItemDetails;
// import 'package:maintenance/Activity/Activity.dart' as activity;
// import 'package:maintenance/Activity/AdditionalPeople.dart' as activityAddPpl;
// import 'package:maintenance/Activity/Attachments.dart' as activityAttachment;
// import 'package:maintenance/Activity/GeneralData.dart' as actGenData;
// import 'package:maintenance/Activity/Transfer.dart' as activityTransfer;
// import 'package:maintenance/ApprovalStatus/ApprovalStatus.dart';
// import 'package:maintenance/CashReceipt/CashReceipt.dart';
// import 'package:maintenance/CashReceipt/GeneralData.dart' as CashRcptGen;
// import 'package:maintenance/Component/GetFormattedDate.dart';
// import 'package:maintenance/CustomersVisit/Attachment.dart'
//     as customerVisitAttachment;
// import 'package:maintenance/CustomersVisit/CompetitorDetails.dart'
//     as customerVisitCompetitorDetails;
// import 'package:maintenance/CustomersVisit/CustomerVisit.dart' as customerVisit;
// import 'package:maintenance/CustomersVisit/GeneralData.dart'
//     as customerVisitGeneral;
// import 'package:maintenance/CustomersVisit/MarketingMaterial.dart'
//     as customerVisitMarketing;
// import 'package:maintenance/CustomersVisit/TransactionInfo.dart'
//     as customerVisitTransactionInfo;
// import 'package:maintenance/CustomersVisit/TransactionInfo.dart';
// import 'package:maintenance/DatabaseInitialization.dart';
// import 'package:maintenance/Delivery/Addresses/BillingAddress.dart'
//     as DeliveryBill;
// import 'package:maintenance/Delivery/Addresses/ShippingAddress.dart'
//     as DeliveryShip;
// import 'package:maintenance/Delivery/GeneralData.dart' as DeliveryGen;
// import 'package:maintenance/Delivery/ItemDetails/ItemDetails.dart'
//     as DelItemDetails;
// import 'package:maintenance/DeliveryConfirmation/Addresses/BillingAddress.dart'
//     as DeliveryConfirmationBill;
// import 'package:maintenance/DeliveryConfirmation/Addresses/ShippingAddress.dart'
//     as DeliveryConfirmationShip;
// import 'package:maintenance/DeliveryConfirmation/DeliveryConfirmation.dart';
// import 'package:maintenance/DeliveryConfirmation/GeneralData.dart'
//     as DeliveryConfirmationGen;
// import 'package:maintenance/DeliveryConfirmation/ItemDetails/ItemDetails.dart'
//     as DeliveryConfirmationItemDetails;
// import 'package:maintenance/DeliverySchedule/DeliverySchedule.dart';
// import 'package:maintenance/DeliverySchedule/GeneralData.dart'
//     as DeliveryScheduleGen;
// import 'package:maintenance/DeliverySchedule/ItemDetails/AdditionalItemDetails.dart'
//     as DeliveryScheduleAddItems;
// import 'package:maintenance/DeliverySchedule/ItemDetails/ItemDetailsModel.dart';
// import 'package:maintenance/DeliverySchedule/TransactionInfo.dart'
//     as DeliveryScheduleTr;
// import 'package:maintenance/ExpenseManagement/CashHandover/CashHandover.dart'
//     as cashHandover;
// import 'package:maintenance/ExpenseManagement/CashHandover/CashHandoverScreen.dart'
//     as cashHandoverScreen;
// import 'package:maintenance/ExpenseManagement/CashRequisition/CashRequisition.dart'
//     as cashReq;
// import 'package:maintenance/ExpenseManagement/CashRequisition/EmployeeData.dart'
//     as cashReqEmpData;
// import 'package:maintenance/ExpenseManagement/CashRequisition/ExpenseType.dart'
//     as cashReqExpType;
// import 'package:maintenance/ExpenseManagement/CashRequisitionApproval/CashRequisitionApproval.dart'
//     as cashReqApr;
// import 'package:maintenance/ExpenseManagement/CashRequisitionApproval/EmployeeData.dart'
//     as cashReqAprEmpData;
// import 'package:maintenance/ExpenseManagement/CashRequisitionApproval/ExpenseType.dart'
//     as cashReqExpAprType;
// import 'package:maintenance/ExpenseManagement/ExpenseCapture/ECSummary.dart';
// import 'package:maintenance/ExpenseManagement/ExpenseCapture/ExpenseCapture.dart'
//     as expenseCapture;
// import 'package:maintenance/ExpenseManagement/ExpenseCapture/ExpenseCaptureScreen.dart'
//     as expenseCaptureScreen;
// import 'package:maintenance/ExpenseManagement/ExpenseCaptureApproval/Documents.dart'
//     as expenseCaptureApprovalDocs;
// import 'package:maintenance/ExpenseManagement/ExpenseCaptureApproval/Summary.dart'
//     as expenseCaptureApprovalSummary;
// import 'package:maintenance/ExpenseManagement/Reconciliation/EmployeeData.dart'
//     as reconEmpData;
// import 'package:maintenance/ExpenseManagement/Reconciliation/ExpenseType.dart'
//     as reconExpnseData;
// import 'package:maintenance/ExpenseManagement/Reconciliation/Reconciliation.dart'
//     as reconciliation;
// import 'package:maintenance/ReturnOrder/Addresses/BillingAddress.dart'
//     as returnBillAdd;
// import 'package:maintenance/ReturnOrder/Addresses/ShippingAddress.dart'
//     as returnShipAdd;
// import 'package:maintenance/ReturnOrder/GeneralData.dart' as returnGenData;
// import 'package:maintenance/ReturnOrder/ItemDetails/ItemDetails.dart'
//     as returnItemDetails;
// import 'package:maintenance/ReturnOrder/ReturnOrder.dart';
// import 'package:maintenance/Sales&Planning/Deposit/Deposit.dart' as deposit;
// import 'package:maintenance/Sales&Planning/Deposit/EmployeeData.dart'
//     as depositEmpData;
// import 'package:maintenance/SalesOrder/Addresses/BillingAddress.dart'
//     as SalesOrderBill;
// import 'package:maintenance/SalesOrder/Addresses/ShippingAddress.dart'
//     as SalesOrderShip;
// import 'package:maintenance/SalesOrder/GeneralData.dart' as SalesOrderGen;
// import 'package:maintenance/SalesOrder/ItemDetails/ItemDetails.dart'
//     as SOItemDetails;
// import 'package:maintenance/SalesOrder/SalesOrder.dart';
// import 'package:maintenance/SalesQuotation/Addresses/BillingAddress.dart'
//     as salesQuotationBill;
// import 'package:maintenance/SalesQuotation/Addresses/ShippingAddress.dart'
//     as salesQuotationShip;
// import 'package:maintenance/SalesQuotation/GeneralData.dart' as salesQuotationGen;
// import 'package:maintenance/SalesQuotation/ItemDetails/ItemDetails.dart'
//     as salesItemDetails;
// import 'package:maintenance/SalesQuotation/SalesQuotation.dart' as salesQuotation;
// import 'package:maintenance/StockTake/GeneralData.dart' as stkGenData;
// import 'package:maintenance/StockTake/ItemDetails/ItemDetails.dart'
//     as stkItmDetails;
// import 'package:maintenance/StockTake/StockTake.dart' as stockTake;
// import 'package:maintenance/Sync/SyncModels/ApprovalModel.dart';
// import 'package:maintenance/Sync/SyncModels/DPT1.dart';
// import 'package:maintenance/Sync/SyncModels/ECP1.dart';
// import 'package:maintenance/Sync/SyncModels/LITPL_OADM.dart';
// import 'package:maintenance/Sync/SyncModels/OCRN.dart';
// import 'package:maintenance/Sync/SyncModels/OCRT.dart';
// import 'package:maintenance/Sync/SyncModels/XPM1.dart';
// import 'package:maintenance/VisitPlan/GeneralData.dart' as vpGenData;
// import 'package:maintenance/VisitPlan/Plan/EditPlan.dart' as vpEditPlan;
// import 'package:maintenance/VisitPlan/Plan/NewCustomerVisit.dart';
// import 'package:maintenance/VisitPlan/Plan/VisitList.dart' as vpPlanList;
// import 'package:maintenance/VisitPlan/VisitPlan.dart' as visitPlan;
//
// // import 'package:maintenance/Activity/AdditionalPeople.dart' as activityAdditionalPeople;
// // import 'package:maintenance/Activity/AdditionalPeople.dart' as activityAdditionalPeople;
// import 'package:maintenance/main.dart';
// import 'package:sqflite/sqlite_api.dart';
//
// clearActivityData() {
//   activity.Activity.selectedActionIndex = RxInt(4);
//   activity.Activity.selectedAction = RxString('Activity');
//   actGenData.GeneralData.BaseTransId = '';
//   actGenData.GeneralData.WebTransId = '';
//   actGenData.GeneralData.ERPDocnum = '';
//   actGenData.GeneralData.TransId = '';
//   actGenData.GeneralData.CustomerCode = '';
//   actGenData.GeneralData.CustomerName = '';
//   actGenData.GeneralData.ContactPersonId = '';
//   actGenData.GeneralData.ContactPersonName = '';
//   actGenData.GeneralData.MobileNumber = '';
//   actGenData.GeneralData.ActivityLocation = '';
//   actGenData.GeneralData.Remarks = '';
//   actGenData.GeneralData.Latitude = '';
//   actGenData.GeneralData.Longitude = '';
//   actGenData.GeneralData.StartDate = '';
//   actGenData.GeneralData.StartTime = '';
//   actGenData.GeneralData.EndDate = '';
//   actGenData.GeneralData.EndTime = '';
//   actGenData.GeneralData.ActivityCompleteTime = '';
//   actGenData.GeneralData.TicketSubject = '';
//   actGenData.GeneralData.PreviousRemarks = '';
//   actGenData.GeneralData.Subject = '';
//   actGenData.GeneralData.Notes = '';
//   actGenData.GeneralData.ActivityType = '';
//   actGenData.GeneralData.SubActivityType = '';
//   actGenData.GeneralData.isActivityDone = false;
//   actGenData.GeneralData.PostingDate = getFormattedDate(DateTime.now());
//   activityAddPpl.AdditionalPeople.additionalPeople.clear();
//   activityTransfer.Transfer.isOwnDepartment = false;
//   activityAttachment.Attachment.attachments.clear();
//   activityAttachment.Attachment.attachment = '';
//   activityAttachment.Attachment.rowId = '';
//   activityAttachment.Attachment.Remarks = '';
//   activityAttachment.Attachment.imageFile = null;
//
//   actGenData.GeneralData.ID = '';
//   actGenData.GeneralData.CreatedBy = '';
//   actGenData.GeneralData.UpdatedBy = '';
//   actGenData.GeneralData.BranchId = '';
//   actGenData.GeneralData.CreateDate = null;
//   actGenData.GeneralData.UpdateDate = null;
//   actGenData.GeneralData.PermanentTransId = '';
//   actGenData.GeneralData.DocEntry = '';
//   actGenData.GeneralData.DocNum = '';
//   actGenData.GeneralData.IssueStatus = 'Select status';
//   actGenData.GeneralData.BaseDocument = 'Select Document';
//   actGenData.GeneralData.AssignToEmpCode = '';
//   actGenData.GeneralData.AssignToEmpName = '';
//   actGenData.GeneralData.IsOwnDepartment = false;
//   actGenData.GeneralData.EmpCode = '';
//
//   actGenData.GeneralData.ActivityTypeCode = '';
//   actGenData.GeneralData.ActivityTypeName = '';
//   actGenData.GeneralData.SubActivityTypeCode = '';
//   actGenData.GeneralData.SubActivityTypeName = '';
//
//   actGenData.GeneralData.PostingAddress = '';
//
//   actGenData.GeneralData.hasCreated = false;
//   actGenData.GeneralData.hasUpdated = false;
//   actGenData.GeneralData.isSelected = false;
// }
//
// Future<void> clearCustomerVisitData() async {
//   TransactionInfo.delivery.clear();
//   TransactionInfo.salesOrder.clear();
//   TransactionInfo.salesQuotation.clear();
//   TransactionInfo.invoice.clear();
//
//   customerVisit.CustomerVisit.saveButtonPesses = false;
//   customerVisit.CustomerVisit.approvalModel =
//       await ApprovalModel.getApprovalModel(DocName: 'Customer Visit');
//   customerVisitGeneral.GeneralData.ID = "";
//   customerVisitGeneral.GeneralData.BaseTransId = "";
//   customerVisitGeneral.GeneralData.VPRowId = "";
//   customerVisitGeneral.GeneralData.isComingFromVPMap = false;
//   customerVisitGeneral.GeneralData.meetingDone = false;
//   customerVisitGeneral.GeneralData.isSelected = false;
//   customerVisitGeneral.GeneralData.hasCreated = false;
//   customerVisitGeneral.GeneralData.hasUpdated = false;
//   customerVisitGeneral.GeneralData.unRegisteredCustomer = true;
//   customerVisitGeneral.GeneralData.enableCustomerName = false;
//   customerVisitGeneral.GeneralData.Currency = userModel.Currency;
//   customerVisitGeneral.GeneralData.CurrRate = userModel.Rate;
//   customerVisitGeneral.GeneralData.selectedMobileCode = "";
//   customerVisitGeneral.GeneralData.PermanentTransId = "";
//   customerVisitGeneral.GeneralData.DocNum = "";
//   customerVisitGeneral.GeneralData.ContactPersonID = "";
//   customerVisitGeneral.GeneralData.TransId = "";
//   customerVisitGeneral.GeneralData.customerCode = "";
//   customerVisitGeneral.GeneralData.customerName = "";
//   customerVisitGeneral.GeneralData.RefNo = "";
//   customerVisitGeneral.GeneralData.ContactPerson = "";
//   customerVisitGeneral.GeneralData.MobileNo = "";
//   customerVisitGeneral.GeneralData.meetinglocation = "";
//   customerVisitGeneral.GeneralData.geofancingdetails = "";
//   customerVisitGeneral.GeneralData.RouteCode = "";
//   customerVisitGeneral.GeneralData.RouteName = "";
//   customerVisitGeneral.GeneralData.CustomerVisitType = "New Customer Visit";
//
//   DateTime now = DateTime.now();
//   customerVisitGeneral.GeneralData.PostingDate = getFormattedDate(now);
//   customerVisitGeneral.GeneralData.LocalPostingDate = await getLocalDate(now);
//   customerVisitGeneral.GeneralData.startdate = getFormattedDate(DateTime.now());
//   customerVisitGeneral.GeneralData.localStartdate = await getLocalDate(now);
//   customerVisitGeneral.GeneralData.starttime =
//       now.hour.toString() + ":" + now.minute.toString();
//   customerVisitGeneral.GeneralData.enddate = getFormattedDate(DateTime.now());
//   customerVisitGeneral.GeneralData.LocalEnddate = await getLocalDate(now);
//   customerVisitGeneral.GeneralData.endtime =
//       (now.hour + 1).toString() + ":" + now.minute.toString();
//   customerVisitGeneral.GeneralData.MeetingTypeCode = "";
//   customerVisitGeneral.GeneralData.subject = "";
//
//   customerVisitGeneral.GeneralData.DocStatus = "Open";
//   customerVisitCompetitorDetails.CompetitorDetails.isSelected = false;
//   customerVisitCompetitorDetails.CompetitorDetails.RowId = "";
//   customerVisitCompetitorDetails.CompetitorDetails.Price = "";
//   customerVisitCompetitorDetails.CompetitorDetails.ItemCode = "";
//   customerVisitCompetitorDetails.CompetitorDetails.ItemName = "";
//   customerVisitCompetitorDetails.CompetitorDetails.Quantity = "";
//   customerVisitCompetitorDetails.CompetitorDetails.UOM = "";
//   customerVisitCompetitorDetails.CompetitorDetails.Competitor = "";
//   customerVisitAttachment.Attachment.docName = "";
//   customerVisitAttachment.Attachment.Remarks = "";
//   customerVisitCompetitorDetails.CompetitorDetails.list.clear();
//   customerVisitMarketing.MarketingMaterial.list.clear();
//   customerVisitAttachment.Attachment.attachments.clear();
//   customerVisitTransactionInfo.TransactionInfo.salesQuotation.clear();
//   customerVisitTransactionInfo.TransactionInfo.salesOrder.clear();
//   customerVisitTransactionInfo.TransactionInfo.delivery.clear();
//   customerVisitTransactionInfo.TransactionInfo.invoice.clear();
//   customerVisitTransactionInfo.TransactionInfo.cashReceipt.clear();
//   customerVisitTransactionInfo.TransactionInfo.visitPlan.clear();
// }
//
// void clearNewCustomerVisit() {
//   NewCustomerVisit.ContactPersonID = '';
//   NewCustomerVisit.customerCode = '';
//   NewCustomerVisit.customerName = '';
//   NewCustomerVisit.ContactPerson = '';
//   NewCustomerVisit.MobileNo = '';
//   NewCustomerVisit.CustomerVisitType = '';
//   NewCustomerVisit.selectedMobileCode = '';
//   NewCustomerVisit.unRegisteredCustomer = true;
//   NewCustomerVisit.enableCustomerName = false;
//   NewCustomerVisit.MobileNumberLength = 10;
// }
//
// clearSalesQuotationData({Transaction? txn}) async {
//   salesItemDetails.ItemDetails.items.clear();
//   salesQuotation.SalesQuotation.approvalModel =
//       await ApprovalModel.getApprovalModel(
//           DocName: 'Sales Quotation', txn: txn);
//   salesQuotation.SalesQuotation.saveButtonPressed = false;
//
//   salesQuotationGen.GeneralData.isSelected = false;
//   salesQuotationGen.GeneralData.hasCreated = false;
//   salesQuotationGen.GeneralData.hasUpdated = false;
//   salesQuotationGen.GeneralData.PriceListCode = "";
//   salesQuotationGen.GeneralData.WhsCode = "";
//   List<OWHS> owhsList=await retrieveOWHSById(null, 'BranchId = ?', [userModel.BranchId],limit: 1);
//   if(owhsList.isNotEmpty)
//   {
//     salesQuotationGen.GeneralData.WhsCode = owhsList[0].WhsCode;
//   }
//   salesQuotationGen.GeneralData.DocNum = "";
//   salesQuotationGen.GeneralData.PermanentTransId = "";
//   salesQuotationGen.GeneralData.Remarks = "";
//   salesQuotationGen.GeneralData.ID = "";
//   salesQuotationGen.GeneralData.TransId = "";
//
//   if (userModel.Type == 'Customer') {
//     salesQuotationGen.GeneralData.customerCode = userModel.UserCode;
//     salesQuotationGen.GeneralData.customerName = userModel.Name;
//   }
//   else
//   {
//     salesQuotationGen.GeneralData.customerCode = '';
//     salesQuotationGen.GeneralData.customerName = '';
//   }
//   salesQuotationGen.GeneralData.RefNo = "";
//   salesQuotationGen.GeneralData.ContactPersonID = "";
//   salesQuotationGen.GeneralData.ContactPerson = "";
//   salesQuotationGen.GeneralData.MobileNo = "";
//
//   DateTime post = DateTime.now();
//   DateTime valid = DateTime.now().add(Duration(days: 7));
//   salesQuotationGen.GeneralData.PostingDate = getFormattedDate(post);
//   salesQuotationGen.GeneralData.ValidUntill = getFormattedDate(valid);
//   salesQuotationGen.GeneralData.LocalPostingDate = await getLocalDate(post);
//   salesQuotationGen.GeneralData.LocalValidUntill = await getLocalDate(valid);
//   salesQuotationGen.GeneralData.Currency = userModel.Currency;
//   salesQuotationGen.GeneralData.CurrRate = userModel.Rate;
//   salesQuotationGen.GeneralData.PaymentTermCode = "";
//   salesQuotationGen.GeneralData.PaymentTermName = "";
//   salesQuotationGen.GeneralData.PaymentTermDays = "";
//   salesQuotationGen.GeneralData.ApprovalStatus = "Pending";
//   salesQuotationGen.GeneralData.DocStatus = "Open";
//   salesQuotationShip.ShippingAddress.RouteCode = "";
//   salesQuotationShip.ShippingAddress.CityName = "";
//   salesQuotationShip.ShippingAddress.CityCode = "";
//   salesQuotationShip.ShippingAddress.Addres = "";
//   salesQuotationShip.ShippingAddress.CountryName = "";
//   salesQuotationShip.ShippingAddress.CountryCode = "";
//   salesQuotationShip.ShippingAddress.StateName = "";
//   salesQuotationShip.ShippingAddress.StateCode = "";
//   salesQuotationShip.ShippingAddress.Latitude = 0.0;
//   salesQuotationShip.ShippingAddress.Longitude = 0.0;
//   salesQuotationShip.ShippingAddress.RowId = 0;
//   salesQuotationShip.ShippingAddress.AddCode = "";
//   salesQuotationBill.BillingAddress.CityName = "";
//   salesQuotationBill.BillingAddress.CityCode = "";
//   salesQuotationBill.BillingAddress.Addres = "";
//   salesQuotationBill.BillingAddress.CountryName = "";
//   salesQuotationBill.BillingAddress.CountryCode = "";
//   salesQuotationBill.BillingAddress.StateName = "";
//   salesQuotationBill.BillingAddress.StateCode = "";
//   salesQuotationBill.BillingAddress.Latitude = 0.0;
//   salesQuotationBill.BillingAddress.Longitude = 0.0;
//   salesQuotationBill.BillingAddress.RowId = 0;
//   salesQuotationBill.BillingAddress.AddCode = "";
// }
//
// Future<void> clearSalesOrderData() async {
//   SOItemDetails.ItemDetails.items.clear();
//   SalesOrder.approvalModel =
//       await ApprovalModel.getApprovalModel(DocName: 'Sales Order');
//   SalesOrderGen.GeneralData.isSelected = false;
//   SalesOrderGen.GeneralData.ID = "";
//   List<OWHS> owhsList=await retrieveOWHSById(null, 'BranchId = ?', [userModel.BranchId],limit: 1);
//   if(owhsList.isNotEmpty)
//   {
//     SalesOrderGen.GeneralData.WhsCode = owhsList[0].WhsCode;
//   }
//   SalesOrderGen.GeneralData.PriceListCode = "";
//   SalesOrderGen.GeneralData.PermanentTransId = "";
//   SalesOrderGen.GeneralData.DocNum = "";
//   SalesOrderGen.GeneralData.BaseTransId = "";
//   SalesOrderGen.GeneralData.Remarks = "";
//   SalesOrderGen.GeneralData.TransId = "";
//
//   SalesOrderGen.GeneralData.RefNo = "";
//   SalesOrderGen.GeneralData.ContactPersonID = "";
//   SalesOrderGen.GeneralData.ContactPerson = "";
//   SalesOrderGen.GeneralData.MobileNo = "";
//   DateTime post = DateTime.now();
//   DateTime valid = DateTime.now().add(Duration(days: 7));
//   SalesOrderGen.GeneralData.PostingDate = getFormattedDate(post);
//   SalesOrderGen.GeneralData.ValidUntill = getFormattedDate(valid);
//   SalesOrderGen.GeneralData.LocalPostingDate = await getLocalDate(post);
//   SalesOrderGen.GeneralData.LocalValidUntill = await getLocalDate(valid);
//   SalesOrderGen.GeneralData.Currency = userModel.Currency;
//   SalesOrderGen.GeneralData.CurrRate = userModel.Rate;
//   SalesOrderGen.GeneralData.PaymentTermCode = "";
//   SalesOrderGen.GeneralData.PaymentTermName = "";
//   SalesOrderGen.GeneralData.PaymentTermDays = "";
//   SalesOrderGen.GeneralData.ApprovalStatus = "Pending";
//   SalesOrderGen.GeneralData.DocStatus = "Open";
//   if (userModel.Type == 'Customer') {
//     SalesOrderGen.GeneralData.customerCode = userModel.UserCode;
//     SalesOrderGen.GeneralData.customerName = userModel.Name;
//   }
//   else
//     {
//       SalesOrderGen.GeneralData.customerCode = '';
//       SalesOrderGen.GeneralData.customerName = '';
//     }
//
//   SalesOrderGen.GeneralData.MobileNo = userModel.MobileNo;
//
//   SalesOrderShip.ShippingAddress.RouteCode = "";
//   SalesOrderShip.ShippingAddress.CityCode = "";
//   SalesOrderShip.ShippingAddress.Addres = "";
//   SalesOrderShip.ShippingAddress.CityName = "";
//   SalesOrderShip.ShippingAddress.CountryName = "";
//   SalesOrderShip.ShippingAddress.CountryCode = "";
//   SalesOrderShip.ShippingAddress.StateName = "";
//   SalesOrderShip.ShippingAddress.StateCode = "";
//   SalesOrderShip.ShippingAddress.Latitude = 0.0;
//   SalesOrderShip.ShippingAddress.Longitude = 0.0;
//   SalesOrderShip.ShippingAddress.RowId = 0;
//   SalesOrderShip.ShippingAddress.AddCode = "";
//   SalesOrderBill.BillingAddress.CityName = "";
//   SalesOrderBill.BillingAddress.CityCode = "";
//   SalesOrderBill.BillingAddress.Addres = "";
//   SalesOrderBill.BillingAddress.CountryName = "";
//   SalesOrderBill.BillingAddress.CountryCode = "";
//   SalesOrderBill.BillingAddress.StateName = "";
//   SalesOrderBill.BillingAddress.StateCode = "";
//   SalesOrderBill.BillingAddress.Latitude = 0.0;
//   SalesOrderBill.BillingAddress.Longitude = 0.0;
//   SalesOrderBill.BillingAddress.RowId = 0;
//   SalesOrderBill.BillingAddress.AddCode = "";
// }
//
// Future<void> clearARInvoiceData() async {
//   ARInvoice.isComingFromAdditionalItems = false;
//   ARInvoice.isComingFromDSC = false;
//   ARInvoice.isComingFromDelivery = false;
//   ARInvoice.saveButtonPressed = false;
//   ARInvoice.approvalModel =
//       await ApprovalModel.getApprovalModel(DocName: 'Invoice');
//   ARItemDetails.ItemDetails.items.clear();
//   ARInvoiceGen.GeneralData.isSelected = false;
//   ARInvoiceGen.GeneralData.createCashReceipt = true;
//   ARInvoiceGen.GeneralData.ID = "";
//   ARInvoiceGen.GeneralData.PriceListCode = "";
//   ARInvoiceGen.GeneralData.WhsCode = "";
//   List<OWHS> owhsList=await retrieveOWHSById(null, 'BranchId = ?', [userModel.BranchId],limit: 1);
//   if(owhsList.isNotEmpty)
//   {
//     ARInvoiceGen.GeneralData.WhsCode = owhsList[0].WhsCode;
//   }
//   ARInvoiceGen.GeneralData.PermanentTransId = "";
//   ARInvoiceGen.GeneralData.DocNum = "";
//   ARInvoiceGen.GeneralData.Remarks = "";
//   ARInvoiceGen.GeneralData.BaseTab = "";
//   ARInvoiceGen.GeneralData.TransId = "";
//   if (userModel.Type == 'Customer') {
//     ARInvoiceGen.GeneralData.customerCode = userModel.UserCode;
//     ARInvoiceGen.GeneralData.customerName = userModel.Name;
//   }
//   else
//   {
//     ARInvoiceGen.GeneralData.customerCode = '';
//     ARInvoiceGen.GeneralData.customerName = '';
//   }
//   ARInvoiceGen.GeneralData.RefNo = "";
//   ARInvoiceGen.GeneralData.ContactPersonID = "";
//   ARInvoiceGen.GeneralData.ContactPerson = "";
//   ARInvoiceGen.GeneralData.MobileNo = "";
//   ARInvoiceGen.GeneralData.RPTransId = "";
//   ARInvoiceGen.GeneralData.DSTranId = "";
//   DateTime post = DateTime.now();
//   DateTime valid = DateTime.now().add(Duration(days: 7));
//   ARInvoiceGen.GeneralData.PostingDate = getFormattedDate(post);
//   ARInvoiceGen.GeneralData.ValidUntill = getFormattedDate(valid);
//   ARInvoiceGen.GeneralData.LocalPostingDate = await getLocalDate(post);
//   ARInvoiceGen.GeneralData.LocalValidUntill = await getLocalDate(valid);
//   ARInvoiceGen.GeneralData.Currency = userModel.Currency;
//   ARInvoiceGen.GeneralData.CurrRate = userModel.Rate;
//   ARInvoiceGen.GeneralData.PaymentTermCode = "";
//   ARInvoiceGen.GeneralData.PaymentTermName = "";
//   ARInvoiceGen.GeneralData.PaymentTermDays = "";
//   ARInvoiceGen.GeneralData.ApprovalStatus = "Pending";
//   ARInvoiceGen.GeneralData.DocStatus = "Close";
//   ARInvoiceShip.ShippingAddress.CityName = "";
//   ARInvoiceShip.ShippingAddress.RouteCode = "";
//   ARInvoiceShip.ShippingAddress.CityCode = "";
//   ARInvoiceShip.ShippingAddress.Addres = "";
//   ARInvoiceShip.ShippingAddress.CountryName = "";
//   ARInvoiceShip.ShippingAddress.CountryCode = "";
//   ARInvoiceShip.ShippingAddress.StateName = "";
//   ARInvoiceShip.ShippingAddress.StateCode = "";
//   ARInvoiceShip.ShippingAddress.Latitude = 0.0;
//   ARInvoiceShip.ShippingAddress.Longitude = 0.0;
//   ARInvoiceShip.ShippingAddress.RowId = 0;
//   ARInvoiceShip.ShippingAddress.AddCode = "";
//   ARInvoiceBill.BillingAddress.CityName = "";
//   ARInvoiceBill.BillingAddress.CityCode = "";
//   ARInvoiceBill.BillingAddress.Addres = "";
//   ARInvoiceBill.BillingAddress.CountryName = "";
//   ARInvoiceBill.BillingAddress.CountryCode = "";
//   ARInvoiceBill.BillingAddress.StateName = "";
//   ARInvoiceBill.BillingAddress.StateCode = "";
//   ARInvoiceBill.BillingAddress.Latitude = 0.0;
//   ARInvoiceBill.BillingAddress.Longitude = 0.0;
//   ARInvoiceBill.BillingAddress.RowId = 0;
//   ARInvoiceBill.BillingAddress.AddCode = "";
// }
//
// Future<void> clearDeliveryConfirmationData() async {
//   DeliveryConfirmation.isComingFromAdditionalItems = false;
//   DeliveryConfirmation.isComingFromDSC = false;
//   DeliveryConfirmation.isComingFromDelivery = false;
//   DeliveryConfirmation.saveButtonPressed = false;
//   // DeliveryConfirmation.approvalModel =
//   //     await ApprovalModel.getApprovalModel(DocName: 'Invoice');
//   DeliveryConfirmationItemDetails.ItemDetails.items.clear();
//   DeliveryConfirmationGen.GeneralData.isSelected = false;
//   DeliveryConfirmationGen.GeneralData.createCashReceipt = true;
//   DeliveryConfirmationGen.GeneralData.PriceListCode = "";
//   DeliveryConfirmationGen.GeneralData.ID = "";
//   DeliveryConfirmationGen.GeneralData.PermanentTransId = "";
//   DeliveryConfirmationGen.GeneralData.DocNum = "";
//   DeliveryConfirmationGen.GeneralData.Remarks = "";
//   DeliveryConfirmationGen.GeneralData.BaseTab = "";
//   DeliveryConfirmationGen.GeneralData.RPTransId = "";
//   DeliveryConfirmationGen.GeneralData.DSTranId = "";
//   DeliveryConfirmationGen.GeneralData.ApprovalStatus = "";
//   DeliveryConfirmationGen.GeneralData.CRTransId = "";
//   DeliveryConfirmationGen.GeneralData.TransId = "";
//   DeliveryConfirmationGen.GeneralData.customerCode = "";
//   DeliveryConfirmationGen.GeneralData.customerName = "";
//   DeliveryConfirmationGen.GeneralData.RefNo = "";
//   DeliveryConfirmationGen.GeneralData.ContactPersonID = "";
//   DeliveryConfirmationGen.GeneralData.ContactPerson = "";
//   DeliveryConfirmationGen.GeneralData.MobileNo = "";
//   DateTime post = DateTime.now();
//
//   DeliveryConfirmationGen.GeneralData.DeliveryDate = getFormattedDate(post);
//   DeliveryConfirmationGen.GeneralData.LocalDeliveryDate =
//       await getLocalDate(post);
//
//   DeliveryConfirmationGen.GeneralData.PostingDate = '';
//   DeliveryConfirmationGen.GeneralData.ValidUntill = '';
//
//   DeliveryConfirmationGen.GeneralData.LocalPostingDate = '';
//   DeliveryConfirmationGen.GeneralData.LocalValidUntill = '';
//   DeliveryConfirmationGen.GeneralData.Currency = '';
//   DeliveryConfirmationGen.GeneralData.CurrRate = '';
//   DeliveryConfirmationGen.GeneralData.PaymentTermCode = "";
//   DeliveryConfirmationGen.GeneralData.PaymentTermName = "";
//   DeliveryConfirmationGen.GeneralData.PaymentTermDays = "";
//   DeliveryConfirmationGen.GeneralData.ApprovalStatus = "";
//   DeliveryConfirmationGen.GeneralData.DocStatus = "";
//   DeliveryConfirmationShip.ShippingAddress.CityName = "";
//   DeliveryConfirmationShip.ShippingAddress.RouteCode = "";
//   DeliveryConfirmationShip.ShippingAddress.CityCode = "";
//   DeliveryConfirmationShip.ShippingAddress.Addres = "";
//   DeliveryConfirmationShip.ShippingAddress.CountryName = "";
//   DeliveryConfirmationShip.ShippingAddress.CountryCode = "";
//   DeliveryConfirmationShip.ShippingAddress.StateName = "";
//   DeliveryConfirmationShip.ShippingAddress.StateCode = "";
//   DeliveryConfirmationShip.ShippingAddress.Latitude = 0.0;
//   DeliveryConfirmationShip.ShippingAddress.Longitude = 0.0;
//   DeliveryConfirmationShip.ShippingAddress.RowId = 0;
//   DeliveryConfirmationShip.ShippingAddress.AddCode = "";
//   DeliveryConfirmationBill.BillingAddress.CityName = "";
//   DeliveryConfirmationBill.BillingAddress.CityCode = "";
//   DeliveryConfirmationBill.BillingAddress.Addres = "";
//   DeliveryConfirmationBill.BillingAddress.CountryName = "";
//   DeliveryConfirmationBill.BillingAddress.CountryCode = "";
//   DeliveryConfirmationBill.BillingAddress.StateName = "";
//   DeliveryConfirmationBill.BillingAddress.StateCode = "";
//   DeliveryConfirmationBill.BillingAddress.Latitude = 0.0;
//   DeliveryConfirmationBill.BillingAddress.Longitude = 0.0;
//   DeliveryConfirmationBill.BillingAddress.RowId = 0;
//   DeliveryConfirmationBill.BillingAddress.AddCode = "";
// }
//
// Future<void> clearDeliveryData() async {
//   DelItemDetails.ItemDetails.items.clear();
//   DeliveryGen.GeneralData.isSelected = false;
//   DeliveryGen.GeneralData.ID = "";
//   DeliveryGen.GeneralData.WhsCode = "";
//   List<OWHS> owhsList=await retrieveOWHSById(null, 'BranchId = ?', [userModel.BranchId],limit: 1);
//   if(owhsList.isNotEmpty)
//   {
//     DeliveryGen.GeneralData.WhsCode = owhsList[0].WhsCode;
//   }
//   DeliveryGen.GeneralData.PriceListCode = "";
//   DeliveryGen.GeneralData.PermanentTransId = "";
//   DeliveryGen.GeneralData.DocNum = "";
//   DeliveryGen.GeneralData.TransId = "";
//   if (userModel.Type == 'Customer') {
//     DeliveryGen.GeneralData.customerCode = userModel.UserCode;
//     DeliveryGen.GeneralData.customerName = userModel.Name;
//   }
//   else
//   {
//     DeliveryGen.GeneralData.customerCode = '';
//     DeliveryGen.GeneralData.customerName = '';
//   }
//   DeliveryGen.GeneralData.RefNo = "";
//   DeliveryGen.GeneralData.ContactPersonID = "";
//   DeliveryGen.GeneralData.ContactPerson = "";
//   DeliveryGen.GeneralData.MobileNo = "";
//   DateTime post = DateTime.now();
//   DateTime valid = DateTime.now().add(Duration(days: 7));
//   DeliveryGen.GeneralData.PostingDate = getFormattedDate(post);
//   DeliveryGen.GeneralData.ValidUntill = getFormattedDate(valid);
//   DeliveryGen.GeneralData.LocalPostingDate = await getLocalDate(post);
//   DeliveryGen.GeneralData.LocalValidUntill = await getLocalDate(valid);
//   DeliveryGen.GeneralData.Currency = userModel.Currency;
//   DeliveryGen.GeneralData.CurrRate = userModel.Rate;
//   DeliveryGen.GeneralData.PaymentTermCode = "";
//   DeliveryGen.GeneralData.PaymentTermName = "";
//   DeliveryGen.GeneralData.PaymentTermDays = "";
//   DeliveryGen.GeneralData.ApprovalStatus = "Pending";
//   DeliveryGen.GeneralData.DocStatus = "Open";
//   DeliveryShip.ShippingAddress.CityName = "";
//   DeliveryShip.ShippingAddress.RouteCode = "";
//   DeliveryShip.ShippingAddress.CityCode = "";
//   DeliveryShip.ShippingAddress.Addres = "";
//
//   DeliveryShip.ShippingAddress.StateName = "";
//   DeliveryShip.ShippingAddress.StateCode = "";
//   DeliveryShip.ShippingAddress.Latitude = 0.0;
//   DeliveryShip.ShippingAddress.Longitude = 0.0;
//   DeliveryShip.ShippingAddress.RowId = 0;
//   DeliveryShip.ShippingAddress.AddCode = "";
//   DeliveryBill.BillingAddress.CityName = "";
//   DeliveryBill.BillingAddress.CityCode = "";
//   DeliveryBill.BillingAddress.Addres = "";
//   DeliveryBill.BillingAddress.CountryName = "";
//   DeliveryBill.BillingAddress.CountryCode = "";
//   DeliveryBill.BillingAddress.StateName = "";
//   DeliveryBill.BillingAddress.StateCode = "";
//   DeliveryBill.BillingAddress.Latitude = 0.0;
//   DeliveryBill.BillingAddress.Longitude = 0.0;
//   DeliveryBill.BillingAddress.RowId = 0;
//   DeliveryBill.BillingAddress.AddCode = "";
// }
//
// Future<void> clearDeliveryScheduleData() async {
//   salesOrderDetails.clear();
//   additionalItemDetails.clear();
//   summaryItems.clear();
//   DeliverySchedule.approvalModel =
//       await ApprovalModel.getApprovalModel(DocName: 'Delivery Schedule');
//   DeliveryScheduleGen.GeneralData.PermanentTransId = "";
//   DeliveryScheduleGen.GeneralData.DocNum = "";
//   DeliveryScheduleGen.GeneralData.ApprovalStatus = "";
//   DeliveryScheduleGen.GeneralData.DocStatus = "Open";
//   DeliveryScheduleGen.GeneralData.DriverId = "";
//   DeliveryScheduleGen.GeneralData.DriverName = "";
//   DeliveryScheduleGen.GeneralData.ID = "";
//   DeliveryScheduleGen.GeneralData.isSelected = false;
//   DeliveryScheduleGen.GeneralData.LoadingCapacity = "";
//   DeliveryScheduleGen.GeneralData.PaymentTermDays = "";
//   DeliveryScheduleGen.GeneralData.PaymentTermName = "";
//   DeliveryScheduleGen.GeneralData.SalesExecutiveName = "";
//   DeliveryScheduleGen.GeneralData.DriverContactNo = "";
//   DeliveryScheduleGen.GeneralData.SEMPID = "";
//   DateTime post = DateTime.now();
//   DateTime valid = DateTime.now().add(Duration(days: 7));
//   DeliveryScheduleGen.GeneralData.PostingDate = getFormattedDate(post);
//   DeliveryScheduleGen.GeneralData.ValidUntill = getFormattedDate(valid);
//   DeliveryScheduleGen.GeneralData.RouteCode = "";
//   DeliveryScheduleGen.GeneralData.RouteName = "";
//   DeliveryScheduleGen.GeneralData.RoutePlanTransId = "";
//   DeliveryScheduleGen.GeneralData.TareWeight = "";
//   DeliveryScheduleGen.GeneralData.SEContact = "";
//   DeliveryScheduleGen.GeneralData.TransId = "";
//   DeliveryScheduleGen.GeneralData.TruckNumber = "";
//   DeliveryScheduleGen.GeneralData.WhsCode = "";
//   DeliveryScheduleGen.GeneralData.VehicleCode = "";
//   DeliveryScheduleGen.GeneralData.Volume = "";
//   DeliveryScheduleGen.GeneralData.LoadingStatus = "";
//   DeliveryScheduleGen.GeneralData.DocStatus = "Open";
//   DeliveryScheduleAddItems.AdditionalItemDetails.invoiceQty.clear();
//   DeliveryScheduleAddItems.AdditionalItemDetails.remainingQty.clear();
//   DeliveryScheduleTr.TransactionInfo.salesOrder.clear();
//   DeliveryScheduleTr.TransactionInfo.additionalItems.clear();
// }
//
// Future<void> clearCashReceiptData() async {
//   CashReceipt.approvalModel =
//       await ApprovalModel.getApprovalModel(DocName: 'Cash Receipt');
//   CashRcptGen.GeneralData.list.clear();
//   CashRcptGen.GeneralData.TransId = "";
//   CashRcptGen.GeneralData.PermanentTransId = "";
//   CashRcptGen.GeneralData.DocNum = "";
//   CashRcptGen.GeneralData.Remarks = "";
//   CashRcptGen.GeneralData.AdAmount = "";
//   CashRcptGen.GeneralData.ApprovalStatus = "";
//   CashRcptGen.GeneralData.ContactPersonID = "";
//   CashRcptGen.GeneralData.Amount = "";
//   CashRcptGen.GeneralData.ContactPerson = "";
//   CashRcptGen.GeneralData.Currency = userModel.Currency;
//   CashRcptGen.GeneralData.CurrRate = userModel.Rate;
//   if (userModel.Type == 'Customer') {
//     CashRcptGen.GeneralData.customerCode = userModel.UserCode;
//     CashRcptGen.GeneralData.customerName = userModel.Name;
//   }
//   else
//   {
//     CashRcptGen.GeneralData.customerCode = '';
//     CashRcptGen.GeneralData.customerName = '';
//   }
//   CashRcptGen.GeneralData.DocStatus = "Open";
//   CashRcptGen.GeneralData.ID = "";
//   CashRcptGen.GeneralData.INTransId = "";
//   CashRcptGen.GeneralData.isSelected = false;
//   CashRcptGen.GeneralData.hasCreated = false;
//   CashRcptGen.GeneralData.hasUpdated = false;
//   CashRcptGen.GeneralData.MobileNo = "";
//   DateTime post = DateTime.now();
//   CashRcptGen.GeneralData.PostingDate = getFormattedDate(post);
//   CashRcptGen.GeneralData.LocalPostingDate = await getLocalDate(post);
// }
//
// clearCashRequisitionData() async {
//   cashReq.CashRequisition.approvalModel =
//       await ApprovalModel.getApprovalModel(DocName: 'Cash Requisition');
//   cashReqEmpData.EmployeeData.hasCreated = false;
//   cashReqEmpData.EmployeeData.hasUpdated = false;
//   cashReqEmpData.EmployeeData.Currency = userModel.Currency;
//   cashReqEmpData.EmployeeData.CurrencyRate = userModel.Rate;
//   cashReqEmpData.EmployeeData.EmpCode = userModel.EmpCode;
//   cashReqEmpData.EmployeeData.ApprovalStatus = "Pending";
//   cashReqEmpData.EmployeeData.RequisitionType = "Standard";
//   cashReqEmpData.EmployeeData.PermanentTransId = "";
//   cashReqEmpData.EmployeeData.ApprovedAmt = "";
//   cashReqEmpData.EmployeeData.DocNum = "";
//   cashReqEmpData.EmployeeData.Factor = "";
//   cashReqEmpData.EmployeeData.ToDate = "";
//   cashReqEmpData.EmployeeData.FromDate = "";
//   cashReqEmpData.EmployeeData.Remarks = "";
//   cashReqEmpData.EmployeeData.RouteCode = "";
//   cashReqEmpData.EmployeeData.RequestedAmt = "";
//   cashReqEmpData.EmployeeData.RPTransId = "";
//   cashReqEmpData.EmployeeData.EmpGroupId = userModel.EmpGID;
//   cashReqEmpData.EmployeeData.EmpName = userModel.EmpName;
//   cashReqEmpData.EmployeeData.ReqDate = getFormattedDate(DateTime.now());
//   cashReqEmpData.EmployeeData.AdditionalCash = "";
//   cashReqEmpData.EmployeeData.ID = "";
//   cashReqEmpData.EmployeeData.Remarks = "";
//   cashReqEmpData.EmployeeData.ShortDescription = userModel.RoleShortDesc;
//   cashReqEmpData.EmployeeData.TransId = "";
//   cashReqExpType.ExpenseType.AdditionalCashReq = "";
//   cashReqExpType.ExpenseType.ExpenseTypeList.clear();
//   cashReqExpType.ExpenseType.factor = "";
//   cashReqExpType.ExpenseType.FromDate = "";
//   cashReqExpType.ExpenseType.ToDate = "";
//   cashReqExpType.ExpenseType.TotalApprovedAmt = "";
//   cashReqExpType.ExpenseType.TotalCashHandover = "";
//   cashReqExpType.ExpenseType.TotalRequestAmt = "";
//   cashReq.CashRequisition.isSelected = false;
//   cashReq.CashRequisition.savedButtonPressed = false;
//
//   cashReqExpType.ExpenseType.ExpenseTypeList.clear();
//   // final Database db = await initializeDB(null);
//
//   // EmployeeData.RPTransId=snapshot.data![index].RPTransId.toString();
//
//   List<XPM1Model> l = await retrieveXPM1ForCashRequisition();
//   l.forEach((element) {
//     ECP1 ecp1 = ECP1(
//         ID: element.ID,
//         AAmount: 0.0,
//         Amount: element.Amount,
//         // ARemarks: element.Remarks,
//         Based: element.Based,
//         ExpId: element.ExpId,
//         ExpShortDesc: element.ExpShortDesc,
//         CreateDate: element.CreateDate,
//         UpdateDate: element.UpdateDate,
//         Factor: element.factor,
//         Mandatory: element.Mandatory,
//         RAmount: 0.0,
//         Remarks: element.Remarks,
//         RowId: element.RowId,
//         RRemarks: "",
//         TransId: "");
//
//     cashReqExpType.ExpenseType.ExpenseTypeList.add(ecp1);
//   });
// }
//
// Future<void> clearCashRequisitionApprovalData() async {
//   cashReqAprEmpData.EmployeeData.Currency = userModel.Currency;
//   cashReqAprEmpData.EmployeeData.CurrencyRate = userModel.Rate;
//   cashReqAprEmpData.EmployeeData.PermanentTransId = "";
//   cashReqAprEmpData.EmployeeData.DocNum = "";
//   cashReqAprEmpData.EmployeeData.EmpCode = "";
//   cashReqAprEmpData.EmployeeData.EmpGroupId = "";
//   cashReqAprEmpData.EmployeeData.EmpName = "";
//   cashReqAprEmpData.EmployeeData.ID = "";
//   cashReqAprEmpData.EmployeeData.Status = "";
//   DateTime post = DateTime.now();
//   cashReqAprEmpData.EmployeeData.PostingDate = getFormattedDate(post);
//   cashReqAprEmpData.EmployeeData.ApprovalDate = getFormattedDate(post);
//   cashReqAprEmpData.EmployeeData.Remarks = "";
//   cashReqAprEmpData.EmployeeData.ShortDescription = "";
//   cashReqAprEmpData.EmployeeData.ShortDescription = "";
//   cashReqAprEmpData.EmployeeData.TransId = "";
//   cashReqExpAprType.ExpenseType.AdditionalCashReq = "";
//   cashReqExpAprType.ExpenseType.ExpenseTypeList.clear();
//   cashReqExpAprType.ExpenseType.factor = "";
//   cashReqExpAprType.ExpenseType.FromDate = "";
//   cashReqExpAprType.ExpenseType.ToDate = "";
//   cashReqExpAprType.ExpenseType.TotalApprovedAmt = "";
//   cashReqExpAprType.ExpenseType.TotalCashHandover = "";
//   cashReqExpAprType.ExpenseType.TotalRequestAmt = "";
//   cashReqApr.CashRequisitionApproval.savedButtonPressed = false;
//   cashReqApr.CashRequisitionApproval.isSelected = false;
//   cashReqAprEmpData.EmployeeData.FromDate = "";
//   cashReqAprEmpData.EmployeeData.ToDate = "";
//   cashReqAprEmpData.EmployeeData.Factor = "";
//   cashReqAprEmpData.EmployeeData.RequestedAmt = "";
//   cashReqAprEmpData.EmployeeData.AdditionalCash = "";
//   cashReqAprEmpData.EmployeeData.AdditionalApprovedCash = "";
// }
//
// Future<void> clearCashHandoverScreen() async {
//   cashHandover.CashHandover.approvalModel =
//       await ApprovalModel.getApprovalModel(DocName: 'Cash Handover');
//   cashHandoverScreen.CashHandoverScreen.CurrencyRate = userModel.Rate;
//   cashHandoverScreen.CashHandoverScreen.Currency = userModel.Currency;
//   cashHandoverScreen.CashHandoverScreen.PermanentTransId = "";
//   cashHandoverScreen.CashHandoverScreen.DocNum = "";
//   cashHandoverScreen.CashHandoverScreen.cashHandover = "";
//   cashHandoverScreen.CashHandoverScreen.CRApprovalAmount = "";
//   cashHandoverScreen.CashHandoverScreen.CRTransId = "";
//   cashHandoverScreen.CashHandoverScreen.EmpCode = "";
//   cashHandoverScreen.CashHandoverScreen.EmpGroupId = "";
//   cashHandoverScreen.CashHandoverScreen.EmpName = "";
//   cashHandoverScreen.CashHandoverScreen.ID = "";
//   cashHandoverScreen.CashHandoverScreen.PreviousCashHandover = "";
//   cashHandoverScreen.CashHandoverScreen.Remarks = "";
//   cashHandoverScreen.CashHandoverScreen.ShortDescription = "";
//   cashHandoverScreen.CashHandoverScreen.CreateDate = "";
//   cashHandoverScreen.CashHandoverScreen.TransId = "";
//   cashHandoverScreen.CashHandoverScreen.DocStatus = "Open";
//   cashHandoverScreen.CashHandoverScreen.ApprovalStatus = "Pending";
//   cashHandover.CashHandover.isSelected = false;
//   cashHandover.CashHandover.saveButtonPressed = false;
// }
//
// Future<void> clearExpenseCaptureScreen() async {
//   expenseCapture.ExpenseCapture.approvalModel =
//       await ApprovalModel.getApprovalModel(DocName: 'Expense Capture');
//   expenseCapture.ExpenseCapture.isSelected = false;
//   expenseCaptureScreen.ExpenseCaptureScreen.Currency = userModel.Currency;
//   expenseCaptureScreen.ExpenseCaptureScreen.ID = '';
//   expenseCaptureScreen.ExpenseCaptureScreen.CurrencyRate = '';
//   expenseCaptureScreen.ExpenseCaptureScreen.PermanentTransId = "";
//   expenseCaptureScreen.ExpenseCaptureScreen.DocNum = "";
//   expenseCaptureScreen.ExpenseCaptureScreen.Amount = "";
//   expenseCaptureScreen.ExpenseCaptureScreen.hasCreated = false;
//   expenseCaptureScreen.ExpenseCaptureScreen.hasUpdated = false;
//   expenseCaptureScreen.ExpenseCaptureScreen.AprvAmount = "";
//
//   expenseCaptureScreen.ExpenseCaptureScreen.ApprovalStatus = "Pending";
//   expenseCaptureScreen.ExpenseCaptureScreen.AprvUserId = "";
//   expenseCaptureScreen.ExpenseCaptureScreen.ExpRemark = "";
//   expenseCaptureScreen.ExpenseCaptureScreen.ExpenseType = "";
//   DateTime post = DateTime.now();
//   expenseCaptureScreen.ExpenseCaptureScreen.PostingDate =
//       getFormattedDate(post);
//   expenseCaptureScreen.ExpenseCaptureScreen.LocalPostingDate =
//       await getLocalDate(post);
//   expenseCaptureScreen.ExpenseCaptureScreen.ReqTransId = "";
//
//   expenseCaptureScreen.ExpenseCaptureScreen.RowID = "";
//
//   expenseCaptureScreen.ExpenseCaptureScreen.EmpId = userModel.UserCode;
//   expenseCaptureScreen.ExpenseCaptureScreen.EmpName = userModel.EmpName;
//   expenseCaptureScreen.ExpenseCaptureScreen.EmpGroupId = userModel.EmpGID;
//   expenseCaptureScreen.ExpenseCaptureScreen.EmpDesc = userModel.RoleShortDesc;
//   expenseCaptureScreen.ExpenseCaptureScreen.Remarks = "";
//   expenseCaptureScreen.ExpenseCaptureScreen.RequestedAmt = "";
//   expenseCaptureScreen.ExpenseCaptureScreen.FromDate =
//       getFormattedDate(DateTime.now());
//   expenseCaptureScreen.ExpenseCaptureScreen.ToDate =
//       getFormattedDate(DateTime.now().add(Duration(days: 7)));
//   expenseCaptureScreen.ExpenseCaptureScreen.Factor = "7";
//   expenseCaptureScreen.ExpenseCaptureScreen.AdditionalCash = "";
//
//   expenseCaptureScreen.ExpenseCaptureScreen.imageFile = null;
//   expenseCaptureScreen.ExpenseCaptureScreen.list.clear();
//   ECSummary.set.clear();
// }
//
// Future<void> clearExpenseCaptureApprovalScreen() async {
//   DateTime post = DateTime.now();
//   expenseCaptureApprovalDocs.Documents.PostingDate = getFormattedDate(post);
//   expenseCaptureApprovalDocs.Documents.Currency = userModel.Currency;
//   expenseCaptureApprovalDocs.Documents.CurrencyRate = userModel.Rate;
//   expenseCaptureApprovalDocs.Documents.PermanentTransId = "";
//   expenseCaptureApprovalDocs.Documents.DocNum = "";
//   expenseCaptureApprovalDocs.Documents.RequestDate = "";
//   expenseCaptureApprovalDocs.Documents.RequestTransId = "";
//   expenseCaptureApprovalSummary.Summary.list.clear();
//   expenseCaptureApprovalSummary.Summary.set.clear();
//   expenseCaptureApprovalSummary.Summary.imageFile = null;
// }
//
// Future<void> clearReconciliationData() async {
//   reconciliation.Reconciliation.approvalModel =
//       await ApprovalModel.getApprovalModel(DocName: 'Cash Reconciliation');
//   reconEmpData.EmployeeData.Currency = userModel.Currency;
//   reconEmpData.EmployeeData.CurrencyRate = userModel.Rate;
//   reconEmpData.EmployeeData.isSelected = false;
//   reconEmpData.EmployeeData.PermanentTransId = "";
//   reconEmpData.EmployeeData.DocNum = "";
//   reconEmpData.EmployeeData.Remarks = "";
//   reconEmpData.EmployeeData.EmpCode = "";
//   reconEmpData.EmployeeData.EmpName = "";
//   reconEmpData.EmployeeData.ID = "";
//   DateTime post = DateTime.now();
//   reconEmpData.EmployeeData.PostingDate = getFormattedDate(post);
//   reconEmpData.EmployeeData.LocalPostingDate = await getLocalDate(post);
//   reconEmpData.EmployeeData.Status = "";
//   reconEmpData.EmployeeData.TransId = "";
//   reconEmpData.EmployeeData.ReqTransId = "";
//   reconExpnseData.ExpenseType.list.clear();
//   // reconExpnseData.ExpenseType.set.clear();
//   reconExpnseData.ExpenseType.fromDate = "";
//   reconExpnseData.ExpenseType.toDate = "";
//   reconExpnseData.ExpenseType.TotalCashHandover = "";
//   reconExpnseData.ExpenseType.CashRequestAmt = "";
//   reconExpnseData.ExpenseType.CashApprovedAmt = "";
//   reconExpnseData.ExpenseType.ExpCapAmt = "";
//   reconExpnseData.ExpenseType.ExpApprovedAmt = "";
//   reconExpnseData.ExpenseType.Recover = "";
//   reconExpnseData.ExpenseType.Pay = "";
//   reconExpnseData.ExpenseType.TotalCashHandover = "";
// }
//
// Future<void> clearDepositData({String? RPTransId}) async {
//   deposit.Deposit.approvalModel =
//       await ApprovalModel.getApprovalModel(DocName: 'Deposit');
//
//   depositEmpData.EmployeeData.grid.clear();
//   depositEmpData.EmployeeData.PostingDate = getFormattedDate(DateTime.now());
//   depositEmpData.EmployeeData.LocalPostingDate =
//       await getLocalDate(DateTime.now());
//   depositEmpData.EmployeeData.isSelected = false;
//   deposit.Deposit.saveButtonPressed = false;
//   depositEmpData.EmployeeData.PermanentTransId = "";
//   depositEmpData.EmployeeData.DocNum = "";
//   depositEmpData.EmployeeData.DepositType = "Bank";
//   depositEmpData.EmployeeData.AcctCode = "";
//   depositEmpData.EmployeeData.Remarks = "";
//   depositEmpData.EmployeeData.ID = "";
//   depositEmpData.EmployeeData.Currency = userModel.Currency;
//   depositEmpData.EmployeeData.CurrRate = userModel.Rate;
//   Database db = await initializeDB(null);
//   String query = '';
//   if (RPTransId == null) {
//     query =
//         "SELECT * FROM OCRT WHERE  CreatedBy='${userModel.UserCode}' collate nocase and OpenAmt > 0 AND Currency = '${userModel.Currency}'";
//   } else {
//     query = "SELECT * FROM OCRT WHERE RPTransId = '$RPTransId' and OpenAmt > 0";
//   }
//   var data = await db.rawQuery(query);
//   print(data);
//   List<OCRTModel> list = data.map((e) => OCRTModel.fromJson(e)).toList();
//   print(list);
//   list.forEach((element) {
//     depositEmpData.EmployeeData.grid.add(DPT1Model(
//       Currency: userModel.Currency,
//       Amount: element.OpenAmt,
//       CRTransId: element.TransId,
//     ));
//   });
//   depositEmpData.EmployeeData.currencyList = await retrieveOCRN(null);
//   depositEmpData.EmployeeData.currencyList.forEach((element) {
//     if (element.Name == depositEmpData.EmployeeData.Currency)
//       depositEmpData.EmployeeData.selectedCurrency = element;
//   });
//
//   depositEmpData.EmployeeData.attachment_ = "";
//   depositEmpData.EmployeeData.RefId = "";
//   depositEmpData.EmployeeData.AdAmount = 0.0;
//   depositEmpData.EmployeeData.Amount = 0.0;
//   depositEmpData.EmployeeData.Branch = userModel.BranchName;
//   if (RPTransId == null) {
//     depositEmpData.EmployeeData.RPTransId = "";
//   }
//   depositEmpData.EmployeeData.RPTransId = RPTransId ?? "";
//
//   depositEmpData.EmployeeData.ShortDescription = userModel.RoleShortDesc;
//   // depositEmpData.EmployeeData.RoutePlanningTransId = "";
//   depositEmpData.EmployeeData.EmpCode = userModel.EmpCode;
//   depositEmpData.EmployeeData.EmpGroupId = userModel.EmpGID;
//   depositEmpData.EmployeeData.EmpName = userModel.EmpName;
// }
//
// clearAppLogData() async {
//   ApprovalStatus.MaxLevel = 0;
//   ApprovalStatus.Level = 0;
//   ApprovalStatus.documents =
//       await retrieveLITPL_OADMById(null, 'Active = ?', [1]);
//   if (ApprovalStatus.documents.isNotEmpty)
//     ApprovalStatus.selectedDocument = ApprovalStatus.documents[0];
//
//   ApprovalStatus.document = null;
// }
//
// clearReturnOrderData() async {
//   returnItemDetails.ItemDetails.items.clear();
//   ReturnOrder.approvalModel =
//       await ApprovalModel.getApprovalModel(DocName: 'Return Order');
//   returnGenData.GeneralData.isSelected = false;
//   returnGenData.GeneralData.ID = "";
//   returnGenData.GeneralData.PermanentTransId = "";
//   returnGenData.GeneralData.DocNum = "";
//   returnGenData.GeneralData.BaseTransId = "";
//   returnGenData.GeneralData.Remarks = "";
//   returnGenData.GeneralData.TransId = "";
//   returnGenData.GeneralData.customerCode = "";
//   returnGenData.GeneralData.customerName = "";
//   returnGenData.GeneralData.RefNo = "";
//   returnGenData.GeneralData.ContactPersonID = "";
//   returnGenData.GeneralData.ContactPerson = "";
//   returnGenData.GeneralData.MobileNo = "";
//   DateTime post = DateTime.now();
//   DateTime valid = DateTime.now().add(Duration(days: 7));
//   returnGenData.GeneralData.PostingDate = getFormattedDate(post);
//   returnGenData.GeneralData.ValidUntill = getFormattedDate(valid);
//   returnGenData.GeneralData.LocalPostingDate = await getLocalDate(post);
//   returnGenData.GeneralData.LocalValidUntill = await getLocalDate(valid);
//   returnGenData.GeneralData.Currency = userModel.Currency;
//   returnGenData.GeneralData.CurrRate = userModel.Rate;
//   returnGenData.GeneralData.PaymentTermCode = "";
//   returnGenData.GeneralData.PaymentTermName = "";
//   returnGenData.GeneralData.PaymentTermDays = "";
//   returnGenData.GeneralData.ApprovalStatus = "Pending";
//   returnGenData.GeneralData.DocStatus = "Open";
//
//   returnShipAdd.ShippingAddress.RouteCode = "";
//   returnShipAdd.ShippingAddress.CityCode = "";
//   returnShipAdd.ShippingAddress.Addres = "";
//   returnShipAdd.ShippingAddress.CityName = "";
//   returnShipAdd.ShippingAddress.CountryName = "";
//   returnShipAdd.ShippingAddress.CountryCode = "";
//   returnShipAdd.ShippingAddress.StateName = "";
//   returnShipAdd.ShippingAddress.StateCode = "";
//   returnShipAdd.ShippingAddress.Latitude = 0.0;
//   returnShipAdd.ShippingAddress.Longitude = 0.0;
//   returnShipAdd.ShippingAddress.RowId = 0;
//   returnShipAdd.ShippingAddress.AddCode = "";
//   returnBillAdd.BillingAddress.CityName = "";
//   returnBillAdd.BillingAddress.CityCode = "";
//   returnBillAdd.BillingAddress.Addres = "";
//   returnBillAdd.BillingAddress.CountryName = "";
//   returnBillAdd.BillingAddress.CountryCode = "";
//   returnBillAdd.BillingAddress.StateName = "";
//   returnBillAdd.BillingAddress.StateCode = "";
//   returnBillAdd.BillingAddress.Latitude = 0.0;
//   returnBillAdd.BillingAddress.Longitude = 0.0;
//   returnBillAdd.BillingAddress.RowId = 0;
//   returnBillAdd.BillingAddress.AddCode = "";
// }
//
// Future<void> clearVisitPlanData() async {
//   visitPlan.VisitPlan.saveButtonPressed = false;
//   vpGenData.GeneralData.isSelected = false;
//   vpGenData.GeneralData.hasCreated = false;
//   vpGenData.GeneralData.hasUpdated = false;
//   vpGenData.GeneralData.PermanentTransId = '';
//   vpGenData.GeneralData.DocNum = '';
//   vpGenData.GeneralData.StartDate = getFormattedDate(DateTime.now());
//   vpGenData.GeneralData.EndDate =
//       getFormattedDate(DateTime.now().add(Duration(days: 7)));
//   vpGenData.GeneralData.TransId = '';
//   vpGenData.GeneralData.RouteCode = '';
//   vpGenData.GeneralData.RouteName = '';
//   vpGenData.GeneralData.EmployeeName1 = userModel.EmpName;
//   vpGenData.GeneralData.EmployeeName2 = '';
//   vpGenData.GeneralData.EmployeeName3 = '';
//   vpGenData.GeneralData.EmployeeCode1 = userModel.EmpCode;
//   vpGenData.GeneralData.EmployeeCode2 = '';
//   vpGenData.GeneralData.EmployeeCode3 = '';
//   vpGenData.GeneralData.DocStatus = 'Open';
//   vpGenData.GeneralData.ApprovalStatus = 'Pending';
//   vpPlanList.VisitList.planList.clear();
//   visitPlan.VisitPlan.approvalModel =
//       await ApprovalModel.getApprovalModel(DocName: 'Visit Plan');
// }
//
// void clearEditVisitPlanData() {
//   vpEditPlan.EditPlan.ATTransId = '';
//   vpEditPlan.EditPlan.CardName = '';
//   vpEditPlan.EditPlan.PersonContactName = '';
//   vpEditPlan.EditPlan.MobileNo = '';
//   vpEditPlan.EditPlan.EmployeeName;
//   vpEditPlan.EditPlan.index = 0;
//   vpEditPlan.EditPlan.selectedEmployee = null;
//   vpEditPlan.EditPlan.selectedCustomersVisit = null;
//   vpEditPlan.EditPlan.selectedPlan = null;
// }
//
// Future<void> clearStockTakeData() async {
//   stkGenData.GeneralData.isSelected = false;
//   stkGenData.GeneralData.hasCreated = false;
//   stkGenData.GeneralData.hasUpdated = false;
//   stkGenData.GeneralData.ID = '';
//   stkGenData.GeneralData.PermanentTransId = '';
//   stkGenData.GeneralData.DocNum = '';
//   stkGenData.GeneralData.TransId = '';
//   stkGenData.GeneralData.priceListCode = '';
//   stkGenData.GeneralData.PostingDate = getFormattedDate(DateTime.now());
//   stkGenData.GeneralData.LocalPostingDate = await getLocalDate(DateTime.now());
//
//   stkGenData.GeneralData.CustomerCode = '';
//   stkGenData.GeneralData.CustomerName = '';
//   stkGenData.GeneralData.PersonName = '';
//   stkGenData.GeneralData.Employee1 = '';
//   stkGenData.GeneralData.Employee2 = '';
//   stkGenData.GeneralData.StockTakeDate = getFormattedDate(DateTime.now());
//   stkGenData.GeneralData.LocalStockTakeDate =
//       await getLocalDate(DateTime.now());
//   stkGenData.GeneralData.StockTakeTime = '';
//   stkGenData.GeneralData.ApprovalStatus = 'Pending';
//   stkGenData.GeneralData.DocStatus = 'Open';
//   stkGenData.GeneralData.Remarks = '';
//   stkGenData.GeneralData.MobileNumber;
//   stkItmDetails.ItemDetails.items.clear();
//   stockTake.StockTake.saveButtonPressed = false;
//   stockTake.StockTake.approvalModel =
//       await ApprovalModel.getApprovalModel(DocName: 'Stock Take');
// }
//
// Future<void> clearIssueRaisedData() async {
//   //todo
//   // issueRaise.IssueRaise.suoisu = null;
//   // issueRaise.IssueRaise.suoisu = SUOISU(
//   //   Status: 'Pending',
//   //   Priority: 'Low',
//   //   RaisedBy: userModel.UserCode,
//   //   OpenDate: DateTime.now(),
//   // );
//   // issueList.Issue.issueList.clear();
// }
