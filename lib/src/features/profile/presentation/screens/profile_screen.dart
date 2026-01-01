import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../services/user_service.dart';
import '../../../../services/theme_service.dart';
import '../../../../services/language_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _userService.getCurrentUser();
      if (mounted) {
        setState(() {
          _userData = user;
          _usernameController.text = user?['name'] ?? '';
          _phoneController.text = user?['emailOrPhone'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_usernameController.text.trim().isEmpty) {
      _showMessage(AppLocalizations.of(context)!.nameRequired, isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedUser = {
        'name': _usernameController.text.trim(),
        'emailOrPhone': _phoneController.text.trim(),
      };
      
      await _userService.updateUser(updatedUser);
      
      if (mounted) {
        setState(() {
          _userData = updatedUser;
          _isEditing = false;
          _isLoading = false;
        });
        _showMessage(AppLocalizations.of(context)!.updateSuccess);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showMessage(AppLocalizations.of(context)!.updateError, isError: true);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccount),
        content: Text(l10n.deleteAccountWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              await _userService.clearUserData();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: Theme.of(context).colorScheme.primary),
                title: Text(l10n.chooseFromGallery),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement gallery picker
                  _showMessage('Gallery picker - Coming soon!');
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: Theme.of(context).colorScheme.primary),
                title: Text(l10n.takePhoto),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement camera
                  _showMessage('Camera - Coming soon!');
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(l10n.removePhoto),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement remove photo
                  _showMessage('Photo removed');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final themeService = Provider.of<ThemeService>(context);
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.profileTitle,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.check, color: theme.colorScheme.primary),
              onPressed: _isLoading ? null : _updateProfile,
            )
          else
            IconButton(
              icon: Icon(Icons.edit, color: theme.colorScheme.primary),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Picture Section
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _userData?['name']?.substring(0, 1).toUpperCase() ?? 'U',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showImagePickerOptions,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.colorScheme.surface,
                                  width: 3,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  // Personal Information Section
                  _buildSectionHeader(l10n.personalInformation, Icons.person),
                  SizedBox(height: 16),
                  
                  _buildInfoCard(
                    icon: Icons.person_outline,
                    label: l10n.username,
                    controller: _usernameController,
                    enabled: _isEditing,
                  ),
                  SizedBox(height: 12),
                  
                  _buildInfoCard(
                    icon: Icons.email_outlined,
                    label: l10n.email,
                    controller: _phoneController,
                    enabled: _isEditing,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 32),

                  // Account Settings Section
                  _buildSectionHeader(l10n.accountSettings, Icons.settings),
                  SizedBox(height: 16),

                  _buildSettingTile(
                    icon: Icons.dark_mode_outlined,
                    title: l10n.darkMode,
                    trailing: Switch(
                      value: themeService.isDarkMode,
                      onChanged: (_) => themeService.toggleTheme(),
                      activeColor: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 12),

                  _buildSettingTile(
                    icon: Icons.language,
                    title: l10n.language,
                    trailing: DropdownButton<String>(
                      value: languageService.locale.languageCode,
                      underline: SizedBox(),
                      items: [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'ar', child: Text('العربية')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          languageService.changeLanguage(value);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 12),

                  _buildSettingTile(
                    icon: Icons.lock_outline,
                    title: l10n.changePassword,
                    trailing: Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      // TODO: Navigate to change password screen
                      _showMessage('Change password - Coming soon!');
                    },
                  ),
                  SizedBox(height: 12),

                  _buildSettingTile(
                    icon: Icons.notifications_outlined,
                    title: l10n.notifications,
                    trailing: Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () => Navigator.of(context).pushNamed('/settings'),
                  ),
                  SizedBox(height: 32),

                  // Danger Zone
                  _buildSectionHeader(l10n.deleteAccount, Icons.warning_amber, isWarning: true),
                  SizedBox(height: 16),

                  OutlinedButton.icon(
                    onPressed: _showDeleteAccountDialog,
                    icon: Icon(Icons.delete_forever),
                    label: Text(l10n.deleteAccount),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, {bool isWarning = false}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isWarning ? Colors.red : Theme.of(context).colorScheme.primary,
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isWarning ? Colors.red : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    bool enabled = false,
    TextInputType? keyboardType,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled
              ? theme.colorScheme.primary.withOpacity(0.5)
              : theme.colorScheme.onSurface.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 4),
                TextField(
                  controller: controller,
                  enabled: enabled,
                  keyboardType: keyboardType,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
