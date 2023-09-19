import 'package:flutter/foundation.dart';

class CommunityModel {
  final String id;
  final String name;
  final String bannerImage;
  final String avatar;
  final String description;
  final List<String> moderators;
  final List<String> members;
  CommunityModel({
    required this.id,
    required this.name,
    required this.bannerImage,
    required this.avatar,
    required this.description,
    required this.moderators,
    required this.members,
  });

  CommunityModel copyWith({
    String? id,
    String? name,
    String? bannerImage,
    String? avatar,
    String? description,
    List<String>? moderators,
    List<String>? members,
  }) {
    return CommunityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bannerImage: bannerImage ?? this.bannerImage,
      avatar: avatar ?? this.avatar,
      description: description ?? this.description,
      moderators: moderators ?? this.moderators,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'bannerImage': bannerImage,
      'avatar': avatar,
      'description': description,
      'moderators': moderators,
      'members': members,
    };
  }

  factory CommunityModel.fromMap(Map<String, dynamic> map) {
    return CommunityModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      bannerImage: map['bannerImage'] ?? '',
      avatar: map['avatar'] ?? '',
      description: map['description'] ?? '',
      members: List<String>.from(map['members']),
      moderators: List<String>.from(map['moderators']),
    );
  }

  @override
  String toString() {
    return 'CommunityModel(id: $id, name: $name, bannerImage: $bannerImage, avatar: $avatar, description: $description, moderators: $moderators, members: $members)';
  }

  @override
  bool operator ==(covariant CommunityModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.bannerImage == bannerImage &&
        other.avatar == avatar &&
        other.description == description &&
        listEquals(other.moderators, moderators) &&
        listEquals(other.members, members);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        bannerImage.hashCode ^
        avatar.hashCode ^
        description.hashCode ^
        moderators.hashCode ^
        members.hashCode;
  }
}
