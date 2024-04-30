import 'package:admin_app/api/entity/UserEntity.dart';
import 'package:admin_app/api/entity/enums/EventResult.dart';
import 'package:admin_app/api/entity/enums/WalletEvent.dart';
import 'package:json_annotation/json_annotation.dart';
part 'WalletEventH.g.dart';
@JsonSerializable()
class WalletEventH{
  int id;
  WalletEvent type;
  EventResult result;
  UserEntity user;
  double old_sum;
  double sum;
  DateTime date;

  WalletEventH({
    required this.id,
    required this.type,
    required this.result,
    required this.user,
    required this.old_sum,
    required this.sum,
    required this.date
});

  factory WalletEventH.fromJson(Map<String, dynamic> json) => _$WalletEventHFromJson(json);
  Map<String, dynamic> toJson() => _$WalletEventHToJson(this);
}