import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/blog_post.dart';
import '../config/graphql_config.dart';

class BlogService {
  final GraphQLClient _client = GraphQLConfig.getClient();

  Future<List<BlogPost>> fetchAllBlogs() async {
    const String query = r'''
      query fetchAllBlogs {
        allBlogPosts {
          id
          title
          subTitle
          body
          dateCreated
        }
      }
    ''';

    final QueryResult result =
        await _client.query(QueryOptions(document: gql(query)));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List<dynamic> blogData = result.data!['allBlogPosts'];
    return blogData.map((json) => BlogPost.fromJson(json)).toList();
  }

  Future<BlogPost> getBlog(String blogId) async {
    const String query = r'''
      query getBlog($blogId: String!) {
        blogPost(blogId: $blogId) {
          id
          title
          subTitle
          body
          dateCreated
        }
      }
    ''';

    final QueryResult result = await _client.query(
      QueryOptions(
        document: gql(query),
        variables: {'blogId': blogId},
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final dynamic blogData = result.data!['blogPost'];
    return BlogPost.fromJson(blogData);
  }

  Future<BlogPost> createBlog(
      String title, String subTitle, String body) async {
    const String mutation = r'''
      mutation createBlogPost($title: String!, $subTitle: String!, $body: String!) {
        createBlog(title: $title, subTitle: $subTitle, body: $body) {
          success
          blogPost {
            id
            title
            subTitle
            body
            dateCreated
          }
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'title': title,
        'subTitle': subTitle,
        'body': body,
      },
    );

    final QueryResult result = await _client.mutate(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final dynamic blogData = result.data!['createBlog']['blogPost'];
    return BlogPost.fromJson(blogData);
  }

  Future<BlogPost> updateBlog(BlogPost blog) async {
    const String mutation = r'''
      mutation updateBlogPost($blogId: String!, $title: String!, $subTitle: String!, $body: String!) {
        updateBlog(blogId: $blogId, title: $title, subTitle: $subTitle, body: $body) {
          success
          blogPost {
            id
            title
            subTitle
            body
            dateCreated
          }
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'blogId': blog.id,
        'title': blog.title,
        'subTitle': blog.subTitle,
        'body': blog.body,
      },
    );

    final QueryResult result = await _client.mutate(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final dynamic blogData = result.data!['updateBlog']['blogPost'];
    return BlogPost.fromJson(blogData);
  }

  Future<void> deleteBlog(String blogId) async {
    const String mutation = r'''
      mutation deleteBlogPost($blogId: String!) {
        deleteBlog(blogId: $blogId) {
          success
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {'blogId': blogId},
    );

    final QueryResult result = await _client.mutate(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final bool success = result.data!['deleteBlog']['success'];
    if (!success) {
      throw Exception('Failed to delete blog post');
    }
  }
}
