import 'package:json_annotation/json_annotation.dart';

part 'specialty_model.g.dart';

@JsonSerializable()
class SpecialtyModel {
  @JsonKey(name: 'Id')
  final int specialityId;

  @JsonKey(name: 'Name')
  final String specialityDesc;

  SpecialtyModel({
    required this.specialityId,
    required this.specialityDesc,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) =>
      _$SpecialtyModelFromJson(json);
  Map<String, dynamic> toJson() => _$SpecialtyModelToJson(this);
}
