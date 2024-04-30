import 'dart:io';

import 'package:app/api/entity/enums/UserRole.dart';

class UserModel{
  String name;
  String surname;
  String password;
  String phone;
  String? number;
  int countryId;
  int cityId;
  UserRole role;
  File? file;
  UserModel(this.file,this.name, this.surname, this.password, this.phone, this.number, this.countryId, this.cityId, this.role);
}