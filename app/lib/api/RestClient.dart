// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:app/api/entity/ChatEntity.dart';
import 'package:app/api/entity/CountryEntity.dart';
import 'package:app/api/entity/MessageEntity.dart';
import 'package:app/api/entity/OrderEntity.dart';
import 'package:app/api/entity/PropertiesEntity.dart';
import 'package:app/api/entity/StorisEntity.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/api/entity/enums/Categories.dart';
import 'package:app/api/entity/enums/MessageType.dart';
import 'package:app/api/entity/enums/StoryType.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import 'entity/CompanyEntity.dart';

part 'RestClient.g.dart';
//45.67.35.206
//192.168.0.11
@RestApi(baseUrl: 'http://192.168.0.11:8080/api/v1/')
abstract class  RestClient{
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;
  
  @GET("user/login")
  Future<String> login(@Query("phone") String phone, @Query("password") String password);
  @POST("user/login")
  Future<UserEntity> loginConfirm(@Query("phone") String phone, @Query("uid") String uid);
  @POST("user/register")
  @MultiPart()
  Future<String> register(@Query("phone") String phone, @Query("password") String password,@Query("name") String name,@Query("surname") String surname,@Query("number") String? number, @Query("role") UserRole role,@Query("countryId") int countryId,@Query("cityId") int cityId, @Query("uid") String uid,@Query("notifyToken") String notifyToken, @Part(name: "photo")File? photo);
  @POST("user/changePhoto")
  @MultiPart()
  Future<String> changePhoto(@Query("uid")String uid, @Part(name: "photo")File file);
  @GET("user/uid")
  Future<UserEntity> getUserByUid(@Query("uid")String uid);
  @POST("user/uid")
  Future<UserEntity> setUserUid(@Query("phone") String phone,@Query("uid")String uid);
  @GET("chat/{id}")
  Future<List<MessageEntity>> getMessages(@Query("uid") String uid,@Path("id")String id);
  @MultiPart()
  @POST("chat/file")
  Future<void> fileMessage(@Query("uid") String uid,@Query("name")String name,@Query("type")MessageType type, @Part(name: "file")File file);
  @GET("chat/findId")
  Future<String> getChatId(@Query("uid")String uid, @Query("name")String name);
  @POST("storis/add")
  @MultiPart()
  Future<void> addStory(@Query("chat")String id,@Query("uid")String uid,@Query("type")StoryType type,@Part(name: "file")File file);
  @GET("storis/chat")
  Future<List<StorisEntity>> getStoris(@Query("uid")String uid,@Query("chat")String chat);
  @GET("location/countries")
  Future<List<CountryEntity>> getCountries();
  @POST("orders/create")
  @MultiPart()
  Future<void> createOrder(@Query("uid")String uid,@Query("startDate")DateTime startDate,@Query("description")String description,@Query("endDate")DateTime endDate,@Query("price")double price,@Query("customPrice")bool customPrice, @Query("outcity")bool outcity, @Part(name: "properties") PropertiesModel properties, @Part(name: "file")File? file);
  @GET("orders/my")
  Future<List<OrderEntity>> myOrders(@Query("uid")String uid, @Query("outcity")bool outcity);
  @GET("orders/active")
  Future<List<OrderEntity>> activeOrders(@Query("uid")String uid, @Query("outcity")bool outcity);
  @POST("user/changeLocation")
  Future<UserEntity> changeLocation(@Query("uid")String uid,@Query("countryId") int countryId,@Query("cityId") int cityId);
  @GET("user/findChat")
  Future<String> findChat(@Query("uid")String uid, @Query("client")String client);
  @GET("user/companyByManager")
  Future<CompanyEntity> findCompany(@Query("uid")String uid);
  @GET("user/chats")
  Future<List<ChatEntity>> myChats(@Query("uid")String uid);
  @GET("user/companies")
  Future<List<CompanyEntity>> findCompanies(@Query("uid")String uid, @Query("category")Categories category);
  @POST("orders/stop")
  Future<void> stopOrder(@Query("id")int id);
}