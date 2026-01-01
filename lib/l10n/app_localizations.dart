import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// The application name
  ///
  /// In ar, this message translates to:
  /// **'مزرعتي'**
  String get appName;

  /// No description provided for @splashWelcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحبا — مزرعتي'**
  String get splashWelcome;

  /// No description provided for @splashSlogan.
  ///
  /// In ar, this message translates to:
  /// **'دبّر مزرعتك بسهولة'**
  String get splashSlogan;

  /// No description provided for @irrigation.
  ///
  /// In ar, this message translates to:
  /// **'السقي'**
  String get irrigation;

  /// No description provided for @expenses.
  ///
  /// In ar, this message translates to:
  /// **'المصاريف'**
  String get expenses;

  /// No description provided for @report.
  ///
  /// In ar, this message translates to:
  /// **'الربح و الخسارة'**
  String get report;

  /// No description provided for @irrigationShort.
  ///
  /// In ar, this message translates to:
  /// **'سقي'**
  String get irrigationShort;

  /// No description provided for @expensesShort.
  ///
  /// In ar, this message translates to:
  /// **'فلوس'**
  String get expensesShort;

  /// No description provided for @profitShort.
  ///
  /// In ar, this message translates to:
  /// **'ربح'**
  String get profitShort;

  /// No description provided for @lossShort.
  ///
  /// In ar, this message translates to:
  /// **'خسارة'**
  String get lossShort;

  /// No description provided for @farmsShort.
  ///
  /// In ar, this message translates to:
  /// **'مزارع'**
  String get farmsShort;

  /// No description provided for @weatherShort.
  ///
  /// In ar, this message translates to:
  /// **'الطقس'**
  String get weatherShort;

  /// No description provided for @addShort.
  ///
  /// In ar, this message translates to:
  /// **'زيد'**
  String get addShort;

  /// No description provided for @reportsShort.
  ///
  /// In ar, this message translates to:
  /// **'تقرير'**
  String get reportsShort;

  /// No description provided for @settingsShort.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات'**
  String get settingsShort;

  /// No description provided for @addExpense.
  ///
  /// In ar, this message translates to:
  /// **'+ زيد مصروف'**
  String get addExpense;

  /// No description provided for @expenseCategory.
  ///
  /// In ar, this message translates to:
  /// **'نوع المصروف'**
  String get expenseCategory;

  /// No description provided for @amount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ'**
  String get amount;

  /// No description provided for @noExpenses.
  ///
  /// In ar, this message translates to:
  /// **'ما كاين حتى مصروف مسجل.'**
  String get noExpenses;

  /// No description provided for @irrigationTitle.
  ///
  /// In ar, this message translates to:
  /// **'تدبير السقي'**
  String get irrigationTitle;

  /// No description provided for @addIrrigation.
  ///
  /// In ar, this message translates to:
  /// **'+ زيد سقي'**
  String get addIrrigation;

  /// No description provided for @irrigationNote.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة (اختياري)'**
  String get irrigationNote;

  /// No description provided for @remindMe.
  ///
  /// In ar, this message translates to:
  /// **'فكرني'**
  String get remindMe;

  /// No description provided for @noIrrigations.
  ///
  /// In ar, this message translates to:
  /// **'ما كاين حتى سقي مسجل.'**
  String get noIrrigations;

  /// No description provided for @harvestTitle.
  ///
  /// In ar, this message translates to:
  /// **'تدبير الحصاد'**
  String get harvestTitle;

  /// No description provided for @addHarvest.
  ///
  /// In ar, this message translates to:
  /// **'+ زيد حصاد'**
  String get addHarvest;

  /// No description provided for @quantity.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get quantity;

  /// No description provided for @pricePerUnit.
  ///
  /// In ar, this message translates to:
  /// **'السعر'**
  String get pricePerUnit;

  /// No description provided for @harvestSummaryTitle.
  ///
  /// In ar, this message translates to:
  /// **'خلاصة الحصاد'**
  String get harvestSummaryTitle;

  /// No description provided for @totalQty.
  ///
  /// In ar, this message translates to:
  /// **'المجموع'**
  String get totalQty;

  /// No description provided for @totalRevenue.
  ///
  /// In ar, this message translates to:
  /// **'المداخيل'**
  String get totalRevenue;

  /// No description provided for @profit.
  ///
  /// In ar, this message translates to:
  /// **'الربح'**
  String get profit;

  /// No description provided for @totalExpenses.
  ///
  /// In ar, this message translates to:
  /// **'المصاريف'**
  String get totalExpenses;

  /// No description provided for @noHarvests.
  ///
  /// In ar, this message translates to:
  /// **'ما كاين حتى حصاد مسجل.'**
  String get noHarvests;

  /// No description provided for @journalTitle.
  ///
  /// In ar, this message translates to:
  /// **'دفتر الفلاحة'**
  String get journalTitle;

  /// No description provided for @addJournal.
  ///
  /// In ar, this message translates to:
  /// **'+ زيد ملاحظة'**
  String get addJournal;

  /// No description provided for @activity.
  ///
  /// In ar, this message translates to:
  /// **'شنو دار'**
  String get activity;

  /// No description provided for @attachPhoto.
  ///
  /// In ar, this message translates to:
  /// **'زيد صورة (اختياري)'**
  String get attachPhoto;

  /// No description provided for @noJournalEntries.
  ///
  /// In ar, this message translates to:
  /// **'ما كاين حتى ملاحظة.'**
  String get noJournalEntries;

  /// No description provided for @reportsTitle.
  ///
  /// In ar, this message translates to:
  /// **'التقارير'**
  String get reportsTitle;

  /// No description provided for @exportPdf.
  ///
  /// In ar, this message translates to:
  /// **'حفظ PDF'**
  String get exportPdf;

  /// No description provided for @shareWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'صيفط ف واتساب'**
  String get shareWhatsapp;

  /// No description provided for @monthlySummary.
  ///
  /// In ar, this message translates to:
  /// **'خلاصة الشهر'**
  String get monthlySummary;

  /// No description provided for @dashboardTitle.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get dashboardTitle;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'نظرة سريعة'**
  String get dashboardSubtitle;

  /// No description provided for @farms.
  ///
  /// In ar, this message translates to:
  /// **'المزارع'**
  String get farms;

  /// No description provided for @weather.
  ///
  /// In ar, this message translates to:
  /// **'الطقس'**
  String get weather;

  /// No description provided for @weatherTitle.
  ///
  /// In ar, this message translates to:
  /// **'الطقس'**
  String get weatherTitle;

  /// No description provided for @irrigationAdvice.
  ///
  /// In ar, this message translates to:
  /// **'نصيحة للسقي'**
  String get irrigationAdvice;

  /// No description provided for @settingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settingsTitle;

  /// No description provided for @offlineMode.
  ///
  /// In ar, this message translates to:
  /// **'بلا نت'**
  String get offlineMode;

  /// No description provided for @accessibilityTitle.
  ///
  /// In ar, this message translates to:
  /// **'سهولة الاستعمال'**
  String get accessibilityTitle;

  /// No description provided for @largeText.
  ///
  /// In ar, this message translates to:
  /// **'كتابة كبيرة'**
  String get largeText;

  /// No description provided for @highContrast.
  ///
  /// In ar, this message translates to:
  /// **'ألوان واضحة'**
  String get highContrast;

  /// No description provided for @voiceFeedback.
  ///
  /// In ar, this message translates to:
  /// **'الصوت'**
  String get voiceFeedback;

  /// No description provided for @saveSettings.
  ///
  /// In ar, this message translates to:
  /// **'حفظ الإعدادات'**
  String get saveSettings;

  /// No description provided for @addFarmTitle.
  ///
  /// In ar, this message translates to:
  /// **'زيد مزرعة'**
  String get addFarmTitle;

  /// No description provided for @farmName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get farmName;

  /// No description provided for @farmLocation.
  ///
  /// In ar, this message translates to:
  /// **'المكان'**
  String get farmLocation;

  /// No description provided for @cropType.
  ///
  /// In ar, this message translates to:
  /// **'نوع الزرع'**
  String get cropType;

  /// No description provided for @area.
  ///
  /// In ar, this message translates to:
  /// **'المساحة'**
  String get area;

  /// No description provided for @notes.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات'**
  String get notes;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'مرحبا في مزرعتي'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختار كيفاش بغيتي تبدا'**
  String get loginSubtitle;

  /// No description provided for @startWithoutAccount.
  ///
  /// In ar, this message translates to:
  /// **'ابدا بلا حساب'**
  String get startWithoutAccount;

  /// No description provided for @loginOrRegister.
  ///
  /// In ar, this message translates to:
  /// **'دخول / تسجيل'**
  String get loginOrRegister;

  /// No description provided for @continueText.
  ///
  /// In ar, this message translates to:
  /// **'تفضل'**
  String get continueText;

  /// No description provided for @myAccount.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get myAccount;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get profile;

  /// No description provided for @dataSync.
  ///
  /// In ar, this message translates to:
  /// **'المزامنة'**
  String get dataSync;

  /// No description provided for @preferences.
  ///
  /// In ar, this message translates to:
  /// **'التفضيلات'**
  String get preferences;

  /// No description provided for @darkMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الليلي'**
  String get darkMode;

  /// No description provided for @darkModeOn.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الليلي مفعل'**
  String get darkModeOn;

  /// No description provided for @darkModeOff.
  ///
  /// In ar, this message translates to:
  /// **'الوضع النهاري مفعل'**
  String get darkModeOff;

  /// No description provided for @appearance.
  ///
  /// In ar, this message translates to:
  /// **'المظهر'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @support.
  ///
  /// In ar, this message translates to:
  /// **'الدعم'**
  String get support;

  /// No description provided for @help.
  ///
  /// In ar, this message translates to:
  /// **'المساعدة'**
  String get help;

  /// No description provided for @feedback.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظاتك'**
  String get feedback;

  /// No description provided for @aboutApp.
  ///
  /// In ar, this message translates to:
  /// **'عن التطبيق'**
  String get aboutApp;

  /// No description provided for @logout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logout;

  /// No description provided for @selectLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اختار اللغة'**
  String get selectLanguage;

  /// No description provided for @french.
  ///
  /// In ar, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @english.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @darija.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get darija;

  /// No description provided for @newIrrigationNotification.
  ///
  /// In ar, this message translates to:
  /// **'وقت السقي!'**
  String get newIrrigationNotification;

  /// No description provided for @irrigationNotificationDesc.
  ///
  /// In ar, this message translates to:
  /// **'المزرعة الشمالية محتاجة السقي اليوم'**
  String get irrigationNotificationDesc;

  /// No description provided for @newExpenseNotification.
  ///
  /// In ar, this message translates to:
  /// **'مصروف جديد مسجل'**
  String get newExpenseNotification;

  /// No description provided for @expenseNotificationDesc.
  ///
  /// In ar, this message translates to:
  /// **'تسجلت 450 درهم للأسمدة'**
  String get expenseNotificationDesc;

  /// No description provided for @newHarvestNotification.
  ///
  /// In ar, this message translates to:
  /// **'وقت الحصاد قرب!'**
  String get newHarvestNotification;

  /// No description provided for @harvestNotificationDesc.
  ///
  /// In ar, this message translates to:
  /// **'الطماطم غادي يكونو جاهزين هاد الأسبوع'**
  String get harvestNotificationDesc;

  /// No description provided for @deleteNotification.
  ///
  /// In ar, this message translates to:
  /// **'امسح'**
  String get deleteNotification;

  /// No description provided for @noNotifications.
  ///
  /// In ar, this message translates to:
  /// **'ما كاين حتى إشعار'**
  String get noNotifications;

  /// No description provided for @notificationsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notificationsTitle;

  /// No description provided for @onboardingIrrigationTitle.
  ///
  /// In ar, this message translates to:
  /// **'سقي الماء'**
  String get onboardingIrrigationTitle;

  /// No description provided for @onboardingIrrigationText.
  ///
  /// In ar, this message translates to:
  /// **'سجل وقت و كمية السقي بسهولة'**
  String get onboardingIrrigationText;

  /// No description provided for @onboardingExpensesTitle.
  ///
  /// In ar, this message translates to:
  /// **'المصاريف'**
  String get onboardingExpensesTitle;

  /// No description provided for @onboardingExpensesText.
  ///
  /// In ar, this message translates to:
  /// **'سجل كل مصروف باش تعرف شحال تنصرف'**
  String get onboardingExpensesText;

  /// No description provided for @onboardingProfitTitle.
  ///
  /// In ar, this message translates to:
  /// **'الربح و الخسارة'**
  String get onboardingProfitTitle;

  /// No description provided for @onboardingProfitText.
  ///
  /// In ar, this message translates to:
  /// **'شوف الربح و الخسارة ديالك في تقرير بسيط'**
  String get onboardingProfitText;

  /// No description provided for @expensesLabel.
  ///
  /// In ar, this message translates to:
  /// **'المصاريف'**
  String get expensesLabel;

  /// No description provided for @totalRevenueLong.
  ///
  /// In ar, this message translates to:
  /// **'المجموع ديال الفلوس'**
  String get totalRevenueLong;

  /// No description provided for @profitLabel.
  ///
  /// In ar, this message translates to:
  /// **'الربح'**
  String get profitLabel;

  /// No description provided for @irrigationsCount.
  ///
  /// In ar, this message translates to:
  /// **'السقيات'**
  String get irrigationsCount;

  /// No description provided for @irrigationsCountMonth.
  ///
  /// In ar, this message translates to:
  /// **'سقيات هاد الشهر'**
  String get irrigationsCountMonth;

  /// No description provided for @farmSavedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'المزرعة تسجلات'**
  String get farmSavedSuccess;

  /// No description provided for @fieldRequired.
  ///
  /// In ar, this message translates to:
  /// **'هاد الحقل ضروري'**
  String get fieldRequired;

  /// No description provided for @selectOption.
  ///
  /// In ar, this message translates to:
  /// **'اختار'**
  String get selectOption;

  /// No description provided for @wheat.
  ///
  /// In ar, this message translates to:
  /// **'قمح'**
  String get wheat;

  /// No description provided for @corn.
  ///
  /// In ar, this message translates to:
  /// **'دورة'**
  String get corn;

  /// No description provided for @vegetables.
  ///
  /// In ar, this message translates to:
  /// **'خضرة'**
  String get vegetables;

  /// No description provided for @olives.
  ///
  /// In ar, this message translates to:
  /// **'زيتون'**
  String get olives;

  /// No description provided for @skip.
  ///
  /// In ar, this message translates to:
  /// **'تفوت'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'مبعد'**
  String get next;

  /// No description provided for @start.
  ///
  /// In ar, this message translates to:
  /// **'بدا'**
  String get start;

  /// No description provided for @noAccountHelperText.
  ///
  /// In ar, this message translates to:
  /// **'ما عندكش حساب؟ تقدر تبدا بلا ما تسجل'**
  String get noAccountHelperText;

  /// No description provided for @backTooltip.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get backTooltip;

  /// No description provided for @notificationsTooltip.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notificationsTooltip;

  /// No description provided for @menuTooltip.
  ///
  /// In ar, this message translates to:
  /// **'القائمة'**
  String get menuTooltip;

  /// No description provided for @forecastTitle.
  ///
  /// In ar, this message translates to:
  /// **'التوقعات - 7 أيام'**
  String get forecastTitle;

  /// No description provided for @timeLabel.
  ///
  /// In ar, this message translates to:
  /// **'وقت'**
  String get timeLabel;

  /// No description provided for @reminderPrefix.
  ///
  /// In ar, this message translates to:
  /// **'تذكير: '**
  String get reminderPrefix;

  /// No description provided for @clearReminder.
  ///
  /// In ar, this message translates to:
  /// **'امسح التذكير'**
  String get clearReminder;

  /// No description provided for @snoozeReminder.
  ///
  /// In ar, this message translates to:
  /// **'أجل التذكير'**
  String get snoozeReminder;

  /// No description provided for @deleteIrrigation.
  ///
  /// In ar, this message translates to:
  /// **'حذف السقي'**
  String get deleteIrrigation;

  /// No description provided for @total.
  ///
  /// In ar, this message translates to:
  /// **'المجموع'**
  String get total;

  /// No description provided for @numberShort.
  ///
  /// In ar, this message translates to:
  /// **'رقم'**
  String get numberShort;

  /// No description provided for @crop.
  ///
  /// In ar, this message translates to:
  /// **'الزرع'**
  String get crop;

  /// No description provided for @qtyShort.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get qtyShort;

  /// No description provided for @price.
  ///
  /// In ar, this message translates to:
  /// **'السعر'**
  String get price;

  /// No description provided for @revenue.
  ///
  /// In ar, this message translates to:
  /// **'المداخيل'**
  String get revenue;

  /// No description provided for @date.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get date;

  /// No description provided for @category.
  ///
  /// In ar, this message translates to:
  /// **'النوع'**
  String get category;

  /// No description provided for @pdfExportFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل تصدير PDF'**
  String get pdfExportFailed;

  /// No description provided for @helpContact.
  ///
  /// In ar, this message translates to:
  /// **'للمساعدة، اتصل بنا: support@mzra3ti.ma'**
  String get helpContact;

  /// No description provided for @appNameAlt.
  ///
  /// In ar, this message translates to:
  /// **'مزرعتي'**
  String get appNameAlt;

  /// No description provided for @okButton.
  ///
  /// In ar, this message translates to:
  /// **'حسناً'**
  String get okButton;

  /// No description provided for @feedbackThanks.
  ///
  /// In ar, this message translates to:
  /// **'شكراً لك! أرسل ملاحظاتك إلى: feedback@mzra3ti.ma'**
  String get feedbackThanks;

  /// No description provided for @cancelButton.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancelButton;

  /// No description provided for @largeTextSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'زيد الكتابة باش تقرا ساهلة'**
  String get largeTextSubtitle;

  /// No description provided for @highContrastSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تاخد كونتراست كبير للعيون'**
  String get highContrastSubtitle;

  /// No description provided for @voiceFeedbackSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'صوت يسمح لك تسمع الحولات'**
  String get voiceFeedbackSubtitle;

  /// No description provided for @offlineModeSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'خلي التطبيق يخدم بلا نت'**
  String get offlineModeSubtitle;

  /// No description provided for @operational.
  ///
  /// In ar, this message translates to:
  /// **'البيانات والمزامنة'**
  String get operational;

  /// No description provided for @settingsSaved.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات تسجلت'**
  String get settingsSaved;

  /// No description provided for @aboutAppDescription.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق مزرعتي لإدارة المزارع'**
  String get aboutAppDescription;

  /// No description provided for @versionLabel.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار'**
  String get versionLabel;

  /// No description provided for @copyrightText.
  ///
  /// In ar, this message translates to:
  /// **'© 2025 جميع الحقوق محفوظة'**
  String get copyrightText;

  /// No description provided for @pushNotifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات الفورية'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'استقبل تنبيهات للأحداث المهمة'**
  String get pushNotificationsSubtitle;

  /// No description provided for @irrigationReminders.
  ///
  /// In ar, this message translates to:
  /// **'تذكيرات السقي'**
  String get irrigationReminders;

  /// No description provided for @irrigationRemindersSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تنبهك ملي يجي وقت السقي'**
  String get irrigationRemindersSubtitle;

  /// No description provided for @harvestAlerts.
  ///
  /// In ar, this message translates to:
  /// **'تنبيهات الحصاد'**
  String get harvestAlerts;

  /// No description provided for @harvestAlertsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'خليك على اطلاع بوقت الحصاد'**
  String get harvestAlertsSubtitle;

  /// No description provided for @syncData.
  ///
  /// In ar, this message translates to:
  /// **'مزامنة البيانات'**
  String get syncData;

  /// No description provided for @lastSynced.
  ///
  /// In ar, this message translates to:
  /// **'آخر مزامنة: اليوم في 10:30 صباحاً'**
  String get lastSynced;

  /// No description provided for @profileSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الملف الشخصي'**
  String get profileSettings;

  /// No description provided for @profileSettingsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'دبّر معلوماتك الشخصية'**
  String get profileSettingsSubtitle;

  /// No description provided for @privacySecurity.
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية والأمان'**
  String get privacySecurity;

  /// No description provided for @privacySecuritySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تحكم في البيانات والخصوصية ديالك'**
  String get privacySecuritySubtitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get languageSubtitle;

  /// No description provided for @account.
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get account;

  /// No description provided for @about.
  ///
  /// In ar, this message translates to:
  /// **'عن التطبيق'**
  String get about;

  /// No description provided for @helpSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'احصل على الدعم والدروس'**
  String get helpSubtitle;

  /// No description provided for @aboutAppSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار 1.0.0'**
  String get aboutAppSubtitle;

  /// No description provided for @logoutTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logoutTitle;

  /// No description provided for @logoutSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اخرج من حسابك'**
  String get logoutSubtitle;

  /// No description provided for @logoutConfirm.
  ///
  /// In ar, this message translates to:
  /// **'واش متأكد بغيتي تخرج؟'**
  String get logoutConfirm;

  /// No description provided for @logoutButton.
  ///
  /// In ar, this message translates to:
  /// **'خروج'**
  String get logoutButton;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phone;

  /// No description provided for @emailOrPhone.
  ///
  /// In ar, this message translates to:
  /// **'البريد أو الهاتف'**
  String get emailOrPhone;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة السر'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة السر'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get fullName;

  /// No description provided for @loginButton.
  ///
  /// In ar, this message translates to:
  /// **'دخول'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل'**
  String get registerButton;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيتي كلمة السر؟'**
  String get forgotPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'عندك حساب؟'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'ما عندكش حساب؟'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In ar, this message translates to:
  /// **'سجل'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In ar, this message translates to:
  /// **'دخل'**
  String get signIn;

  /// No description provided for @emailRequired.
  ///
  /// In ar, this message translates to:
  /// **'البريد ضروري'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In ar, this message translates to:
  /// **'البريح مشي صالح'**
  String get emailInvalid;

  /// No description provided for @phoneInvalid.
  ///
  /// In ar, this message translates to:
  /// **'الرقم خاطئ'**
  String get phoneInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In ar, this message translates to:
  /// **'كلمة السر ضرورية'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In ar, this message translates to:
  /// **'كلمة السر يجب أن تكون 6 أحرف على الأقل'**
  String get passwordTooShort;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمات السر مشي متطابقة'**
  String get passwordsDontMatch;

  /// No description provided for @nameRequired.
  ///
  /// In ar, this message translates to:
  /// **'الاسم ضروري'**
  String get nameRequired;

  /// No description provided for @registrationSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الحساب بنجاح!'**
  String get registrationSuccess;

  /// No description provided for @loginSuccess.
  ///
  /// In ar, this message translates to:
  /// **'مرحبا بعودتك!'**
  String get loginSuccess;

  /// No description provided for @loginError.
  ///
  /// In ar, this message translates to:
  /// **'بيانات خاطئة'**
  String get loginError;

  /// No description provided for @welcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحبا'**
  String get welcome;

  /// No description provided for @createAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get createAccount;

  /// No description provided for @enterYourDetails.
  ///
  /// In ar, this message translates to:
  /// **'دخل بياناتك باش تبدا'**
  String get enterYourDetails;

  /// No description provided for @orContinueWith.
  ///
  /// In ar, this message translates to:
  /// **'أو كمل بـ'**
  String get orContinueWith;

  /// No description provided for @guest.
  ///
  /// In ar, this message translates to:
  /// **'ضيف'**
  String get guest;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
