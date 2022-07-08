import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/models/purchase_model.dart';

import '../models/product_model.dart';

class FirestoreHelper{
  static const String _collectionAdmin = 'Admins';
  static const String _collectionProduct = 'Products';
  static const String _collectionPurchases = 'Purchases';
  static const String _collectionCategory = 'Categories';

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCategories() => _db.collection(_collectionCategory).snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() => _db.collection(_collectionProduct).snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPurchaseByProductId(String id) => _db.collection(_collectionPurchases).where('productId', isEqualTo: id).snapshots();
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getProductByProductId(String id) => _db.collection(_collectionProduct).doc(id).snapshots();

  static Future<void> addNewProduct(ProductModel productModel, PurchaseModel purchaseModel) {
    final wb = _db.batch();
    final productDocRef = _db.collection(_collectionProduct).doc();
    final purchaseDocRef = _db.collection(_collectionPurchases).doc();
    productModel.id = productDocRef.id;
    purchaseModel.purchaseId = purchaseDocRef.id;

    purchaseModel.productId = productDocRef.id;

    wb.set(productDocRef, productModel.toMap());
    wb.set(purchaseDocRef, purchaseModel.toMap());

    return wb.commit();
  }

  static Future<bool>checkAdmin(String email) async {
    final snapshot = await _db.collection(_collectionAdmin)
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty;
  }

}