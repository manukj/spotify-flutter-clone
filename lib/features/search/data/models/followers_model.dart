import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/followers.dart';

part 'followers_model.g.dart';

@JsonSerializable()
class FollowersModel {
  final int? total;

  const FollowersModel({this.total});

  factory FollowersModel.fromJson(Map<String, dynamic> json) => _$FollowersModelFromJson(json);
  Map<String, dynamic> toJson() => _$FollowersModelToJson(this);

  Followers toEntity() => Followers(total: total);
  factory FollowersModel.fromEntity(Followers entity) => FollowersModel(total: entity.total);
} 