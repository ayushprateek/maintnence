// import 'package:get/get.dart';
// import 'package:maintenance/ApprovalStatus/ApprovalListUIComponent.dart';
// import 'package:maintenance/ApprovalStatus/ApprovalStatus.dart';
// 
// import 'package:maintenance/Sync/SyncModels/LITPL_OOAL.dart';
//
// navigateToForm({
//   required String TableName,
//   required String TransId,
// }) async {
//   if (TableName == 'OQUT') {
//     navigateToSalesQuotation(TransId: TransId);
//   } else if (TableName == 'ORDR') {
//     navigateToSalesOrder(TransId: TransId);
//   } else if (TableName == 'ODSC') {
//     navigateToDeliverySchedule(TransId: TransId);
//   } else if (TableName == 'ODLN') {
//     navigateToDelivery(TransId: TransId);
//   } else if (TableName == 'OINV') {
//     navigateToSalesInvoice(TransId: TransId);
//   } else if (TableName == 'OCRT') {
//     navigateToCashReceipt(TransId: TransId);
//   } else if (TableName == 'OECP') {
//     navigateToCashRequisition(TransId: TransId);
//   } else if (TableName == 'OCSH') {
//     navigateToCashHandover(TransId: TransId);
//   } else if (TableName == 'ODPT') {
//     navigateToDeposit(TransId: TransId);
//   } else if (TableName == 'OEXR') {
//     navigateToExpenseCapture(TransId: TransId);
//   } else if (TableName == 'ORCT') {
//     navigateToExpenseReconciliation(TransId: TransId);
//   }
//   //todo:
//   //------------------------
//   // Navigate to Customer's Visit
//   // Navigate to Visit Plan
//   // Navigate to Stock Take
// }
//
// navigateToApproval({
//   required String TableName,
//   required String TransId,
// }) async {
//   List<LITPL_OOAL> list=await retrieveLITPL_OOALById(null, 'TransId = ?', [TransId],limit: 1);
//   if(list.isNotEmpty){
//     await clearAppLogData();
//     ApprovalStatus.document=list[0].DocNum;
//     Get.to(()=>ApprovalStatus());
//   }
// }
