import 'package:flutter/material.dart';
import '../../../../../../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../core/styles.dart';
import '../../../../core/voice_hints.dart';
import '../../../../services/theme_service.dart';
import '../../../../services/user_service.dart';
import '../../data/settings_repository.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _repo = SettingsRepository();

  bool _offlineMode = false;
  bool _largeText = false;
  bool _highContrast = false;
  bool _voiceFeedback = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final offline = await _repo.get<bool>('offlineMode', false);
    final large = await _repo.get<bool>('largeText', false);
    final contrast = await _repo.get<bool>('highContrast', false);
    final voice = await _repo.get<bool>('voiceFeedback', false);

    setState(() {
      _offlineMode = offline ?? true;
      _largeText = large ?? true;
      _highContrast = contrast ?? false;
      _voiceFeedback = voice ?? false;
    });

    // Ensure runtime VoiceHints reflects persisted setting
    VoiceHints.instance.enabled = _voiceFeedback;
  }

  Future<void> _save(String key, dynamic value) async {
    await _repo.set(key, value);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.saveSettings}…')));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.primary,
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        scrolledUnderElevation: 3,
        shadowColor: theme.colorScheme.primary.withOpacity(0.3),
        centerTitle: true,
        title: Text(
          l10n.settingsTitle,
          style: TextStyle(
            color: AppStyles.brandWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppStyles.brandIconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: AppStyles.brandWhite, size: 24),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: l10n.backTooltip,
            padding: EdgeInsets.zero,
          ),
        ),
        iconTheme: IconThemeData(color: AppStyles.brandWhite),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // Appearance Section
              _buildSectionHeader(l10n.appearance ?? 'Appearance', Icons.palette_outlined, theme),
              SizedBox(height: 8),
              _buildCard(
                theme,
                child: Column(
                  children: [
                    Consumer<ThemeService>(
                      builder: (context, themeService, _) => SwitchListTile(
                        title: Text(l10n.darkMode, style: theme.textTheme.bodyLarge),
                        subtitle: Text(
                          themeService.isDarkMode 
                            ? l10n.darkModeOn ?? 'Dark theme active' 
                            : l10n.darkModeOff ?? 'Light theme active',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        value: themeService.isDarkMode,
                        secondary: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        onChanged: (v) => themeService.toggleTheme(),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Accessibility Section
              _buildSectionHeader(l10n.accessibilityTitle, Icons.accessibility_new, theme),
              SizedBox(height: 8),
              _buildCard(
                theme,
                child: Column(
                  children: [
                    _buildSwitchTile(
                      theme,
                      title: l10n.largeText,
                      subtitle: l10n.largeTextSubtitle,
                      icon: Icons.text_fields,
                      value: _largeText,
                      onChanged: (v) {
                        setState(() => _largeText = v);
                        _save('largeText', v);
                      },
                    ),
                    Divider(height: 1),
                    _buildSwitchTile(
                      theme,
                      title: l10n.highContrast,
                      subtitle: l10n.highContrastSubtitle,
                      icon: Icons.contrast,
                      value: _highContrast,
                      onChanged: (v) {
                        setState(() => _highContrast = v);
                        _save('highContrast', v);
                      },
                    ),
                    Divider(height: 1),
                    _buildSwitchTile(
                      theme,
                      title: l10n.voiceFeedback,
                      subtitle: l10n.voiceFeedbackSubtitle,
                      icon: Icons.record_voice_over,
                      value: _voiceFeedback,
                      onChanged: (v) {
                        setState(() => _voiceFeedback = v);
                        _save('voiceFeedback', v);
                        VoiceHints.instance.enabled = v;
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Notifications Section
              _buildSectionHeader(l10n.notifications, Icons.notifications_outlined, theme),
              SizedBox(height: 8),
              _buildCard(
                theme,
                child: Column(
                  children: [
                    _buildSwitchTile(
                      theme,
                      title: l10n.pushNotifications,
                      subtitle: l10n.pushNotificationsSubtitle,
                      icon: Icons.notifications_active,
                      value: true,
                      onChanged: (v) {},
                    ),
                    Divider(height: 1),
                    _buildSwitchTile(
                      theme,
                      title: l10n.irrigationReminders,
                      subtitle: l10n.irrigationRemindersSubtitle,
                      icon: Icons.water_drop_rounded,
                      value: true,
                      onChanged: (v) {},
                    ),
                    Divider(height: 1),
                    _buildSwitchTile(
                      theme,
                      title: l10n.harvestAlerts,
                      subtitle: l10n.harvestAlertsSubtitle,
                      icon: Icons.agriculture_rounded,
                      value: false,
                      onChanged: (v) {},
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Data & Sync Section
              _buildSectionHeader(l10n.operational, Icons.cloud_outlined, theme),
              SizedBox(height: 8),
              _buildCard(
                theme,
                child: Column(
                  children: [
                    _buildSwitchTile(
                      theme,
                      title: l10n.offlineMode,
                      subtitle: l10n.offlineModeSubtitle,
                      icon: Icons.cloud_off,
                      value: _offlineMode,
                      onChanged: (v) {
                        setState(() => _offlineMode = v);
                        _save('offlineMode', v);
                      },
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.sync, color: Colors.blue),
                      ),
                      title: Text(l10n.syncData, style: theme.textTheme.bodyLarge),
                      subtitle: Text(l10n.lastSynced, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Farm Information Section
              _buildSectionHeader(AppLocalizations.of(context)!.farmInformation, Icons.agriculture_rounded, theme),
              SizedBox(height: 8),
              _buildCard(
                theme,
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.landscape, color: Colors.green),
                      ),
                      title: Text(AppLocalizations.of(context)!.farmData, style: theme.textTheme.bodyLarge),
                      subtitle: Text(AppLocalizations.of(context)!.farmInfo, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                      onTap: () {
                        Navigator.of(context).pushNamed('/farm-settings');
                      },
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.brown.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.terrain, color: Colors.brown),
                      ),
                      title: Text(AppLocalizations.of(context)!.landAndPlots, style: theme.textTheme.bodyLarge),
                      subtitle: Text(AppLocalizations.of(context)!.divideFarmIntoPlots, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                      onTap: () {
                        Navigator.of(context).pushNamed('/land-management');
                      },
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.water, color: Colors.amber.shade700),
                      ),
                      title: Text(AppLocalizations.of(context)!.waterSources, style: theme.textTheme.bodyLarge),
                      subtitle: Text(AppLocalizations.of(context)!.wellsTanksIrrigation, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                      onTap: () {
                        Navigator.of(context).pushNamed('/water-sources');
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Account Section
              _buildSectionHeader(l10n.account, Icons.person_outline, theme),
              SizedBox(height: 8),
              _buildCard(
                theme,
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.person, color: theme.colorScheme.primary),
                      ),
                      title: Text(l10n.profileSettings, style: theme.textTheme.bodyLarge),
                      subtitle: Text(l10n.profileSettingsSubtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                      onTap: () {},
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.language, color: Colors.orange),
                      ),
                      title: Text(l10n.language, style: theme.textTheme.bodyLarge),
                      subtitle: Text(l10n.languageSubtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                      onTap: () {},
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.security, color: Colors.purple),
                      ),
                      title: Text(l10n.privacySecurity, style: theme.textTheme.bodyLarge),
                      subtitle: Text(l10n.privacySecuritySubtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // About Section
              _buildSectionHeader(l10n.about, Icons.info_outline, theme),
              SizedBox(height: 8),
              _buildCard(
                theme,
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.help_outline, color: Colors.teal),
                      ),
                      title: Text(l10n.help, style: theme.textTheme.bodyLarge),
                      subtitle: Text(l10n.helpSubtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.helpContact),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.agriculture_rounded, color: Colors.green),
                      ),
                      title: Text(l10n.aboutApp, style: theme.textTheme.bodyLarge),
                      subtitle: Text(l10n.aboutAppSubtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Row(
                              children: [
                                Icon(Icons.agriculture_rounded, color: theme.colorScheme.primary),
                                SizedBox(width: 8),
                                Text(l10n.appNameAlt),
                              ],
                            ),
                            content: Text(
                              '${l10n.aboutAppDescription}\n\n${l10n.versionLabel}: 1.0.0\n\n${l10n.copyrightText}',
                              style: TextStyle(fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(l10n.okButton),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Danger Zone
              _buildCard(
                theme,
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.logout, color: Colors.red),
                  ),
                  title: Text(l10n.logoutTitle, style: theme.textTheme.bodyLarge?.copyWith(color: Colors.red)),
                  subtitle: Text(l10n.logoutSubtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l10n.logoutTitle),
                        content: Text(l10n.logoutConfirm),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(l10n.cancelButton),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: Text(l10n.logoutButton),
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
                ),
              ),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(ThemeData theme, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSwitchTile(
    ThemeData theme, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: theme.textTheme.bodyLarge),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      value: value,
      secondary: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: value 
            ? theme.colorScheme.primaryContainer 
            : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: value 
            ? theme.colorScheme.primary 
            : theme.colorScheme.onSurfaceVariant,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
