class MaintenanceItemsQueryModel {
  String? transId;
  String? checkListStatus;
  String? checkType;
  String? code;
  int? id;
  DateTime? validUntilDb;
  String? validUntil;
  String? cardCode;
  String? createdBy;
  String? workCenterCode;
  String? rowId;
  String? workCenterName;
  String? equipmentCode;
  String? equipmentName;
  String? checkListCode;
  String? checkListName;
  String? checkListDesc;
  String? technicianCode;
  String? technicianName;
  String? checkListDocEntry;
  DateTime? dueDate;
  DateTime? lastPostingDate;
  int? validDays;
  double? openQty;
  String? docNum;
  String? docCode;
  String? lastReading;

  MaintenanceItemsQueryModel({
    required this.transId,
    required this.code,
    required this.checkListStatus,
    required this.checkType,
    required this.id,
    this.validUntilDb,
    required this.validUntil,
    required this.cardCode,
    required this.createdBy,
    required this.workCenterCode,
    required this.rowId,
    required this.workCenterName,
    required this.equipmentCode,
    required this.equipmentName,
    required this.checkListCode,
    required this.checkListName,
    required this.checkListDesc,
    required this.technicianCode,
    required this.technicianName,
    required this.checkListDocEntry,
    this.dueDate,
    this.lastPostingDate,
    required this.validDays,
    this.openQty,
    required this.docNum,
    required this.docCode,
    required this.lastReading,
  });

  factory MaintenanceItemsQueryModel.fromJson(Map<String?, dynamic> json) {
    return MaintenanceItemsQueryModel(
      transId: json['TransId']?.toString() ?? '',
      code: json['Code']?.toString() ?? '',
      checkListStatus: json['CheckListStatus']?.toString() ?? '',
      checkType: json['CheckType']?.toString() ?? '',
      id: int.tryParse(json['ID'].toString()),
      validUntilDb: DateTime.tryParse(json['ValidUntilDb'].toString()),
      validUntil: json['validUntil']?.toString() ?? '',
      cardCode: json['CardCode']?.toString() ?? '',
      createdBy: json['CreatedBy']?.toString() ?? '',
      workCenterCode: json['WorkCenterCode']?.toString() ?? '',
      rowId: json['RowId']?.toString() ?? '',
      workCenterName: json['WorkCenterName']?.toString() ?? '',
      equipmentCode: json['EquipmentCode']?.toString() ?? '',
      equipmentName: json['EquipmentName']?.toString() ?? '',
      checkListCode: json['CheckListCode']?.toString() ?? '',
      checkListName: json['CheckListName']?.toString() ?? '',
      checkListDesc: json['CheckListDesc']?.toString() ?? '',
      technicianCode: json['TechnicianCode']?.toString() ?? '',
      technicianName: json['TechnicianName']?.toString() ?? '',
      checkListDocEntry: json['CheckListDocEntry']?.toString() ?? '',
      dueDate: json['DueDate'] != null ? DateTime.parse(json['DueDate']) : null,
      lastPostingDate: DateTime.tryParse(json['LastPostingDate'].toString()),
      validDays: int.tryParse(json['ValidDays'].toString()),
      openQty: json['OpenQty'] != null ? json['OpenQty'].toDouble() : null,
      docNum: json['DocNum']?.toString() ?? '',
      docCode: json['DocCode']?.toString() ?? '',
      lastReading: json['LastReading']?.toString() ?? '',
    );
  }

  Map<String?, dynamic> toJson() {
    return {
      'transId': transId,
      'CheckListStatus': checkListStatus,
      'CheckType': checkType,
      'code': code,
      'id': id,
      'validUntilDb': validUntilDb?.toIso8601String(),
      'validUntil': validUntil,
      'cardCode': cardCode,
      'createdBy': createdBy,
      'workCenterCode': workCenterCode,
      'rowId': rowId,
      'workCenterName': workCenterName,
      'equipmentCode': equipmentCode,
      'equipmentName': equipmentName,
      'checkListCode': checkListCode,
      'checkListName': checkListName,
      'checkListDesc': checkListDesc,
      'technicianCode': technicianCode,
      'technicianName': technicianName,
      'checkListDocEntry': checkListDocEntry,
      'dueDate': dueDate?.toIso8601String(),
      'LastPostingDate': lastPostingDate?.toIso8601String(),
      'validDays': validDays,
      'openQty': openQty,
      'docNum': docNum,
      'docCode': docCode,
      'lastReading': lastReading,
    };
  }
}
