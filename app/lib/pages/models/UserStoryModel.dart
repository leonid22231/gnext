import 'package:app/api/entity/StorisEntity.dart';
import 'package:app/api/entity/UserEntity.dart';

class UserStoryModel{
  int? index;
  UserEntity? user;
  List<StorisEntity> story = [];
}