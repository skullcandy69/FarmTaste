class CoverImages {
  List<ImageData> data;

  CoverImages({this.data});

  CoverImages.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ImageData>();
      json['data'].forEach((v) {
        data.add(new ImageData.fromJson(v));
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

class ImageData {
  int id;
  String title;
  String imageUrl;
  String slug;
  int priority;
  String createdAt;
  String updatedAt;

  ImageData(
      {this.id,
      this.title,
      this.imageUrl,
      this.slug,
      this.priority,
      this.createdAt,
      this.updatedAt});

  ImageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json['image_url'];
    slug = json['slug'];
    priority = json['priority'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image_url'] = this.imageUrl;
    data['slug'] = this.slug;
    data['priority'] = this.priority;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
