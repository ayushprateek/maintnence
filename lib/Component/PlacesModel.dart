// To parse this JSON data, do
//
//     final placesModel = placesModelFromJson(jsonString);
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:maintenance/Sync/CustomURL.dart';

PlacesModel placesModelFromJson(String str) =>
    PlacesModel.fromJson(json.decode(str));

String placesModelToJson(PlacesModel data) => json.encode(data.toJson());

class PlacesModel {
  PlacesModel({
    required this.predictions,
    this.status,
  });

  late List<Prediction?> predictions;
  String? status;

  factory PlacesModel.fromJson(Map<String, dynamic> json) => PlacesModel(
        predictions: List<Prediction>.from(
            json["predictions"].map((x) => Prediction.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "predictions": List<dynamic>.from(predictions.map((x) => x?.toJson())),
        "status": status,
      };
}

class Prediction {
  Prediction({
    this.description,
    required this.matchedSubstrings,
    this.placeId,
    this.reference,
    required this.structuredFormatting,
    required this.terms,
    required this.types,
  });

  String? description;
  late List<MatchedSubstring?> matchedSubstrings;
  String? placeId;
  String? reference;
  late StructuredFormatting structuredFormatting;
  late List<Term?> terms;
  late List<String?> types;

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        description: json["description"],
        matchedSubstrings: List<MatchedSubstring>.from(
            json["matched_substrings"]
                .map((x) => MatchedSubstring.fromJson(x))),
        placeId: json["place_id"],
        reference: json["reference"],
        structuredFormatting:
            StructuredFormatting.fromJson(json["structured_formatting"]),
        terms: List<Term>.from(json["terms"].map((x) => Term.fromJson(x))),
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "matched_substrings":
            List<dynamic>.from(matchedSubstrings.map((x) => x?.toJson())),
        "place_id": placeId,
        "reference": reference,
        "structured_formatting": structuredFormatting.toJson(),
        "terms": List<dynamic>.from(terms.map((x) => x?.toJson())),
        "types": List<dynamic>.from(types.map((x) => x)),
      };
}

class MatchedSubstring {
  MatchedSubstring({
    this.length,
    this.offset,
  });

  int? length;
  int? offset;

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) =>
      MatchedSubstring(
        length: json["length"],
        offset: json["offset"],
      );

  Map<String, dynamic> toJson() => {
        "length": length,
        "offset": offset,
      };
}

class StructuredFormatting {
  StructuredFormatting({
    this.mainText,
    required this.mainTextMatchedSubstrings,
    this.secondaryText,
  });

  String? mainText;
  late List<MatchedSubstring> mainTextMatchedSubstrings;
  String? secondaryText;

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json["main_text"],
        mainTextMatchedSubstrings: List<MatchedSubstring>.from(
            json["main_text_matched_substrings"]
                .map((x) => MatchedSubstring.fromJson(x))),
        secondaryText: json["secondary_text"],
      );

  Map<String, dynamic> toJson() => {
        "main_text": mainText,
        "main_text_matched_substrings": List<dynamic>.from(
            mainTextMatchedSubstrings.map((x) => x.toJson())),
        "secondary_text": secondaryText,
      };
}

class Term {
  Term({
    this.offset,
    this.value,
  });

  int? offset;
  String? value;

  factory Term.fromJson(Map<String, dynamic> json) => Term(
        offset: json["offset"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "offset": offset,
        "value": value,
      };
}

Future<PlacesModel> getPlaces(String placeName) async {
  //String url="https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=AIzaSyCmijT_PoZ6_j28v0Of37JWKu7ACqMolmY&sessiontoken=1234567890&components=country:in";
  String url =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$googleAPiKey&sessiontoken=1234567890&components=country:in";
  var res = await http.get(Uri.parse(url));
  // print(res.body);
  return placesModelFromJson(res.body);
}
