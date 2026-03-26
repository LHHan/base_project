import 'dart:ui';

import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// iOS-style frosted glass navigation bar.
///
/// Sits at the top of the screen in a [Stack], blurring content that scrolls
/// behind it. The [title] fades in once the user has scrolled past the large
/// title in the page body.
///
/// Usage:
/// ```dart
/// Stack(
///   children: [
///     CustomScrollView(
///       controller: controller.scrollController,
///       slivers: [
///         SliverToBoxAdapter(child: SizedBox(height: topPadding + kToolbarHeight)),
///         SliverToBoxAdapter(child: Padding(..., child: Text(title, style: tsPageName))),
///         // ... page content
///       ],
///     ),
///     Positioned(
///       top: 0, left: 0, right: 0,
///       child: WFrostedAppBar(
///         topPadding: topPadding,
///         scrollController: controller.scrollController,
///         title: 'My Page',
///       ),
///     ),
///   ],
/// )
/// ```
class WFrostedAppBar extends StatelessWidget {
  const WFrostedAppBar({
    super.key,
    required this.topPadding,
    required this.scrollController,
    required this.title,
    this.titleAppearOffset = 48.0,
    this.titleFadeRange = 24.0,
    this.trailing,
  });

  final double topPadding;
  final ScrollController scrollController;

  /// The page title shown centered in the collapsed bar.
  final String title;

  /// Scroll offset (px) at which the title starts fading in.
  final double titleAppearOffset;

  /// Scroll distance over which the title transitions from invisible to opaque.
  final double titleFadeRange;

  /// Optional widget pinned to the right of the appbar (same fade as title).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final appBarHeight = topPadding + kToolbarHeight;

    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        final offset =
            scrollController.hasClients ? scrollController.offset : 0.0;
        final titleOpacity =
            ((offset - titleAppearOffset) / titleFadeRange).clamp(0.0, 1.0);

        return SizedBox(
          height: appBarHeight,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: appBarHeight,
                color:
                    Get.theme.scaffoldBackgroundColor.withValues(alpha: 0.75),
                child: Padding(
                  padding: EdgeInsets.only(top: topPadding),
                  child: SizedBox(
                    height: kToolbarHeight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Centered title
                          Opacity(
                            opacity: titleOpacity,
                            child: Text(
                              title,
                              style: Get.textTheme.tsPageName.copyWith(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // Optional trailing action (right-aligned, same fade)
                          if (trailing != null)
                            Positioned(
                              right: 0,
                              child: Opacity(
                                opacity: titleOpacity,
                                child: trailing!,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
