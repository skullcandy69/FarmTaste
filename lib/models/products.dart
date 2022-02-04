import 'package:equatable/equatable.dart';

class ProductsCategories {
  List<ProductCategoryData> data;

  ProductsCategories({this.data});

  ProductsCategories.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      // data = new List<ProductCategoryData>();
      data = [];
      json['data'].forEach((v) {
        data.add(new ProductCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductCategoryData {
  int id;
  String title;
  String slug;
  String createdAt;
  String updatedAt;
  String deletedAt;

  ProductCategoryData(
      {this.id,
      this.title,
      this.slug,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ProductCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class ProductSubCategory {
  List<ProductSubCategoryData> data;

  ProductSubCategory({this.data});

  ProductSubCategory.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      // data = new List<ProductSubCategoryData>();
      data = [];
      json['data'].forEach((v) {
        data.add(new ProductSubCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductSubCategoryData {
  int id;
  String title;
  String slug;
  int categoryId;
  String imageUrl;
  String createdAt;
  String updatedAt;
  String deletedAt;

  ProductSubCategoryData(
      {this.id,
      this.title,
      this.slug,
      this.categoryId,
      this.imageUrl,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ProductSubCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    categoryId = json['category_id'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['category_id'] = this.categoryId;
    data['image_url'] = this.imageUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Products {
  List<ProductData> data;

  Products({this.data});

  Products.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      // data = new List<ProductData>();
      data =[];
      json['data'].forEach((v) {
        data.add(new ProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductData extends Equatable{
  String sType;
  int id;
  String title;
  int subCategoryId;
  String imageUrl;
  bool isUnderGst;
  String baseQuantity;
  int mrp;
  int sellingPrice;
  int cityId;
  dynamic gstRate;
  dynamic gstAmount;
  bool isActive;
  bool inStock;
  String slug;
  String createdAt;
  String updatedAt;
  dynamic rating;
  ProductData(
      {this.sType,
      this.id,
      this.title,
      this.subCategoryId,
      this.imageUrl,
      this.isUnderGst,
      this.baseQuantity,
      this.mrp,
      this.sellingPrice,
      this.cityId,
      this.gstRate,
      this.rating,
      this.gstAmount,
      this.isActive,
      this.inStock,
      this.slug,
      this.createdAt,
      this.updatedAt});

  ProductData.fromJson(Map<String, dynamic> json) {
    sType = json['__type'];
    id = json['id'];
    title = json['title'];
    subCategoryId = json['sub_category_id'];
    imageUrl = json['image_url'];
    isUnderGst = json['is_under_gst'];
    baseQuantity = json['base_quantity'];
    mrp = json['mrp'];
    sellingPrice = json['selling_price'];
    cityId = json['city_id'];
    gstRate = json['gst_rate'];
    rating = json['rating'];
    gstAmount = json['gst_amount'];
    isActive = json['is_active'];
    inStock = json['in_stock'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__type'] = this.sType;
    data['id'] = this.id;
    data['title'] = this.title;
    data['sub_category_id'] = this.subCategoryId;
    data['image_url'] = this.imageUrl;
    data['is_under_gst'] = this.isUnderGst;
    data['base_quantity'] = this.baseQuantity;
    data['mrp'] = this.mrp;
    data['selling_price'] = this.sellingPrice;
    data['city_id'] = this.cityId;
    data['gst_rate'] = this.gstRate;
    data['gst_amount']=this.gstAmount;
    data['is_active'] = this.isActive;
    data['in_stock'] = this.inStock;
    data['slug'] = this.slug;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
  
 @override
  List<Object> get props => [id];
}
