import 'package:equatable/equatable.dart';

class AreaModel {
  List<AreaData> data;

  AreaModel({this.data});

  AreaModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      // data = new List<AreaData>();
      data =[];
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

class AreaData extends Equatable {
  int id;
  String title;
  String slug;
  dynamic imageUrl;
  int cityId;
  bool isActive;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  AreaData(
      {this.id,
      this.title,
      this.slug,
      this.imageUrl,
      this.cityId,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  AreaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    imageUrl = json['image_url'];
    cityId = json['city_id'];
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
    data['city_id'] = this.cityId;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }

  @override
  List<Object> get props => [id];
}
