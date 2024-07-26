import 'package:app/api/entity/CityEntity.dart';
import 'package:app/api/entity/enums/Mode.dart';
import 'package:flutter/material.dart';

class CustomTransportationPage extends StatefulWidget {
  final bool sub;
  final CityEntity city;
  final Set<Mode> supportModes;
  final Mode? startMode;
  const CustomTransportationPage(
      {required this.sub,
      required this.city,
      required this.supportModes,
      this.startMode,
      super.key});

  @override
  State<CustomTransportationPage> createState() =>
      _CustomTransportationPageState();
}

class _CustomTransportationPageState extends State<CustomTransportationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
