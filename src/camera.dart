import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import 'camera.dart';

class Camera extends StatefulWidget {
  final loadingWidget;
  Camera(this.loadingWidget);

  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  List<CameraDescription> _cameras;
  CameraController _controller;
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    setupCamera();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_controller == null || !_controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      setupCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      if (widget.loadingWidget != null) {
        return widget.loadingWidget;
      } else {
        return Container(
          color: Colors.black,
        );
      }
    } else {
      return CameraPreview(_controller);
    }
  }

  Future<void> setupCamera() async {
    await [
      Permission.camera,
    ].request();
    _cameras = await availableCameras();
    var controller = await selectCamera();
    setState(() => _controller = controller);
  }

  selectCamera() async {
    var controller = CameraController(_cameras[_selected], ResolutionPreset.low);
    await controller.initialize();
    return controller;
  }

  Future<void> takePicture() async {
    try {
      final DateFormat formatter = DateFormat('yyyyMMddHHmmss');
      String fileName = 'image_${formatter.format(DateTime.now())}';
      final String path = '${_imagesFolder.path}/$fileName.png';
      await widget._controller.takePicture(path);
    } catch(e) {
      print(e);
    }
  }  
  
  toggleCamera() async {
    int newSelected = (_selected + 1) % _cameras.length;
    _selected = newSelected;
    
    var controller = await selectCamera();
    setState(() => _controller = controller);
  }
}
