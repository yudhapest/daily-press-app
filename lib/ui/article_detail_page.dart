import 'package:daily_press/common/navigation.dart';
import 'package:daily_press/data/model/article.dart';
import 'package:daily_press/ui/article_web_view.dart';
import 'package:flutter/material.dart';

class ArticleDetailPage extends StatelessWidget {
  static const routeName = '/article-detail';
  final Article article;
  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final formattedUploadDate = article.publishedAt != null
        ? article.publishedAt!.toIso8601String().substring(0, 10)
        : '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Press'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Text(
                article.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey,
                  image: DecorationImage(
                      image: NetworkImage(article.urlToImage!),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'By: ${article.author}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[600],
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Published: $formattedUploadDate',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Text(
                    article.content ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigation.intentWithData(
                          ArticleWebView.routeName, article.url);
                    },
                    child: const Text('Read More'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
