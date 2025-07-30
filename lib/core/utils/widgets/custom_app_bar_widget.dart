import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final bool showBell;
  final bool showUserIcon;
  final bool showGridInLeading;
  final bool showBackInLeading;
  final bool showBackButton;
  final bool showLogoutIcon; // خاصية جديدة لعرض أيقونة تسجيل الخروج
  final VoidCallback? onBackPressed;
  final VoidCallback? onGridPressed;
  final VoidCallback? onLogoutPressed; // معالج لتسجيل الخروج
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBell = true,
    this.showUserIcon = false,
    this.showGridInLeading = false,
    this.showBackInLeading = false,
    this.showBackButton = true,
    this.showLogoutIcon = false, // القيمة الافتراضية لأيقونة تسجيل الخروج
    this.onBackPressed,
    this.onGridPressed,
    this.onLogoutPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          backgroundColor ?? const Color.fromARGB(255, 255, 255, 255),
      elevation: 0,
      leadingWidth: (showUserIcon ||
              showGridInLeading ||
              (showBackInLeading && showBackButton))
          ? 100
          : null,
      leading: showUserIcon == true
          ? Padding(
              padding: const EdgeInsetsDirectional.only(start: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, color: Colors.white),
              ),
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: onBackPressed,
            ),
      title: title != null ? Text(title!) : null,
      centerTitle: true,
      // actions: [
      //   if (showBell)
      //     IconButton(
      //       icon: Image.asset('assets/images/bell.png', width: 28, height: 28),
      //       onPressed: () {},
      //     ),
      //   if (showLogoutIcon)
      //     IconButton(
      //       icon: const Icon(Icons.logout, color: Colors.red, size: 28),
      //       onPressed: onLogoutPressed,
      //       style: ButtonStyle(
      //         backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
      //         shape: WidgetStateProperty.all<OutlinedBorder>(
      //           const CircleBorder(),
      //         ),
      //       ),
      //     ),
      //   if (!showGridInLeading)
      //     IconButton(
      //       icon:
      //           const Icon(Icons.grid_view, color: Color(0xFF00C4B4), size: 28),
      //       onPressed: onGridPressed,
      //       style: ButtonStyle(
      //         backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
      //         shape: WidgetStateProperty.all<OutlinedBorder>(
      //           const CircleBorder(),
      //         ),
      //       ),
      //     ),
      // ],
    );
  }
}
