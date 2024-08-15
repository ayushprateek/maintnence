import 'package:maintenance/Component/CompanyDetails.dart';
import 'package:maintenance/Component/IsNumeric.dart';
import 'package:maintenance/Purchase/PurchaseRequest/edit/ItemDetails/ItemDetails.dart';
import 'package:maintenance/Sync/SyncModels/PRPRQ1.dart';

void calculatePurchaseRequest() {
  double sum = 0.0, tax = 0.0, discount = 0.0;
  for (int i = 0; i < ItemDetails.items.length; i++) {
    PRPRQ1 prprq1 = ItemDetails.items[i];
    double price = roundToTwoDecimal(prprq1.Price);
    double msp = roundToTwoDecimal(prprq1.MSP);
    discount += roundToTwoDecimal(prprq1.Discount);
    sum += (roundToTwoDecimal(prprq1.Price)) *
        (roundToTwoDecimal(prprq1.Quantity));
    double total_tax = 0.0;
    if (CompanyDetails.ocinModel?.IsMtv == true) {
      if (price > msp) {
        total_tax = (((roundToTwoDecimal(prprq1.Price)) *
                    (roundToTwoDecimal(prprq1.Quantity))) -
                (roundToTwoDecimal(prprq1.Discount))) *
            (roundToTwoDecimal(prprq1.TaxRate)) /
            100;
      } else {
        total_tax = (((roundToTwoDecimal(prprq1.MSP)) *
                    (roundToTwoDecimal(prprq1.Quantity))) -
                (roundToTwoDecimal(prprq1.Discount))) *
            (roundToTwoDecimal(prprq1.TaxRate)) /
            100;
      }
    } else {
      total_tax = (((roundToTwoDecimal(prprq1.Price)) *
                  (roundToTwoDecimal(prprq1.Quantity))) -
              (roundToTwoDecimal(prprq1.Discount))) *
          (roundToTwoDecimal(prprq1.TaxRate)) /
          100;
    }
    ItemDetails.items[i].LineTotal = roundToTwoDecimal(total_tax) +
        roundToTwoDecimal(price) * (roundToTwoDecimal(prprq1.Quantity)) -
        (roundToTwoDecimal(prprq1.Discount));
    tax += roundToTwoDecimal(total_tax);
  }
  double total_amt = roundToTwoDecimal(sum) +
      roundToTwoDecimal(tax) -
      roundToTwoDecimal(discount);
  double discPer = (discount / total_amt) * 100;
  // GeneralData.discPer = roundToTwoDecimal(discPer).toStringAsFixed(2);
  // GeneralData.totBDisc = roundToTwoDecimal(sum).toStringAsFixed(2);
  // GeneralData.discVal = roundToTwoDecimal(discount).toStringAsFixed(2);
  // GeneralData.docTotal = roundToTwoDecimal(total_amt).toStringAsFixed(2);
  // GeneralData.taxVal = roundToTwoDecimal(tax).toStringAsFixed(2);
}
