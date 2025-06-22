import 'dart:convert';
import 'package:dart_rest_api/common/common_data.dart';
import 'package:dart_rest_api/common/converter.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/db_service.dart';

class UserHandler {
  final DBService db;

  UserHandler(this.db);

  Router get router {
    final router = Router();

    router.get('/users', (Request request) async {
      if (db.connection == null || !db.connection!.isOpen) {
        throw Exception('Database connection is not established');
      }

      final results = await db.connection!.execute(
        'SELECT * FROM basic_details',
      );
      final users = results.map((row) => row.toColumnMap()).toList();
      
      return Response.ok(
        CommonData.encodeDataToJsonApi<List<Map<String,dynamic>>>(users, request, isApiSuccess: true, message: 'Users fetched successfully'),
        headers: {'Content-Type': 'application/json'},
      );
    });

    router.post('/users', (Request request) async {
      FilterData.processReceivedData(request, ['name', 'age']).then((
        data,
      ) async {
        print('Received data: $data');
        final name = data['name'];
        final age = data['age'];

        if (name != null && age != null) {
          await db.connection?.execute(
            Sql.named(
              'INSERT INTO basic_details (name, age) VALUES (@name, @age)',
            ),
            parameters: {'name': name, 'age': age},
          );

          return Response.ok(
            jsonEncode({'message': 'User added'}),
            headers: {'Content-Type': 'application/json'},
          );
        } else {
          return Response(400, body: 'Missing name or age fields');
        }
      });
    });

    return router;
  }
}
