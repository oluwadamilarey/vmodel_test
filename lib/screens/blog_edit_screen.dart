import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/blog_post.dart';
import '../providers/blog_provider.dart';

class BlogEditScreen extends StatefulWidget {
  final BlogPost? blog;

  const BlogEditScreen({super.key, this.blog});

  @override
  _BlogEditScreenState createState() => _BlogEditScreenState();
}

class _BlogEditScreenState extends State<BlogEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subTitleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.blog?.title ?? '');
    _subTitleController =
        TextEditingController(text: widget.blog?.subTitle ?? '');
    _bodyController = TextEditingController(text: widget.blog?.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subTitleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.blog == null ? 'Create Blog Post' : 'Edit Blog Post',
            style: const TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _subTitleController,
                decoration: const InputDecoration(
                  labelText: 'Subtitle',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subtitle';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'Body',
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the body';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _saveBlogPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveBlogPost() {
    if (_formKey.currentState!.validate()) {
      final blogProvider = Provider.of<BlogProvider>(context, listen: false);

      if (widget.blog == null) {
        blogProvider.createBlog(
          _titleController.text,
          _subTitleController.text,
          _bodyController.text,
        );
      } else {
        final updatedBlog = widget.blog!.copyWith(
          title: _titleController.text,
          subTitle: _subTitleController.text,
          body: _bodyController.text,
        );
        blogProvider.updateBlog(updatedBlog);
      }

      Navigator.of(context).pop();
    }
  }
}
