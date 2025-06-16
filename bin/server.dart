import 'package:dart_rest_api/env/common_env.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:dart_rest_api/services/db_service.dart';
import 'package:dart_rest_api/handlers/user_handler.dart';

void main() async {
  final db = DBService();
  await db.connect();

  final router = Router();
  router.mount('/api/', UserHandler(db).router.call);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  final server = await serve(handler, ServerConfig.serverConfig.host, ServerConfig.port);
  print('✅ Server running on http://${server.address.host}:${server.port}');
}