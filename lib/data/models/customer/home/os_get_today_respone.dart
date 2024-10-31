class OsTodayRes {
  OSGetTodayResult? oSGetTodayResult;

  OsTodayRes({this.oSGetTodayResult});

  OsTodayRes.fromJson(Map<String, dynamic> json) {
    oSGetTodayResult = json['OS_GetTodayResult'] != null
        ? OSGetTodayResult.fromJson(json['OS_GetTodayResult'])
        : null;
  }
}

class OSGetTodayResult {
  List<Table0>? table0;
  List<Table1>? table1;
  List<Table10>? table10;
  List<Table11>? table11;
  List<Table14>? table14;
  List<Table2>? table2;
  List<Table3>? table3;
  List<Table4>? table4;
  List<Table5>? table5;
  List<Table6>? table6;
  List<Table7>? table7;
  List<Table8>? table8;
  List<Table9>? table9;

  OSGetTodayResult(
      {this.table0,
      this.table1,
      this.table10,
      this.table11,
      this.table14,
      this.table2,
      this.table3,
      this.table4,
      this.table5,
      this.table6,
      this.table7,
      this.table8,
      this.table9});

  OSGetTodayResult.fromJson(Map<String, dynamic> json) {
    if (json['Table0'] != null) {
      table0 = <Table0>[];
      json['Table0'].forEach((v) {
        table0!.add(Table0.fromJson(v));
      });
    }
    if (json['Table1'] != null) {
      table1 = <Table1>[];
      json['Table1'].forEach((v) {
        table1!.add(Table1.fromJson(v));
      });
    }
    if (json['Table10'] != null) {
      table10 = <Table10>[];
      json['Table10'].forEach((v) {
        table10!.add(Table10.fromJson(v));
      });
    }
    if (json['Table11'] != null) {
      table11 = <Table11>[];
      json['Table11'].forEach((v) {
        table11!.add(Table11.fromJson(v));
      });
    }
    if (json['Table14'] != null) {
      table14 = <Table14>[];
      json['Table14'].forEach((v) {
        table14!.add(Table14.fromJson(v));
      });
    }
    if (json['Table2'] != null) {
      table2 = <Table2>[];
      json['Table2'].forEach((v) {
        table2!.add(Table2.fromJson(v));
      });
    }
    if (json['Table3'] != null) {
      table3 = <Table3>[];
      json['Table3'].forEach((v) {
        table3!.add(Table3.fromJson(v));
      });
    }
    if (json['Table4'] != null) {
      table4 = <Table4>[];
      json['Table4'].forEach((v) {
        table4!.add(Table4.fromJson(v));
      });
    }
    if (json['Table5'] != null) {
      table5 = <Table5>[];
      json['Table5'].forEach((v) {
        table5!.add(Table5.fromJson(v));
      });
    }
    if (json['Table6'] != null) {
      table6 = <Table6>[];
      json['Table6'].forEach((v) {
        table6!.add(Table6.fromJson(v));
      });
    }
    if (json['Table7'] != null) {
      table7 = <Table7>[];
      json['Table7'].forEach((v) {
        table7!.add(Table7.fromJson(v));
      });
    }
    if (json['Table8'] != null) {
      table8 = <Table8>[];
      json['Table8'].forEach((v) {
        table8!.add(Table8.fromJson(v));
      });
    }
    if (json['Table9'] != null) {
      table9 = <Table9>[];
      json['Table9'].forEach((v) {
        table9!.add(Table9.fromJson(v));
      });
    }
  }
}

class Table0 {
  String? lOCALDATE;

  Table0({this.lOCALDATE});

  Table0.fromJson(Map<String, dynamic> json) {
    lOCALDATE = json['LOCALDATE'];
  }
}

class Table1 {
  String? clientRefNo;
  double? gRQTY;
  double? oRDQTY;
  double? pER;

  Table1({this.clientRefNo, this.gRQTY, this.oRDQTY, this.pER});

  Table1.fromJson(Map<String, dynamic> json) {
    clientRefNo = json['ClientRefNo'];
    gRQTY = json['GR_QTY'];
    oRDQTY = json['ORD_QTY'];
    pER = json['PER'];
  }
}

class Table10 {
  int? gIQTY;
  int? oORDQTY;
  double? pER;

  Table10({this.gIQTY, this.oORDQTY, this.pER});

  Table10.fromJson(Map<String, dynamic> json) {
    gIQTY = json['GIQTY'];
    oORDQTY = json['OORDQTY'];
    pER = double.parse(json['PER'].toString());
  }
}

class Table11 {
  int? aLLQTY;
  double? pER;
  int? uSEDQTY;

  Table11({this.aLLQTY, this.pER, this.uSEDQTY});

  Table11.fromJson(Map<String, dynamic> json) {
    aLLQTY = json['ALLQTY'];
    pER = json['PER'].toDouble();
    uSEDQTY = json['USEDQTY'];
  }
}

class Table14 {
  int? cOMPLETEQTY;
  double? pER;
  int? tORDQTY;

  Table14({this.cOMPLETEQTY, this.pER, this.tORDQTY});

  Table14.fromJson(Map<String, dynamic> json) {
    cOMPLETEQTY = json['COMPLETEQTY'];
    pER = double.parse(json['PER'].toString());
    tORDQTY = json['TORDQTY'];
  }
}

class Table2 {
  String? clientRefNo;
  int? gLQTY;
  double? oRDQTY;
  double? pER;

  Table2({this.clientRefNo, this.gLQTY, this.oRDQTY, this.pER});

  Table2.fromJson(Map<String, dynamic> json) {
    clientRefNo = json['ClientRefNo'];
    gLQTY = json['GL_QTY'];
    oRDQTY = json['ORD_QTY'];
    pER = json['PER'];
  }
}

class Table3 {
  String? clientRefNo;
  int? gLQTY;
  double? oRDQTY;
  double? pER;

  Table3({this.clientRefNo, this.gLQTY, this.oRDQTY, this.pER});

  Table3.fromJson(Map<String, dynamic> json) {
    clientRefNo = json['ClientRefNo'];
    gLQTY = json['GL_QTY'];
    oRDQTY = json['ORD_QTY'];
    pER = json['PER'];
  }
}

class Table4 {
  String? column;
  int? value;

  Table4({this.column, this.value});

  Table4.fromJson(Map<String, dynamic> json) {
    column = json['Column'];
    value = json['Value'];
  }
}

class Table5 {
  String? column;
  int? value;

  Table5({this.column, this.value});

  Table5.fromJson(Map<String, dynamic> json) {
    column = json['Column'];
    value = json['Value'];
  }
}

class Table6 {
  Attributes? attributes;
  List<double>? coordinates;

  Table6({this.attributes, this.coordinates});

  Table6.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? Attributes.fromJson(json['attributes'])
        : null;
    coordinates = json['coordinates'].cast<double>();
  }
}

class Attributes {
  String? name;
  int? value;

  Attributes({this.name, this.value});

  Attributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }
}

class Table7 {
  String? column;
  int? max;
  int? value;

  Table7({this.column, this.max, this.value});

  Table7.fromJson(Map<String, dynamic> json) {
    column = json['Column'];
    max = json['Max'];
    value = json['Value'];
  }
}

class Table8 {
  String? column;
  int? max;
  int? value;

  Table8({this.column, this.max, this.value});

  Table8.fromJson(Map<String, dynamic> json) {
    column = json['Column'];
    max = json['Max'];
    value = json['Value'];
  }
}

class Table9 {
  int? gRQTY;
  int? iORDQTY;
  double? pER;

  Table9({this.gRQTY, this.iORDQTY, this.pER});

  Table9.fromJson(Map<String, dynamic> json) {
    gRQTY = json['GRQTY'];
    iORDQTY = json['IORDQTY'];
    pER = double.parse(json['PER'].toString());
  }
}
