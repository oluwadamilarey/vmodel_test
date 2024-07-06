import 'package:blog_app/config/graphql_config.dart';
import 'package:blog_app/providers/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'screens/blog_list_screen.dart';

void main() async {
  // Initialize hive for graphql_flutter
  await initHiveForFlutter();
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQLConfig.initializeClient(),
      child: ChangeNotifierProvider(
        create: (context) => BlogProvider(),
        child: MaterialApp(
          title: 'Blog App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const BlogListScreen(),
        ),
      ),
    );
  }
}
