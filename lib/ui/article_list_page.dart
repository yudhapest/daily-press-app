import 'package:daily_press/provider/news_provider.dart';
import 'package:daily_press/utils/result_state.dart';
import 'package:daily_press/widgets/card_shimmer.dart';
import 'package:daily_press/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../widgets/card_article.dart';

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({super.key});

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final greeting = newsProvider.greeting;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good $greeting',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Explore the world by one click',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final greeting = newsProvider.greeting;

    return CupertinoPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good $greeting',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Explore the world by one click',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: () => newsProvider.refreshFetchArticles(),
      child: Consumer<NewsProvider>(
        builder: (context, snapshot, _) {
          if (snapshot.state == ResultState.loading ||
              newsProvider.isRefreshing) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: 5, // Jumlah card shimmer saat data masih loading
              itemBuilder: (context, index) {
                return const ShimmerCard();
              },
            );
          } else if (snapshot.state == ResultState.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.result.articles.length,
              itemBuilder: (context, index) {
                var article = snapshot.result.articles[index];
                return CardArticle(article: article);
              },
            );
          } else if (snapshot.state == ResultState.noData) {
            return Center(
              child: Material(
                child: Text(snapshot.message),
              ),
            );
          } else if (snapshot.state == ResultState.error) {
            return Center(
              child: Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Lottie.asset(
                        'assets/no_network.json',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => newsProvider.refreshFetchArticles(),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).refreshFetchArticles();
    });
  }
}
