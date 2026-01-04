import 'package:flutter/material.dart';
import '../../../../../../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../core/styles.dart';
import '../../../../core/app_icons.dart';
import '../../../../core/voice_hints.dart';
import '../../../../services/language_service.dart';
import '../../../../services/theme_service.dart';
import '../../../../services/user_service.dart';
import '../../../../shared/widgets/dashboard_card.dart';
import '../../../../shared/widgets/padded_fab.dart';
import '../../../irrigation/data/irrigation_repository.dart';
import '../../data/expense_repository.dart';
import '../../../harvest/data/harvest_repository.dart';
import '../../../sales/data/sales_repository.dart';

class Mzra3tiHomeScreen extends StatefulWidget {
  const Mzra3tiHomeScreen({Key? key}) : super(key: key);

  @override
  State<Mzra3tiHomeScreen> createState() => _Mzra3tiHomeScreenState();
}

class _Mzra3tiHomeScreenState extends State<Mzra3tiHomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String _currentLanguage = 'العربية';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Track which notification types are visible (by type: 'irrigation', 'expense', 'harvest')
  Set<String> _visibleNotifications = {'irrigation', 'expense', 'harvest'};
  
  // Repositories for real-time data
  final irrigationRepo = IrrigationRepository();
  final expenseRepo = ExpenseRepository();
  final harvestRepo = HarvestRepository();
  final salesRepo = SalesRepository();
  
  // Key to force rebuild of statistics
  Key _statsKey = UniqueKey();
  
  // Animation controller for smooth transitions
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Force refresh when returning to this screen
    setState(() {
      _statsKey = UniqueKey();
    });
    // Restart animation
    _animationController.reset();
    _animationController.forward();
  }

  void _showAddMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Color(0xFF2C2C2E), Color(0xFF1C1C1E)]
                : AppStyles.whiteGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: AppStyles.deepShadow,
        ),
        padding: EdgeInsets.only(
          top: 12,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(height: 24),
            Text(
              l10n.addShort,
              style: TextStyle(
                fontSize: 28, // Larger
                fontWeight: FontWeight.w900,
                color: isDarkMode ? Colors.white : Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 24),

            // Premium large buttons with gradients
            _buildAddButton(
              ctx,
              icon: Icons.water_drop_rounded,
              label: l10n.irrigationShort,
              gradient: AppStyles.blueGradient,
              onPressed: () => Navigator.of(ctx).pushNamed('/irrigations'),
            ),
            SizedBox(height: 16),
            _buildAddButton(
              ctx,
              icon: Icons.attach_money,
              label: l10n.expensesShort,
              gradient: [
                Color(0xFFF59E0B), // Amber 500
                Color(0xFFD97706), // Amber 600
                Color(0xFFB45309), // Amber 700
              ],
              onPressed: () => Navigator.of(ctx).pushNamed('/expenses'),
            ),
            SizedBox(height: 16),
            _buildAddButton(
              ctx,
              icon: Icons.trending_up,
              label: l10n.profitShort,
              gradient: AppStyles.greenGradient,
              onPressed: () => Navigator.of(ctx).pushNamed('/harvests'),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 72, // Larger touch target
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppStyles.premiumCardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 32, // Larger
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 20, // Larger
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernDrawer(BuildContext context) {
    final green = AppStyles.primaryGreen;
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Color(0xFF1C1C1E), Color(0xFF2C2C2E)]
                : AppStyles.whiteGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
            // Header with profile/account section
            FutureBuilder<Map<String, dynamic>?>(
              future: UserService().getCurrentUser(),
              builder: (context, snapshot) {
                final userData = snapshot.data;
                final isLoggedIn = userData != null;
                final userName = userData?['name'] ?? l10n.guest;
                final userEmail = userData?['emailOrPhone'] ?? l10n.noAccountHelperText;

                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppStyles.greenGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: AppStyles.deepShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.person, color: Colors.white, size: 48), // Larger
                      ),
                      SizedBox(height: 16),
                      Text(
                        userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24, // Larger
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        isLoggedIn ? userEmail : l10n.guest,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 16, // Larger
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 16),
                children: [
                  // Account Section - Conditional based on auth status
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      l10n.myAccount,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  FutureBuilder<bool>(
                    future: UserService().isLoggedIn(),
                    builder: (context, snapshot) {
                      final isLoggedIn = snapshot.data ?? false;
                      
                      if (!isLoggedIn) {
                        // Show login/register buttons when not logged in
                        return Column(
                          children: [
                            _buildDrawerItem(
                              icon: Icons.login,
                              title: l10n.loginOrRegister,
                              subtitle: l10n.loginSubtitle,
                              iconColor: Colors.blue.shade600,
                              onTap: () => Navigator.of(context).pushNamed('/login'),
                            ),
                          ],
                        );
                      } else {
                        // Show user account bar when logged in
                        return FutureBuilder<Map<String, dynamic>?>(
                          future: UserService().getCurrentUser(),
                          builder: (context, userSnapshot) {
                            final user = userSnapshot.data;
                            final userName = user?['name'] ?? l10n.guest;
                            final userEmail = user?['emailOrPhone'] ?? '';
                            
                            return _buildDrawerItem(
                              icon: Icons.account_circle,
                              title: userName,
                              subtitle: userEmail,
                              iconColor: Theme.of(context).colorScheme.primary,
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed('/profile');
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                  
                  Divider(height: 32, thickness: 1),

                  // Preferences Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      l10n.preferences,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Consumer<ThemeService>(
                    builder: (context, themeService, _) => _buildDrawerSwitchItem(
                      icon: themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      title: l10n.darkMode,
                      subtitle: themeService.isDarkMode ? 'On' : 'Off',
                      iconColor: themeService.isDarkMode ? Colors.indigo.shade400 : Colors.amber.shade700,
                      value: themeService.isDarkMode,
                      onChanged: (val) => themeService.toggleTheme(),
                    ),
                  ),
                  _buildDrawerItem(
                    icon: Icons.language,
                    title: l10n.language,
                    subtitle: _currentLanguage,
                    iconColor: Colors.purple.shade600,
                    onTap: () => _showLanguageDialog(context),
                  ),
                  _buildDrawerItem(
                    icon: Icons.build_rounded,
                    title: l10n.equipmentManagement,
                    subtitle: l10n.equipmentSubtitle,
                    iconColor: Colors.brown.shade600,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/equipment');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.event_rounded,
                    title: l10n.cropCalendar,
                    subtitle: l10n.cropCalendarSubtitle,
                    iconColor: Colors.green.shade700,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/crop-calendar');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.notifications_active,
                    title: l10n.notificationsMenu,
                    subtitle: l10n.notificationsSubtitle,
                    iconColor: Colors.red.shade600,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/notifications');
                    },
                  ),

                  Divider(height: 32, thickness: 1),

                  // Support Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      l10n.support,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    icon: Icons.bar_chart_rounded,
                    title: l10n.analytics,
                    subtitle: l10n.analyticsSubtitle,
                    iconColor: Colors.purple.shade600,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/analytics');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.shopping_cart,
                    title: l10n.sales,
                    subtitle: l10n.salesSubtitle,
                    iconColor: Colors.orange.shade700,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/sales');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_outline,
                    title: l10n.help,
                    subtitle: l10n.feedback,
                    iconColor: Colors.orange.shade600,
                    onTap: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.helpContact),
                          duration: Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(label: 'حسناً', onPressed: () {}),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.info_outline,
                    title: l10n.aboutApp,
                    subtitle: 'v1.0.0',
                    iconColor: Colors.teal.shade600,
                    onTap: () {
                      Navigator.of(context).pop();
                      final dialogL10n = AppLocalizations.of(context)!;
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Row(
                            children: [
                              Icon(Icons.agriculture_rounded, color: AppStyles.primaryGreen),
                              SizedBox(width: 8),
                              Text(dialogL10n.appNameAlt),
                            ],
                          ),
                          content: Text(
                            '${dialogL10n.aboutAppDescription}\n\n${dialogL10n.versionLabel}: 1.0.0\n\n${dialogL10n.copyrightText}',
                            style: TextStyle(fontSize: 16),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: Text(dialogL10n.okButton),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.feedback_outlined,
                    title: l10n.feedback,
                    subtitle: l10n.aboutApp,
                    iconColor: Colors.pink.shade600,
                    onTap: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.feedbackThanks),
                          duration: Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Logout button at bottom
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l10n.logout),
                        content: Text(l10n.logoutConfirm),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(l10n.cancelButton),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600),
                            child: Text(l10n.logout),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && mounted) {
                      // Logout user
                      final userService = UserService();
                      await userService.logout();
                      
                      // Navigate to login and clear stack
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login',
                        (route) => false,
                      );
                    }
                  },
                  icon: Icon(Icons.logout, size: 24),
                  label: Text(l10n.logout, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            )
          : null,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: iconColor.withOpacity(0.05),
    );
  }

  Widget _buildDrawerSwitchItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            )
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: iconColor,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.language, color: Colors.purple.shade600),
            SizedBox(width: 12),
            Text(
              l10n.selectLanguage,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(l10n.darija, 'ar', languageService),
            _buildLanguageOption(l10n.english, 'en', languageService),
            _buildLanguageOption(l10n.french, 'fr', languageService),
          ],
        ),
      ),
    );
  }

  void _showNotificationsDrawer() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          final l10n = AppLocalizations.of(context)!;
          final notifications = _getLocalizedNotifications(context)
              .where((n) => _visibleNotifications.contains(n['type']))
              .toList();
          
          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) => Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade900 : Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.notifications, color: Colors.red.shade600, size: 24),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.notificationsTitle,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : Colors.black87,
                                  ),
                                ),
                                Text(
                                  '${notifications.length} ${l10n.notifications}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _visibleNotifications.clear();
                            });
                            setModalState(() {});
                            Navigator.pop(context);
                          },
                          child: Text(l10n.deleteNotification, style: TextStyle(color: Colors.red.shade600)),
                        ),
                      ],
                    ),
                  ),
                  
                  Divider(height: 1),
                  
                  // Notifications list
                  Expanded(
                    child: notifications.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.notifications_off, size: 64, color: Colors.grey.shade400),
                                SizedBox(height: 16),
                                Text(
                                  l10n.noNotifications,
                                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            controller: scrollController,
                            padding: EdgeInsets.all(16),
                            itemCount: notifications.length,
                            separatorBuilder: (context, index) => SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              return _buildNotificationCard(notification, setModalState);
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, StateSetter setModalState) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (notification['color'] as Color).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (notification['color'] as Color).withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            notification['icon'] as IconData,
            color: notification['color'] as Color,
            size: 28,
          ),
        ),
        title: Text(
          notification['title'] as String,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            Text(
              notification['message'] as String,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
                SizedBox(width: 4),
                Text(
                  notification['time'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.close, color: Colors.grey.shade400),
          onPressed: () {
            setState(() {
              _visibleNotifications.remove(notification['type']);
            });
            setModalState(() {});
            if (_visibleNotifications.isEmpty) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language, String code, LanguageService languageService) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isSelected = languageService.locale.languageCode == code;
    return ListTile(
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? AppStyles.primaryGreen : Colors.grey,
      ),
      title: Text(
        language,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      onTap: () {
        languageService.changeLanguage(code);
        setState(() => _currentLanguage = language);
        Navigator.pop(context);
      },
    );
  }

  // Helper method to get current notifications with localized strings
  List<Map<String, dynamic>> _getLocalizedNotifications(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return [
      {
        'title': l10n.newIrrigationNotification,
        'message': l10n.irrigationNotificationDesc,
        'type': 'irrigation',
        'icon': Icons.water_drop_rounded,
        'color': Colors.blue,
        'time': '1h',
      },
      {
        'title': l10n.newExpenseNotification,
        'message': l10n.expenseNotificationDesc,
        'type': 'expense',
        'icon': Icons.attach_money,
        'color': Colors.orange,
        'time': '3h',
      },
      {
        'title': l10n.newHarvestNotification,
        'message': l10n.harvestNotificationDesc,
        'type': 'harvest',
        'icon': Icons.check_circle,
        'color': Colors.green,
        'time': '1d',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final green = AppStyles.primaryGreen;
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: _buildModernDrawer(context),
      appBar: AppBar(
        backgroundColor: Color(0xFF059669),
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(top: 6),
          child: Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.white, size: 26),
                onPressed: () => _showNotificationsDrawer(),
                tooltip: l10n.notifications,
              ),
              if (_visibleNotifications.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '${_visibleNotifications.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
        title: Text(
          l10n.appName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white, size: 26),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Color(0xFF1C1C1E), Color(0xFF2C2C2E)]
                : AppStyles.whiteGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              left: 20,
              top: 16,
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 90, // Account for FAB + bottom nav
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F8F4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pushNamed('/weather'),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFD4EDE0),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.wb_sunny_rounded,
                                  color: Color(0xFF10B981),
                                  size: 28,
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '29°☀️',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                                height: 1.0,
                              ),
                            ),
                            SizedBox(height: 0),
                            Text(
                              'الطقس مشمس اليوم',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF9CA3AF),
                                height: 1.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'مرحبا 👋',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1F2937),
                                    height: 1.0,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'نظرة سريعة على مزرعتك اليوم',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF6B7280),
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 16),
                
                // Statistics Cards Grid - احترافي ونظيف
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Responsive grid: 2 columns on mobile, 3 on tablet, 4 on desktop
                    final crossAxisCount = constraints.maxWidth > 1024
                        ? 4
                        : constraints.maxWidth > 768
                            ? 3
                            : 2;
                    return GridView.count(
                      key: _statsKey,
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.15,
                      children: [
                    FutureBuilder<double>(
                      future: harvestRepo.totalRevenue(),
                      builder: (context, snapshot) {
                        final total = snapshot.data ?? 0.0;
                        return _buildStatCard(
                          title: l10n.harvestTitle,
                          value: 'DH ${total.toStringAsFixed(0)}',
                          icon: Icons.agriculture_rounded,
                          color: Color(0xFF66BB6A),
                          onTap: () async {
                            await Navigator.of(context).pushNamed('/harvests');
                            setState(() => _statsKey = UniqueKey());
                          },
                        );
                      },
                    ),
                    FutureBuilder<int>(
                      future: irrigationRepo.getAll().then((list) => list.length),
                      builder: (context, snapshot) {
                        final count = snapshot.data ?? 0;
                        return _buildStatCard(
                          title: l10n.irrigation,
                          value: 'DH $count',
                          icon: Icons.water_drop_rounded,
                          color: Color(0xFF2196F3),
                          onTap: () async {
                            await Navigator.of(context).pushNamed('/irrigations');
                            setState(() => _statsKey = UniqueKey());
                          },
                        );
                      },
                    ),
                    FutureBuilder<double>(
                      future: salesRepo.totalRevenue(),
                      builder: (context, snapshot) {
                        final total = snapshot.data ?? 0.0;
                        return _buildStatCard(
                          title: l10n.sales,
                          value: 'DH ${total.toStringAsFixed(0)}',
                          icon: Icons.shopping_bag_rounded,
                          color: Color(0xFF66BB6A),
                          onTap: () async {
                            await Navigator.of(context).pushNamed('/sales');
                            setState(() => _statsKey = UniqueKey());
                          },
                        );
                      },
                    ),
                    FutureBuilder<double>(
                      future: expenseRepo.total(),
                      builder: (context, snapshot) {
                        final total = snapshot.data ?? 0.0;
                        return _buildStatCard(
                          title: l10n.expenses,
                          value: 'DH ${total.toStringAsFixed(0)}',
                          icon: Icons.account_balance_wallet_rounded,
                          color: Color(0xFFFFA726),
                          onTap: () async {
                            await Navigator.of(context).pushNamed('/expenses');
                            setState(() => _statsKey = UniqueKey());
                          },
                        );
                      },
                    ),
                  ],
                    );
                  },
                ),

                SizedBox(height: 16),
                
                // Quick Actions - أزرار سريعة
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickAction(
                        icon: Icons.bar_chart,
                        label: l10n.analytics,
                        color: Color(0xFF3F7F57),
                        onTap: () => Navigator.of(context).pushNamed('/analytics'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickAction(
                        icon: Icons.calendar_month_rounded,
                        label: l10n.calendar,
                        color: Color(0xFF3F7F57),
                        onTap: () => Navigator.of(context).pushNamed('/crop-calendar'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickAction(
                        icon: Icons.build_rounded,
                        label: l10n.equipment,
                        color: Color(0xFF3F7F57),
                        onTap: () => Navigator.of(context).pushNamed('/equipment'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    floatingActionButton: Container(
        height: 80, // Larger
        width: 80, // Larger
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: AppStyles.greenGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: AppStyles.deepShadow,
        ),
        child: FloatingActionButton(
          onPressed: () {
            VoiceHints.instance.speak(l10n.addShort);
            _showAddMenu(context);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 40, // Much larger
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 12,
            elevation: 0,
            color: Colors.transparent,
            height: 70,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomNavItem(
                    icon: Icons.home,
                    label: l10n.home,
                    isSelected: true,
                    onTap: () {},
                  ),
                  _buildBottomNavItem(
                    icon: Icons.water_drop,
                    label: l10n.irrigation,
                    isSelected: false,
                    onTap: () => Navigator.of(context).pushNamed('/irrigations'),
                  ),
                  SizedBox(width: 64), // Space for FAB
                  _buildBottomNavItem(
                    icon: Icons.description,
                    label: 'التقارير',
                    isSelected: false,
                    onTap: () => Navigator.of(context).pushNamed('/reports'),
                  ),
                  _buildBottomNavItem(
                    icon: Icons.settings,
                    label: l10n.settings,
                    isSelected: false,
                    onTap: () => Navigator.of(context).pushNamed('/settings'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final emeraldGreen = Color(0xFF059669);
    final blueColor = Color(0xFF2196F3);
    final greenColor = Color(0xFF3F7F57);
    
    // Determine color based on label
    Color itemColor;
    if (label == AppLocalizations.of(context)!.irrigation) {
      itemColor = blueColor;
    } else {
      itemColor = emeraldGreen;
    }
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
            decoration: isSelected
                ? BoxDecoration(
                    color: itemColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  )
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: label == AppLocalizations.of(context)!.irrigation
                      ? blueColor
                      : label == 'التقارير'
                          ? greenColor
                          : label == AppLocalizations.of(context)!.analytics
                              ? emeraldGreen
                              : label == AppLocalizations.of(context)!.settings
                                  ? (isDark ? Colors.grey.shade300 : Colors.grey.shade700)
                                  : (isSelected
                                      ? emeraldGreen
                                      : (isDark ? Colors.grey.shade300 : Colors.grey.shade700)),
                ),
                SizedBox(height: 1),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? emeraldGreen
                        : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // بطاقة كبيرة للعمليات الأساسية
  Widget _buildBigActionCard({
    required IconData icon,
    required String emoji,
    required String label,
    required String count,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(isDark ? 0.6 : 0.7),
              color.withOpacity(isDark ? 0.8 : 0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji كبير
            Text(
              emoji,
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 12),
            // العدد
            Text(
              count,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            // الاسم
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.95),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // عنصر للملخص المالي
  Widget _buildMoneyItem(String label, String amount, IconData icon, Color textColor) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: textColor, size: 28),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // زر القائمة البسيط
  Widget _buildSimpleMenuButton({
    required IconData icon,
    required String emoji,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon دائري
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Text(
                emoji,
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(width: 16),
            // النص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // سهم
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark 
                ? Colors.black.withOpacity(0.2)
                : color.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with subtle background
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(isDark ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: isDark ? color.withOpacity(0.9) : color,
                ),
              ),
              SizedBox(height: 12),
              // Value
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              // Label
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.surfaceVariant,
          foregroundColor: theme.colorScheme.onSurfaceVariant,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: theme.colorScheme.outlineVariant.withOpacity(0.5),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 26,
                ),
              ),
              SizedBox(height: 7),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                  height: 1.0,
                ),
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  height: 1.0,
                ),
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xFFDEF3E8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Color(0xFF3F7F57),
              size: 28,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E2E2E),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
