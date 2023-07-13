import 'dart:io';

import 'package:daily_press/data/api/api_service.dart';
import 'package:daily_press/data/model/article.dart';
import 'package:daily_press/utils/result_state.dart';
import 'package:flutter/foundation.dart';

class NewsProvider extends ChangeNotifier {
  final ApiService apiService;

  NewsProvider({required this.apiService}) {
    _fetchArticles();
  }

  late ArticlesResult _articlesResult;
  late ResultState _state;
  String _message = '';
  bool _isRefreshing = false;
  String _greeting = '';

  ArticlesResult get result => _articlesResult;
  ResultState get state => _state;
  String get message => _message;
  bool get isRefreshing => _isRefreshing;
  String get greeting => _greeting;

  Future<dynamic> _fetchArticles() async {
    _state = ResultState.loading;
    _setGreeting();
    notifyListeners();
    try {
      final getConnection = await checkConnection();
      if (getConnection) {
        final response = await apiService.topHeadlines();
        if (response.articles.isEmpty) {
          _state = ResultState.noData;
          notifyListeners();
          return _message = 'Tidak ada data';
        } else {
          _articlesResult = response;
          _state = ResultState.hasData;
          notifyListeners();
          return _articlesResult;
        }
      } else {
        _state = ResultState.error;
        notifyListeners();
        return _message = 'Tidak ada koneksi';
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error : $e';
    }
  }

  Future<void> refreshFetchArticles() async {
    _isRefreshing = true;
    _setGreeting();
    notifyListeners();
    try {
      final getConnection = await checkConnection();
      if (getConnection) {
        _articlesResult = await apiService.topHeadlines();
        if (_articlesResult.articles.isEmpty) {
          _state = ResultState.noData;
          throw 'Tidak ada data';
        } else {
          _state = ResultState.hasData;
        }
      } else {
        _state = ResultState.error;
        throw 'Tidak ada koneksi';
      }
    } catch (e) {
      _state = ResultState.error;
      throw 'Error: $e';
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  static Future<bool> checkConnection() async {
    try {
      final connect = await InternetAddress.lookup('google.com');
      if (connect.isNotEmpty && connect[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  void _setGreeting() {
    final currentTime = DateTime.now();
    final currentHour = currentTime.hour;

    if (currentHour < 12) {
      _greeting = 'Morning';
    } else if (currentHour < 17) {
      _greeting = 'Afternoon';
    } else {
      _greeting = 'Night';
    }
  }
}
