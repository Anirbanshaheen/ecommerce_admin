import 'package:ecommerce_admin/auth/firebase_auth_service.dart';
import 'package:ecommerce_admin/custom_widgets/dashboard_button.dart';
import 'package:ecommerce_admin/pages/login_page.dart';
import 'package:ecommerce_admin/pages/new_product_page.dart';
import 'package:ecommerce_admin/pages/product_list_page.dart';
import 'package:ecommerce_admin/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    _productProvider.init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuthService.logoutAdmin().then((value) => Navigator.pushReplacementNamed(context, LoginPage.routeName));
            },
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        children: [
          DashboardButton(
            label: 'Add Product',
            onPressed: () => Navigator.pushNamed(context, NewProductPage.routeName),
          ),
          DashboardButton(
            label: 'View Product',
            onPressed: () => Navigator.pushNamed(context, ProductListPage.routeName),
          ),
          DashboardButton(
            label: 'View Product',
            onPressed: () => Navigator.pushNamed(context, ProductListPage.routeName),
          ),
          DashboardButton(
            label: 'View Product',
            onPressed: () => Navigator.pushNamed(context, ProductListPage.routeName),
          ),
          DashboardButton(
            label: 'View Product',
            onPressed: () => Navigator.pushNamed(context, ProductListPage.routeName),
          ),
          DashboardButton(
            label: 'View Product',
            onPressed: () => Navigator.pushNamed(context, ProductListPage.routeName),
          ),
          DashboardButton(
            label: 'View Product',
            onPressed: () => Navigator.pushNamed(context, ProductListPage.routeName),
          ),
        ],
      ),
    );
  }
}
