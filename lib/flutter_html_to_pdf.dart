import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf/file_utils.dart';

/// HTML to PDF Converter
class FlutterHtmlToPdf {
  static const MethodChannel _channel =
      const MethodChannel('flutter_html_to_pdf');

  /// Creates PDF Document from HTML content
  /// Can throw a [PlatformException] or (unlikely) a [MissingPluginException] converting html to pdf
  static Future<File> convertFromHtmlContent(String htmlContent,
      PaperSize paperSize, String targetDirectory, String targetName) async {
    final temporaryCreatedHtmlFile =
        await FileUtils.createFileWithStringContent(
            htmlContent, "$targetDirectory/$targetName.html");
    final generatedPdfFilePath = await _convertFromHtmlFilePath(
        temporaryCreatedHtmlFile.path, paperSize);
    final generatedPdfFile = FileUtils.copyAndDeleteOriginalFile(
        generatedPdfFilePath, targetDirectory, targetName);
    temporaryCreatedHtmlFile.delete();

    return generatedPdfFile;
  }

  /// Creates PDF Document from File that contains HTML content
  /// Can throw a [PlatformException] or (unlikely) a [MissingPluginException] converting html to pdf
  static Future<File> convertFromHtmlFile(File htmlFile, PaperSize paperSize,
      String targetDirectory, String targetName) async {
    final generatedPdfFilePath =
        await _convertFromHtmlFilePath(htmlFile.path, paperSize);
    final generatedPdfFile = FileUtils.copyAndDeleteOriginalFile(
        generatedPdfFilePath, targetDirectory, targetName);

    return generatedPdfFile;
  }

  /// Creates PDF Document from path to File that contains HTML content
  /// Can throw a [PlatformException] or (unlikely) a [MissingPluginException] converting html to pdf
  static Future<File> convertFromHtmlFilePath(String htmlFilePath,
      PaperSize paperSize, String targetDirectory, String targetName) async {
    final generatedPdfFilePath =
        await _convertFromHtmlFilePath(htmlFilePath, paperSize);
    final generatedPdfFile = FileUtils.copyAndDeleteOriginalFile(
        generatedPdfFilePath, targetDirectory, targetName);

    return generatedPdfFile;
  }

  /// Assumes the invokeMethod call will return successfully
  static Future<String> _convertFromHtmlFilePath(
      String htmlFilePath, PaperSize paperSize) async {
    final result = await _channel.invokeMethod(
        'convertHtmlToPdf', <String, dynamic>{
      'htmlFilePath': htmlFilePath,
      'paperSize': paperSize.name
    });
    return result as String;
  }
}

/// Paper size
enum PaperSize {
  A3,
  A4,
  A5,
  Letter,
  Legal,
}
