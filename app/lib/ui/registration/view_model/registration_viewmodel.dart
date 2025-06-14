import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../../data/repositories/camera_repository.dart';

class RegistrationViewModel extends ChangeNotifier {
  final CameraRepository _repository;

  bool hasPermission = false;
  String? imagePath;

  Uint8List? imageDocument;
  Uint8List? imageSelfie;

  RegistrationViewModel(this._repository);

  Future<bool> requestCameraPermission() async {
    hasPermission = await _repository.requestCameraPermission();
    notifyListeners();
    return hasPermission;
  }

  Future<void> captureImage() async {
    if (hasPermission) {
      imagePath = await _repository.captureImage();
      notifyListeners();
    }
  }

  bool get hasAllFilled => imageDocument != null && imageSelfie != null;

  void saveDocumentImage(Uint8List imageBytes) {
    imageDocument = imageBytes;
    notifyListeners();
  }

  void saveSelfieImage(Uint8List imageBytes) {
    imageSelfie = imageBytes;
    notifyListeners();
  }
}
