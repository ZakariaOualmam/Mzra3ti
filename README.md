# 🌾 Mzra3ti - Professional Farm Management App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**A modern, professional farming management application built with Flutter**

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Usage](#-usage) • [Technical Details](#-technical-details)

</div>

---

## 📖 Overview

**Mzra3ti** (My Farm) is a comprehensive farm management application designed to help farmers efficiently manage their agricultural operations. The app provides an intuitive dashboard for tracking irrigation, expenses, harvests, and farm activities, with a focus on professional UI/UX and multilingual support.

### 🎯 Purpose

- **Simplify Farm Management**: Track all farm activities in one centralized location
- **Data-Driven Decisions**: Monitor expenses, revenue, and profit/loss reports
- **User-Friendly Interface**: Professional design with responsive layouts and smooth navigation
- **Multilingual Support**: Available in Arabic (Derija) and English
- **Accessibility**: Dark/light mode support for comfortable viewing in any environment

---

## ✨ Features

### 🔐 Authentication System

#### **Smart Login/Register Flow**
- **Before Login:**
  - Clean "Login or Register" button displayed in navigation drawer
  - New users can easily create accounts with name, email/phone, and password
  - Input validation for all fields (email format, password strength, matching passwords)
  
- **After Account Creation:**
  - ✅ Automatic login after successful registration
  - ✅ Login/register buttons completely hidden
  - ✅ Replaced with user account bar showing username and profile icon
  - ✅ Smooth navigation to dashboard with no back navigation to auth screens
  - ✅ Persistent login state across app restarts

#### **Professional Login Screen**
- Email/phone and password authentication
- Show/hide password toggle
- Dark mode toggle switch directly on login screen
- Form validation with localized error messages
- Smooth transitions and loading states

### 👤 User Profile Management

#### **Profile Page Features**
- **Profile Picture Management:**
  - Circular avatar with gradient background
  - First letter of username displayed as placeholder
  - Options to change picture (Gallery, Camera, Remove)
  
- **Personal Information Editing:**
  - Edit username with inline text fields
  - Edit email/phone number
  - Edit mode toggle with save button
  - Real-time validation and success/error notifications

- **Account Settings:**
  - Dark mode toggle switch
  - Language selector (English/Arabic dropdown)
  - Quick access to notifications settings
  - Change password option (placeholder for future implementation)
  
- **Danger Zone:**
  - Delete account with confirmation dialog
  - Warning message about permanent data deletion

### 🎨 Theme System

#### **Dark Mode / Light Mode Support**
- **Light Mode:**
  - Background: `#F5F5F5` (Clean light gray)
  - Surface: `#FAFAFA` (Soft white)
  - Primary: `#2E7D32` (Professional green)
  - Professional shadows and subtle borders

- **Dark Mode:**
  - Background: `#1C1C1E` (Deep dark gray)
  - Surface: `#2C2C2E` (Elevated dark gray)
  - Primary: `#81C784` (Lighter green for visibility)
  - Optimized contrast for readability

- **Theme Features:**
  - Smooth animated transitions (300ms)
  - Consistent color scheme across all screens
  - Material 3 design system
  - Theme persistence using SharedPreferences

### 📊 Dashboard & Home Screen

#### **Professional Welcome Card**
- **Before Login:** Generic welcome message
- **After Login:** Personalized greeting - "Welcome, [Username]"
- Dynamic icon and gradient background
- Theme-aware styling

#### **Dashboard Cards Grid**
- **Irrigation Management** - Track water usage and scheduling
- **Expense Tracking** - Monitor farm costs and spending
- **Harvest Records** - Record crop yields and revenue
- **Farm Management** - Add and manage multiple farms
- Clean 2-column grid layout with proper spacing
- Each card features:
  - Custom icon with circular background
  - Value display (quantity, amount, etc.)
  - Descriptive label
  - Tap navigation to respective screens

#### **Navigation Drawer**
- User profile header with avatar and account info
- Organized sections:
  - **Account Section**: Login/profile button (conditional)
  - **Main Navigation**: Irrigation, Expenses, Harvests, Farms, Weather
  - **Tools**: Journal, Reports
  - **Preferences**: Settings
- Logout button with confirmation dialog

### ⚙️ Settings Page

#### **Comprehensive Settings Options**
1. **Appearance Section:**
   - Dark mode toggle with moon/sun icon
   - Theme changes apply instantly across the app

2. **Accessibility Section:**
   - Large text option
   - High contrast mode
   - Voice feedback support
   - Professional icons and descriptions

3. **Notifications Section:** *(NEW)*
   - Enable/disable app notifications
   - Manage notification preferences

4. **Data & Sync Section:**
   - Data sync management
   - Backup and restore options

5. **Account Section:** *(NEW)*
   - Quick access to profile settings
   - Account management options

6. **About Section:**
   - App information
   - Version details
   - Support links

7. **Logout:**
   - Secure logout with confirmation dialog
   - Clears auth state and navigates to login

### 🌍 Language Support

#### **Bilingual Interface**
- **Arabic (Derija):** Full RTL support with native translations
- **English:** Complete localization for all UI elements
- **72+ Localization Keys** including:
  - Authentication screens (login, register, validation)
  - Profile management
  - Dashboard and navigation
  - Settings and preferences
  - Success/error messages
  
- Language persists across app sessions
- Instant language switching from profile or settings

### 📱 UI/UX Excellence

#### **Responsive Design**
- ✅ Overflow-free layouts with proper constraints
- ✅ Flexible widgets and SingleChildScrollView for scrollable content
- ✅ LayoutBuilder for adaptive sizing
- ✅ Professional spacing and alignment throughout
- ✅ Bottom padding to prevent content hiding under navigation bar

#### **Professional Polish**
- Material 3 design language
- Smooth animations and transitions (BouncingScrollPhysics)
- Consistent icon sizing and spacing
- Gradient backgrounds and shadow effects
- Theme-aware text colors and contrast
- Floating action buttons with proper elevation
- Card-based layouts with subtle borders

#### **Navigation Flow**
```
Splash Screen
    ↓
    ├─→ (Not Logged In) → Onboarding → Login/Register → Dashboard
    └─→ (Logged In) → Dashboard
                         ↓
                    Home Screen
                         ↓
        ┌────────────────┼────────────────┐
        ↓                ↓                ↓
    Profile Page    Settings Page    Feature Screens
    (User Data)    (Preferences)    (Irrigation, etc.)
```

---

## 🖼️ Screenshots

```
📸 Coming Soon
- Login Screen (Light/Dark)
- Dashboard (Light/Dark)
- Profile Page
- Settings Page
```

---

## 🚀 Installation

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Chrome, iOS Simulator, or Android Emulator

### Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/mzra3ti.git
   cd mzra3ti
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Localizations**
   ```bash
   flutter gen-l10n
   ```

4. **Run the App**
   ```bash
   # On Chrome (Web)
   flutter run -d chrome
   
   # On Android Emulator
   flutter run -d android
   
   # On iOS Simulator
   flutter run -d ios
   ```

---

## 📘 Usage

### First Time Setup

1. **Launch the App** - You'll see the splash screen with app branding
2. **Onboarding** - Swipe through feature introduction screens
3. **Create Account:**
   - Tap "Login or Register" in the drawer
   - Navigate to "Register" screen
   - Enter your name, email/phone, and password
   - Tap "Create Account"
   - ✅ Automatically logged in and redirected to dashboard

### Using the Dashboard

1. **View Quick Stats** - See irrigation, expenses, harvest, and farm counts
2. **Tap Cards** - Navigate to detailed screens for each category
3. **Access Drawer** - Swipe from right or tap menu icon
4. **Navigate Features** - Use drawer to access all app sections

### Managing Your Profile

1. **Access Profile:**
   - After login, tap your account bar in the drawer
   - Or navigate via Settings
   
2. **Edit Information:**
   - Tap the edit icon in the top-right
   - Modify username or email/phone
   - Tap the checkmark to save changes
   
3. **Change Theme:**
   - Toggle dark mode switch in profile
   - Theme applies instantly
   
4. **Switch Language:**
   - Select English or العربية from dropdown
   - All text updates immediately

### Testing Features

#### Test Login/Register Flow:
1. Logout from settings (if logged in)
2. Observe "Login or Register" button in drawer
3. Register a new account
4. Note automatic login and button disappearance
5. User account bar replaces login button

#### Test Theme Switching:
1. Go to Profile or Settings
2. Toggle dark mode switch
3. Observe instant theme change throughout app
4. Restart app - theme persists

#### Test Language Switching:
1. Open Profile page
2. Select language from dropdown
3. All text updates to selected language
4. Restart app - language persists

---

## 🔧 Technical Details

### Architecture

```
lib/
├── main.dart                          # App entry point
├── l10n/                              # Localization files
│   ├── app_en.arb                     # English translations
│   ├── app_ar.arb                     # Arabic translations
│   └── app_localizations.dart         # Generated localizations
├── src/
│   ├── app.dart                       # MaterialApp configuration
│   ├── core/
│   │   ├── constants.dart             # App constants
│   │   └── styles.dart                # Theme definitions
│   ├── services/
│   │   ├── user_service.dart          # Authentication & user data
│   │   ├── theme_service.dart         # Theme management
│   │   └── language_service.dart      # Language management
│   └── features/
│       ├── auth/                      # Authentication screens
│       │   └── presentation/
│       │       └── screens/
│       │           ├── login_screen.dart
│       │           └── register_screen.dart
│       ├── profile/                   # Profile management
│       │   └── presentation/
│       │       └── screens/
│       │           └── profile_screen.dart
│       ├── settings/                  # Settings screens
│       ├── expenses/                  # Dashboard & expenses
│       ├── irrigation/                # Irrigation management
│       ├── harvest/                   # Harvest tracking
│       ├── farms/                     # Farm management
│       ├── journal/                   # Farm journal
│       ├── reports/                   # Reports & analytics
│       └── weather/                   # Weather information
```

### Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.0.0
  
  # Local Storage
  shared_preferences: ^2.0.15
  
  # Localization
  flutter_localizations:
    sdk: flutter
  intl: any
  
  # UI Components
  flutter_svg: ^2.0.0
  file_picker: ^8.1.6
  
  # Platform
  flutter:
    sdk: flutter
```

### State Management

**Provider Pattern:**
- `ThemeService` - Manages theme state (light/dark mode)
- `LanguageService` - Manages locale state (Arabic/English)
- `UserService` - Manages authentication and user data

**Data Persistence:**
- SharedPreferences for:
  - User authentication state
  - Theme preference
  - Language selection
  - User profile data

### Navigation System

**Route-Based Navigation:**
```dart
routes: {
  '/': SplashScreen,
  '/onboarding': OnboardingScreen,
  '/login': LoginScreen,
  '/register': RegisterScreen,
  '/profile': ProfileScreen,
  '/home': HomeScreen,
  '/settings': SettingsScreen,
  // ... other feature routes
}
```

**Navigation Patterns:**
- `pushNamed()` - Standard forward navigation
- `pushReplacementNamed()` - Replace current screen
- `pushNamedAndRemoveUntil()` - Clear navigation stack (used post-login)
- `pop()` - Go back

### Authentication Flow

1. **App Launch:**
   - SplashScreen checks `UserService.isLoggedIn()`
   - Routes to `/home` if logged in, `/onboarding` if not

2. **Registration:**
   - Validate all inputs
   - Save user data to SharedPreferences
   - Set `isLoggedIn = true`
   - Navigate to `/home` with `pushNamedAndRemoveUntil()`

3. **Login:**
   - Validate credentials against stored data
   - Set `isLoggedIn = true`
   - Navigate to `/home` with `pushNamedAndRemoveUntil()`

4. **Logout:**
   - Set `isLoggedIn = false`
   - Clear navigation stack
   - Navigate to `/login`

### Conditional UI Rendering

**Account Section in Drawer:**
```dart
FutureBuilder<bool>(
  future: UserService().isLoggedIn(),
  builder: (context, snapshot) {
    if (snapshot.data == true) {
      // Show user account bar with name/email
      return UserAccountTile();
    } else {
      // Show login/register button
      return LoginButton();
    }
  }
)
```

**Welcome Card:**
```dart
FutureBuilder<bool>(
  future: UserService().isLoggedIn(),
  builder: (context, snapshot) {
    if (snapshot.data == true) {
      // Show personalized welcome: "Welcome, Ahmed"
      return PersonalizedWelcome();
    } else {
      // Show generic welcome message
      return GenericWelcome();
    }
  }
)
```

### Theme Implementation

**Light Theme:**
```dart
ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Color(0xFFF5F5F5),
    surface: Color(0xFFFAFAFA),
    primary: Color(0xFF2E7D32),
    // ... other colors
  ),
)
```

**Dark Theme:**
```dart
ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color(0xFF1C1C1E),
    surface: Color(0xFF2C2C2E),
    primary: Color(0xFF81C784),
    // ... other colors
  ),
)
```

### Localization Setup

**Configuration (`l10n.yaml`):**
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

**Usage in Code:**
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.welcome);  // Outputs: "Welcome" or "مرحبا"
```

---

## 🎯 Implementation Highlights

### Bottom Overflow Fixes
- Used `LayoutBuilder` for responsive button sizing
- Added `Flexible` widgets to prevent overflow
- Implemented `SingleChildScrollView` with proper padding
- Bottom padding adjusted to `90px` to clear floating buttons

### Dashboard Color Adjustments
- Replaced hardcoded white colors with theme variables
- Updated `dashboard_card.dart` to use `theme.colorScheme`
- Professional color palette for light/dark modes
- Gradient backgrounds for profile avatars

### Settings Page Enhancement
- Added 6+ organized sections with icons
- Professional card-based layout
- Notification preferences section
- Account management section
- Logout with confirmation dialog

### Profile Page Innovation
- Circular gradient avatar with first letter
- Inline editing mode with toggle
- Modal bottom sheet for profile picture options
- Real-time validation and feedback
- Delete account with safety confirmation

---

## 🛠️ Development

### Running Tests
```bash
flutter test
```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

---

## 📝 Future Enhancements

- [ ] Backend API integration for user authentication
- [ ] Cloud sync for farm data
- [ ] Real-time weather API integration
- [ ] Export reports to PDF
- [ ] WhatsApp sharing for reports
- [ ] Camera integration for profile pictures
- [ ] Push notifications
- [ ] Offline mode with SQLite
- [ ] Multi-farm support with switching
- [ ] Expense category analytics

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Your Name**
- GitHub: [@zakariaoualmam](https://github.com/yourusername)
- Email: zakariaoualmam9@gmail.com

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI/UX guidelines
- The open-source community for packages and resources

---

<div align="center">

**⭐ If you find this project helpful, please consider giving it a star! ⭐**

Made with ❤️ and Flutter

</div>
