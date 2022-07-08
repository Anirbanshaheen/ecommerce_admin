import 'package:ecommerce_admin/pages/product_details_page.dart';
import 'package:ecommerce_admin/providers/product_provider.dart';
import 'package:ecommerce_admin/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  static const String routeName = '/products';

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),
      body: _productProvider.productList.isEmpty ? Center(
        child: Text('No items found'),
      ) : ListView.builder(
        itemCount: _productProvider.productList.length,
        itemBuilder: (context, index) {
          final product = _productProvider.productList[index];
          return Card(
            elevation: 5,
            child: ListTile(
              onTap: () => Navigator.pushNamed(context, ProductDetailsPage.routeName, arguments: [product.id, product.name]),
                title: Text(product.name!),
                leading: fadedImageWidget(product.imageDownloadUrl!),
                trailing: Chip(
                  label: Text('$takaSymbol${product.price}'),
                )
            ),
          );
        },
      ),
    );
  }

  Widget fadedImageWidget(String url) {
    return FadeInImage.assetNetwork(
        fadeInDuration: const Duration(seconds: 3),
        fadeInCurve: Curves.bounceInOut,
        fit: BoxFit.cover,
        placeholder: 'images/imageplaceholder.png',
        image: url
    );
  }
}
