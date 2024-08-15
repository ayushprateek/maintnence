import 'package:maintenance/Component/CompanyDetails.dart';

getFormattedDecimal({required double? value, int? dp}) {
  if (dp == null) {
    int fractionDigits =
        (CompanyDetails.ocinModel?.ConfigNumberStep?.length ?? 3) - 1;
    if (fractionDigits <= 0) {
      fractionDigits = 2;
    }
    return value?.toStringAsFixed(fractionDigits) ?? '';
  } else {
    return value?.toStringAsFixed(dp) ?? '';
  }
}
