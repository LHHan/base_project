import 'package:base_project_getx/app/core/utils/app_const.dart';
import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:base_project_getx/app/data/models/feed_model.dart';
import 'package:base_project_getx/app/widgets/p_appbar_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/feed_controller.dart';

class FeedView extends GetView<FeedController> {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return PAppbarTransparency(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8).w,
                child: Text('Feed', style: Get.textTheme.tsPageName),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.posts.isEmpty) {
                    return const Center(child: Text('No posts found'));
                  }
                  return RefreshIndicator(
                    onRefresh: controller.onRefresh,
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        12.w,
                        4.h,
                        12.w,
                        AppConstant().kBottomNavigationBarHeight.toDouble().h,
                      ),
                      itemCount: controller.posts.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) =>
                          _PostCard(post: controller.posts[index]),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final FeedModel post;

  static const _avatarColors = [
    Color(0xFF5C6BC0), // indigo
    Color(0xFF26A69A), // teal
    Color(0xFFEC407A), // pink
    Color(0xFF42A5F5), // blue
    Color(0xFFFF7043), // deep orange
    Color(0xFF66BB6A), // green
    Color(0xFFAB47BC), // purple
    Color(0xFFFFCA28), // amber
  ];

  Color get _avatarColor => _avatarColors[post.userId % _avatarColors.length];

  String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: Get.theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Header: avatar + user + tags ----
            Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: _avatarColor,
                  child: Text(
                    'U${post.userId}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User ${post.userId}',
                        style: Get.textTheme.tsBody.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Post #${post.id}',
                        style: Get.textTheme.tsSubTitle,
                      ),
                    ],
                  ),
                ),
                // Tags
                if (post.tags.isNotEmpty)
                  _TagChip(label: post.tags.first),
              ],
            ),

            SizedBox(height: 12.h),

            // ---- Title ----
            Text(
              post.title,
              style: Get.textTheme.tsBody.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 17.sp,
              ),
            ),

            SizedBox(height: 6.h),

            // ---- Body ----
            Text(
              post.body,
              style: Get.textTheme.tsSubTitle.copyWith(height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            // ---- Extra tags ----
            if (post.tags.length > 1) ...[
              SizedBox(height: 10.h),
              Wrap(
                spacing: 6.w,
                children: post.tags
                    .skip(1)
                    .map((t) => _TagChip(label: t))
                    .toList(),
              ),
            ],

            SizedBox(height: 14.h),

            // ---- Footer: reactions ----
            Divider(
              height: 1,
              color: Get.theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                _ReactionItem(
                  icon: Icons.favorite_rounded,
                  color: const Color(0xFFEC407A),
                  label: _formatCount(post.likes),
                ),
                20.horizontalSpace,
                _ReactionItem(
                  icon: Icons.thumb_down_rounded,
                  color: Get.theme.colorScheme.onSurfaceVariant,
                  label: _formatCount(post.dislikes),
                ),
                const Spacer(),
                _ReactionItem(
                  icon: Icons.remove_red_eye_rounded,
                  color: Get.theme.colorScheme.onSurfaceVariant,
                  label: _formatCount(post.views),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        '#$label',
        style: Get.textTheme.tsChip.copyWith(
          color: Get.theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ReactionItem extends StatelessWidget {
  const _ReactionItem({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.r, color: color),
        5.horizontalSpace,
        Text(label, style: Get.textTheme.tsChip),
      ],
    );
  }
}
