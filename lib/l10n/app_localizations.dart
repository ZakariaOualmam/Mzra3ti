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
  /// **'لا توجد عمليات سقي'**
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
  /// **'السعر (DH)'**
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
  /// **'لا توجد عمليات حصاد'**
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
  /// **'اسم المزرعة'**
  String get farmName;

  /// No description provided for @farmLocation.
  ///
  /// In ar, this message translates to:
  /// **'المكان'**
  String get farmLocation;

  /// No description provided for @cropType.
  ///
  /// In ar, this message translates to:
  /// **'نوع المحصول'**
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
  /// **'خضروات'**
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
  /// **'الإيرادات'**
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

  /// No description provided for @profileTitle.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get profileTitle;

  /// No description provided for @editProfile.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملف الشخصي'**
  String get editProfile;

  /// No description provided for @personalInformation.
  ///
  /// In ar, this message translates to:
  /// **'المعلومات الشخصية'**
  String get personalInformation;

  /// No description provided for @profilePicture.
  ///
  /// In ar, this message translates to:
  /// **'صورة الملف الشخصي'**
  String get profilePicture;

  /// No description provided for @changePicture.
  ///
  /// In ar, this message translates to:
  /// **'تغيير الصورة'**
  String get changePicture;

  /// No description provided for @chooseFromGallery.
  ///
  /// In ar, this message translates to:
  /// **'اختر من المعرض'**
  String get chooseFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In ar, this message translates to:
  /// **'التقط صورة'**
  String get takePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In ar, this message translates to:
  /// **'إزالة الصورة'**
  String get removePhoto;

  /// No description provided for @username.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستخدم'**
  String get username;

  /// No description provided for @editUsername.
  ///
  /// In ar, this message translates to:
  /// **'تعديل اسم المستخدم'**
  String get editUsername;

  /// No description provided for @enterNewUsername.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم المستخدم الجديد'**
  String get enterNewUsername;

  /// No description provided for @phoneNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneNumber;

  /// No description provided for @editPhone.
  ///
  /// In ar, this message translates to:
  /// **'تعديل رقم الهاتف'**
  String get editPhone;

  /// No description provided for @accountSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الحساب'**
  String get accountSettings;

  /// No description provided for @changePassword.
  ///
  /// In ar, this message translates to:
  /// **'تغيير كلمة المرور'**
  String get changePassword;

  /// No description provided for @deleteAccount.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحساب'**
  String get deleteAccount;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن التراجع عن هذا الإجراء. سيتم حذف جميع بياناتك نهائياً.'**
  String get deleteAccountWarning;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @update.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get update;

  /// No description provided for @updateSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم التحديث بنجاح'**
  String get updateSuccess;

  /// No description provided for @updateError.
  ///
  /// In ar, this message translates to:
  /// **'فشل التحديث'**
  String get updateError;

  /// No description provided for @backToDashboard.
  ///
  /// In ar, this message translates to:
  /// **'العودة إلى لوحة التحكم'**
  String get backToDashboard;

  /// No description provided for @equipmentManagement.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المعدات'**
  String get equipmentManagement;

  /// No description provided for @equipmentSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'معدات وآلات المزرعة'**
  String get equipmentSubtitle;

  /// No description provided for @cropCalendar.
  ///
  /// In ar, this message translates to:
  /// **'التقويم الزراعي'**
  String get cropCalendar;

  /// No description provided for @cropCalendarSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'مواعيد الزراعة والحصاد'**
  String get cropCalendarSubtitle;

  /// No description provided for @notificationsMenu.
  ///
  /// In ar, this message translates to:
  /// **'التنبيهات'**
  String get notificationsMenu;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'التذكيرات والإشعارات'**
  String get notificationsSubtitle;

  /// No description provided for @analytics.
  ///
  /// In ar, this message translates to:
  /// **'التحليلات'**
  String get analytics;

  /// No description provided for @analyticsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'رسوم بيانية وإحصائيات'**
  String get analyticsSubtitle;

  /// No description provided for @sales.
  ///
  /// In ar, this message translates to:
  /// **'المبيعات'**
  String get sales;

  /// No description provided for @salesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تتبع المبيعات والعملاء'**
  String get salesSubtitle;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @financial.
  ///
  /// In ar, this message translates to:
  /// **'المالية'**
  String get financial;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات'**
  String get settings;

  /// No description provided for @quickActions.
  ///
  /// In ar, this message translates to:
  /// **'أزرار سريعة'**
  String get quickActions;

  /// No description provided for @calendar.
  ///
  /// In ar, this message translates to:
  /// **'التقويم'**
  String get calendar;

  /// No description provided for @equipment.
  ///
  /// In ar, this message translates to:
  /// **'المعدات'**
  String get equipment;

  /// No description provided for @notificationAlerts.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر هنا التذكيرات والتنبيهات المهمة'**
  String get notificationAlerts;

  /// No description provided for @addNewExpense.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مصروف جديد'**
  String get addNewExpense;

  /// No description provided for @editExpense.
  ///
  /// In ar, this message translates to:
  /// **'تعديل المصروف'**
  String get editExpense;

  /// No description provided for @deleteExpense.
  ///
  /// In ar, this message translates to:
  /// **'حذف المصروف'**
  String get deleteExpense;

  /// No description provided for @confirmDeleteExpense.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد حذف هذا المصروف؟'**
  String get confirmDeleteExpense;

  /// No description provided for @addNewIrrigation.
  ///
  /// In ar, this message translates to:
  /// **'إضافة سقي جديد'**
  String get addNewIrrigation;

  /// No description provided for @editIrrigation.
  ///
  /// In ar, this message translates to:
  /// **'تعديل السقي'**
  String get editIrrigation;

  /// No description provided for @confirmDeleteIrrigation.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد حذف هذه العملية؟'**
  String get confirmDeleteIrrigation;

  /// No description provided for @addNewHarvest.
  ///
  /// In ar, this message translates to:
  /// **'إضافة حصاد جديد'**
  String get addNewHarvest;

  /// No description provided for @editHarvest.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الحصاد'**
  String get editHarvest;

  /// No description provided for @deleteHarvest.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحصاد'**
  String get deleteHarvest;

  /// No description provided for @confirmDeleteHarvest.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف هذا الحصاد؟'**
  String get confirmDeleteHarvest;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @addNewEquipment.
  ///
  /// In ar, this message translates to:
  /// **'إضافة معدة جديدة'**
  String get addNewEquipment;

  /// No description provided for @editEquipment.
  ///
  /// In ar, this message translates to:
  /// **'تعديل المعدة'**
  String get editEquipment;

  /// No description provided for @deleteEquipment.
  ///
  /// In ar, this message translates to:
  /// **'حذف المعدة'**
  String get deleteEquipment;

  /// No description provided for @confirmDeleteEquipment.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد حذف هذه المعدة؟'**
  String get confirmDeleteEquipment;

  /// No description provided for @addNewCrop.
  ///
  /// In ar, this message translates to:
  /// **'إضافة محصول جديد'**
  String get addNewCrop;

  /// No description provided for @editCrop.
  ///
  /// In ar, this message translates to:
  /// **'تعديل المحصول'**
  String get editCrop;

  /// No description provided for @deleteCrop.
  ///
  /// In ar, this message translates to:
  /// **'حذف المحصول'**
  String get deleteCrop;

  /// No description provided for @confirmDeleteCrop.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد حذف هذا المحصول من التقويم؟'**
  String get confirmDeleteCrop;

  /// No description provided for @addNewSale.
  ///
  /// In ar, this message translates to:
  /// **'إضافة بيع جديد'**
  String get addNewSale;

  /// No description provided for @editSale.
  ///
  /// In ar, this message translates to:
  /// **'تعديل البيع'**
  String get editSale;

  /// No description provided for @deleteSale.
  ///
  /// In ar, this message translates to:
  /// **'حذف البيع'**
  String get deleteSale;

  /// No description provided for @confirmDeleteSale.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد حذف هذا البيع؟'**
  String get confirmDeleteSale;

  /// No description provided for @categories.
  ///
  /// In ar, this message translates to:
  /// **'الفئات'**
  String get categories;

  /// No description provided for @totalAmount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ الإجمالي'**
  String get totalAmount;

  /// No description provided for @expenseDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ المصروف'**
  String get expenseDate;

  /// No description provided for @enterAmount.
  ///
  /// In ar, this message translates to:
  /// **'أدخل قيمة المصروف'**
  String get enterAmount;

  /// No description provided for @noData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات'**
  String get noData;

  /// No description provided for @noMonthlyData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات شهرية'**
  String get noMonthlyData;

  /// No description provided for @noExpensesData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مصاريف'**
  String get noExpensesData;

  /// No description provided for @customerInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات العميل'**
  String get customerInfo;

  /// No description provided for @customerName.
  ///
  /// In ar, this message translates to:
  /// **'اسم العميل'**
  String get customerName;

  /// No description provided for @productInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات المنتج'**
  String get productInfo;

  /// No description provided for @product.
  ///
  /// In ar, this message translates to:
  /// **'المنتج'**
  String get product;

  /// No description provided for @paymentAndStatus.
  ///
  /// In ar, this message translates to:
  /// **'الدفع والحالة'**
  String get paymentAndStatus;

  /// No description provided for @dateLabel.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get dateLabel;

  /// No description provided for @noSales.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مبيعات'**
  String get noSales;

  /// No description provided for @notesLabel.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات'**
  String get notesLabel;

  /// No description provided for @noEquipment.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد معدات'**
  String get noEquipment;

  /// No description provided for @noCrops.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد محاصيل'**
  String get noCrops;

  /// No description provided for @addCropsToTrack.
  ///
  /// In ar, this message translates to:
  /// **'أضف محاصيلك لتتبع مواعيد الحصاد'**
  String get addCropsToTrack;

  /// No description provided for @noReadyCrops.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد محاصيل جاهزة'**
  String get noReadyCrops;

  /// No description provided for @noNotificationsData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تنبيهات'**
  String get noNotificationsData;

  /// No description provided for @quantityKg.
  ///
  /// In ar, this message translates to:
  /// **'الكمية (كلغ)'**
  String get quantityKg;

  /// No description provided for @enterQuantityKg.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الكمية بالكيلوغرام'**
  String get enterQuantityKg;

  /// No description provided for @priceDhKg.
  ///
  /// In ar, this message translates to:
  /// **'السعر (درهم/كلغ)'**
  String get priceDhKg;

  /// No description provided for @totalQuantityLabel.
  ///
  /// In ar, this message translates to:
  /// **'الكمية الإجمالية'**
  String get totalQuantityLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get quantityLabel;

  /// No description provided for @priceLabel.
  ///
  /// In ar, this message translates to:
  /// **'السعر'**
  String get priceLabel;

  /// No description provided for @equipmentName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المعدة'**
  String get equipmentName;

  /// No description provided for @purchaseDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الشراء'**
  String get purchaseDate;

  /// No description provided for @cropName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المحصول'**
  String get cropName;

  /// No description provided for @season.
  ///
  /// In ar, this message translates to:
  /// **'الموسم'**
  String get season;

  /// No description provided for @plantingDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الزراعة'**
  String get plantingDate;

  /// No description provided for @expectedHarvestDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الحصاد المتوقع'**
  String get expectedHarvestDate;

  /// No description provided for @enableReminders.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل التذكيرات'**
  String get enableReminders;

  /// No description provided for @sendReminderBeforeHarvest.
  ///
  /// In ar, this message translates to:
  /// **'إرسال تذكير قبل موعد الحصاد'**
  String get sendReminderBeforeHarvest;

  /// No description provided for @pending.
  ///
  /// In ar, this message translates to:
  /// **'معلق'**
  String get pending;

  /// No description provided for @managerName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المسؤول'**
  String get managerName;

  /// No description provided for @irrigationDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ السقي'**
  String get irrigationDate;

  /// No description provided for @enableReminder.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل التذكير'**
  String get enableReminder;

  /// No description provided for @sendIrrigationReminder.
  ///
  /// In ar, this message translates to:
  /// **'إرسال تذكير لموعد السقي'**
  String get sendIrrigationReminder;

  /// No description provided for @reminder.
  ///
  /// In ar, this message translates to:
  /// **'تذكير'**
  String get reminder;

  /// No description provided for @harvestDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الحصاد'**
  String get harvestDate;

  /// No description provided for @farmInfo.
  ///
  /// In ar, this message translates to:
  /// **'الاسم، المساحة، الموقع، نوع التربة'**
  String get farmInfo;

  /// No description provided for @farmInformation.
  ///
  /// In ar, this message translates to:
  /// **'معلومات المزرعة'**
  String get farmInformation;

  /// No description provided for @farmData.
  ///
  /// In ar, this message translates to:
  /// **'بيانات المزرعة'**
  String get farmData;

  /// No description provided for @landAndPlots.
  ///
  /// In ar, this message translates to:
  /// **'الأراضي والقطع'**
  String get landAndPlots;

  /// No description provided for @divideFarmIntoPlots.
  ///
  /// In ar, this message translates to:
  /// **'تقسيم المزرعة إلى قطع وإدارتها'**
  String get divideFarmIntoPlots;

  /// No description provided for @waterSources.
  ///
  /// In ar, this message translates to:
  /// **'مصادر المياه'**
  String get waterSources;

  /// No description provided for @wellsTanksIrrigation.
  ///
  /// In ar, this message translates to:
  /// **'الآبار، الخزانات، أنظمة الري'**
  String get wellsTanksIrrigation;

  /// No description provided for @harvestManagement.
  ///
  /// In ar, this message translates to:
  /// **'إدارة المحاصيل والحصاد'**
  String get harvestManagement;

  /// No description provided for @harvestSummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص الحصاد'**
  String get harvestSummary;

  /// No description provided for @harvestOperations.
  ///
  /// In ar, this message translates to:
  /// **'عملية حصاد'**
  String get harvestOperations;

  /// No description provided for @netProfit.
  ///
  /// In ar, this message translates to:
  /// **'صافي الربح'**
  String get netProfit;

  /// No description provided for @harvestLog.
  ///
  /// In ar, this message translates to:
  /// **'سجل الحصاد'**
  String get harvestLog;

  /// No description provided for @clickToAddHarvest.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على + لإضافة حصاد جديد'**
  String get clickToAddHarvest;

  /// No description provided for @clickToAddExpense.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على + لإضافة مصروف جديد'**
  String get clickToAddExpense;

  /// No description provided for @clickToAddIrrigation.
  ///
  /// In ar, this message translates to:
  /// **'اضغط على + لإضافة سقي جديد'**
  String get clickToAddIrrigation;

  /// No description provided for @popularCrops.
  ///
  /// In ar, this message translates to:
  /// **'محاصيل شائعة:'**
  String get popularCrops;

  /// No description provided for @customers.
  ///
  /// In ar, this message translates to:
  /// **'العملاء'**
  String get customers;

  /// No description provided for @cash.
  ///
  /// In ar, this message translates to:
  /// **'نقدي'**
  String get cash;

  /// No description provided for @paid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوع'**
  String get paid;

  /// No description provided for @partiallyPaid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوع جزئياً'**
  String get partiallyPaid;

  /// No description provided for @noCustomers.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد عملاء'**
  String get noCustomers;

  /// No description provided for @readyForHarvest.
  ///
  /// In ar, this message translates to:
  /// **'جاهز للحصاد'**
  String get readyForHarvest;

  /// No description provided for @allCrops.
  ///
  /// In ar, this message translates to:
  /// **'جميع المحاصيل'**
  String get allCrops;

  /// No description provided for @grains.
  ///
  /// In ar, this message translates to:
  /// **'حبوب'**
  String get grains;

  /// No description provided for @fruits.
  ///
  /// In ar, this message translates to:
  /// **'فواكه'**
  String get fruits;

  /// No description provided for @other.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get other;

  /// No description provided for @spring.
  ///
  /// In ar, this message translates to:
  /// **'الربيع'**
  String get spring;

  /// No description provided for @summer.
  ///
  /// In ar, this message translates to:
  /// **'الصيف'**
  String get summer;

  /// No description provided for @autumn.
  ///
  /// In ar, this message translates to:
  /// **'الخريف'**
  String get autumn;

  /// No description provided for @winter.
  ///
  /// In ar, this message translates to:
  /// **'الشتاء'**
  String get winter;

  /// No description provided for @daysCount.
  ///
  /// In ar, this message translates to:
  /// **'عدد الأيام (إذا لازم)'**
  String get daysCount;

  /// No description provided for @averageDaysToHarvest.
  ///
  /// In ar, this message translates to:
  /// **'متوسط الأيام حتى الحصاد'**
  String get averageDaysToHarvest;

  /// No description provided for @irrigationTime.
  ///
  /// In ar, this message translates to:
  /// **'وقت السقي'**
  String get irrigationTime;

  /// No description provided for @additionalIrrigationInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات إضافية عن السقي'**
  String get additionalIrrigationInfo;

  /// No description provided for @fullIrrigationTime.
  ///
  /// In ar, this message translates to:
  /// **'موعد السقي الكامل'**
  String get fullIrrigationTime;

  /// No description provided for @tractor.
  ///
  /// In ar, this message translates to:
  /// **'جرار'**
  String get tractor;

  /// No description provided for @purchasePrice.
  ///
  /// In ar, this message translates to:
  /// **'سعر الشراء (DH)'**
  String get purchasePrice;

  /// No description provided for @active.
  ///
  /// In ar, this message translates to:
  /// **'نشط'**
  String get active;

  /// No description provided for @maintenance.
  ///
  /// In ar, this message translates to:
  /// **'صيانة'**
  String get maintenance;

  /// No description provided for @inMaintenance.
  ///
  /// In ar, this message translates to:
  /// **'قيد الصيانة'**
  String get inMaintenance;

  /// No description provided for @needsMaintenance.
  ///
  /// In ar, this message translates to:
  /// **'تحتاج صيانة'**
  String get needsMaintenance;

  /// No description provided for @dates.
  ///
  /// In ar, this message translates to:
  /// **'التواريخ'**
  String get dates;

  /// No description provided for @lastMaintenance.
  ///
  /// In ar, this message translates to:
  /// **'آخر صيانة'**
  String get lastMaintenance;

  /// No description provided for @notDoneYet.
  ///
  /// In ar, this message translates to:
  /// **'لم تتم بعد'**
  String get notDoneYet;

  /// No description provided for @nextMaintenance.
  ///
  /// In ar, this message translates to:
  /// **'الصيانة القادمة'**
  String get nextMaintenance;

  /// No description provided for @notSpecified.
  ///
  /// In ar, this message translates to:
  /// **'غير محددة'**
  String get notSpecified;

  /// No description provided for @expectedRevenue.
  ///
  /// In ar, this message translates to:
  /// **'الإيرادات المتوقعة'**
  String get expectedRevenue;

  /// No description provided for @upcomingMaintenance.
  ///
  /// In ar, this message translates to:
  /// **'صيانة قادمة'**
  String get upcomingMaintenance;

  /// No description provided for @categoryFarming.
  ///
  /// In ar, this message translates to:
  /// **'زراعة'**
  String get categoryFarming;

  /// No description provided for @categoryTractor.
  ///
  /// In ar, this message translates to:
  /// **'تراكتور'**
  String get categoryTractor;

  /// No description provided for @categoryIrrigation.
  ///
  /// In ar, this message translates to:
  /// **'سقي'**
  String get categoryIrrigation;

  /// No description provided for @categoryLabor.
  ///
  /// In ar, this message translates to:
  /// **'عمال'**
  String get categoryLabor;

  /// No description provided for @categoryAccessories.
  ///
  /// In ar, this message translates to:
  /// **'ملحقات'**
  String get categoryAccessories;

  /// No description provided for @categoryOther.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get categoryOther;

  /// No description provided for @equipmentTractor.
  ///
  /// In ar, this message translates to:
  /// **'جرار'**
  String get equipmentTractor;

  /// No description provided for @equipmentWaterPump.
  ///
  /// In ar, this message translates to:
  /// **'مضخة ماء'**
  String get equipmentWaterPump;

  /// No description provided for @equipmentHandTools.
  ///
  /// In ar, this message translates to:
  /// **'أدوات يدوية'**
  String get equipmentHandTools;

  /// No description provided for @equipmentFarmMachinery.
  ///
  /// In ar, this message translates to:
  /// **'آلات زراعية'**
  String get equipmentFarmMachinery;

  /// No description provided for @equipmentIrrigationSystem.
  ///
  /// In ar, this message translates to:
  /// **'نظام ري'**
  String get equipmentIrrigationSystem;

  /// No description provided for @equipmentOther.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get equipmentOther;

  /// No description provided for @cropWheat.
  ///
  /// In ar, this message translates to:
  /// **'قمح'**
  String get cropWheat;

  /// No description provided for @cropPotatoes.
  ///
  /// In ar, this message translates to:
  /// **'بطاطس'**
  String get cropPotatoes;

  /// No description provided for @cropCucumber.
  ///
  /// In ar, this message translates to:
  /// **'خيار'**
  String get cropCucumber;

  /// No description provided for @cropTomatoes.
  ///
  /// In ar, this message translates to:
  /// **'طماطم'**
  String get cropTomatoes;

  /// No description provided for @cropOnion.
  ///
  /// In ar, this message translates to:
  /// **'بصل'**
  String get cropOnion;

  /// No description provided for @cropCarrot.
  ///
  /// In ar, this message translates to:
  /// **'جزر'**
  String get cropCarrot;

  /// No description provided for @cropPepper.
  ///
  /// In ar, this message translates to:
  /// **'فلفل'**
  String get cropPepper;

  /// No description provided for @cropWatermelon.
  ///
  /// In ar, this message translates to:
  /// **'بطيخ'**
  String get cropWatermelon;

  /// No description provided for @cropStrawberry.
  ///
  /// In ar, this message translates to:
  /// **'فراولة'**
  String get cropStrawberry;

  /// No description provided for @cropCorn.
  ///
  /// In ar, this message translates to:
  /// **'ذرة'**
  String get cropCorn;

  /// No description provided for @totalExpensesTitle.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المصاريف'**
  String get totalExpensesTitle;

  /// No description provided for @totalQuantityKg.
  ///
  /// In ar, this message translates to:
  /// **'كلغ'**
  String get totalQuantityKg;

  /// No description provided for @dailyAverage.
  ///
  /// In ar, this message translates to:
  /// **'متوسط يومي'**
  String get dailyAverage;

  /// No description provided for @last7Days.
  ///
  /// In ar, this message translates to:
  /// **'آخر 7 أيام'**
  String get last7Days;

  /// No description provided for @monthSummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص 6 أشهر'**
  String get monthSummary;

  /// No description provided for @daySaturday.
  ///
  /// In ar, this message translates to:
  /// **'السبت'**
  String get daySaturday;

  /// No description provided for @dayFriday.
  ///
  /// In ar, this message translates to:
  /// **'الجمعة'**
  String get dayFriday;

  /// No description provided for @dayThursday.
  ///
  /// In ar, this message translates to:
  /// **'الخميس'**
  String get dayThursday;

  /// No description provided for @dayWednesday.
  ///
  /// In ar, this message translates to:
  /// **'الأربعاء'**
  String get dayWednesday;

  /// No description provided for @dayTuesday.
  ///
  /// In ar, this message translates to:
  /// **'الثلاثاء'**
  String get dayTuesday;

  /// No description provided for @dayMonday.
  ///
  /// In ar, this message translates to:
  /// **'الإثنين'**
  String get dayMonday;

  /// No description provided for @daySunday.
  ///
  /// In ar, this message translates to:
  /// **'الأحد'**
  String get daySunday;

  /// No description provided for @totalProfitTitle.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الأرباح'**
  String get totalProfitTitle;

  /// No description provided for @expenseBreakdown.
  ///
  /// In ar, this message translates to:
  /// **'توزيع المصاريف'**
  String get expenseBreakdown;

  /// No description provided for @expensesChart.
  ///
  /// In ar, this message translates to:
  /// **'المصاريف'**
  String get expensesChart;

  /// No description provided for @broken.
  ///
  /// In ar, this message translates to:
  /// **'معطل'**
  String get broken;

  /// No description provided for @purchasedOn.
  ///
  /// In ar, this message translates to:
  /// **'شراء'**
  String get purchasedOn;
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
