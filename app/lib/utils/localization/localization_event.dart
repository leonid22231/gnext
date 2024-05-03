part of 'localization_block.dart';

abstract class LanguageEvent {
  const LanguageEvent();
}

class ToggleLanguageEvent extends LanguageEvent {
  final String language;

  ToggleLanguageEvent(this.language);
}
