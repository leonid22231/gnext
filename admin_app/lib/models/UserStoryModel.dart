import 'package:admin_app/api/entity/StorisEntity.dart';
import 'package:admin_app/api/entity/UserEntity.dart';


class UserStoryModel{
  UserEntity? user;
  List<StorisEntity> story = [];
}