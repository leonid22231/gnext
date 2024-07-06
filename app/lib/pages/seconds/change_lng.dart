import 'package:app/generated/l10n.dart';
import 'package:app/utils/GlobalsWidgets.dart';
import 'package:app/utils/localization/localization_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  @override
  Widget build(BuildContext context) {
    List<Locale> locales = context
        .findAncestorWidgetOfExactType<MaterialApp>()!
        .supportedLocales
        .toList();
    Locale selectedLanguage = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).change_lng,
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: ListView.separated(
          itemCount: locales.length,
          itemBuilder: (context, index) {
            String lngName =
                (LocaleNames.of(context)!.nameOf(locales[index].languageCode) ??
                    "null");
            lngName =
                "${lngName[0].toUpperCase()}${lngName.substring(1).toLowerCase()}";
            return InkWell(
              onTap: () async {
                SharedPreferences spref = await SharedPreferences.getInstance();
                spref.setString("lng", locales[index].languageCode);
                final loginBloc = BlocProvider.of<LanguageBloc>(context);
                loginBloc.add(
                  ToggleLanguageEvent(
                      locales[index].languageCode), // 0 - en, 1 - es
                );
              },
              child: Ink(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: selectedLanguage == locales[index]
                        ? Color(0xffffdb54)
                        : Color(0xff787878)),
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Center(
                  child: Text(
                    lngName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 2.h,
            );
          },
        ),
      ),
    );
  }
}
