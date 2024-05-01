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
import 'package:currency_converter/currency.dart';
import 'package:http/http.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:image_picker/image_picker.dart';
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
  @override
  Widget build(BuildContext context) {
    UserEntity user = widget.user;
    GlobalsWidgets.wallet = user.wallet;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 40.h,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: const Color(0xff317EFA)),
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
                            final XFile? video = await picker.pickImage(source: ImageSource.gallery);
                            debugPrint("Media ${video!.name}");
                            File file = File.fromUri(Uri.parse(video.path));
                            Dio dio = Dio();
                            RestClient client = RestClient(dio);
                            client.changePhoto(GlobalsWidgets.uid, file).then((value) {
                              setState(() {
                                GlobalsWidgets.image = value;
                              });
                            });
                          },
                          child: Ink(
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(40), // Image radius
                                child: Image.network(GlobalsWidgets.getUserPhoto(), fit: BoxFit.cover),
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
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
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
                      style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    user.role == UserRole.SPECIALIST
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  Text("${GlobalsWidgets.wallet.round()} ₸", style: TextStyle(fontSize: 16.sp, color: Colors.white))
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
                                          return StatefulBuilder(builder: (context, state) {
                                            return AlertDialog(
                                              title: Text(
                                                S.of(context).payment,
                                                style: TextStyle(fontSize: 16.sp),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  OutlinedButton(
                                                      onPressed: () {},
                                                      child: const Text(
                                                        "Russia - Visa / Master Card / МИР",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Colors.black),
                                                      )),
                                                  SizedBox(
                                                    height: 1.h,
                                                  ),
                                                  OutlinedButton(
                                                      onPressed: () async {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return StatefulBuilder(builder: (context, state) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                    S.of(context).enter_money,
                                                                    style: TextStyle(fontSize: 16.sp),
                                                                  ),
                                                                  content: Column(
                                                                    mainAxisSize: MainAxisSize.min,
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
                                                                      Builder(builder: (context) {
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
                                                                      onPressed: () async {
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
                                                                                    "details": {"subtotal": '$money', "shipping": '0', "shipping_discount": 0}
                                                                                  },
                                                                                  "description": "The payment transaction description.",
                                                                                  // "payment_options": {
                                                                                  //   "allowed_payment_method":
                                                                                  //       "INSTANT_FUNDING_SOURCE"
                                                                                  // },
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
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Colors.black),
                                                      )),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    textStyle: Theme.of(context).textTheme.labelLarge,
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
                                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
                                  child: Text(
                                    S.of(context).add_money,
                                    style: const TextStyle(color: Colors.white),
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
                            Text("${user.city}", style: TextStyle(fontSize: 18.sp, color: Colors.white))
                          ],
                        ),
                        OutlinedButton(
                            onPressed: () async {
                              Dio dio = Dio();
                              RestClient client = RestClient(dio);
                              List<CountryEntity> list = await client.getCountries();
                              CountryEntity userCountry = await client.findCountryByCity(user.city.id);

                              CountryEntity initialCountry = list.first;
                              CityEntity initialCity = initialCountry.cities.first;
                              for (int i = 0; i < list.length; i++) {
                                if (list[i].name.contains(userCountry.name)) {
                                  initialCountry = list[i];
                                  break;
                                }
                              }
                              for (int i = 0; i < initialCountry.cities.length; i++) {
                                if (initialCountry.cities[i].name.contains(user.city.name)) {
                                  initialCity = initialCountry.cities[i];
                                  break;
                                }
                              }
                              if (context.mounted) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder: (context, state) {
                                        return AlertDialog(
                                          title: Text(
                                            S.of(context).edit_location,
                                            style: TextStyle(fontSize: 16.sp),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomDropdown<CountryEntity>(
                                                items: list,
                                                initialItem: initialCountry,
                                                hintText: S.of(context).select_country,
                                                decoration: CustomDropdownDecoration(
                                                  closedBorder: Border.all(color: const Color(0xffD9D9D9)),
                                                  closedFillColor: Colors.transparent,
                                                  expandedBorder: Border.all(color: const Color(0xffD9D9D9)),
                                                  expandedFillColor: Colors.white,
                                                ),
                                                onChanged: (country) {
                                                  initialCountry = country;
                                                  initialCity = country.cities.first;
                                                  state(() {});
                                                },
                                              ),
                                              SizedBox(
                                                height: 1.h,
                                              ),
                                              CustomDropdown<CityEntity>(
                                                items: initialCountry.cities,
                                                initialItem: initialCity,
                                                hintText: S.of(context).select_city,
                                                decoration: CustomDropdownDecoration(
                                                  closedBorder: Border.all(color: const Color(0xffD9D9D9)),
                                                  closedFillColor: Colors.transparent,
                                                  expandedBorder: Border.all(color: const Color(0xffD9D9D9)),
                                                  expandedFillColor: Colors.white,
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
                                                textStyle: Theme.of(context).textTheme.labelLarge,
                                              ),
                                              child: Text(S.of(context).cancel),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                textStyle: Theme.of(context).textTheme.labelLarge,
                                              ),
                                              child: Text(S.of(context).ok),
                                              onPressed: () {
                                                Dio dio = Dio();
                                                RestClient client = RestClient(dio);
                                                client.changeLocation(GlobalsWidgets.uid, initialCountry.id, initialCity.id).then((value) {
                                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainRoute(userEntity: value)), (route) => false);
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                    });
                              }
                            },
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
                            child: Text(
                              S.of(context).edit,
                              style: const TextStyle(color: Colors.white),
                            ))
                      ],
                    )
                  ],
                ),
              ),
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
                                  launchUrl(Uri.parse("https://Wa.me/77075926691"), mode: LaunchMode.externalApplication);
                                },
                                style: OutlinedButton.styleFrom(backgroundColor: GlobalsColor.blue, side: BorderSide.none),
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
                                  launchUrl(Uri.parse("https://forms.gle/JccFuuxj713Gn6Ew6"), mode: LaunchMode.externalApplication);
                                },
                                style: OutlinedButton.styleFrom(backgroundColor: Colors.red, side: BorderSide.none),
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
                                textStyle: Theme.of(context).textTheme.labelLarge,
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
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
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
              height: 2.h,
            ),
            InkWell(
              onTap: () async {
                GlobalsWidgets.uid = "";
                FirebaseAuth.instance.signOut();
                (await SharedPreferences.getInstance()).remove("phone");
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
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
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
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
    );
  }

  Future<double> convertToUsd(double kzt) async {
    DateTime date = DateTime.now();
    Currency from = Currency.kzt;
    Currency to = Currency.usd;
    String url = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@${DateFormat("yyyy-MM-dd").format(date)}/v1/currencies/${from.name}.json";
    var response = await get(Uri.parse(url));
    var finding;
    try {
      finding = jsonDecode(response.body)[from.name][to.name];
    } catch (e) {
      url = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@${DateFormat("yyyy-MM-dd").format(date.add(const Duration(days: -1)))}/v1/currencies/${from.name}.json";
      response = await get(Uri.parse(url));
      finding = jsonDecode(response.body)[from.name][to.name];
    }
    double unitValue = double.parse(finding.toString());
    double value = kzt * unitValue;

    value = (value * 100).round() / 100;
    return double.parse(value.toStringAsFixed(2));
  }
}
