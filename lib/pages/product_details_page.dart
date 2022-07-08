import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/models/product_model.dart';
import 'package:ecommerce_admin/providers/product_provider.dart';
import 'package:ecommerce_admin/utils/constants.dart';
import 'package:ecommerce_admin/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/product_details';

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {

  String? productId;
  String productName = '';
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context,listen: false); // Provider Object

    final argList = ModalRoute.of(context)!.settings.arguments as List;
    productId = argList[0];
    productName = argList[1];
    _productProvider.getPurchasesByProductId(productId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productName),),
      body: Center(
        child: Consumer<ProductProvider>(
          builder: (context, provider, _) => StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: provider.getProductByProductId(productId!),
            builder: (context, snapshot){
              if(snapshot.hasData){
                final product = ProductModel.fromMap(snapshot.data!.data()!);
                return ListView(
                  children: [
                    FadeInImage.assetNetwork(
                        fadeInDuration: const Duration(seconds: 3),
                        fadeInCurve: Curves.bounceInOut,
                        fit: BoxFit.cover,
                        placeholder: 'images/imageplaceholder.png',
                        image: product.imageDownloadUrl!,
                        width: double.infinity,
                        height: 250,
                    ),
                    ListTile(
                      title: Text(product.name!),
                      subtitle: Text(product.category!),
                      trailing: Text('$takaSymbol${product.price}'),
                    ),
                    ListTile(
                      title: Text('Sale Price: ${product.price!}'),
                    ),
                    ListTile(
                      title: const Text('Purchase History'),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: provider.purchaseList.map((purchase) => ListTile(
                          title: Text(getFormattedDate(purchase.purchaseDate.toDate(), 'MMM dd, yyyy')),
                          trailing: Text('$takaSymbol${purchase.purchasePrice}'),
                        )).toList(),
                      ),
                    )
                  ],
                );
              }
              if(snapshot.hasError){
                return const Text('Failed to load data');
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

