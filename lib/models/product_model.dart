class ProductModel {
  String? id;
  String? name;
  String? category;
  num? price;
  String? imageName;
  String? imageDownloadUrl;
  String? description;
  bool isAvailable;

  ProductModel(
      {this.id,
      this.name,
      this.category,
      this.price,
      this.imageName,
      this.imageDownloadUrl,
      this.description,
      this.isAvailable = true});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'imageDownloadUrl': imageDownloadUrl,
      'description': description,
      'isAvailable': isAvailable,
      'imageName': imageName,
    };
    return map;
  }

  // Todo ask factory?
  factory ProductModel.fromMap(Map<String,dynamic> map) => ProductModel(
    id: map['id'],
    name: map['name'],
    category: map['category'],
    price: map['price'],
    imageDownloadUrl: map['imageDownloadUrl'],
    description: map['description'],
    isAvailable: map['isAvailable'],
    imageName: map['imageName'],
  );

  @override
  String toString() {
    return 'ProductModel{id: $id, name: $name, category: $category, price: $price, imageName: $imageName, imageDownloadUrl: $imageDownloadUrl, description: $description, isAvailable: $isAvailable}';
  }
}
