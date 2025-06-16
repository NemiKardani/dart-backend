import 'package:postgres/postgres.dart';

class ServerConfig {
  static Endpoint get serverConfig => Endpoint(
    host: 'localhost',
    port: 5432,
    username: 'postgres',
    password: 'Test@123',
    database: 'nemi_test_db',
  );

  static const int port = 8080;
}
