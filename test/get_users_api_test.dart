import 'package:flutter_test/flutter_test.dart';
import 'package:khedma/core/network/user_api_service.dart';

void main() {
  test('Get users from API', () async {
    final service = UserApiService();

    final users = await service.getUsers();

    expect(users, isNotEmpty);
    expect(users.first.name, isNotEmpty);
  });
}
