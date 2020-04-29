import 'package:flutter/material.dart';

class StampIndicator {
  String stampAmount = "-";
  String stampInTransactionAmount = "-";
  StampIndicator({String stampAmount, String stampInTransactionAmount}) {
    this.stampAmount = stampAmount;
    this.stampInTransactionAmount = stampInTransactionAmount;
  }
  void updateStampAmount({@required String stampAmount}) {
    this.stampAmount = stampAmount;
  }

  void updateStampInTransactionAmount(
      {@required String stampInTransactionAmount}) {
    this.stampInTransactionAmount = stampInTransactionAmount;
  }

  String exportToString() {
    return this.stampInTransactionAmount + "/" + this.stampAmount;
  }
}
