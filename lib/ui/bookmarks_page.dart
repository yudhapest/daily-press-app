import 'package:daily_press/provider/database_provider.dart';
import 'package:daily_press/utils/result_state.dart';
import 'package:daily_press/widgets/card_article.dart';
import 'package:daily_press/widgets/card_shimmer.dart';
import 'package:daily_press/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class BookmarksPage extends StatelessWidget {
  static const routeName = '/bookmarks-page';
  static const String bookmarksTitle = 'Bookmarks';

  const BookmarksPage({Key? key}) : super(key: key);

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 14.0),
                child: Text(
                  bookmarksTitle,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              Expanded(child: _buildList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 14.0),
                child: Text(
                  bookmarksTitle,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              Expanded(
                child: _buildList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.hasData) {
          return ListView.builder(
            itemCount: provider.bookmarks.length,
            itemBuilder: (context, index) {
              return CardArticle(article: provider.bookmarks[index]);
            },
          );
        } else if (provider.state == ResultState.noData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Lottie.asset(
                    'assets/no_data.json',
                  ),
                ),
              ],
            ),
          );
        } else if (provider.state == ResultState.error) {
          return Center(
            child: Material(
              child: Text(provider.message),
            ),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: 3, // Jumlah card shimmer saat data masih loading
            itemBuilder: (context, index) {
              return const ShimmerCard();
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
