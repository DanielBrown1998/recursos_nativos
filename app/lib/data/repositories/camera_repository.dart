import 'dart:async';

class CameraRepository {
  Future<bool> requestCameraPermission() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Simula permissão concedida
  }

  Future<String?> captureImage() async {
    await Future.delayed(const Duration(seconds: 1));
    return "assets/images/test_photo.png"; // Simula uma imagem capturada
  }
}
