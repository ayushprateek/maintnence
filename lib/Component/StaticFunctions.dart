// class StaticFunctions{
//    static List<MNTTP1> GetPairedEquipments(String inputValue)
//   {
//     List<MNTTP1> MNTTP1s = new List<MNTTP1>();
//     // Get the latest MNOTTP record for the given EquipmentCode
//     MNOTTP mNOTTP = _db.MNOTTPs
//         .Where(m => m.EquipmentCode == inputValue)
//         .OrderByDescending(m => m.CreateDate)
//         .FirstOrDefault();
//
//     if (mNOTTP != null)
//     {
//       // Get the associated MNTTP1 records
//       MNTTP1s = _db.MNTTP1
//           .Where(m => m.TransId == mNOTTP.TransId && m.StartDate < DateTime.Now && m.EndDate > DateTime.Now)
//           .ToList();
//     }
//     return MNTTP1s;
//   }
// }