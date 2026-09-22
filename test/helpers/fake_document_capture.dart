import 'dart:io';
import 'dart:typed_data';

import 'package:kosha/core/services/files/document_capture.dart';

/// Stands in for the file picker and the camera scanner, so widget tests can
/// exercise everything above them for real.
///
/// Both methods return null by default — the "user backed out" path, which is
/// the one a test forgets to set up and should not silently pass as a success.
class FakeDocumentCapture implements DocumentCapture {
  FakeDocumentCapture({this.fileToReturn, this.scanToReturn});

  /// What [pickFile] hands back.
  File? fileToReturn;

  /// What [scanToPdf] hands back.
  Uint8List? scanToReturn;

  int pickCalls = 0;
  int scanCalls = 0;

  @override
  Future<File?> pickFile() async {
    pickCalls++;
    return fileToReturn;
  }

  @override
  Future<Uint8List?> scanToPdf() async {
    scanCalls++;
    return scanToReturn;
  }
}
