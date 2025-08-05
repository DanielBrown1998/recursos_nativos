import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_banco_douro/ui/registration/widgets/denied_camera_permission_dialog.dart';
import 'package:flutter_banco_douro/ui/registration/widgets/image_preview_dialog.dart';
import 'package:flutter_banco_douro/ui/registration/widgets/request_camera_permission_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'view_model/registration_viewmodel.dart';
import 'widgets/form_field_widget.dart';
import 'package:camera/camera.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedDocumentType = "CNH"; // Valor inicial do dropdown
  CameraController? cameraController;
  XFile? pictureDoc;
  XFile? pictureFace;
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegistrationViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro"),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              /// CAMPOS DO FORMULÁRIO
              const FormFieldWidget(label: "Nome"),
              const FormFieldWidget(label: "Sobrenome"),
              const FormFieldWidget(label: "Data de Nascimento"),
              const FormFieldWidget(label: "Endereço"),
              const FormFieldWidget(label: "Cidade"),
              const FormFieldWidget(label: "Estado"),
              const FormFieldWidget(label: "CPF"),

              /// DROPDOWN DE TIPO DE DOCUMENTO
              const SizedBox(height: 16),
              const Text("Tipo de documento"),
              DropdownButton<String>(
                value: _selectedDocumentType,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: "RG", child: Text("RG")),
                  DropdownMenuItem(value: "CNH", child: Text("CNH")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDocumentType = value!;
                  });
                },
              ),
              const FormFieldWidget(label: "Órgão expedidor"),

              const SizedBox(height: 16),

              /// FOTO DO DOCUMENTO
              _buildImageSection(
                  label: "Fotografar documento",
                  onTap: () async {
                    viewModel.imageDocument =
                        await _handleCameraClicked(context);
                  },
                  icon: Icons.badge,
                  isDocument: true),

              const SizedBox(height: 16),

              /// FOTO DO ROSTO
              _buildImageSection(
                  label: "Fotografar rosto",
                  onTap: () async {
                    viewModel.imageSelfie =
                        await _handleCameraClicked(context, isDocument: false);
                  },
                  isDocument: false,
                  icon: Icons.face),

              const SizedBox(height: 24),

              /// BOTÕES DE AÇÃO
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text("Cancelar"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: viewModel.hasAllFilled
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                // TODO: processar os dados aqui
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text("Cadastrar"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Seção para exibir as imagens tiradas (Documento ou Rosto)
  Widget _buildImageSection(
      {required String label,
      required VoidCallback onTap,
      required IconData icon,
      required bool isDocument}) {
    final viewModel = Provider.of<RegistrationViewModel>(context);
    return Column(
      spacing: 8,
      children: [
        Container(
          width: 150,
          height: 200,
          color: Colors.grey.shade200,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 750),
            layoutBuilder: (currentChild, previousChildren) {
              return (!isDocument && viewModel.imageSelfie != null)
                  ? Image.memory(viewModel.imageSelfie!)
                  : (isDocument && viewModel.imageDocument != null)
                      ? Image.memory(viewModel.imageDocument!)
                      : Icon(
                          icon,
                          size: 48,
                          color: Colors.grey.shade600,
                        );
            },
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.camera_alt),
              label: Text(label),
            ),
          ],
        ),
      ],
    );
  }

  /// Lógica para solicitar permissão da câmera
  Future<Uint8List?> _handleCameraClicked(BuildContext context,
      {bool isDocument = true}) async {
    List<CameraDescription> cameras = await availableCameras();
    PermissionStatus cameraPermissionStatus = await Permission.camera.status;

    if (cameraPermissionStatus == PermissionStatus.denied) {
      if (!context.mounted) return null;
      PermissionStatus? newCameraPermissionStatus =
          await showRequestCameraPermissionDialog(context);
      if (newCameraPermissionStatus != null) {
        cameraPermissionStatus = newCameraPermissionStatus;
      }
    } else if (cameraPermissionStatus.isPermanentlyDenied) {
      if (!context.mounted) return null;
      await showDeniedCameraPermissionDialog(context);
    }
    if (!cameraPermissionStatus.isDenied &&
        !cameraPermissionStatus.isPermanentlyDenied) {
      late CameraDescription cameraDescription;
      if (isDocument) {
        cameraController =
            CameraController(cameras.first, ResolutionPreset.high);
        await cameraController!.initialize();
        cameraDescription = cameras.first;
      } else {
        cameraController = CameraController(cameras.last, ResolutionPreset.max);
        await cameraController!.initialize();
        cameraDescription = cameras.last;
      }

      double aspectRatio = cameraController!.value.aspectRatio;
      if (!context.mounted) return null;
      Uint8List? picture = await showCamera(context, cameraController!,
          cameraDescription, aspectRatio, isDocument);
      setState(() {});
      return picture;
    }
    return null;
  }
}

Future<Uint8List?> showCamera(
    BuildContext context,
    CameraController cameraController,
    CameraDescription cameraDescription,
    double aspectRatio,
    bool isDocument) {
  switch (cameraDescription.sensorOrientation) {
    case (0):
      cameraController.lockCaptureOrientation(DeviceOrientation.landscapeRight);
      break;
    case (90):
      cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);
      break;
    case (180):
      cameraController.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
      break;
    case (270):
      cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);
      break;
  }
  // Usamos o widget Dialog para ter mais controle sobre o layout e preencher a tela inteira.
  final cameraDialog = Dialog(
    shape: const BeveledRectangleBorder(),
    backgroundColor: Colors.black,
    insetPadding: EdgeInsets.zero, // Remove o padding padrão ao redor do Dialog
    child: (cameraController.value.isInitialized)
        ? Stack(
            fit: StackFit.expand,
            children: [
              // Camera Preview em tela cheia
              (!isDocument)
                  ? Container(
                      decoration: const BoxDecoration(color: Colors.white),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1 / aspectRatio,
                    child: CameraPreview(
                      cameraController,
                    ),
                  ),
                ),
              ),
              // Imagem de guia sobreposta
              Image.asset(
                (isDocument)
                    ? "assets/images/guides/guide_cnh.png"
                    : "assets/images/guides/guide_selfie.png",
                fit: BoxFit.contain,
              ),
              // Botões de ação na parte inferior
              Positioned(
                bottom: 64,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Transform.rotate(
                      angle: isDocument ? pi / 2 : 0,
                      child: IconButton(
                        onPressed: () async {
                          Uint8List? picture = await _onCapturePictureButton(
                              context, cameraController);
                          if (!context.mounted) return;
                          cameraController.dispose();
                          Navigator.pop(context, picture);
                        },
                        icon: Icon(Icons.camera_alt,
                            color: (isDocument) ? Colors.white : Colors.black,
                            size: 42),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        cameraController.dispose();
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.cancel,
                          color: (isDocument) ? Colors.white : Colors.black,
                          size: 42),
                    ),
                  ],
                ),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator()),
  );

  return showDialog(
    context: context,
    builder: (context) {
      return cameraDialog;
    },
  );
}

Future<dynamic> _onCapturePictureButton(
    BuildContext context, CameraController cameraController) async {
  XFile snapshotFile = await cameraController.takePicture();

  Uint8List snapshotFileAsByte = await snapshotFile.readAsBytes();

  if (!context.mounted) return;
  bool confirm = await showImagePreviewDialog(context, snapshotFileAsByte,
      needConfirmation: true);
  if (confirm) return snapshotFileAsByte;
  return null;
}
