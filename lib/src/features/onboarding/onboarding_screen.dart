import 'package:flutter/material.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../core/app_icons.dart';
import '../../core/styles.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _current = 0;

  void _next(int totalPages) {
    if (_current < totalPages - 1) {
      _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildPage(_OnboardingPageData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
            ),
            child: Center(child: Icon(data.icon, size: 84, color: AppStyles.primaryGreen)),
          ),
          SizedBox(height: 28),
          Text(data.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text(data.text, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black87)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final List<_OnboardingPageData> pages = [
      _OnboardingPageData(
        icon: AppIcons.irrigation,
        title: l10n.onboardingIrrigationTitle,
        text: l10n.onboardingIrrigationText,
      ),
      _OnboardingPageData(
        icon: Icons.attach_money,
        title: l10n.onboardingExpensesTitle,
        text: l10n.onboardingExpensesText,
      ),
      _OnboardingPageData(
        icon: Icons.analytics,
        title: l10n.onboardingProfitTitle,
        text: l10n.onboardingProfitText,
      ),
    ];
    
    return Scaffold(
      backgroundColor: Color(0xFFF6F7F9),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _skip,
                child: Text(l10n.skip, style: TextStyle(color: AppStyles.primaryGreen, fontWeight: FontWeight.w600)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (context, index) => _buildPage(pages[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pages.length, (i) {
                      final active = i == _current;
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        margin: EdgeInsets.symmetric(horizontal: 6),
                        width: active ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active ? AppStyles.primaryGreen : Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _skip,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(l10n.skip, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppStyles.primaryGreen)),
                          ),
                          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: BorderSide(color: AppStyles.primaryGreen)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _next(pages.length),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(_current == pages.length - 1 ? l10n.start : l10n.next, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                          style: ElevatedButton.styleFrom(backgroundColor: AppStyles.primaryGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String text;

  _OnboardingPageData({required this.icon, required this.title, required this.text});
}
