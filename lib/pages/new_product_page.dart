import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/custom_widgets/custom_progress_dialog.dart';
import 'package:ecommerce_admin/models/product_model.dart';
import 'package:ecommerce_admin/models/purchase_model.dart';
import 'package:ecommerce_admin/providers/product_provider.dart';
import 'package:ecommerce_admin/utils/constants.dart';
import 'package:ecommerce_admin/utils/helper_function.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewProductPage extends StatefulWidget {
  static const String routeName = '/new_product';

  @override
  _NewProductPageState createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  late ProductProvider _productProvider;
  final _formKey = GlobalKey<FormState>();
  String? _category;
  DateTime? _dateTime;
  final ProductModel _productModel = ProductModel();
  final PurchaseModel _purchaseModel = PurchaseModel(purchaseDate: Timestamp.fromDate(DateTime.now()));
  ImageSource _imageSource = ImageSource.camera;
  String? _imagePath;
  bool isSaving = false;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProduct,
          )
        ],
      ),
      body: Stack(
        children: [
          if(isSaving) const Center(child: CustomProgressDialog(title: 'Please wait'),),
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(12.0),
              children: [
                TextFormField(
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productModel.name = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  //maxLines: 10,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productModel.description = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Product Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _purchaseModel.purchasePrice = num.parse(value!);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Purchase Price',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productModel.price = num.parse(value!);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Sale Price',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _purchaseModel.qty = num.parse(value!);
                    // Todo 1 done
                    // _productModel.stock = int.parse(value!);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10,),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder()
                  ),
                  hint: const Text('Select Category'),
                  value: _category,
                  onChanged: (value) {
                    setState(() {
                      _category = value;
                    });
                  },
                  onSaved: (value){
                    _productModel.category = value;
                  },
                  items: _productProvider.categoryList.map((cat) => DropdownMenuItem(
                    child: Text(cat),
                    value: cat,
                  )).toList(),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                Card(
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                          onPressed: _showDatePicker,
                          icon: const Icon(Icons.date_range),
                          label: const Text('Select Date')
                      ),
                      Text(_dateTime == null ? 'No date chosen' : getFormattedDate(_dateTime!, 'MMM dd, yyyy')),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Card(
                  elevation: 10,
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2)
                        ),
                        child: _imagePath == null ? Image.asset('images/imageplaceholder.png')
                            : Image.file(File(_imagePath!), width: 100, height: 100, fit: BoxFit.cover,),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            child: const Text('Camera'),
                            onPressed: () {
                              _imageSource = ImageSource.camera;
                              _pickImage();
                            },
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                            child: const Text('Gallery'),
                            onPressed: () {
                              _imageSource = ImageSource.gallery;
                              _pickImage();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveProduct() async {
    final isConnected = await isConnectedToInternet();
    if(isConnected) {
      if(_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (_dateTime == null) {
          showMessage(context, 'Please a select a date');
          return;
        }
        if (_imagePath == null) {
          showMessage(context, 'Please a select an image');
          return;
        }
        setState(() {
          isSaving = true;
        });

        _uploadImageAndSaveProduct();

      }
    }else {
      showMessage(context, 'No internet connection detected.');
    }

  }

  void _showDatePicker() async {
    final dt = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now());
    if(dt != null) {
      setState(() {
        _dateTime = dt;
        _purchaseModel.purchaseDate = Timestamp.fromDate(_dateTime!);
      });
      // Todo 2
      // _productModel.purchaseDate = Timestamp.fromDate(_dateTime!);
    }
  }

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: _imageSource, imageQuality: 60);
    if(pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
      // Todo 3
      // _productModel.localImagePath = _imagePath;
    }
  }

  void _uploadImageAndSaveProduct() async {
    final imageName = '${_productModel.name}_${DateTime.now().millisecondsSinceEpoch}';
    _productModel.imageName = imageName;

    final photoRef = FirebaseStorage.instance.ref().child('$photoDirectory/$imageName');
    final uploadTask = photoRef.putFile(File(_imagePath!));
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    _productModel.imageDownloadUrl = downloadUrl;

    _productProvider.insertNewProduct(_productModel, _purchaseModel)
        .then((value) {
        setState(() {
          isSaving = false;
        });
        Navigator.pop(context);
    }).catchError((error) {
      showMessage(context, 'Could not save!');
    });
  }
}
