import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app.colors.dart'; // Assuming this holds your custom colors
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/category_chip.dart';
import 'package:news_app/widgets/loading_shimmer.dart';

class HomeView extends GetView<NewsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Change 1: Set a light background for the body content
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        // Change 2: Use a primary color for the AppBar for visual impact
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Global News Today',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Text color is white
          ),
        ),
        centerTitle: true,
        // Change 3: Set icon theme to white for better contrast
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 4.0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          SizedBox(width: 8), // Added spacing for aesthetic
        ],
      ),
      body: Column(
        children: [
          // Categories
          Container(
            height: 60,
            color: Colors.white,
            // Change 4: Add a subtle divider/shadow under the category bar
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return Obx(
                  () => CategoryChip(
                    label: category.capitalize ?? category,
                    isSelected: controller.selectedCategory == category,
                    onTap: () => controller.selectCategory(category),
                  ),
                );
              },
            ),
          ),

          // News List
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
                color: Colors.deepPurple, // Change 5: Set indicator color
                onRefresh: controller.refreshNews,
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  itemCount: controller.articles.length,
                  itemBuilder: (context, index) {
                    final article = controller.articles[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0), // Added spacing between cards
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

  // --- Helper Widgets Enhancement ---

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Change 6: Use a larger icon and color
          Icon(Icons.cloud_off, size: 80, color: AppColors.error),
          SizedBox(height: 24),
          Text(
            'Connection Error',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Failed to load news. Please check your internet connection.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: controller.refreshNews,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple, // Change 7: Stylish button color
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Retry Loading',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Change 8: Use a more illustrative icon
          Icon(Icons.sentiment_dissatisfied, size: 80, color: Colors.grey),
          SizedBox(height: 24),
          Text(
            'Nothing to see here!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'The selected category is empty or your search yielded no results.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => controller.selectCategory('general'), // Suggest refreshing the main feed
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade300,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'View General News',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    // No major visual change to the dialog, but ensure consistency
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search News', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Enter topic or keyword...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), // Rounded border
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                controller.searchNews(searchController.text);
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple, // Consistent primary color
            ),
            child: Text('Search', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}