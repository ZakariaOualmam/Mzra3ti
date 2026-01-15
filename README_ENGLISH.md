# 🌾 Mzra3ti - Professional Farm Management App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**A modern, professional farming management application built with Flutter**

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Usage](#-usage) • [Technical Details](#-technical-details)

</div>

---

## 📖 What is Mzra3ti?

**Mzra3ti** (My Farm in Arabic) is a comprehensive farm management application designed to help farmers efficiently manage their agricultural operations. The app provides an intuitive dashboard for tracking irrigation, expenses, harvests, and farm activities, with a focus on professional UI/UX and multilingual support.

### 🎯 Purpose and Mission

**Mzra3ti** addresses several critical challenges faced by modern farmers:

1. **Information Organization** - Centralize all farm data in one secure, accessible location
2. **Financial Transparency** - Track expenses and revenue with precision and clarity
3. **Smart Planning** - Schedule and organize agricultural activities efficiently
4. **Data-Driven Decisions** - Make informed choices based on detailed reports and analytics
5. **Time Efficiency** - Quick access to all information without searching through notebooks
6. **User-Friendly Experience** - Simple, intuitive interface accessible to all skill levels

---

## ✨ Core Features

### 🔐 Authentication System

**Smart Login/Register Flow:**
- **Account Creation:** Simple registration with name, email/phone, and secure password
- **Secure Login:** Email/phone and password authentication
- **Auto-login:** Automatic login after successful registration
- **Input Validation:** Real-time validation with localized error messages
- **Logout:** Secure logout with confirmation dialog
- **Theme Toggle:** Switch between light and dark mode directly from login screen
- **Persistent State:** Login status maintained across app restarts

### 👤 User Profile Management

**Comprehensive Profile Features:**
- **Profile Picture Management:**
  - Circular avatar with gradient background
  - First letter of username as placeholder
  - Options to change picture (Gallery, Camera, Remove)
  
- **Personal Information Editing:**
  - Edit username with inline text fields
  - Edit email/phone number
  - Edit mode toggle with save button
  - Real-time validation and success/error notifications

- **Quick Settings:**
  - Dark mode toggle switch
  - Language selector (English/Arabic/French dropdown)
  - Quick access to notifications settings
  - Change password option

- **Danger Zone:**
  - Delete account with confirmation dialog
  - Warning message about permanent data deletion

### 🏠 Dashboard & Home Screen

**Professional Welcome Card:**
- **Before Login:** Generic welcome message
- **After Login:** Personalized greeting - "Welcome, [Username]"
- Dynamic icon and gradient background
- Theme-aware styling

**Dashboard Feature Cards:**
- 🚰 **Irrigation Management** - Track water usage and scheduling
- 💰 **Expense Tracking** - Monitor farm costs and spending
- 🌾 **Harvest Records** - Record crop yields and revenue
- 🚜 **Farm Management** - Add and manage multiple farms
- 📅 **Crop Calendar** - Plan planting and harvest schedules
- 📊 **Analytics** - View detailed statistics and insights
- 🛠️ **Equipment** - Track farm machinery and tools
- 💵 **Sales** - Monitor product sales and revenue

**Features:**
- Clean 2-column grid layout with proper spacing
- Each card features custom icon with circular background
- Value display (quantity, amount, etc.)
- Tap navigation to respective screens

### 🌍 Land Mapping

**Geographic Features:**
- **Visual Maps:** View your farm parcels on Google Maps
- **Area Measurement:** Calculate land surface area
- **Points of Interest:** Mark important locations (wells, storage, etc.)
- **Navigation:** Get directions to your parcels
- **GPS Integration:** Real-time location tracking
- **Boundary Marking:** Define field boundaries

### 📝 Farm Journal

**Activity Logging:**
- **Daily Activities:** Record all farm operations
- **Detailed Notes:** Add comments and observations
- **Timestamp Tracking:** Chronological activity history
- **Search & Filter:** Quickly find past activities
- **Categorization:** Organize by activity type
- **Photo Attachments:** Document activities with images (future)

### 📊 Financial Reports

**Comprehensive Analytics:**
- **Expense Reports:** Visualize spending patterns
- **Revenue Reports:** Track income by harvest
- **Profit/Loss Analysis:** Automatic profitability calculations
- **PDF Export:** Generate printable reports
- **Share Functionality:** Send reports via WhatsApp or email
- **Interactive Charts:** Clear data visualizations
- **Time Period Filters:** View data by day, week, month, year

### 🌤️ Weather Information

**Complete Weather Features:**
- **Current Conditions:** Temperature, humidity, wind speed
- **Forecasts:** Multi-day weather predictions
- **Severe Weather Alerts:** Notifications for dangerous conditions
- **Location-Based:** Weather for your farm location
- **Agricultural Advice:** Recommendations based on weather
- **Historical Data:** Past weather patterns (future)

### 🛠️ Equipment Management

**Machinery Inventory:**
- **Complete List:** All tools and machines
- **Maintenance Tracking:** Schedule and track servicing
- **Cost Recording:** Purchase and repair expenses
- **Status Monitoring:** Track equipment condition
- **Maintenance Reminders:** Automated notifications
- **Usage Logs:** Track equipment usage hours

### ⚙️ Comprehensive Settings

**Appearance Section:**
- 🌙 Dark Mode - Eye protection for night use
- ☀️ Light Mode - Optimal visibility during day
- Instant theme switching
- Professional color schemes

**Language Support:**
- 🇲🇦 Arabic (Darija) - Moroccan dialect
- 🇬🇧 English - Full English localization
- 🇫🇷 French - Complete French translation
- 72+ localization keys

**Accessibility Options:**
- 📝 Large Text - Enhanced readability
- 🔊 High Contrast - Better visibility
- 🗣️ Voice Feedback - Audio assistance

**Notifications:**
- 🔔 Enable/disable app notifications
- Customize notification preferences
- Manage alert types

**Data & Sync:**
- ☁️ Cloud synchronization
- 💾 Backup and restore
- 🔄 Automatic updates

**Account Management:**
- Profile settings quick access
- Change password
- Delete account option
- Logout with confirmation

---

## 🎨 Professional Design

### UI/UX Excellence:

- ✅ **Material Design 3** - Latest Google design standards
- ✅ **Professional Color Palette** - Agricultural green with harmonious accents
- ✅ **Smooth Animations** - Fluid transitions between screens
- ✅ **Responsive Design** - Adapts to all screen sizes
- ✅ **RTL Support** - Right-to-left layout for Arabic
- ✅ **Accessibility** - Usable by everyone
- ✅ **Overflow-Free Layouts** - Proper constraints and scrolling
- ✅ **Theme Consistency** - Unified design language throughout

### Color Themes:

**Light Mode:**
- Background: Light gray `#F5F5F5`
- Surface: Soft white `#FAFAFA`
- Primary: Agricultural green `#2E7D32`
- Text: Dark, readable colors
- Shadows: Subtle elevation effects

**Dark Mode:**
- Background: Deep dark gray `#1C1C1E`
- Surface: Elevated dark gray `#2C2C2E`
- Primary: Light green `#81C784`
- Text: Light, readable colors
- Optimized contrast for night use

---

## 🔧 How to Use the App

### First-Time Setup:

1. **Launch App** - View splash screen with branding
2. **Onboarding** - Swipe through feature introduction screens
3. **Create Account:**
   - Tap "Login or Register" in the drawer
   - Navigate to "Register" screen
   - Enter name, email/phone, and password
   - Tap "Create Account"
   - ✅ Automatically logged in and redirected to dashboard

### Using the Dashboard:

1. **View Quick Stats** - Overview of irrigation, expenses, harvest, and farm counts
2. **Tap Cards** - Navigate to detailed screens for each category
3. **Access Drawer** - Swipe from right or tap menu icon
4. **Navigate Features** - Use drawer to access all app sections

### Managing Your Profile:

1. **Access Profile:**
   - After login, tap your account bar in the drawer
   - Or navigate via Settings
   
2. **Edit Information:**
   - Tap the edit icon in the top-right
   - Modify username or email/phone
   - Tap the checkmark to save changes
   
3. **Change Theme:**
   - Toggle dark mode switch in profile
   - Theme applies instantly across app
   
4. **Switch Language:**
   - Select English, العربية, or Français from dropdown
   - All text updates immediately
   - Language persists across app restarts

---

## 🚀 Installation for Developers

### Prerequisites:

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Chrome, iOS Simulator, or Android Emulator

### Installation Steps:

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/mzra3ti.git
cd mzra3ti

# 2. Install dependencies
flutter pub get

# 3. Generate localizations
flutter gen-l10n

# 4. Run the app
# On Chrome (Web)
flutter run -d chrome

# On Android Emulator
flutter run -d android

# On iOS Simulator
flutter run -d ios
```

### Build for Production:

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## 📦 Technology Stack

### Core Technologies:

- **Flutter** - UI framework
- **Dart** - Programming language
- **Provider** - State management
- **SharedPreferences** - Local data storage
- **Google Maps Flutter** - Mapping functionality
- **Geolocator** - GPS location services
- **Geocoding** - Address and coordinate conversion
- **PDF & Printing** - Report generation and export
- **File Picker** - File selection
- **Share Plus** - Content sharing
- **URL Launcher** - External links
- **Intl** - Internationalization

### Project Architecture:

```
lib/
├── main.dart                      # App entry point
├── l10n/                          # Localization files
│   ├── app_en.arb                # English translations
│   ├── app_ar.arb                # Arabic translations
│   ├── app_fr.arb                # French translations
│   └── app_localizations.dart    # Generated localizations
├── src/
│   ├── app.dart                   # MaterialApp configuration
│   ├── core/
│   │   ├── constants.dart         # App constants
│   │   └── styles.dart            # Theme definitions
│   ├── services/
│   │   ├── user_service.dart      # Authentication & user data
│   │   ├── theme_service.dart     # Theme management
│   │   └── language_service.dart  # Language management
│   └── features/
│       ├── auth/                  # Authentication screens
│       ├── profile/               # Profile management
│       ├── dashboard/             # Home dashboard
│       ├── irrigation/            # Irrigation tracking
│       ├── expenses/              # Expense management
│       ├── harvest/               # Harvest records
│       ├── farms/                 # Farm management
│       ├── journal/               # Activity journal
│       ├── reports/               # Financial reports
│       ├── weather/               # Weather information
│       ├── land_map/              # Geographic mapping
│       ├── equipment/             # Equipment inventory
│       ├── crop_calendar/         # Planting schedule
│       ├── analytics/             # Data analytics
│       ├── sales/                 # Sales tracking
│       ├── notifications/         # Notification center
│       └── settings/              # App settings
```

### State Management Pattern:

**Provider-based Architecture:**
- `ThemeService` - Manages theme state (light/dark mode)
- `LanguageService` - Manages locale state (Arabic/English/French)
- `UserService` - Manages authentication and user data

**Data Persistence:**
- SharedPreferences for:
  - User authentication state
  - Theme preference
  - Language selection
  - User profile data
  - App settings

---

## 🎯 Problems Solved

### 1. Information Chaos
**Problem:** Farmers use multiple notebooks, scattered papers, difficult to find information
**Solution:** Centralized digital system with organized data structure

### 2. Financial Opacity
**Problem:** Unclear spending patterns, difficult to calculate profitability
**Solution:** Automated expense tracking with detailed financial reports

### 3. Poor Planning
**Problem:** No clear schedule for agricultural activities
**Solution:** Crop calendar with automated reminders and notifications

### 4. Uninformed Decisions
**Problem:** Lack of data to make good farming decisions
**Solution:** Comprehensive reports and statistical analysis

### 5. Time Wastage
**Problem:** Spend too much time searching for information
**Solution:** Fast search and intelligent filtering

### 6. Technology Barrier
**Problem:** Complex apps difficult for farmers to use
**Solution:** Simple, intuitive interface in local languages

---

## 🔮 Future Enhancements

### Near-Term Features:

- [ ] **Backend API** - Server infrastructure for data sync
- [ ] **Cloud Synchronization** - Real-time data backup
- [ ] **Live Weather API** - Real-time weather integration
- [ ] **Camera Integration** - Direct photo capture for profile and documentation
- [ ] **Push Notifications** - Instant alerts and reminders
- [ ] **Offline Mode** - Full functionality without internet (SQLite)
- [ ] **Password Recovery** - Email-based password reset

### Advanced Features:

- [ ] **AI Recommendations** - Intelligent farming advice
- [ ] **Multi-Farm Support** - Manage multiple farms with switching
- [ ] **Marketplace** - Buy and sell agricultural products
- [ ] **Farmer Community** - Social network for farmers
- [ ] **Educational Content** - Tutorials and farming guides
- [ ] **Expert Consultations** - Connect with agricultural experts
- [ ] **Automated Cost Calculation** - Production cost analytics
- [ ] **Pest & Disease Tracking** - Monitor and treat crop problems
- [ ] **Worker Management** - Attendance and payroll tracking
- [ ] **Loan Information** - Agricultural financing options

### Technical Improvements:

- [ ] **Performance Optimization** - Faster, lighter app
- [ ] **Enhanced Design** - Even better UI/UX
- [ ] **Additional Languages** - Tamazight, Spanish, etc.
- [ ] **Automatic Backup** - Scheduled data protection
- [ ] **Multiple Themes** - More color scheme options
- [ ] **Home Screen Widgets** - Quick information access
- [ ] **Smartwatch Support** - Apple Watch and Wear OS apps
- [ ] **Voice Commands** - Hands-free operation
- [ ] **Barcode Scanner** - Product and inventory scanning
- [ ] **QR Code Generation** - Digital farm identification

---

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines:

- Follow Flutter best practices
- Write clean, documented code
- Test on multiple platforms
- Update relevant documentation
- Follow the existing code style

---

## 📞 Support & Contact

For questions, issues, or support:

- 📧 Email: support@mzra3ti.ma
- 💬 WhatsApp: +212 649667420
- 🌐 Website: www.mzra3ti.ma
- 📱 Facebook: @Mzra3tiApp
- 📸 Instagram: @mzra3ti
- 💼 LinkedIn: Mzra3ti
- 🐛 Issues: GitHub Issues page

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### MIT License Summary:
- ✅ Commercial use allowed
- ✅ Modification allowed
- ✅ Distribution allowed
- ✅ Private use allowed
- ❗ License and copyright notice required

---

## 👏 Acknowledgments

Special thanks to:

- **Flutter Team** - For the amazing cross-platform framework
- **Google Material Design** - For UI/UX guidelines and components
- **Open Source Community** - For packages and resources
- **Moroccan Farmers** - For inspiring this project
- **Contributors** - Everyone who helps improve Mzra3ti

---

## 📊 Project Status

**Current Version:** 0.0.1 (Alpha)  
**Status:** Active Development  
**Platforms:** Android, iOS, Web  
**Languages:** Arabic (Darija), English, French  

### Development Roadmap:

- ✅ Phase 1: Core Features (Authentication, Dashboard, Profile)
- ✅ Phase 2: Data Management (Expenses, Irrigation, Harvest)
- 🔄 Phase 3: Advanced Features (Weather, Maps, Reports)
- 📋 Phase 4: Cloud Integration (Backend API, Sync)
- 📋 Phase 5: Community Features (Marketplace, Social)

---

<div align="center">

**⭐ If you find this project helpful, please give it a star! ⭐**

Made with ❤️ and Flutter for Moroccan farmers 🇲🇦

**🌾 Mzra3ti - Your Farm in Your Pocket 🌾**

---

### Quick Links

[Documentation](#) • [Demo](#) • [Report Bug](#) • [Request Feature](#)

</div>
