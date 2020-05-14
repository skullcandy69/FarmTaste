class ProductsCategories {
  List<ProductCategoryData> data;

  ProductsCategories({this.data});

  ProductsCategories.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ProductCategoryData>();
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
      data = new List<ProductSubCategoryData>();
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
      data = new List<ProductData>();
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

class ProductData {
  String sType;
  int id;
  String title;
  int subCategoryId;
  String imageUrl;
  bool isUnderGst;
  dynamic gstRate;
  String slug;
  String createdAt;
  String updatedAt;
  String deletedAt;
  List<Rate> rate;

  ProductData(
      {this.sType,
      this.id,
      this.title,
      this.subCategoryId,
      this.imageUrl,
      this.isUnderGst,
      this.gstRate,
      this.slug,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.rate});

  ProductData.fromJson(Map<String, dynamic> json) {
    sType = json['__type'];
    id = json['id'];
    title = json['title'];
    subCategoryId = json['sub_category_id'];
    imageUrl = json['image_url'];
    isUnderGst = json['is_under_gst'];
    gstRate = json['gst_rate'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['rate'] != null) {
      rate = new List<Rate>();
      json['rate'].forEach((v) {
        rate.add(new Rate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__type'] = this.sType;
    data['id'] = this.id;
    data['title'] = this.title;
    data['sub_category_id'] = this.subCategoryId;
    data['image_url'] = this.imageUrl;
    data['is_under_gst'] = this.isUnderGst;
    data['gst_rate'] = this.gstRate;
    data['slug'] = this.slug;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.rate != null) {
      data['rate'] = this.rate.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rate {
  String sType;
  int id;
  int baseAmount;
  int discountedAmount;

  Rate({this.sType, this.id, this.baseAmount, this.discountedAmount});

  Rate.fromJson(Map<String, dynamic> json) {
    sType = json['__type'];
    id = json['id'];
    baseAmount = json['base_amount'];
    discountedAmount = json['discounted_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__type'] = this.sType;
    data['id'] = this.id;
    data['base_amount'] = this.baseAmount;
    data['discounted_amount'] = this.discountedAmount;
    return data;
  }
}
