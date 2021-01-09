// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return UserProfile(
    locName: json['locName'] as String,
    depth: json['depth'] as String,
    sizes: json['sizes'] as String,
    lat: json['lat'] as String,
    lng: json['lng'] as String,
    date: json['date'] as String,
    time: json['time'] as String,
  );
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'locName': instance.locName,
      'depth': instance.depth,
      'sizes': instance.sizes,
      'lat': instance.lat,
      'lng': instance.lng,
      'date': instance.date,
      'time': instance.time,
    };

Quake _$QuakeFromJson(Map<String, dynamic> json) {
  return Quake(
    locName: json['locName'] as String,
    depth: json['depth'] as String,
    sizes: json['sizes'] as String,
    lat: json['lat'] as String,
    lng: json['lng'] as String,
    date: json['date'] as String,
    time: json['time'] as String,
  );
}

Map<String, dynamic> _$QuakeToJson(Quake instance) => <String, dynamic>{
      'locName': instance.locName,
      'depth': instance.depth,
      'sizes': instance.sizes,
      'lat': instance.lat,
      'lng': instance.lng,
      'date': instance.date,
      'time': instance.time,
    };
