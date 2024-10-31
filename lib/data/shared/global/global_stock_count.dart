class GlobalStockCount {
  String? lastLocation;
  get getLastLocation => lastLocation;

  set setLastLocation(value) => lastLocation = value;

  String? lastItemCode;
  get getLastItemCode => lastItemCode;

  set setLastItemCode(value) => lastItemCode = value;
}

GlobalStockCount globalStockCount = GlobalStockCount();
