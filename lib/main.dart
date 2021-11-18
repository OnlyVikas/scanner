import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


void main() {
  runApp(MaterialApp(home:MyApp() ,));
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {controller!.pauseCamera();} else if (Platform.isIOS) {controller!.resumeCamera();}}
  @override
  Widget build(BuildContext context) {
    return  Hero(tag: "QR Scanner", child: Scaffold(body: Column(
      children: <Widget>[
        Expanded(flex: 10, child: _buildQrView(context),),
        Expanded(flex: 1,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Column(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (result != null)Text('Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                else Text('Scan a code',style: TextStyle(fontSize:24,color: Colors.blue),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(4),
                      child: ElevatedButton(
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              return Text('Flash: ${snapshot.data}');
                            },
                          )),

                    ),
                    Container(
                      margin: EdgeInsets.all(4),
                      child: ElevatedButton(
                          onPressed: () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Text(
                                    'Camera facing ${describeEnum(snapshot.data!)}');
                              } else {
                                return Text('loading');
                              }
                            },
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.all(4),
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller?.pauseCamera();
                        },
                        child: Text('pause', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(4),
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller?.resumeCamera();
                        },
                        child: Text('resume', style: TextStyle(fontSize: 20)),
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
        )
      ],),));
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 600 ||
        MediaQuery.of(context).size.height < 600) ? 250.0 : 400.0;
    return QRView(key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(borderColor: Colors.green, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),);}

  void _onQRViewCreated(QRViewController controller) {
    setState(() {this.controller = controller;});
    controller.scannedDataStream.listen((scanData) {
      setState(() {result = scanData;});
    });}
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();}
}


