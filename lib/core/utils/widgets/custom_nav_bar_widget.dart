// Widget for the bottom navigation bar
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBarWidget extends StatefulWidget {
  const BottomNavBarWidget({super.key});

  @override
  _BottomNavBarWidgetState createState() => _BottomNavBarWidgetState();
}
class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  int _selectedIndex = 0;

  Widget _navItemWithImage(String imagePath, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 28,
            height: 28,
            color: isSelected ? const Color(0xFF00C4B4) : Colors.grey.shade600,
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF00C4B4),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 107,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            bottom: 15,
            left: 16,
            right: 16,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _navItemWithImage('assets/images/Home.png', 0),
                  _navItemWithImage('assets/images/Frame 427320589.png', 1),
                  const SizedBox(width: 48),
                  _navItemWithImage('assets/images/Calendar.png', 2),
                  _navItemWithImage('assets/images/My Profile.png', 3),
                ],
              ),
            ),
          ),
          Positioned(
            top: 15,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 55.h,
                height: 90.h,
                decoration: const BoxDecoration(
                  color: Color(0xFF00C4B4),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, size: 36, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
