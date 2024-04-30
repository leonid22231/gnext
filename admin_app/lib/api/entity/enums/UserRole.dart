import 'package:admin_app/utils/globals.dart';
enum UserRole{
  ADMIN,MANAGER,SPECIALIST,USER;
  @override
  String toString(){
    return getRole(this);
  }
}