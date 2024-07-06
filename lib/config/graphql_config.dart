// lib/config/graphql_config.dart

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static ValueNotifier<GraphQLClient> initializeClient() {
    final HttpLink httpLink = HttpLink(
      'https://uat-api.vmodel.app/graphql/',
    );

    final GraphQLClient client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()),
    );

    return ValueNotifier(client);
  }

  static GraphQLClient getClient() {
    return initializeClient().value;
  }
}
