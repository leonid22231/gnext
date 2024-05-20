import 'dart:io';

import 'package:admin_app/api/entity/ChatEntity.dart';
import 'package:admin_app/api/entity/CompanyEntity.dart';
import 'package:admin_app/api/entity/CountryEntity.dart';
import 'package:admin_app/api/entity/FilterEntity.dart';
import 'package:admin_app/api/entity/MessageEntity.dart';
import 'package:admin_app/api/entity/OrderEntity.dart';
import 'package:admin_app/api/entity/PropertiesEntity.dart';
import 'package:admin_app/api/entity/StorisEntity.dart';
import 'package:admin_app/api/entity/UserEntity.dart';
import 'package:admin_app/api/entity/WalletEventH.dart';
import 'package:admin_app/api/entity/enums/Categories.dart';
import 'package:admin_app/api/entity/enums/MessageType.dart';
import 'package:admin_app/api/entity/enums/StoryType.dart';
import 'package:admin_app/api/entity/enums/UserRole.dart';
import 'package:admin_app/api/entity/enums/WalletEvent.dart';
import 'package:admin_app/utils/StatisticModel.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'RestClient.g.dart';

//192.168.0.11
//45.67.35.206
@RestApi(baseUrl: 'http://45.159.250.175:8080/api/v1/')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("user/login")
  Future<UserEntity> login(
      @Query("phone") String phone, @Query("password") String password);
  @POST("user/register")
  Future<UserEntity> register(
      @Query("phone") String phone,
      @Query("password") String password,
      @Query("name") String name,
      @Query("surname") String surname,
      @Query("number") String? number,
      @Query("role") UserRole role,
      @Query("countryId") int countryId,
      @Query("cityId") int cityId,
      @Query("uid") String uid,
      @Query("notifyToken") String notifyToken);
  @GET("user/uid")
  Future<UserEntity> getUserByUid(@Query("uid") String uid);
  @POST("user/uid")
  Future<UserEntity> setUserUid(
      @Query("phone") String phone, @Query("uid") String uid);
  @GET("chat/{id}")
  Future<List<MessageEntity>> getMessages(@Path("id") String id);
  @MultiPart()
  @POST("admin/file")
  Future<void> fileMessage(
      @Query("uid") String uid,
      @Query("countryId") int countryId,
      @Query("cityId") int cityId,
      @Query("name") String name,
      @Query("type") MessageType type,
      @Part(name: "file") File file);
  @GET("chat/findId")
  Future<String> getChatId(
      @Query("uid") String uid, @Query("name") String name);
  @POST("storis/add")
  @MultiPart()
  Future<void> addStory(@Query("chat") String id, @Query("uid") String uid,
      @Query("type") StoryType type, @Part(name: "file") File file);
  @GET("storis/chat")
  Future<List<StorisEntity>> getStoris(
      @Query("uid") String uid, @Query("chat") String chat);
  @GET("location/AdminCountries")
  Future<List<CountryEntity>> getCountries();
  @POST("orders/create")
  Future<void> createOrder(
      @Query("uid") String uid,
      @Query("startDate") DateTime startDate,
      @Query("endDate") DateTime endDate,
      @Query("price") double price,
      @Query("customPrice") bool customPrice,
      @Query("outcity") bool outcity,
      @Body() PropertiesModel properties);
  @GET("orders/my")
  Future<List<OrderEntity>> myOrders(
      @Query("uid") String uid, @Query("outcity") bool outcity);
  @GET("orders/active")
  Future<List<OrderEntity>> activeOrders(
      @Query("uid") String uid, @Query("outcity") bool outcity);
  @POST("user/changeLocation")
  Future<UserEntity> changeLocation(@Query("uid") String uid,
      @Query("countryId") int countryId, @Query("cityId") int cityId);
  @GET("user/findChat")
  Future<String> findChat(
      @Query("uid") String uid, @Query("client") String client);
  @GET("user/chats")
  Future<List<ChatEntity>> myChats(@Query("uid") String uid);
  @GET("admin/login")
  Future<String> adminLogin(
      @Query("phone") String phone, @Query("password") String password);
  @POST("admin/login")
  Future<UserEntity> loginConfirm(
      @Query("phone") String phone, @Query("uid") String uid);
  @GET("admin/stat")
  Future<StatisticModel> getStat();
  @GET("admin/users")
  Future<List<UserEntity>> findUsers(@Query("query") String? query);
  @GET("admin/chats")
  Future<List<ChatEntity>> findChats(
      @Query("countryId") int countryId, @Query("cityId") int cityId);
  @GET("admin/chats/messages")
  Future<List<MessageEntity>> getMessagesByLocation(
    @Query("countryId") int countryId,
    @Query("cityId") int cityId,
    @Query("name") String name,
  );
  @GET("admin/filters")
  Future<List<FilterEntity>> findFilters();
  @GET("user/walletHistory")
  Future<List<WalletEventH>> findWalletHistory(@Query("uid") String uid);
  @POST("user/walletEvent")
  Future<void> walletEvent(@Query("uid") String uid,
      @Query("type") WalletEvent type, @Query("sum") double sum);
  @POST("admin/filters/add")
  Future<void> addFilter(@Query("word") String word);
  @DELETE("admin/filters/delete")
  Future<void> deleteFilter(@Query("id") int id);
  @POST("admin/changeRole")
  Future<void> changeRole(
      @Query("uid") String uid, @Query("role") UserRole role);
  @GET("admin/companies")
  Future<List<CompanyEntity>> findCompanies(@Query("countryId") int countryId,
      @Query("cityId") int cityId, @Query("category") Categories category);
  @POST("admin/setManager")
  Future<void> setManager(@Query("uid") String uid, @Query("id") int id);
  @POST("admin/companies/add")
  @MultiPart()
  Future<void> addCompany(
      @Query("countryId") int countryId,
      @Query("cityId") int cityId,
      @Query("category") Categories category,
      @Query("name") String name,
      @Query("phone") String phone,
      @Query("street") String street,
      @Query("house") String house,
      @Part(name: "photo") File? file);
  @DELETE("admin/companies/delete")
  Future<void> deleteCompany(@Query("id") int id);
  @POST("location/country/create")
  Future<String> createCountry(@Query("name") String name);
  @POST("location/city/create")
  Future<String> createCity(
      @Query("countryId") int id, @Query("name") String name);
}
