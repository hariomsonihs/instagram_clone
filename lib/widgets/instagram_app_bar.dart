import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_constants.dart';

class InstagramAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InstagramAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      leadingWidth: 48,
      leading: IconButton(
        icon: const Icon(Icons.add, color: Colors.black, size: 28),
        onPressed: () {},
        padding: const EdgeInsets.only(left: 12),
      ),
      centerTitle: true,
      title: Text(
        'Instagram',
        style: GoogleFonts.grandHotel(
          fontSize: 36,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.favorite_border,
                color: Colors.black,
                size: 27,
              ),
              Positioned(
                top: -1,
                right: -1,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: AppConstants.instagramRed,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(height: 0.5, color: AppConstants.borderColor),
      ),
    );
  }
}
