import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:blog_app/services/blog_service.dart';
import 'package:blog_app/models/blog_post.dart';

class MockGraphQLClient extends Mock implements GraphQLClient {}

void main() {
  late BlogService blogService;
  late MockGraphQLClient mockClient;

  setUp(() {
    mockClient = MockGraphQLClient();
    blogService = BlogService(client: mockClient);
  });

  test('fetchAllBlogs returns list of BlogPosts when successful', () async {
    final queryResult = QueryResult(
      source: QueryResultSource.network,
      data: {
        'allBlogPosts': [
          {
            'id': '1',
            'title': 'Test Blog',
            'subTitle': 'Test Subtitle',
            'body': 'Test Body',
            'dateCreated': '2023-07-05T12:00:00Z',
          },
        ],
      },
      options: QueryOptions(document: gql('')),
    );

    when(mockClient.query(any)).thenAnswer((_) async => queryResult);

    final result = await blogService.fetchAllBlogs();

    expect(result, isA<List<BlogPost>>());
    expect(result.length, 1);
    expect(result[0].title, 'Test Blog');
  });

  test('fetchAllBlogs throws exception when unsuccessful', () async {
    final queryResult = QueryResult(
      source: QueryResultSource.network,
      exception: OperationException(
          graphqlErrors: [const GraphQLError(message: 'Failed to fetch blogs')]),
      options: QueryOptions(document: gql('')),
    );

    when(mockClient.query(any)).thenAnswer((_) async => queryResult);

    expect(() => blogService.fetchAllBlogs(), throwsException);
  });

  // TODO: Add more tests for getBlog, createBlog, updateBlog, and deleteBlog methods
}
