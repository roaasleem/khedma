import 'package:khedma/core/models/user_model.dart';

import 'api_client.dart';

class UserApiService {
  Future<List<UserModel>> getUsers() async {
    final response = await ApiClient.dio.get('/users');
    final List<dynamic> data = response.data;
    return data.map((user) => UserModel.fromJson(user)).toList();
  }

  Future<UserModel> getUserById(String id) async {
    final response = await ApiClient.dio.get('/users/$id');
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> createUser(Map<String, dynamic> userData) async {
    final response = await ApiClient.dio.post('/users', data: userData);
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> updateUser(String id, Map<String, dynamic> userData) async {
    final response = await ApiClient.dio.put('/users/$id', data: userData);
    return UserModel.fromJson(response.data);
  }

  Future<void> deleteUser(String id) async {
    await ApiClient.dio.delete('/users/$id');
  }
}
