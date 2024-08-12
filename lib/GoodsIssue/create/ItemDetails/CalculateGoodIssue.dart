import 'package:maintenance/Component/CompanyDetails.dart';
import 'package:maintenance/Component/IsNumeric.dart';
import 'package:maintenance/GoodsIssue/create/GeneralData.dart';
import 'package:maintenance/GoodsIssue/create/ItemDetails/ItemDetails.dart';
import 'package:maintenance/Sync/SyncModels/IMGDI1.dart';

void calculateGoodsIssue() {
  double sum = 0.0, tax = 0.0, discount = 0.0;
  for (int i = 0; i < ItemDetails.items.length; i++) {
    IMGDI1 imgd1 = ItemDetails.items[i];
    double price = roundToTwoDecimal(imgd1.Price);
    double msp = roundToTwoDecimal(imgd1.MSP);
    discount += roundToTwoDecimal(imgd1.Discount);
    sum +=
        (roundToTwoDecimal(imgd1.Price)) * (roundToTwoDecimal(imgd1.Quantity));
    double total_tax = 0.0;
    if (CompanyDetails.ocinModel?.IsMtv == true) {
      if (price > msp) {
        total_tax = (((roundToTwoDecimal(imgd1.Price)) *
                    (roundToTwoDecimal(imgd1.Quantity))) -
                (roundToTwoDecimal(imgd1.Discount))) *
            (roundToTwoDecimal(imgd1.TaxRate)) /
            100;
      } else {
        total_tax = (((roundToTwoDecimal(imgd1.MSP)) *
                    (roundToTwoDecimal(imgd1.Quantity))) -
                (roundToTwoDecimal(imgd1.Discount))) *
            (roundToTwoDecimal(imgd1.TaxRate)) /
            100;
      }
    } else {
      total_tax = (((roundToTwoDecimal(imgd1.Price)) *
                  (roundToTwoDecimal(imgd1.Quantity))) -
              (roundToTwoDecimal(imgd1.Discount))) *
          (roundToTwoDecimal(imgd1.TaxRate)) /
          100;
    }
    ItemDetails.items[i].LineTotal = roundToTwoDecimal(total_tax) +
        roundToTwoDecimal(price) * (roundToTwoDecimal(imgd1.Quantity)) -
        (roundToTwoDecimal(imgd1.Discount));
    tax += roundToTwoDecimal(total_tax);
  }
  double total_amt = roundToTwoDecimal(sum) +
      roundToTwoDecimal(tax) -
      roundToTwoDecimal(discount);
  double discPer = (discount / total_amt) * 100;
  GeneralData.discPer = roundToTwoDecimal(discPer).toStringAsFixed(2);
  GeneralData.totBDisc = roundToTwoDecimal(sum).toStringAsFixed(2);
  GeneralData.discVal = roundToTwoDecimal(discount).toStringAsFixed(2);
  GeneralData.docTotal = roundToTwoDecimal(total_amt).toStringAsFixed(2);
  GeneralData.taxVal = roundToTwoDecimal(tax).toStringAsFixed(2);
}
