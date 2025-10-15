import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app.colors.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/category_chip.dart';
import 'package:news_app/widgets/loading_shimmer.dart';

class HomeView extends GetView<NewsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          '🗞️ News Today',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: AppColors.primary),
            onPressed: () => _showSearchDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [
          // === CATEGORY SECTION ===
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CategoryChip(
                      label: category.capitalize ?? category,
                      isSelected: controller.selectedCategory == category,
                      onTap: () => controller.selectCategory(category),
                    ),
                  ),
                );
              },
            ),
          ),

          // === NEWS LIST ===
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return LoadingShimmer();
              }

              if (controller.error.isNotEmpty) {
                return _buildErrorWidget();
              }

              if (controller.articles.isEmpty) {
                return _buildEmptyWidget();
              }

              return RefreshIndicator(
                onRefresh: controller.refreshNews,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.articles.length,
                  itemBuilder: (context, index) {
                    final article = controller.articles[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: NewsCard(
                        article: article,
                        onTap: () =>
                            Get.toNamed(Routes.NEWS_DETAIL, arguments: article),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // === ERROR STATE ===
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 80, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your internet connection and try again.',
            style: TextStyle(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.refreshNews,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // === EMPTY STATE ===
  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.newspaper_outlined,
              size: 80, color: AppColors.textHint.withOpacity(0.7)),
          const SizedBox(height: 16),
          Text(
            'No News Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try exploring another category or search for something else.',
            style: TextStyle(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // === SEARCH DIALOG ===
  void _showSearchDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '🔍 Search News',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Enter a keyword...',
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              controller.searchNews(value);
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: AppColors.textHint)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                controller.searchNews(searchController.text);
                Navigator.of(context).pop();
              }
            },
            child: Text('Search'),
          ),
        ],
      ),
    );
  }
}
