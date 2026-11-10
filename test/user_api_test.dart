import 'package:flutter_test/flutter_test.dart';
import 'package:khedma/core/network/user_api_service.dart';

void main() {
  test('User API CRUD operations', () async {
    final service = UserApiService();
    String? userId;

    try {
      final user = await service.createUser({
        'name': 'Test User',
        'email': 'testuser@gmail.com',
        'phone': '01000000000',
        'avatar': '',
        'role': 'customer',
        'favorites': '[]',
      });

      userId = user.id;

      final users = await service.getUsers();
      expect(users.any((u) => u.id == user.id), true);

      final result = await service.getUserById(user.id);
      expect(result.id, user.id);

      final updatedUser = await service.updateUser(user.id, {
        'name': 'Updated User',
        'email': 'testuser@gmail.com',
        'phone': '01000000000',
        'avatar': '',
        'role': 'customer',
        'favorites': '[]',
      });

      expect(updatedUser.name, 'Updated User');
    } finally {
      if (userId != null) {
        await service.deleteUser(userId);
      }
    }
  });
}
