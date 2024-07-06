import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/blog_provider.dart';
import '../widgets/blog_list_item.dart';
import 'blog_edit_screen.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BlogProvider>(context, listen: false).fetchBlogs();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('my mutterings', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: () =>
                Provider.of<BlogProvider>(context, listen: false).fetchBlogs(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search blogs...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<BlogProvider>(
              builder: (context, blogProvider, child) {
                if (blogProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (blogProvider.error != null) {
                  return Center(
                      child: Text('Error: ${blogProvider.error}',
                          style: const TextStyle(color: Colors.red)));
                }
                if (blogProvider.blogPosts.isEmpty) {
                  return const Center(
                      child: Text('No blog posts available.',
                          style: TextStyle(fontSize: 18)));
                }

                var filteredBlogs = blogProvider.blogPosts.where((blog) {
                  return blog.title
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                      blog.subTitle
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                      blog.body
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                }).toList();

                if (filteredBlogs.isEmpty) {
                  return const Center(
                      child: Text('No matching blog posts found.',
                          style: TextStyle(fontSize: 18)));
                }

                return ListView.builder(
                  itemCount: filteredBlogs.length,
                  itemBuilder: (context, index) {
                    final blog = filteredBlogs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: BlogListItem(
                        blog: blog,
                        onDelete: (id) => blogProvider.deleteBlog(id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const BlogEditScreen())),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
