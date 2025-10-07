import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'package:news_app/utils/constants.dart';
import 'package:news_app/utils/app.colors.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/models/news_response.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/controllers/news_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(
    fileName: "assets/.env",
  ); // pastikan path sesuai pubspec.yaml
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ==========================================================
  // 1. TESTING CONSTANTS
  // ==========================================================
  String _testConstants() {
    return "API Key: ${Constants.apiKey.isNotEmpty ? Constants.apiKey : 'Tidak ditemukan'}\n"
        "Base URL: ${Constants.baseUrl}\n"
        "Default Country: ${Constants.defaultCountry}\n"
        "Categories: ${Constants.categories.join(", ")}";
  }

  // ==========================================================
  // 2. TESTING APP COLORS
  // ==========================================================
  Widget _testAppColors() {
    return Column(
      children: [
        Container(
          height: 50,
          color: AppColors.primary,
          child: const Center(
            child: Text("Primary", style: TextStyle(color: Colors.white)),
          ),
        ),
        Container(
          height: 50,
          color: AppColors.secondary,
          child: const Center(
            child: Text("Secondary", style: TextStyle(color: Colors.black)),
          ),
        ),
        Container(
          height: 50,
          color: AppColors.error,
          child: const Center(
            child: Text("Error", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // 3. TESTING NEWS SERVICE (Langsung API)
  // ==========================================================
  Future<String> _testNewsService() async {
    final service = NewsService();
    final NewsResponse response = await service.getTopHeadlines(
      country: "us",
      category: "technology",
    );
    return "Status: ${response.status}\n"
        "Total Results: ${response.totalResults}\n"
        "First Article: ${response.articles.isNotEmpty ? response.articles.first.title : 'No articles'}";
  }

  // ==========================================================
  // 4. TESTING NEWS ARTICLE (Ambil Artikel Pertama dari API)
  // ==========================================================
  Future<NewsArticle?> _testNewsArticle({int index = 0}) async {
    final service = NewsService();
    final response = await service.getTopHeadlines(
      country: "us",
      category: "business",
    );

    if (response.articles.isEmpty) return null;

    // kalau index lebih besar dari jumlah artikel, fallback ke artikel pertama
    if (index >= response.articles.length) index = 0;

    return response.articles[index];
  }

  // ==========================================================
  // 5. TESTING NEWS RESPONSE (Parsing Response Full dari API)
  // ==========================================================
  Future<String> _testNewsResponse() async {
    final service = NewsService();
    final NewsResponse response = await service.getTopHeadlines(
      country: "us",
      category: "science",
    );

    final String status = response.status;
    final int total = response.totalResults;
    final String firstTitle = response.articles.isNotEmpty
        ? response.articles.first.title ?? "no title"
        : "no articles";

    return "Status: $status\n"
        "Total Results: $total\n"
        "First Article: $firstTitle";
  }

  // ==========================================================
  // 6. TESTING NEWS CONTROLLER (GetX State Management)
  // ==========================================================
  Widget _testNewsController() {
    final controller = Get.put(NewsController());
    return Obx(() {
      if (controller.isLoading) {
        return const CircularProgressIndicator();
      }
      if (controller.error.isNotEmpty) {
        return Text("Error: ${controller.error}");
      }
      if (controller.articles.isEmpty) {
        return const Text("Tidak ada artikel");
      }
      return Expanded(
        child: ListView(
          children: controller.articles
              .map((a) => ListTile(title: Text(a.title ?? "No title")))
              .toList(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Constants → cek API key, base URL, kategori.
    // 2. AppColors → cek warna di UI.
    // 3. NewsService → panggil API, tampilkan status, total, first article.
    // 4. NewsArticle → ambil artikel pertama dari API, tampilkan title + source.
    // 5. NewsResponse → parsing full response API, tampilkan status, total, first title.
    // 6. NewsController (GetX) → binding data ke UI, tampilkan semua artikel.

    const int activeTest = 6;

    const Map<int, String> testDescriptions = {
      1: "1. Testing Constants",
      2: "2. Testing AppColors",
      3: "3. Testing NewsService",
      4: "4. Testing NewsArticle",
      5: "5. Testing NewsResponse",
      6: "6. Testing NewsController",
    };

    final String testDescription =
        testDescriptions[activeTest] ?? "Belum pilih test";

    Widget body;
    switch (activeTest) {
      case 1:
        body = Text(
          _testConstants(),
          style: const TextStyle(fontSize: 16, color: Colors.black),
        );
        break;
      case 2:
        body = _testAppColors();
        break;
      case 3:
        body = FutureBuilder<String>(
          future: _testNewsService(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            return Text(snapshot.data ?? "No data");
          },
        );
        break;
      case 4:
        body = FutureBuilder<NewsArticle?>(
          future: _testNewsArticle(index: 2), // contoh ambil artikel ke-3
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            final article = snapshot.data;
            if (article == null) return const Text("Tidak ada artikel");

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (article.urlToImage != null)
                  Image.network(
                    article.urlToImage!,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 12),
                Text(
                  article.title ?? "No title",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sumber: ${article.source?.name ?? 'Unknown'}",
                  textAlign: TextAlign.center,
                ),
                Text(
                  "URL: ${article.url ?? '-'}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            );
          },
        );
        break;
      case 5:
        body = FutureBuilder<String>(
          future: _testNewsResponse(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            return Text(snapshot.data ?? "No data");
          },
        );
        break;
      case 6:
        body = _testNewsController();
        break;
      default:
        body = const Text("Pilih test dengan ubah activeTest = 1..6");
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Testing News App -  $testDescription")),
        body: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: body,
        ),
      ),
    );
  }
}