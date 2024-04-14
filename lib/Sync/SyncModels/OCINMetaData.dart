import 'dart:convert';

List<OCINMetaDataModel> OCINMetaDataModelFromJson(String str) =>
    List<OCINMetaDataModel>.from(
        json.decode(str).map((x) => OCINMetaDataModel.fromJson(x)));

String OCINMetaDataModelToJson(List<OCINMetaDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OCINMetaDataModel {
  OCINMetaDataModel({
    this.CompanyName,
    this.MobSessionTimoutMinute,
    this.MobSyncTimeMinute,
    this.OrganizationLogoUrl,
    this.OrganizationBackgroundUrl,
    this.MinMobileVersion,
    this.MinMobileBuildNo,
  });

  int? MobSessionTimoutMinute;
  int? MobSyncTimeMinute;

  String? CompanyName;
  String? OrganizationLogoUrl;
  String? OrganizationBackgroundUrl;
  String? MinMobileVersion;
  int? MinMobileBuildNo;

  factory OCINMetaDataModel.fromJson(Map<String, dynamic> json) =>
      OCINMetaDataModel(
        MobSessionTimoutMinute:
            int.tryParse(json["MobSessionTimoutMinute"].toString()) ?? 0,
        MobSyncTimeMinute:
            int.tryParse(json["MobSyncTimeMinute"].toString()) ?? 0,
        CompanyName: json["CompanyName"] ?? "",
        OrganizationLogoUrl: json["OrganizationLogoUrl"] ?? "",
        OrganizationBackgroundUrl: json["OrganizationLogoUrl"] ?? "",
        MinMobileVersion: json['MinMobileVersion'] ?? '',
        MinMobileBuildNo:
            int.tryParse(json["MinMobileBuildNo"].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "MobSessionTimoutMinute": MobSessionTimoutMinute,
        "MobSyncTimeMinute": MobSyncTimeMinute,
        "CompanyName": CompanyName,
        "OrganizationLogoUrl": OrganizationLogoUrl,
        "OrganizationBackgroundUrl": OrganizationLogoUrl,
        'MinMobileVersion': MinMobileVersion,
        'MinMobileBuildNo': MinMobileBuildNo,
      };
}
