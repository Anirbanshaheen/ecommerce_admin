import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseModel {
  String? purchaseId;
  String? productId;
  Timestamp purchaseDate;
  num qty;
  num purchasePrice;

  PurchaseModel(
      {this.purchaseId,
      this.productId,
      required this.purchaseDate,
      this.qty = 1,
      this.purchasePrice = 0.0});

  Map<String, dynamic> toMap() {
    var map = <String,dynamic> {
      'purchaseId' : purchaseId,
      'productId' : productId,
      'purchaseDate' : purchaseDate,
      'purchasePrice' : purchasePrice,
      'quantity' : qty,
    };
    return map;
  }

  factory PurchaseModel.fromMap(Map<String, dynamic> map) => PurchaseModel(
    purchaseId: map['purchaseId'],
    productId: map['productId'],
    purchaseDate: map['purchaseDate'],
    purchasePrice: map['purchasePrice'],
    qty: map['quantity'],
  );

  @override
  String toString() {
    return 'PurchaseModel{purchaseId: $purchaseId, productId: $productId, purchaseDate: $purchaseDate, qty: $qty, purchasePrice: $purchasePrice}';
  }
}
