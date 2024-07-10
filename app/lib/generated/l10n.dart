// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Грузоперевозки`
  String get page1 {
    return Intl.message(
      'Грузоперевозки',
      name: 'page1',
      desc: '',
      args: [],
    );
  }

  /// `Поиск груза`
  String get page2 {
    return Intl.message(
      'Поиск груза',
      name: 'page2',
      desc: '',
      args: [],
    );
  }

  /// `Найти эвакуатор`
  String get page3 {
    return Intl.message(
      'Найти эвакуатор',
      name: 'page3',
      desc: '',
      args: [],
    );
  }

  /// `Манипулятор`
  String get page4 {
    return Intl.message(
      'Манипулятор',
      name: 'page4',
      desc: '',
      args: [],
    );
  }

  /// `Самосвал`
  String get page5 {
    return Intl.message(
      'Самосвал',
      name: 'page5',
      desc: '',
      args: [],
    );
  }

  /// `Автовоз`
  String get page6 {
    return Intl.message(
      'Автовоз',
      name: 'page6',
      desc: '',
      args: [],
    );
  }

  /// `Эксковатор`
  String get page7 {
    return Intl.message(
      'Эксковатор',
      name: 'page7',
      desc: '',
      args: [],
    );
  }

  /// `Погрузчик`
  String get page8 {
    return Intl.message(
      'Погрузчик',
      name: 'page8',
      desc: '',
      args: [],
    );
  }

  /// `Авторынок`
  String get page9 {
    return Intl.message(
      'Авторынок',
      name: 'page9',
      desc: '',
      args: [],
    );
  }

  /// `Грузчики`
  String get page10 {
    return Intl.message(
      'Грузчики',
      name: 'page10',
      desc: '',
      args: [],
    );
  }

  /// `Автосалон`
  String get page11 {
    return Intl.message(
      'Автосалон',
      name: 'page11',
      desc: '',
      args: [],
    );
  }

  /// `Такси межгород`
  String get page12 {
    return Intl.message(
      'Такси межгород',
      name: 'page12',
      desc: '',
      args: [],
    );
  }

  /// `Межгород`
  String get option1 {
    return Intl.message(
      'Межгород',
      name: 'option1',
      desc: '',
      args: [],
    );
  }

  /// `По городу`
  String get option2 {
    return Intl.message(
      'По городу',
      name: 'option2',
      desc: '',
      args: [],
    );
  }

  /// `Перейти в чат`
  String get go_to_chat {
    return Intl.message(
      'Перейти в чат',
      name: 'go_to_chat',
      desc: '',
      args: [],
    );
  }

  /// `Например, фото груза. Форматы: GIF, JPEG, PNG, TXT, PDF, DOC и тд.`
  String get files {
    return Intl.message(
      'Например, фото груза. Форматы: GIF, JPEG, PNG, TXT, PDF, DOC и тд.',
      name: 'files',
      desc: '',
      args: [],
    );
  }

  /// `Фото. Форматы JPEG, PNG и тд.`
  String get files_photo {
    return Intl.message(
      'Фото. Форматы JPEG, PNG и тд.',
      name: 'files_photo',
      desc: '',
      args: [],
    );
  }

  /// `Заполните все пустые поля`
  String get warning_1 {
    return Intl.message(
      'Заполните все пустые поля',
      name: 'warning_1',
      desc: '',
      args: [],
    );
  }

  /// `Выберите фотографию!`
  String get warning_3 {
    return Intl.message(
      'Выберите фотографию!',
      name: 'warning_3',
      desc: '',
      args: [],
    );
  }

  /// `Зарегистрироваться`
  String get reg {
    return Intl.message(
      'Зарегистрироваться',
      name: 'reg',
      desc: '',
      args: [],
    );
  }

  /// `Регистрация`
  String get register {
    return Intl.message(
      'Регистрация',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Имя`
  String get name {
    return Intl.message(
      'Имя',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Введите имя`
  String get name_ {
    return Intl.message(
      'Введите имя',
      name: 'name_',
      desc: '',
      args: [],
    );
  }

  /// `Фамилия`
  String get surname {
    return Intl.message(
      'Фамилия',
      name: 'surname',
      desc: '',
      args: [],
    );
  }

  /// `Введите фамилию`
  String get surname_ {
    return Intl.message(
      'Введите фамилию',
      name: 'surname_',
      desc: '',
      args: [],
    );
  }

  /// `Госномер`
  String get gos_number {
    return Intl.message(
      'Госномер',
      name: 'gos_number',
      desc: '',
      args: [],
    );
  }

  /// `Введите госномер`
  String get gos_number_ {
    return Intl.message(
      'Введите госномер',
      name: 'gos_number_',
      desc: '',
      args: [],
    );
  }

  /// `Фото профиля`
  String get photo_profile {
    return Intl.message(
      'Фото профиля',
      name: 'photo_profile',
      desc: '',
      args: [],
    );
  }

  /// `Добавьте фото профиля`
  String get photo_profile_ {
    return Intl.message(
      'Добавьте фото профиля',
      name: 'photo_profile_',
      desc: '',
      args: [],
    );
  }

  /// `Фото газели спереди`
  String get photo_gos {
    return Intl.message(
      'Фото газели спереди',
      name: 'photo_gos',
      desc: '',
      args: [],
    );
  }

  /// `Добавьте фото Газели спереди`
  String get photo_gos_ {
    return Intl.message(
      'Добавьте фото Газели спереди',
      name: 'photo_gos_',
      desc: '',
      args: [],
    );
  }

  /// `Сохранить груз`
  String get save {
    return Intl.message(
      'Сохранить груз',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Принимаю политику конфиденциальности`
  String get accept {
    return Intl.message(
      'Принимаю политику конфиденциальности',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Маршрут`
  String get create_1 {
    return Intl.message(
      'Маршрут',
      name: 'create_1',
      desc: '',
      args: [],
    );
  }

  /// `Откуда`
  String get create_2 {
    return Intl.message(
      'Откуда',
      name: 'create_2',
      desc: '',
      args: [],
    );
  }

  /// `Куда`
  String get create_3 {
    return Intl.message(
      'Куда',
      name: 'create_3',
      desc: '',
      args: [],
    );
  }

  /// `Когда`
  String get create_4 {
    return Intl.message(
      'Когда',
      name: 'create_4',
      desc: '',
      args: [],
    );
  }

  /// `Выберите дату`
  String get date_pick {
    return Intl.message(
      'Выберите дату',
      name: 'date_pick',
      desc: '',
      args: [],
    );
  }

  /// `Дата загрузки`
  String get date {
    return Intl.message(
      'Дата загрузки',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Дата разгрузки`
  String get date_ {
    return Intl.message(
      'Дата разгрузки',
      name: 'date_',
      desc: '',
      args: [],
    );
  }

  /// `Оплата`
  String get pay {
    return Intl.message(
      'Оплата',
      name: 'pay',
      desc: '',
      args: [],
    );
  }

  /// `Сумма`
  String get sum {
    return Intl.message(
      'Сумма',
      name: 'sum',
      desc: '',
      args: [],
    );
  }

  /// `Минимальная сумма оплаты 1$`
  String get min_sum {
    return Intl.message(
      'Минимальная сумма оплаты 1\$',
      name: 'min_sum',
      desc: '',
      args: [],
    );
  }

  /// `Договорная`
  String get dog {
    return Intl.message(
      'Договорная',
      name: 'dog',
      desc: '',
      args: [],
    );
  }

  /// `Документы`
  String get doc {
    return Intl.message(
      'Документы',
      name: 'doc',
      desc: '',
      args: [],
    );
  }

  /// `Описание`
  String get desc {
    return Intl.message(
      'Описание',
      name: 'desc',
      desc: '',
      args: [],
    );
  }

  /// `Написать`
  String get typing {
    return Intl.message(
      'Написать',
      name: 'typing',
      desc: '',
      args: [],
    );
  }

  /// `Скачать файл`
  String get download_file {
    return Intl.message(
      'Скачать файл',
      name: 'download_file',
      desc: '',
      args: [],
    );
  }

  /// `Завершить`
  String get end {
    return Intl.message(
      'Завершить',
      name: 'end',
      desc: '',
      args: [],
    );
  }

  /// `Пользователь`
  String get user {
    return Intl.message(
      'Пользователь',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `Позвонить`
  String get call {
    return Intl.message(
      'Позвонить',
      name: 'call',
      desc: '',
      args: [],
    );
  }

  /// `Пополнить счёт`
  String get add_money {
    return Intl.message(
      'Пополнить счёт',
      name: 'add_money',
      desc: '',
      args: [],
    );
  }

  /// `Выберите страну`
  String get select_country {
    return Intl.message(
      'Выберите страну',
      name: 'select_country',
      desc: '',
      args: [],
    );
  }

  /// `Выберите город`
  String get select_city {
    return Intl.message(
      'Выберите город',
      name: 'select_city',
      desc: '',
      args: [],
    );
  }

  /// `Изменить местоположение`
  String get edit_location {
    return Intl.message(
      'Изменить местоположение',
      name: 'edit_location',
      desc: '',
      args: [],
    );
  }

  /// `Изменить`
  String get edit {
    return Intl.message(
      'Изменить',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Выход`
  String get exit {
    return Intl.message(
      'Выход',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Добавить`
  String get add {
    return Intl.message(
      'Добавить',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Помощь с приложением`
  String get help {
    return Intl.message(
      'Помощь с приложением',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Удаление аккаунта`
  String get help_1 {
    return Intl.message(
      'Удаление аккаунта',
      name: 'help_1',
      desc: '',
      args: [],
    );
  }

  /// `Связаться`
  String get connect {
    return Intl.message(
      'Связаться',
      name: 'connect',
      desc: '',
      args: [],
    );
  }

  /// `Сначала введите номер телефона!`
  String get warning_2 {
    return Intl.message(
      'Сначала введите номер телефона!',
      name: 'warning_2',
      desc: '',
      args: [],
    );
  }

  /// `Введите новый пароль`
  String get enter_new_password {
    return Intl.message(
      'Введите новый пароль',
      name: 'enter_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Введите сумму зачисления`
  String get enter_money {
    return Intl.message(
      'Введите сумму зачисления',
      name: 'enter_money',
      desc: '',
      args: [],
    );
  }

  /// `По городу`
  String get city {
    return Intl.message(
      'По городу',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Межгород`
  String get no_city {
    return Intl.message(
      'Межгород',
      name: 'no_city',
      desc: '',
      args: [],
    );
  }

  /// `Введите код`
  String get enter_code {
    return Intl.message(
      'Введите код',
      name: 'enter_code',
      desc: '',
      args: [],
    );
  }

  /// `Неверный код!`
  String get code_error {
    return Intl.message(
      'Неверный код!',
      name: 'code_error',
      desc: '',
      args: [],
    );
  }

  /// `Вход`
  String get signin {
    return Intl.message(
      'Вход',
      name: 'signin',
      desc: '',
      args: [],
    );
  }

  /// `Номер телефона`
  String get number_phone {
    return Intl.message(
      'Номер телефона',
      name: 'number_phone',
      desc: '',
      args: [],
    );
  }

  /// `Введите номер телефона`
  String get number_phone_ {
    return Intl.message(
      'Введите номер телефона',
      name: 'number_phone_',
      desc: '',
      args: [],
    );
  }

  /// `Пароль`
  String get password {
    return Intl.message(
      'Пароль',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Введите пароль`
  String get password_ {
    return Intl.message(
      'Введите пароль',
      name: 'password_',
      desc: '',
      args: [],
    );
  }

  /// `Забыли пароль?`
  String get forgot_password {
    return Intl.message(
      'Забыли пароль?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка`
  String get error {
    return Intl.message(
      'Ошибка',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Поиск`
  String get search {
    return Intl.message(
      'Поиск',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Поиск груза`
  String get search_ {
    return Intl.message(
      'Поиск груза',
      name: 'search_',
      desc: '',
      args: [],
    );
  }

  /// `Подтвердить`
  String get ok {
    return Intl.message(
      'Подтвердить',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Отмена`
  String get cancel {
    return Intl.message(
      'Отмена',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Не найдено`
  String get not_fount {
    return Intl.message(
      'Не найдено',
      name: 'not_fount',
      desc: '',
      args: [],
    );
  }

  /// `Добавить груз`
  String get add_option {
    return Intl.message(
      'Добавить груз',
      name: 'add_option',
      desc: '',
      args: [],
    );
  }

  /// `Чат`
  String get chat {
    return Intl.message(
      'Чат',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `Пользователь`
  String get user_role_1 {
    return Intl.message(
      'Пользователь',
      name: 'user_role_1',
      desc: '',
      args: [],
    );
  }

  /// `Перевозчик`
  String get user_role_2 {
    return Intl.message(
      'Перевозчик',
      name: 'user_role_2',
      desc: '',
      args: [],
    );
  }

  /// `Выберите способ оплаты`
  String get payment {
    return Intl.message(
      'Выберите способ оплаты',
      name: 'payment',
      desc: '',
      args: [],
    );
  }

  /// `Текст...`
  String get text {
    return Intl.message(
      'Текст...',
      name: 'text',
      desc: '',
      args: [],
    );
  }

  /// `Адрес:`
  String get address {
    return Intl.message(
      'Адрес:',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Добавить фото`
  String get add_photo {
    return Intl.message(
      'Добавить фото',
      name: 'add_photo',
      desc: '',
      args: [],
    );
  }

  /// `Добавить историю`
  String get add_stor {
    return Intl.message(
      'Добавить историю',
      name: 'add_stor',
      desc: '',
      args: [],
    );
  }

  /// `Фото`
  String get photo {
    return Intl.message(
      'Фото',
      name: 'photo',
      desc: '',
      args: [],
    );
  }

  /// `Фото (Камера)`
  String get photo_ {
    return Intl.message(
      'Фото (Камера)',
      name: 'photo_',
      desc: '',
      args: [],
    );
  }

  /// `Видео`
  String get video {
    return Intl.message(
      'Видео',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `Видео (Камера)`
  String get video_ {
    return Intl.message(
      'Видео (Камера)',
      name: 'video_',
      desc: '',
      args: [],
    );
  }

  /// `Загрузка...`
  String get loading {
    return Intl.message(
      'Загрузка...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Добавить груз`
  String get preload_page1 {
    return Intl.message(
      'Добавить груз',
      name: 'preload_page1',
      desc: '',
      args: [],
    );
  }

  /// `Стать перевозчиком`
  String get preload_page2 {
    return Intl.message(
      'Стать перевозчиком',
      name: 'preload_page2',
      desc: '',
      args: [],
    );
  }

  /// `Найти груз`
  String get preload_page3 {
    return Intl.message(
      'Найти груз',
      name: 'preload_page3',
      desc: '',
      args: [],
    );
  }

  /// `Создать объявление`
  String get create_shop {
    return Intl.message(
      'Создать объявление',
      name: 'create_shop',
      desc: '',
      args: [],
    );
  }

  /// `Введите название`
  String get create_shop_name {
    return Intl.message(
      'Введите название',
      name: 'create_shop_name',
      desc: '',
      args: [],
    );
  }

  /// `Название`
  String get create_shop_name_ {
    return Intl.message(
      'Название',
      name: 'create_shop_name_',
      desc: '',
      args: [],
    );
  }

  /// `Введите улицу`
  String get create_shop_street {
    return Intl.message(
      'Введите улицу',
      name: 'create_shop_street',
      desc: '',
      args: [],
    );
  }

  /// `Улица`
  String get create_shop_street_ {
    return Intl.message(
      'Улица',
      name: 'create_shop_street_',
      desc: '',
      args: [],
    );
  }

  /// `Введите номер дома`
  String get create_shop_house {
    return Intl.message(
      'Введите номер дома',
      name: 'create_shop_house',
      desc: '',
      args: [],
    );
  }

  /// `Номер дома`
  String get create_shop_house_ {
    return Intl.message(
      'Номер дома',
      name: 'create_shop_house_',
      desc: '',
      args: [],
    );
  }

  /// `Создать`
  String get create {
    return Intl.message(
      'Создать',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Зарегистрируйтесь или войдите чтобы посмотреть`
  String get register_please {
    return Intl.message(
      'Зарегистрируйтесь или войдите чтобы посмотреть',
      name: 'register_please',
      desc: '',
      args: [],
    );
  }

  /// `Когда`
  String get date_create {
    return Intl.message(
      'Когда',
      name: 'date_create',
      desc: '',
      args: [],
    );
  }

  /// `Сохранить`
  String get save_ {
    return Intl.message(
      'Сохранить',
      name: 'save_',
      desc: '',
      args: [],
    );
  }

  /// `Цена`
  String get price {
    return Intl.message(
      'Цена',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Введите цену`
  String get price_ {
    return Intl.message(
      'Введите цену',
      name: 'price_',
      desc: '',
      args: [],
    );
  }

  /// `имя_пользователя`
  String get user_name {
    return Intl.message(
      'имя_пользователя',
      name: 'user_name',
      desc: '',
      args: [],
    );
  }

  /// `Договор оферты`
  String get profile_1 {
    return Intl.message(
      'Договор оферты',
      name: 'profile_1',
      desc: '',
      args: [],
    );
  }

  /// `Политика конфиденциальности`
  String get profile_2 {
    return Intl.message(
      'Политика конфиденциальности',
      name: 'profile_2',
      desc: '',
      args: [],
    );
  }

  /// `Попутчик`
  String get poput {
    return Intl.message(
      'Попутчик',
      name: 'poput',
      desc: '',
      args: [],
    );
  }

  /// `Мои заказы`
  String get my_orders {
    return Intl.message(
      'Мои заказы',
      name: 'my_orders',
      desc: '',
      args: [],
    );
  }

  /// `Создано:`
  String get create_ate {
    return Intl.message(
      'Создано:',
      name: 'create_ate',
      desc: '',
      args: [],
    );
  }

  /// `Просмотр изображения`
  String get image_view {
    return Intl.message(
      'Просмотр изображения',
      name: 'image_view',
      desc: '',
      args: [],
    );
  }

  /// `Дата отправления`
  String get date_start {
    return Intl.message(
      'Дата отправления',
      name: 'date_start',
      desc: '',
      args: [],
    );
  }

  /// `Ваши заказы:`
  String get you_orders {
    return Intl.message(
      'Ваши заказы:',
      name: 'you_orders',
      desc: '',
      args: [],
    );
  }

  /// `Другие заказы:`
  String get not_you_orders {
    return Intl.message(
      'Другие заказы:',
      name: 'not_you_orders',
      desc: '',
      args: [],
    );
  }

  /// `Изменить язык`
  String get change_lng {
    return Intl.message(
      'Изменить язык',
      name: 'change_lng',
      desc: '',
      args: [],
    );
  }

  /// `Завершен`
  String get transport_end {
    return Intl.message(
      'Завершен',
      name: 'transport_end',
      desc: '',
      args: [],
    );
  }

  /// `Вы уверены что хотите удалить аккаунт ?`
  String get delete_account {
    return Intl.message(
      'Вы уверены что хотите удалить аккаунт ?',
      name: 'delete_accound',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'hy'),
      Locale.fromSubtags(languageCode: 'kk'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'ky'),
      Locale.fromSubtags(languageCode: 'pl'),
      Locale.fromSubtags(languageCode: 'uz'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
