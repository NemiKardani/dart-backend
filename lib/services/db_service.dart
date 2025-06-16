import 'package:dart_rest_api/env/common_env.dart';
import 'package:postgres/postgres.dart';

class DBService {
  Connection? connection;

  Future<void> connect() async {
    if (connection != null && connection!.isOpen) {
      print('✅ Already connected to DB');

      return;
    }
    connection = await Connection.open(
      ServerConfig.serverConfig,
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );

    if (connection != null && connection!.isOpen) {
      print('✅ Connected to DB');
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    if (connection == null || !connection!.isOpen) {
      throw Exception('Database connection is not established');
    }

    final results = await connection!.execute('SELECT * FROM basic_details');
    return results.map((row) => row.toColumnMap()).toList();
  }

  Future<void> close() async {
    if (connection != null && connection!.isOpen) {
      await connection!.close();
      print('✅ Database connection closed');
    }
  }
}
