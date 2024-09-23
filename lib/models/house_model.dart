import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class HouseModel {
  int? id;
  String? image;
  int? price;
  int? bedrooms;
  int? bathrooms;
  int? size;
  String? description;
  String? zip;
  String? city;
  int? latitude;
  int? longitude;
  String? createdDate;
  HouseModel({
    this.id,
    this.image,
    this.price,
    this.bedrooms,
    this.bathrooms,
    this.size,
    this.description,
    this.zip,
    this.city,
    this.latitude,
    this.longitude,
    this.createdDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'price': price,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'size': size,
      'description': description,
      'zip': zip,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'createdDate': createdDate,
    };
  }

  factory HouseModel.fromMap(Map<String, dynamic> map) {
    return HouseModel(
      id: map['id'] != null ? map['id'] as int : null,
      image: map['image'] != null ? map['image'] as String : null,
      price: map['price'] != null ? map['price'] as int : null,
      bedrooms: map['bedrooms'] != null ? map['bedrooms'] as int : null,
      bathrooms: map['bathrooms'] != null ? map['bathrooms'] as int : null,
      size: map['size'] != null ? map['size'] as int : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      zip: map['zip'] != null ? map['zip'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      latitude: map['latitude'] != null ? map['latitude'] as int : null,
      longitude: map['longitude'] != null ? map['longitude'] as int : null,
      createdDate:
          map['createdDate'] != null ? map['createdDate'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HouseModel.fromJson(String source) =>
      HouseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  HouseModel copyWith({
    int? id,
    String? image,
    int? price,
    int? bedrooms,
    int? bathrooms,
    int? size,
    String? description,
    String? zip,
    String? city,
    int? latitude,
    int? longitude,
    String? createdDate,
  }) {
    return HouseModel(
      id: id ?? this.id,
      image: image ?? this.image,
      price: price ?? this.price,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      size: size ?? this.size,
      description: description ?? this.description,
      zip: zip ?? this.zip,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  String toString() {
    return 'HouseModel(id: $id, image: $image, price: $price, bedrooms: $bedrooms, bathrooms: $bathrooms, size: $size, description: $description, zip: $zip, city: $city, latitude: $latitude, longitude: $longitude, createdDate: $createdDate)';
  }
}
