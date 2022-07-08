import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/db/firestore_helper.dart';
import 'package:ecommerce_admin/models/purchase_model.dart';
import 'package:flutter/foundation.dart';

import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier{
  List<String> categoryList = [];
  List<ProductModel> productList = [];
  List<PurchaseModel> purchaseList = [];

  init(){
    _getAllProducts();
    _getAllCategories();
  }

  void _getAllProducts() {
    FirestoreHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  void getPurchasesByProductId(String id) {
    FirestoreHelper.getAllPurchaseByProductId(id).listen((snapshot) {
      purchaseList = List.generate(snapshot.docs.length, (index) => PurchaseModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProductByProductId(String id) => FirestoreHelper.getProductByProductId(id);

  void _getAllCategories() {
    FirestoreHelper.getCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length, (index) => snapshot.docs[index].data()['name']);
      notifyListeners();
    });
  }

  Future<void> insertNewProduct(ProductModel productModel, PurchaseModel purchaseModel) {
    return FirestoreHelper.addNewProduct(productModel, purchaseModel);
  }

  Future<bool> checkAdmin(String email) {
    return FirestoreHelper.checkAdmin(email);
  }
}