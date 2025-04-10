abstract class AuthRepository {
  Future<void> login(String username, String password);
  Future<void> logout();
  Future<bool> isAuthenticated();
  Future<String?> getToken();
}