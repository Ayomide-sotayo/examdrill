import 'package:examdril/screens/best_next_step/bns_game_screen.dart';
import 'package:examdril/screens/best_next_step/bns_instructions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

// ─────────────────────────────────────────────
//  THEME MODEL
// ─────────────────────────────────────────────
class BnsTheme {
  final String label;
  final String bgAsset; // full-screen bg for the game screen
  final Color cardAreaColor; // the card grid background
  final Color cardColor; // individual card color
  final Color textColor; // question text color

  const BnsTheme({
    required this.label,
    required this.bgAsset,
    required this.cardAreaColor,
    required this.cardColor,
    required this.textColor,
  });
}

const kBnsThemes = [
  BnsTheme(
    label: 'Blue',
    bgAsset: 'assets/images/blue.png',
    cardAreaColor: Color(0xFF547A95),
    cardColor: Color(0xFF2C3947),
    textColor: Color(0xFF1E2D35),
  ),
  BnsTheme(
    label: 'Green',
    bgAsset: 'assets/images/green.png',
    cardAreaColor: Color(0xFF408A71),
    cardColor: Color(0xFF0B312E),
    textColor: Color(0xFF1A2E22),
  ),
];

// ─────────────────────────────────────────────
//  PREGAME SCREEN
// ─────────────────────────────────────────────
class BnsPreGameScreen extends StatefulWidget {
  const BnsPreGameScreen({super.key});

  @override
  State<BnsPreGameScreen> createState() => _BnsPreGameScreenState();
}

class _BnsPreGameScreenState extends State<BnsPreGameScreen> {
  late int _selectedTheme;
  bool _isSoundOn = true;

  bool get _themeChosen => _selectedTheme != -1;

  @override
  void initState() {
    super.initState();
    _selectedTheme = Random().nextInt(kBnsThemes.length);
    // Enable immersive mode when entering pre-game/game flow
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Reset to edge-to-edge when leaving the game flow (popping back to dashboard)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFE8EDF2,
      ), // the outer bg (same steely blue as Figma)
      body: SafeArea(
        child: Stack(
          children: [
            // ── scrollable body ──────────────────────
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  _buildTopBar(),
                  SizedBox(height: 20.h),
                  _buildHeader(),
                  SizedBox(height: 24.h),
                  _buildStatsRow(),
                  SizedBox(height: 16.h),
                  _buildBenefitsSection(),
                  SizedBox(height: 16.h),
                  _buildThemeSection(),
                  SizedBox(height: 16.h),
                  _buildPacksSection(),
                  SizedBox(
                    height: 100.h,
                  ), // padding so content clears floating button
                ],
              ),
            ),
            // ── floating start button ────────────────
            Positioned(
              bottom: 24.h,
              left: 16.w,
              right: 16.w,
              child: _buildStartButton(),
            ),
          ],
        ),
      ),
    );
  }

  // ── TOP BAR ─────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.close, color: Color(0xFF2C3947), size: 24.sp),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BnsInstructionsScreen(
                        theme: _themeChosen ? kBnsThemes[_selectedTheme] : kBnsThemes[1],
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.help_outline_rounded,
                  color: const Color(0xFF2C3947),
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 16.w),
              GestureDetector(
                onTap: () => setState(() => _isSoundOn = !_isSoundOn),
                child: Icon(
                  _isSoundOn ? Icons.volume_up_outlined : Icons.volume_off_outlined,
                  color: const Color(0xFF2C3947),
                  size: 22.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── HEADER ──────────────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            color: Color(0xFF2C3947),
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.r),
            
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset('assets/images/feet.png',),
            )
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Best Next Step',
          style: TextStyle(
            color: Color(0xFF2C3947),
            fontSize: 22.sp,
            fontWeight: FontWeight.w100,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  // ── STATS ROW ───────────────────────────────
  Widget _buildStatsRow() {
    return Container(
      width: 342.w,
      height: 92.h,
      decoration: BoxDecoration(
        color: const Color(0xFF547A95),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color.fromARGB(255, 34, 51, 87),
          width: 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _statItem('Best Score', '5,738')),

            Expanded(child: _statItem('Difficulty', '18/400')),

            Expanded(child: _statItem('Played', '20')),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w100,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── BENEFITS ────────────────────────────────
  Widget _buildBenefitsSection() {
    return Center(
      child: Container(
        width: 342.w,
        height: 215.h,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 25.w),
        decoration: BoxDecoration(
          color: const Color(0xFF547A95),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color.fromARGB(255, 34, 51, 87),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Benefits',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w100,
              ),
            ),
            SizedBox(height: 25.h),
            _benefitItem('Trains exam-style judgement', icon: Icons.assignment_rounded),
            SizedBox(height: 25.h),
            _benefitItem('Builds real readiness, not just recall', icon: Icons.lightbulb_outline_rounded),
            SizedBox(height: 25.h),
            _benefitItem('Reveals why answers are wrong', icon: Icons.search_rounded),
          ],
        ),
      ),
    );
  }

  Widget _benefitItem(String text, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null)
          Icon(icon, color: Colors.white, size: 24.sp)
        else
          Image.asset(
            'assets/images/benefit.png',
            height: 25.h,
            width: 21.3.w,
            errorBuilder: (_, __, ___) =>
                Icon(Icons.psychology_outlined, color: Colors.white, size: 22.sp),
          ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }

  // ── THEME PICKER ────────────────────────────
  Widget _buildThemeSection() {
    return Center(
      child: Container(
        width: 342.w,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 22.w),
        decoration: BoxDecoration(
          color: const Color(0xFF547A95),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Color(0xFF2C3947), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pick a Theme',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w100,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: List.generate(kBnsThemes.length, (i) {
                final isSelected = _selectedTheme == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTheme = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: 16.w),
                    width: 80.w,
                    height: 130.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected ? Color(0xFF2C3947) : Colors.transparent,
                        width: 2.5.w,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Color(0xFF2C3947).withValues(alpha: 0.4),
                                blurRadius: 4.r,
                              ),
                            ]
                          : [],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.asset(
                        kBnsThemes[i].bgAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: kBnsThemes[i].cardAreaColor,
                          child: Center(
                            child: Text(
                              kBnsThemes[i].label,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ── PACKS / TOPICS ───────────────────────────
  Widget _buildPacksSection() {
    const packs = [
      ('Therapeutics', '100%'),
      ('Safety', '0%'),
      ('Monitoring', '0%'),
      ('Pharmacokinetics', '0%'),
    ];

    return Center(
      child: Container(
        width: 342.w,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF547A95),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(width: 1, color: Color(0xFF2C3947),),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
              child: Text(
                'Packs',
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
            ),
            ...packs
                .expand(
                  (p) => [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: _packItem(p.$1, p.$2),
                    ),
                    Divider(color: const Color.fromARGB(0, 255, 255, 255), height: 1.h, thickness: 1),
                  ],
                )
                .toList()
              ..removeLast(), // remove trailing divider
          ],
        ),
      ),
    );
  }

  Widget _packItem(String name, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── FLOATING START BUTTON ─────────────────────
  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        // null onPressed = visually disabled; only active when theme chosen
        onPressed: _themeChosen
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BnsGameScreen(
                      theme: kBnsThemes[_selectedTheme],
                      isSoundEnabled: _isSoundOn,
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _themeChosen
              ? const Color(0xFF1E2D35)
              : const Color(0xFF1E2D35).withValues(alpha: 0.35),
          disabledBackgroundColor: const Color(
            0xFF1E2D35,
          ).withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start Game',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.play_arrow_outlined, color: Colors.white, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
