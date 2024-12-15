import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final _supabase = Supabase.instance.client;
  final loading = false.obs;

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      loading.value = true;
      await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      loading.value = true;
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      loading.value = true;
      await _supabase.auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }
}
