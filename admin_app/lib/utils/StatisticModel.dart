import 'package:json_annotation/json_annotation.dart';

part 'StatisticModel.g.dart';

@JsonSerializable()
class StatisticModel {
  int userCount;
  int chatCount;
  int messagesCount;
  int countryCount;
  int cityCount;
  int allOrders;
  int activeOrders;

  StatisticModel(this.userCount, this.chatCount, this.messagesCount,
      this.countryCount, this.cityCount, this.allOrders, this.activeOrders);

  factory StatisticModel.fromJson(Map<String, dynamic> json) => _$StatisticModelFromJson(json);
  Map<String, dynamic> toJson() => _$StatisticModelToJson(this);
}