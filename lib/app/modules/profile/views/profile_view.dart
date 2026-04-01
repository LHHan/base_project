import 'package:base_project_getx/app/core/utils/app_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Get.textTheme.tsTitle),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.user.value;
        if (user == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_off_outlined, size: 48),
                12.verticalSpace,
                const Text('Failed to load profile'),
                12.verticalSpace,
                ElevatedButton(
                  onPressed: controller.fetchProfile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              24.verticalSpace,
              CircleAvatar(
                radius: 52,
                backgroundImage: NetworkImage(user.image),
                onBackgroundImageError: (_, __) {},
              ),
              16.verticalSpace,
              Text(
                '${user.firstName} ${user.lastName}',
                style: Get.textTheme.tsLabel,
              ),
              4.verticalSpace,
              Text(
                '@${user.username}',
                style: Get.textTheme.tsSubTitle,
              ),
              24.verticalSpace,
              _InfoSection(
                title: 'Personal',
                items: [
                  _InfoRow(label: 'Email', value: user.email),
                  _InfoRow(label: 'Phone', value: user.phone),
                  _InfoRow(label: 'Age', value: user.age.toString()),
                  _InfoRow(label: 'Gender', value: user.gender),
                  _InfoRow(label: 'Birth date', value: user.birthDate),
                ],
              ),
              16.verticalSpace,
              _InfoSection(
                title: 'Address',
                items: [
                  _InfoRow(label: 'City', value: user.address.city),
                  _InfoRow(label: 'Address', value: user.address.address),
                ],
              ),
              16.verticalSpace,
              _InfoSection(
                title: 'Company',
                items: [
                  _InfoRow(label: 'Name', value: user.company.name),
                  _InfoRow(label: 'City', value: user.company.address.city),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _InfoSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Get.textTheme.tsBody.copyWith(fontWeight: FontWeight.bold)),
        8.verticalSpace,
        Card(
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Get.textTheme.tsSubTitle),
          Flexible(
            child: Text(
              value,
              style: Get.textTheme.tsBody,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
