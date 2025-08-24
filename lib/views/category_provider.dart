import 'package:flutter/cupertino.dart';

import '../testClient.dart';

class CategoryProvider extends ChangeNotifier {
  final CommandClient client;
  List<String> _categories = [];
  bool _isLoading = true;
  String? _error;

  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CategoryProvider({required this.client}) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await client.sendCommand("getCategories");
      List<String> fetched = List<String>.from(response['categories']).toSet().toList();
      _categories = fetched;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
