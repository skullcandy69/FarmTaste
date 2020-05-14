class AreaModel {
  List<AreaData> data;

  AreaModel({this.data});

  AreaModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<AreaData>();
      json['data'].forEach((v) {
        data.add(new AreaData.fromJson(v));
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

class AreaData {
  int id;
  String title;
  String slug;
  String imageUrl;
  int locationId;
  bool isActive;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  AreaData(
      {this.id,
      this.title,
      this.slug,
      this.imageUrl,
      this.locationId,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  AreaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    imageUrl = json['image_url'];
    locationId = json['location_id'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['image_url'] = this.imageUrl;
    data['location_id'] = this.locationId;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
