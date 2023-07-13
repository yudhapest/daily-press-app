import 'package:daily_press/common/navigation.dart';
import 'package:daily_press/data/model/article.dart';
import 'package:daily_press/provider/database_provider.dart';
import 'package:daily_press/ui/article_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CardArticle extends StatelessWidget {
  final Article article;

  const CardArticle({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedUploadDate = article.publishedAt != null
        ? article.publishedAt!.toIso8601String().substring(0, 10)
        : '';

    return Consumer<DatabaseProvider>(builder: (context, provider, child) {
      return FutureBuilder<bool>(
        future: provider.isBookmarked(article.url),
        builder: (context, snapshot) {
          var isBookmarked = snapshot.data ?? false;
          return Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: GestureDetector(
              onTap: () {
                Navigation.intentWithData(
                  ArticleDetailPage.routeName,
                  article,
                );
              },
              child: Card(
                elevation: 3,
                shadowColor: Colors.grey[400],
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 150,
                      margin: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          article.urlToImage ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 4.0, right: 16.0, bottom: 6.0),
                        child: SizedBox(
                          height: 160,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                article.description ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                textAlign: TextAlign.justify,
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Text(
                                    'Upload: $formattedUploadDate',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),
                                  isBookmarked
                                      ? IconButton(
                                          icon: const Icon(
                                              Icons.bookmark_added_rounded,
                                              color: Colors.grey),
                                          onPressed: () {
                                            provider
                                                .removeBookmark(article.url);
                                            showSnackbar(context,
                                                'Removed from bookmark',
                                                duration:
                                                    const Duration(seconds: 2));
                                          },
                                        )
                                      : IconButton(
                                          icon: const Icon(
                                              Icons.bookmark_border_outlined,
                                              color: Colors.grey),
                                          onPressed: () {
                                            provider.addBookmark(article);
                                            showSnackbar(
                                              context,
                                              'Added to bookmark',
                                              duration:
                                                  const Duration(seconds: 2),
                                            );
                                          },
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  void showSnackbar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 1)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              const SizedBox(width: 8.0),
              Text(message),
            ],
          ),
        ),
        duration: duration,
      ),
    );
  }
}
