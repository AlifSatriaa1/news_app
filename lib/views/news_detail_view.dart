import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/utils/app.colors.dart'; // Ensure this is defined with colors like primary, textPrimary, etc.
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app/models/news_article.dart';

class NewsDetailView extends StatelessWidget {
  // Use a more specific color palette for better visual appeal
  static const Color primaryColor = Colors.deepPurple;
  static const Color accentColor = Color(0xFFFDD835); // A bright yellow accent

  final NewsArticle article = Get.arguments as NewsArticle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Change 1: Enhance SliverAppBar for a dramatic hero image effect
          SliverAppBar(
            expandedHeight: 350, // Slightly taller expanded height
            pinned: true,
            // Use system UI overlay for a transparent status bar look
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarColor: Colors.transparent,
            ),
            iconTheme: IconThemeData(color: Colors.white), // Icons are white over the dark image
            backgroundColor: primaryColor, // Solid color when collapsed
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 16, bottom: 16),
              // Optional: Add a subtle title to the collapsed app bar
              title: Text(
                article.title != null ? (article.title!.length > 30 ? '${article.title!.substring(0, 27)}...' : article.title!) : 'News Detail',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              background: _buildImageHero(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                onPressed: () => _shareArticle(),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  switch (value) {
                    case 'copy_link':
                      _copyLink();
                      break;
                    case 'open_browser':
                      _openInBrowser();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'copy_link',
                    child: Row(
                      children: [
                        Icon(Icons.copy, color: primaryColor),
                        SizedBox(width: 8),
                        Text('Copy Link'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'open_browser',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_new, color: primaryColor), // Changed icon to open_in_new
                        SizedBox(width: 8),
                        Text('Open in Browser'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Change 2: Title - Larger, bolder, and better separation
                  if (article.title != null) ...[
                    Text(
                      article.title!,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900, // Very bold
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 16),
                  ],

                  // Change 3: Source and Date - Use a styled Author/Source chip
                  _buildSourceAndDateRow(),
                  SizedBox(height: 20),

                  // Change 4: Description - Prominent lead-in text
                  if (article.description != null && article.description != article.title) ...[
                    Text(
                      article.description!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500, // Medium weight for readability
                        color: AppColors.textSecondary.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                    Divider(height: 40, thickness: 1, color: AppColors.divider.withOpacity(0.5)),
                  ],

                  // Change 5: Content - Clear text body
                  if (article.content != null) ...[
                    Text(
                      'Full Story', // Better label than 'Content'
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      // Clean up the content, often includes an ellipsis and character count
                      article.content!.replaceAll(RegExp(r'\[\+\d+ chars\]$'), ''),
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 32),
                  ],

                  // Change 6: Read More Button - Primary action at the bottom
                  if (article.url != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _openInBrowser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        icon: Icon(Icons.launch, color: Colors.white),
                        label: Text(
                          'Read Full Article on Web',
                          style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Methods/Widgets ---

  Widget _buildImageHero() {
    return article.urlToImage != null
        ? Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: article.urlToImage!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.divider,
                  child: Center(child: CircularProgressIndicator(color: primaryColor)),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.divider,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: AppColors.textHint,
                  ),
                ),
              ),
              // Change 7: Add a subtle gradient overlay on the image for readability of top bar icons
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.0, -1.0),
                    end: Alignment(0.0, 0.4),
                    colors: <Color>[
                      Color(0x60000000),
                      Color(0x00000000),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Container(
            color: primaryColor.withOpacity(0.8),
            child: Icon(
              Icons.newspaper,
              size: 80,
              color: Colors.white.withOpacity(0.8),
            ),
          );
  }

  Widget _buildSourceAndDateRow() {
    return Row(
      children: [
        // Source Chip
        if (article.source?.name != null) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: primaryColor.withOpacity(0.3)), // Subtle border
            ),
            child: Text(
              article.source!.name!,
              style: TextStyle(
                color: primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 12),
        ],
        
        // Date Text
        if (article.publishedAt != null) ...[
          Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
          SizedBox(width: 4),
          Text(
            timeago.format(DateTime.parse(article.publishedAt!)),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }

  void _shareArticle() {
    if (article.url != null) {
      Share.share(
        'Read this article: ${article.title ?? 'News Article'}\n\n${article.url!}',
        subject: article.title,
      );
    }
  }

  void _copyLink() {
    if (article.url != null) {
      Clipboard.setData(ClipboardData(text: article.url!));
      Get.snackbar(
        'Copied!',
        'Article link copied to clipboard.',
        icon: Icon(Icons.check_circle, color: Colors.white),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(10),
      );
    }
  }

  void _openInBrowser() async {
    if (article.url != null) {
      final Uri url = Uri.parse(article.url!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open the link: ${article.url}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      }
    }
  }
}