import 'package:examdril/models/bns_question_model.dart';
import 'package:examdril/screens/best_next_step/bns_option_card.dart';
import 'package:examdril/screens/best_next_step/bns_pregame_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BnsInstructionsScreen extends StatefulWidget {
  final BnsTheme theme;
  const BnsInstructionsScreen({super.key, required this.theme});

  @override
  State<BnsInstructionsScreen> createState() => _BnsInstructionsScreenState();
}

class _BnsInstructionsScreenState extends State<BnsInstructionsScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _hintController;
  late Animation<Offset> _dragAnimation;
  late Animation<double> _handOpacity;

  @override
  void initState() {
    super.initState();
    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    // Use fixed pixel values here — ScreenUtil (.w/.h) needs context which isn't
    // guaranteed ready inside initState.
    _dragAnimation = TweenSequence<Offset>([
      TweenSequenceItem(tween: ConstantTween(Offset.zero), weight: 15),
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(-100, -150))
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(tween: ConstantTween(const Offset(-100, -150)), weight: 15),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-100, -150), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
    ]).animate(_hintController);

    _handOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 15),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 15),
    ]).animate(_hintController);

    _hintController.repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.theme.bgAsset),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Text(
                'Instructions',
                style: TextStyle(
                  color: widget.theme.textColor,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  children: [
                    _buildPageOne(),
                    _buildPageTwo(),
                  ],
                ),
              ),
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageOne() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildScenarioBox('A patient taking lithium for bipolar disorder begins using ibuprofen regularly for back pain. What is the next best step ?'),
        const Spacer(),
        Text(
          'Read through the question',
          style: TextStyle(
            color: widget.theme.textColor.withOpacity(0.7),
            fontSize: 16.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildScenarioBox(String text) {
    return Container(
      width: 358.w,
      height: 183.h,
      padding: EdgeInsets.only(top: 12.6.h, right: 12.2.w, left: 12.2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: 'Roboto',
            color: widget.theme.textColor,
            fontSize: 20.2.sp,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildPageTwo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                _buildMockOptionsPanel(),
                
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'Drag and drop the cards in the appropriate\n positions to play',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.theme.textColor.withOpacity(0.7),
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildMockOptionsPanel() {
    return Container(
      width: 358.w,
      height: 448.h,
      decoration: BoxDecoration(
        color: widget.theme.cardAreaColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Stack(
        children: [
          ...List.generate(5, (i) {
            final pos = _getSlotPosition(i);
            final label = kSlotLabels[i];
            final text = i == 4 ? 'Clarify the allergy history before dispensing' : 
                         i == 0 ? 'Automatically substitute azithromycin' :
                         i == 1 ? 'Dispense with diphenhydramine pre-treatment' :
                         i == 2 ? 'Dispense and advise stop if rash occurs' :
                         'Refuse and end the encounter';

            return Positioned(
              left: pos.dx,
              top: pos.dy,
              child: Column(
                children: [
                  _buildAnimatedCard(i, text),
                  SizedBox(height: 4.h),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
          // Dark Overlay limited to the panel
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          _buildAnimatedHand(),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard(int slotIndex, String text) {
    Widget card = SizedBox(
      width: 92.w,
      height: 145.6.h,
      child: BnsOptionCard(
        text: text,
        state: BnsCardState.normal,
        themeCardColor: widget.theme.cardColor,
        colorIndex: slotIndex,
      ),
    );

    // Card at slot 4 gets dragged, card at slot 0 is the destination (show as highlighted)
    if (slotIndex == 4) {
      return AnimatedBuilder(
        animation: _dragAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: _dragAnimation.value,
            child: child,
          );
        },
        child: card,
      );
    }
    return card;
  }

  Widget _buildAnimatedHand() {
    final pos4 = _getSlotPosition(4);
    return AnimatedBuilder(
      animation: _hintController,
      builder: (context, child) {
        final drag = _dragAnimation.value;
        return Positioned(
          left: pos4.dx + 30.w + drag.dx,
          top: pos4.dy + 90.h + drag.dy,
          child: IgnorePointer(
            child: Opacity(
              opacity: _handOpacity.value,
              child: Image.asset(
                'assets/images/hand.png',
                width: 52.w,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHintText() {
    return Positioned(
      top: 448.h + 20.h,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Text(
          'Swap the cards to play',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Offset _getSlotPosition(int slotIndex) {
    final double x0 = 20.5.w;
    final double x1 = 133.w;
    final double x2 = 245.5.w;
    final double y0 = 30.h;
    final double y1 = 240.h;
    switch (slotIndex) {
      case 0: return Offset(x0, y0);
      case 1: return Offset(x1, y0);
      case 2: return Offset(x2, y0);
      case 3: return Offset(x0, y1);
      case 4: return Offset(x1, y1);
      default: return Offset.zero;
    }
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 30.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDot(0),
              SizedBox(width: 8.w),
              _buildDot(1),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E2D35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                elevation: 0,
              ),
              onPressed: _nextPage,
              child: Text(
                _currentPage == 0 ? 'Next' : 'Done',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: isActive ? widget.theme.textColor : widget.theme.textColor.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
    );
  }
}
