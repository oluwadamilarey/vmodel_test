import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:blog_app/providers/blog_provider.dart';
import 'package:blog_app/services/blog_service.dart';
import 'package:blog_app/models/blog_post.dart';

class MockBlogService extends Mock implements BlogService {}

void main() {
  late BlogProvider blogProvider;
  late MockBlogService mockBlogService;

  setUp(() {
    mockBlogService = MockBlogService();
    blogProvider = BlogProvider(blogService: mockBlogService);
  });

  test('fetchBlogs updates blogPosts when successful', () async {
    final blogs = [
      BlogPost(
          id: '1',
          title: 'Test Blog',
          subTitle: 'Test Subtitle',
          body: 'Test Body',
          dateCreated: DateTime.now()),
    ];

    when(mockBlogService.fetchAllBlogs()).thenAnswer((_) async => blogs);

    await blogProvider.fetchBlogs();

    expect(blogProvider.blogPosts, blogs);
    expect(blogProvider.isLoading, false);
    expect(blogProvider.error, null);
  });

  test('fetchBlogs sets error when unsuccessful', () async {
    when(mockBlogService.fetchAllBlogs())
        .thenThrow(Exception('Failed to fetch blogs'));

    await blogProvider.fetchBlogs();

    expect(blogProvider.blogPosts, isEmpty);
    expect(blogProvider.isLoading, false);
    expect(blogProvider.error, isNotNull);
  });

  // TODO: Add more tests for createBlog, updateBlog, and deleteBlog methods
}
