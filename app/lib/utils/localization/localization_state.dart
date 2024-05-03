part of 'localization_block.dart';

abstract class LanguageState {
  const LanguageState();

}

class LanguageLoaded extends LanguageState {
  final String locale;

  LanguageLoaded(this.locale);
}