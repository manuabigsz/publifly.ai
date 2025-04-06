// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:minio/io.dart';
import 'package:minio/minio.dart';

class UploadImagemFilebase {
  final String accessKey = 'EAD946CF95C216360931';
  final String secretKey = '7QoKvY1LjDFh6S6ebt0FvQUG3tDFV6q7nl7xQh2i';
  final String bucketName = 'tcc-2-saves';
  final String ipfsBaseUrl = 'https://ipfs.filebase.io/ipfs/';

  Future<String?> uploadAndFetchCid(
      Uint8List imageBytes, String objectName) async {
    try {
      final minio = Minio(
        endPoint: 's3.filebase.com',
        accessKey: accessKey,
        secretKey: secretKey,
        useSSL: true,
      );

      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/$objectName');
      await tempFile.writeAsBytes(imageBytes);

      await minio.fPutObject(bucketName, objectName, tempFile.path);

      final objectStat = await minio.statObject(bucketName, objectName);

      final cid = objectStat.metaData?['cid'] ?? '';
      if (cid.isEmpty) {
        throw Exception('CID não encontrado nos metadados do objeto.');
      }

      final objectUrl = '$ipfsBaseUrl$cid';

      return objectUrl;
    } catch (e) {
      print('Erro: $e');
      return null;
    }
  }
}
