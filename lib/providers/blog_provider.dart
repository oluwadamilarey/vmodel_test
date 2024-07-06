import 'package:flutter/foundation.dart';
import '../models/blog_post.dart';
import '../services/blog_service.dart';

class BlogProvider with ChangeNotifier {
  final BlogService _blogService = BlogService();
  List<BlogPost> _blogPosts = [];
  bool _isLoading = false;
  String? _error;

  List<BlogPost> get blogPosts => _blogPosts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBlogs() async {
    _setLoading(true);
    try {
      _blogPosts = await _blogService.fetchAllBlogs();
      _sortBlogsAscending();
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch blogs: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createBlog(String title, String subTitle, String body) async {
    _setLoading(true);
    try {
      final newBlog = await _blogService.createBlog(title, subTitle, body);
      _blogPosts.add(newBlog);
      _sortBlogsAscending();
      _error = null;
    } catch (e) {
      _error = 'Failed to create blog: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateBlog(BlogPost updatedBlog) async {
    _setLoading(true);
    try {
      final updated = await _blogService.updateBlog(updatedBlog);
      final index = _blogPosts.indexWhere((blog) => blog.id == updated.id);
      if (index != -1) {
        _blogPosts[index] = updated;
      }
      _sortBlogsAscending();
      _error = null;
    } catch (e) {
      _error = 'Failed to update blog: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteBlog(String id) async {
    _setLoading(true);
    try {
      await _blogService.deleteBlog(id);
      _blogPosts.removeWhere((blog) => blog.id == id);
      _error = null;
    } catch (e) {
      _error = 'Failed to delete blog: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  BlogPost? getBlogById(String id) {
    try {
      return _blogPosts.firstWhere((blog) => blog.id == id);
    } catch (e) {
      return null;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _sortBlogsAscending() {
    _blogPosts.sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
    notifyListeners();
  }
}
