// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:app/api/RestClient.dart';
import 'package:app/api/entity/CityEntity.dart';
import 'package:app/api/entity/CountryEntity.dart';
import 'package:app/api/entity/UserEntity.dart';
import 'package:app/api/entity/enums/UserRole.dart';
import 'package:app/api/entity/enums/WalletEvent.dart';
import 'package:app/auth/login_page.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/main_route.dart';
import 'package:app/utils/GlobalsColors.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:app/utils/localization/localization_block.dart';
import 'package:currency_converter/currency.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final UserEntity user;
  const ProfilePage({required this.user, super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  String? telegram, new_telegram;
  String? whatsapp, new_whatsapp;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  @override
  Widget build(BuildContext context) {
    Locale selectedLanguage = Localizations.localeOf(context);
    UserEntity user = widget.user;
    GlobalsWidgets.wallet = user.wallet;
    if (user.telegram != null && user.telegram != telegram) {
      telegram = user.telegram ?? GlobalsWidgets.telegram;
    }
    if (user.whatsapp != null && user.whatsapp != whatsapp) {
      whatsapp = user.whatsapp ?? GlobalsWidgets.whatsapp;
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(2.h).copyWith(bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: double.maxFinite,
                    height: 60.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xff317EFA)),
                    child: Padding(
                      padding: EdgeInsets.all(3.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? video = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  debugPrint("Media ${video!.name}");
                                  File file =
                                      File.fromUri(Uri.parse(video.path));
                                  Dio dio = Dio();
                                  RestClient client = RestClient(dio);
                                  client
                                      .changePhoto(GlobalsWidgets.uid, file)
                                      .then((value) {
                                    setState(() {
                                      GlobalsWidgets.image = value;
                                    });
                                  });
                                },
                                child: Ink(
                                  child: ClipOval(
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                          40), // Image radius
                                      child: Image.network(
                                          GlobalsWidgets.getUserPhoto(),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox.fromSize(
                                size: const Size.fromRadius(40),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: const Size.fromRadius(12).height,
                                    width: const Size.fromRadius(12).width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Icon(
                                      Icons.edit,
                                      size: 5.w,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Text(
                            "${user.name} ${user.surname}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          user.role == UserRole.SPECIALIST
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.wallet_outlined,
                                          color: Colors.white,
                                          size: 8.w,
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        Text(
                                            "${GlobalsWidgets.wallet.round()} ₸",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.white))
                                      ],
                                    ),
                                    OutlinedButton(
                                        onPressed: () {
                                          String count = "0";
                                          double value = 0;
                                          double money = 0;
                                          //TODO: Money
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                    builder: (context, state) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      S.of(context).payment,
                                                      style: TextStyle(
                                                          fontSize: 16.sp),
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        OutlinedButton(
                                                            onPressed: () {},
                                                            child: const Text(
                                                              "Russia - Visa / Master Card / МИР",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            )),
                                                        SizedBox(
                                                          height: 1.h,
                                                        ),
                                                        OutlinedButton(
                                                            onPressed:
                                                                () async {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return StatefulBuilder(builder:
                                                                        (context,
                                                                            state) {
                                                                      return AlertDialog(
                                                                        title:
                                                                            Text(
                                                                          S.of(context).enter_money,
                                                                          style:
                                                                              TextStyle(fontSize: 16.sp),
                                                                        ),
                                                                        content:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Text(
                                                                              S.of(context).min_sum,
                                                                              style: TextStyle(fontSize: 14.sp),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 8.h,
                                                                              child: TextFormField(
                                                                                onChanged: (value) {
                                                                                  count = value;
                                                                                  state(() {});
                                                                                },
                                                                                decoration: InputDecoration(
                                                                                  hintText: S.of(context).sum,
                                                                                  suffixText: "₸",
                                                                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                                                                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xffD9D9D9))),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Builder(builder:
                                                                                (context) {
                                                                              try {
                                                                                value = double.parse(count);
                                                                                return FutureBuilder(
                                                                                    future: convertToUsd(double.parse(count)),
                                                                                    builder: (context, snapshot) {
                                                                                      if (snapshot.hasData) {
                                                                                        money = snapshot.data!;
                                                                                        return Text(
                                                                                          "Примерная сумма перевода ${snapshot.data} \$",
                                                                                          style: TextStyle(fontSize: 14.sp),
                                                                                        );
                                                                                      } else {
                                                                                        return Text("Примерная сумма перевода: 0 \$", style: TextStyle(fontSize: 14.sp));
                                                                                      }
                                                                                    });
                                                                              } catch (e) {
                                                                                return Text("Примерная сумма перевода: 0 \$", style: TextStyle(fontSize: 14.sp));
                                                                              }
                                                                            })
                                                                          ],
                                                                        ),
                                                                        actions: [
                                                                          TextButton(
                                                                            style:
                                                                                TextButton.styleFrom(
                                                                              textStyle: Theme.of(context).textTheme.labelLarge,
                                                                            ),
                                                                            child:
                                                                                Text(S.of(context).cancel),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                          TextButton(
                                                                            style:
                                                                                TextButton.styleFrom(
                                                                              textStyle: Theme.of(context).textTheme.labelLarge,
                                                                            ),
                                                                            child:
                                                                                Text(S.of(context).pay),
                                                                            onPressed:
                                                                                () async {
                                                                              print("Value $money");
                                                                              if (context.mounted && money > 1) {
                                                                                money = await convertToUsd(value);
                                                                                Navigator.of(context)
                                                                                    .push(MaterialPageRoute(
                                                                                  builder: (BuildContext context) => PaypalCheckoutView(
                                                                                    sandboxMode: false,
                                                                                    clientId: "AWVLsDNYVWYiwdXs6S1IOb-Rg5HdRNRF09iAphxmzqYNMSvLQy6sqx7aehS96OaYckbqw0AZRWBxN3Bs",
                                                                                    secretKey: "EGdk3TP0sBF31nk4jf0LqE0xcSgBmx_BL3GPUegDqByierwx5rlCS0kiWG2X9-aCiy3T-VwaQH8K_-Sw",
                                                                                    transactions: [
                                                                                      {
                                                                                        "amount": {
                                                                                          "total": '$money',
                                                                                          "currency": "USD",
                                                                                          "details": {
                                                                                            "subtotal": '$money',
                                                                                            "shipping": '0',
                                                                                            "shipping_discount": 0
                                                                                          }
                                                                                        },
                                                                                        "description": "The payment transaction description.",
                                                                                      }
                                                                                    ],
                                                                                    note: "Contact us for any questions on your order.",
                                                                                    onSuccess: (Map params) async {
                                                                                      Dio dio = Dio();
                                                                                      RestClient client = RestClient(dio);
                                                                                      client.walletEvent(GlobalsWidgets.uid, WalletEvent.ADD, double.parse(count)).then((value) {
                                                                                        GlobalsWidgets.wallet += double.parse(count);
                                                                                        Navigator.pop(context);
                                                                                      });
                                                                                    },
                                                                                    onError: (error) {
                                                                                      debugPrint("onError: $error");
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    onCancel: () {
                                                                                      debugPrint('cancelled:');
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                  ),
                                                                                ))
                                                                                    .then((value) {
                                                                                  setState(() {});
                                                                                });
                                                                              }
                                                                            },
                                                                          ),
                                                                        ],
                                                                      );
                                                                    });
                                                                  });
                                                            },
                                                            child: const Text(
                                                              "All World - Visa / Master Card / American Express",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            )),
                                                        Platform.isAndroid
                                                            ? OutlinedButton(
                                                                onPressed:
                                                                    () async {
                                                                  List<String>
                                                                      _kProductIds =
                                                                      [
                                                                    "pay_100",
                                                                    "pay_300",
                                                                    "pay_500"
                                                                  ];
                                                                  final ProductDetailsResponse
                                                                      productDetailResponse =
                                                                      await _inAppPurchase
                                                                          .queryProductDetails(
                                                                              _kProductIds.toSet());
                                                                  debugPrint(
                                                                      "Not found size ${productDetailResponse.notFoundIDs.toString()}");
                                                                  debugPrint(
                                                                      "Found size ${productDetailResponse.productDetails.length}");
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return StatefulBuilder(builder:
                                                                            (context,
                                                                                state) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text(
                                                                              "Выберите сумму",
                                                                              style: TextStyle(fontSize: 16.sp),
                                                                            ),
                                                                            content:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Text("*Цены указаны с комиссией"),
                                                                                ListView.separated(
                                                                                  shrinkWrap: true,
                                                                                  itemCount: productDetailResponse.productDetails.length,
                                                                                  itemBuilder: (context, index) {
                                                                                    return OutlinedButton(
                                                                                        onPressed: () {
                                                                                          _inAppPurchase.buyConsumable(purchaseParam: PurchaseParam(productDetails: productDetailResponse.productDetails[index]));
                                                                                        },
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Text(productDetailResponse.productDetails[index].title.split("\\(")[0], textAlign: TextAlign.center, style: TextStyle(color: Colors.black)),
                                                                                            Text(
                                                                                              productDetailResponse.productDetails[index].price,
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(color: Colors.black),
                                                                                            )
                                                                                          ],
                                                                                        ));
                                                                                  },
                                                                                  separatorBuilder: (context, index) {
                                                                                    return SizedBox(
                                                                                      height: 1.h,
                                                                                    );
                                                                                  },
                                                                                )
                                                                              ],
                                                                            ),
                                                                            actions: [
                                                                              TextButton(
                                                                                style: TextButton.styleFrom(
                                                                                  textStyle: Theme.of(context).textTheme.labelLarge,
                                                                                ),
                                                                                child: Text(S.of(context).cancel),
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                              ),
                                                                              TextButton(
                                                                                style: TextButton.styleFrom(
                                                                                  textStyle: Theme.of(context).textTheme.labelLarge,
                                                                                ),
                                                                                child: Text(S.of(context).pay),
                                                                                onPressed: () async {},
                                                                              ),
                                                                            ],
                                                                          );
                                                                        });
                                                                      });
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Google pay",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ))
                                                            : Platform.isIOS
                                                                ? OutlinedButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child:
                                                                        const Text(
                                                                      "Apple pay",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    ))
                                                                : const SizedBox
                                                                    .shrink()
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelLarge,
                                                        ),
                                                        child: Text(S
                                                            .of(context)
                                                            .cancel),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                              });
                                        },
                                        style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Colors.white)),
                                        child: Text(
                                          S.of(context).add_money,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ))
                                  ],
                                )
                              : const SizedBox.shrink(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_history,
                                    color: Colors.white,
                                    size: 10.w,
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Text("${user.city}",
                                      style: TextStyle(
                                          fontSize: 18.sp, color: Colors.white))
                                ],
                              ),
                              OutlinedButton(
                                  onPressed: () async {
                                    Dio dio = Dio();
                                    RestClient client = RestClient(dio);
                                    List<CountryEntity> list =
                                        await client.getCountries();
                                    CountryEntity userCountry = await client
                                        .findCountryByCity(user.city.id);

                                    CountryEntity initialCountry = list.first;
                                    CityEntity initialCity =
                                        initialCountry.cities.first;
                                    for (int i = 0; i < list.length; i++) {
                                      if (list[i]
                                          .name
                                          .contains(userCountry.name)) {
                                        initialCountry = list[i];
                                        break;
                                      }
                                    }
                                    for (int i = 0;
                                        i < initialCountry.cities.length;
                                        i++) {
                                      if (initialCountry.cities[i].name
                                          .contains(user.city.name)) {
                                        initialCity = initialCountry.cities[i];
                                        break;
                                      }
                                    }
                                    if (context.mounted) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(
                                                builder: (context, state) {
                                              return AlertDialog(
                                                title: Text(
                                                  S.of(context).edit_location,
                                                  style: TextStyle(
                                                      fontSize: 16.sp),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    CustomDropdown<
                                                        CountryEntity>(
                                                      items: list,
                                                      initialItem:
                                                          initialCountry,
                                                      hintText: S
                                                          .of(context)
                                                          .select_country,
                                                      decoration:
                                                          CustomDropdownDecoration(
                                                        closedBorder: Border.all(
                                                            color: const Color(
                                                                0xffD9D9D9)),
                                                        closedFillColor:
                                                            Colors.transparent,
                                                        expandedBorder: Border.all(
                                                            color: const Color(
                                                                0xffD9D9D9)),
                                                        expandedFillColor:
                                                            Colors.white,
                                                      ),
                                                      onChanged: (country) {
                                                        initialCountry =
                                                            country;
                                                        initialCity = country
                                                            .cities.first;
                                                        state(() {});
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),
                                                    CustomDropdown<CityEntity>(
                                                      items:
                                                          initialCountry.cities,
                                                      initialItem: initialCity,
                                                      hintText: S
                                                          .of(context)
                                                          .select_city,
                                                      decoration:
                                                          CustomDropdownDecoration(
                                                        closedBorder: Border.all(
                                                            color: const Color(
                                                                0xffD9D9D9)),
                                                        closedFillColor:
                                                            Colors.transparent,
                                                        expandedBorder: Border.all(
                                                            color: const Color(
                                                                0xffD9D9D9)),
                                                        expandedFillColor:
                                                            Colors.white,
                                                      ),
                                                      onChanged: (city) {
                                                        initialCity = city;
                                                      },
                                                    )
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelLarge,
                                                    ),
                                                    child: Text(
                                                        S.of(context).cancel),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelLarge,
                                                    ),
                                                    child:
                                                        Text(S.of(context).ok),
                                                    onPressed: () {
                                                      Dio dio = Dio();
                                                      RestClient client =
                                                          RestClient(dio);
                                                      client
                                                          .changeLocation(
                                                              GlobalsWidgets
                                                                  .uid,
                                                              initialCountry.id,
                                                              initialCity.id)
                                                          .then((value) {
                                                        Navigator.pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    MainRoute(
                                                                        userEntity:
                                                                            value)),
                                                            (route) => false);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                          });
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.white)),
                                  child: Text(
                                    S.of(context).edit,
                                    style: const TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Telegram",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 6.h,
                                child: TextFormField(
                                  onChanged: (value) {
                                    new_telegram = value;
                                  },
                                  key: const Key("P"),
                                  style: const TextStyle(color: Colors.white),
                                  initialValue: telegram,
                                  decoration: InputDecoration(
                                    hintText: S.of(context).user_name,
                                    prefixText: "@",
                                    prefixStyle:
                                        const TextStyle(color: Colors.white),
                                    hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.5)),
                                    contentPadding:
                                        EdgeInsets.zero.copyWith(left: 5.w),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color: Color(0xffD9D9D9))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color: Color(0xffD9D9D9))),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "WhatsApp",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 6.h,
                                child: TextFormField(
                                  key: const Key("w"),
                                  onChanged: (value) {
                                    new_whatsapp = value;
                                  },
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.,]+')),
                                  ],
                                  style: const TextStyle(color: Colors.white),
                                  initialValue: whatsapp,
                                  decoration: InputDecoration(
                                    hintText: "7(XXX)XXX-XX-XX",
                                    prefixText: "+",
                                    prefixStyle:
                                        const TextStyle(color: Colors.white),
                                    hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.5)),
                                    contentPadding:
                                        EdgeInsets.zero.copyWith(left: 5.w),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color: Color(0xffD9D9D9))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color: Color(0xffD9D9D9))),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            height: 5.h,
                            child: OutlinedButton(
                                onPressed: () {
                                  if (new_whatsapp != null &&
                                      new_whatsapp![0] == "8") {
                                    new_whatsapp =
                                        new_whatsapp!.replaceFirst("8", "7");
                                  }
                                  GlobalsWidgets.telegram = new_telegram;
                                  GlobalsWidgets.whatsapp = new_whatsapp;
                                  Dio dio = Dio();
                                  RestClient client = RestClient(dio);
                                  client
                                      .saveUser(GlobalsWidgets.uid,
                                          new_telegram, new_whatsapp)
                                      .then((value) => debugPrint(
                                          "User saved $telegram $whatsapp"));
                                },
                                style: OutlinedButton.styleFrom(
                                    side:
                                        const BorderSide(color: Colors.white)),
                                child: Text(
                                  S.of(context).save_,
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            SharedPreferences spref =
                                await SharedPreferences.getInstance();
                            spref.setString("lng", "kk");
                            final loginBloc =
                                BlocProvider.of<LanguageBloc>(context);
                            loginBloc.add(
                              ToggleLanguageEvent('kk'), // 0 - en, 1 - es
                            );
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  color: selectedLanguage.languageCode == "kk"
                                      ? Color(0xffffdb54)
                                      : Colors.transparent),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 8),
                                child: Center(
                                  child: Text(
                                    "Қаз",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: () async {
                            SharedPreferences spref =
                                await SharedPreferences.getInstance();
                            spref.setString("lng", "ru");
                            final loginBloc =
                                BlocProvider.of<LanguageBloc>(context);
                            loginBloc.add(
                              ToggleLanguageEvent('ru'), // 0 - en, 1 - es
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                color: selectedLanguage.languageCode == "ru"
                                    ? Color(0xffffdb54)
                                    : Colors.transparent),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              child: Center(
                                child: Text(
                                  "Рус",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, state) {
                          return AlertDialog(
                            title: Text(
                              S.of(context).help,
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    launchUrl(
                                        Uri.parse("https://Wa.me/77075926691"),
                                        mode: LaunchMode.externalApplication);
                                  },
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: GlobalsColor.blue,
                                      side: BorderSide.none),
                                  child: Text(
                                    S.of(context).help,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    launchUrl(
                                        Uri.parse(
                                            "https://forms.gle/JccFuuxj713Gn6Ew6"),
                                        mode: LaunchMode.externalApplication);
                                  },
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      side: BorderSide.none),
                                  child: Text(
                                    S.of(context).help_1,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: Text(S.of(context).cancel),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                      });
                },
                borderRadius: BorderRadius.circular(15),
                child: Ink(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.help),
                      SizedBox(
                        width: 5.w,
                      ),
                      Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            S.of(context).help,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          )),
                      SizedBox(
                        width: 5.w,
                      ),
                      const Icon(Icons.keyboard_arrow_right_sharp)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              InkWell(
                onTap: () async {
                  launchUrl(
                      Uri.parse(
                          "https://docs.google.com/document/d/11C0jApi9Dw2M4Kr3FqhPpLXAkHHkZSgMTd7UYaaw6o4/edit?usp=sharing"),
                      mode: LaunchMode.externalApplication);
                },
                borderRadius: BorderRadius.circular(15),
                child: Ink(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.warning_outlined),
                      SizedBox(
                        width: 5.w,
                      ),
                      Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            S.of(context).profile_1,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          )),
                      SizedBox(
                        width: 5.w,
                      ),
                      const Icon(Icons.keyboard_arrow_right_sharp)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              InkWell(
                onTap: () async {
                  launchUrl(
                      Uri.parse(
                          "https://docs.google.com/document/d/1HqoV4QF3rvikvG4Rgm_gSF_6kQEjIT84e0NmC102_o0/edit?usp=sharing"),
                      mode: LaunchMode.externalApplication);
                },
                borderRadius: BorderRadius.circular(15),
                child: Ink(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.warning_outlined),
                      SizedBox(
                        width: 5.w,
                      ),
                      Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            S.of(context).profile_2,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          )),
                      SizedBox(
                        width: 5.w,
                      ),
                      const Icon(Icons.keyboard_arrow_right_sharp)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              InkWell(
                onTap: () async {
                  GlobalsWidgets.uid = "";
                  FirebaseAuth.instance.signOut();
                  (await SharedPreferences.getInstance()).remove("phone");
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false);
                  }
                },
                borderRadius: BorderRadius.circular(15),
                child: Ink(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 5.w,
                      ),
                      Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            S.of(context).exit,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.sp),
                          )),
                      SizedBox(
                        width: 5.w,
                      ),
                      const Icon(Icons.keyboard_arrow_right_sharp)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<double> convertToUsd(double kzt) async {
    DateTime date = DateTime.now();
    String from = Currency.kzt;
    String to = Currency.usd;
    String url =
        "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@${DateFormat("yyyy-MM-dd").format(date)}/v1/currencies/${from}.json";
    var response = await get(Uri.parse(url));
    var finding;
    try {
      finding = jsonDecode(response.body)[from][to];
    } catch (e) {
      url =
          "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@${DateFormat("yyyy-MM-dd").format(date.add(const Duration(days: -1)))}/v1/currencies/${from}.json";
      response = await get(Uri.parse(url));
      finding = jsonDecode(response.body)[from][to];
    }
    double unitValue = double.parse(finding.toString());
    double value = kzt * unitValue;

    value = (value * 100).round() / 100;
    return double.parse(value.toStringAsFixed(2));
  }
}
