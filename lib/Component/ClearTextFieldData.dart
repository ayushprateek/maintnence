import 'package:maintenance/CheckListDocument/GeneralData.dart' as checkListDoc;

clearPRF1TextFields() {
  checkListDoc.GeneralData.iD = '';
  checkListDoc.GeneralData.permanentTransId = '';
  checkListDoc.GeneralData.transId = '';
  checkListDoc.GeneralData.docEntry = '';
  checkListDoc.GeneralData.docNum = '';
  checkListDoc.GeneralData.canceled = '';
  checkListDoc.GeneralData.docStatus = '';
  checkListDoc.GeneralData.approvalStatus = '';
  checkListDoc.GeneralData.checkListStatus = '';
  checkListDoc.GeneralData.objectCode = '';
  checkListDoc.GeneralData.equipmentCode = '';
  checkListDoc.GeneralData.equipmentName = '';
  checkListDoc.GeneralData.checkListCode = '';
  checkListDoc.GeneralData.checkListName = '';
  checkListDoc.GeneralData.workCenterCode = '';
  checkListDoc.GeneralData.workCenterName = '';
  checkListDoc.GeneralData.openDate = DateTime.now();
  checkListDoc.GeneralData.closeDate = DateTime.now();
  checkListDoc.GeneralData.postingDate = DateTime.now();
  checkListDoc.GeneralData.validUntill = DateTime.now();
  checkListDoc.GeneralData.lastReadingDate = DateTime.now();
  checkListDoc.GeneralData.lastReading = '';
  checkListDoc.GeneralData.assignedUserCode = '';
  checkListDoc.GeneralData.assignedUserName = '';
  checkListDoc.GeneralData.mNJCTransId = '';
  checkListDoc.GeneralData.remarks = '';
  checkListDoc.GeneralData.createdBy = '';
  checkListDoc.GeneralData.updatedBy = '';
  checkListDoc.GeneralData.branchId = '';
  checkListDoc.GeneralData.createDate = DateTime.now();
  checkListDoc.GeneralData.updateDate = DateTime.now();
  checkListDoc.GeneralData.currentReading = '';
  checkListDoc.GeneralData.isConsumption = false;
  checkListDoc.GeneralData.isRequest = false;
}
