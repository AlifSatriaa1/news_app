import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/utils/app.colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app/models/news_article.dart';

class NewsDetailView extends StatelessWidget {
  final NewsArticle article = Get.arguments as NewsArticle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // === HEADER IMAGE ===
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  article.urlToImage != null
                      ? CachedNetworkImage(
                          imageUrl: article.urlToImage!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade200,
                            child: Icon(Icons.image_not_supported,
                                color: Colors.grey, size: 60),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade300,
                          child: Icon(Icons.newspaper,
                              size: 60, color: Colors.grey.shade600),
                        ),

                  // Gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black87,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Title overlay
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 20,
                    child: Text(
                      article.title ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: _shareArticle,
              ),
              PopupMenuButton<String>(
                color: Colors.white,
                icon: const Icon(Icons.more_vert, color: Colors.white),
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
                  const PopupMenuItem(
                    value: 'copy_link',
                    child: Row(
                      children: [
                        Icon(Icons.copy, size: 20),
                        SizedBox(width: 8),
                        Text('Copy Link'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'open_browser',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_browser, size: 20),
                        SizedBox(width: 8),
                        Text('Open in Browser'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // === ARTICLE CONTENT ===
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and Date
                  Row(
                    children: [
                      if (article.source?.name != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            article.source!.name!,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      if (article.publishedAt != null)
                        Text(
                          timeago.format(DateTime.parse(article.publishedAt!)),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Description
                  if (article.description != null)
                    Text(
                      article.description!,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Content
                  if (article.content != null) ...[
                    Text(
                      'Article',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.content!,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        height: 1.7,
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),

                  // Read More
                  if (article.url != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: const Text(
                          'Read Full Article',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: _openInBrowser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // === SHARE ===
  void _shareArticle() {
    if (article.url != null) {
      Share.share(
        '${article.title ?? 'Check out this news'}\n\n${article.url!}',
        subject: article.title,
      );
    }
  }

  // === COPY LINK ===
  void _copyLink() {
    if (article.url != null) {
      Clipboard.setData(ClipboardData(text: article.url!));
      Get.snackbar(
        'Link Copied ✅',
        'You can now paste it anywhere',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // === OPEN IN BROWSER ===
  void _openInBrowser() async {
    if (article.url != null) {
      final Uri url = Uri.parse(article.url!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error ❌',
          'Could not open the article',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
        );
      }
    }
  }
}
