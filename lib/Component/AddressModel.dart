class AddressModel {
  final int ID, RowId;
  final String RouteCode,
      RouteName,
      Code,
      AddressCode,
      Address,
      CityName,
      StateName,
      CountryName,
      CityCode,
      StateCode,
      CountryCode;
  double Latitude, Longitude;

  AddressModel({
    required this.RowId,
    required this.AddressCode,
    required this.ID,
    required this.Code,
    required this.StateName,
    required this.CityCode,
    required this.StateCode,
    required this.CountryCode,
    required this.Longitude,
    required this.Latitude,
    required this.CityName,
    required this.Address,
    required this.RouteCode,
    required this.RouteName,
    required this.CountryName,
  });

  AddressModel.fromMap(Map<String, dynamic> res)
      : ID = res["ID"],
        Code = res["Code"],
        RouteCode = res["RouteCode"] ?? "",
        CountryCode = res["CountryCode"] ?? "",
        RouteName = res["RouteName"] ?? "",
        StateCode = res["StateCode"] ?? "",
        Longitude = double.tryParse(res["Longitude"].toString()) ?? 0.0,
        Latitude = double.tryParse(res["Latitude"].toString()) ?? 0.0,
        RowId = res["RowId"] ?? 0,
        AddressCode = res["AddressCode"] ?? "",
        CountryName = res["CountryName"] ?? "",
        StateName = res["StateName"] ?? "",
        Address = res["Address"] ?? "",
        CityCode = res["CityCode"] ?? "",
        CityName = res["CityName"] ?? "";

  Map<String, Object> toMap() {
    return {
      'ID': ID,
      'Code': Code,
      'CountryName': CountryName,
      'Longitude': Longitude,
      'Latitude': Latitude,
      'CountryCode': CountryCode,
      'StateCode': StateCode,
      'RouteName': RouteName,
      'StateName': StateName,
      'RouteCode': RouteCode,
      'RowId': RowId,
      'AddressCode': AddressCode,
      'Address': Address,
      'CityCode': CityCode,
      'CityName': CityName,
    };
  }
}
