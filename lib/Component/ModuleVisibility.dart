class ModuleVisibility {
  String name;
  bool sel = false;
  bool ReadOnly_ = false;
  bool Self_ = false;
  bool Branch_ = false;

  ModuleVisibility(
      {required this.name,
      required this.Branch_,
      required this.ReadOnly_,
      required this.sel,
      required this.Self_});
}
