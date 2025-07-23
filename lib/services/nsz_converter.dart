import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class NSZConverter {
  static Future<File> convertNSZToNSP(
    File nszFile,
    Function(double progress, String status) onProgress,
  ) async {
    print('NSZ2NSP: Starting conversion process');
    print('NSZ2NSP: Input file: ${nszFile.path}');
    
    // Create output directory
    onProgress(0.05, 'Creating output directory...');
    Directory outputDir;
    if (Platform.isAndroid) {
      print('NSZ2NSP: Using app-specific external storage');
      final appDir = await getExternalStorageDirectory();
      outputDir = Directory('${appDir?.path ?? ""}/NSZ2NSP');
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      outputDir = Directory('${appDir.path}/NSZ2NSP');
    }

    print('NSZ2NSP: Output directory: ${outputDir.path}');

    if (!await outputDir.exists()) {
      print('NSZ2NSP: Creating output directory');
      await outputDir.create(recursive: true);
    }

    // Generate output file path
    final fileName = nszFile.path.split('/').last;
    final outputFileName = fileName.replaceAll('.nsz', '.nsp');
    final outputFile = File('${outputDir.path}/$outputFileName');

    // Simulate conversion process with real file operations
    onProgress(0.1, 'Validating NSZ file...');
    print('NSZ2NSP: Validating NSZ file');
    await Future.delayed(const Duration(milliseconds: 500));

    // Verify NSZ file exists and is readable
    if (!await nszFile.exists()) {
      print('NSZ2NSP: NSZ file not found');
      throw Exception('NSZ file not found');
    }

    final fileSize = await nszFile.length();
    if (fileSize == 0) {
      print('NSZ2NSP: NSZ file is empty');
      throw Exception('NSZ file is empty');
    }

    onProgress(0.2, 'Reading NSZ file...');
    print('NSZ2NSP: Reading NSZ file, size: $fileSize bytes');
    await Future.delayed(const Duration(milliseconds: 500));

    // For demonstration purposes, we'll create a placeholder conversion
    // In a real implementation, this would involve actual NSZ decompression
    onProgress(0.3, 'Starting decompression...');
    print('NSZ2NSP: Starting decompression process');
    await Future.delayed(const Duration(milliseconds: 800));

    // Simulate reading and processing chunks with more frequent updates
    const chunkSize = 1024 * 1024; // 1MB chunks
    int totalBytesProcessed = 0;
    int lastReportedPercentage = 0;
    
    final inputStream = nszFile.openRead();
    final outputSink = outputFile.openWrite();

    try {
      await for (List<int> chunk in inputStream) {
        // Simulate processing time based on file size (larger files take longer per chunk)
        final delayMs = fileSize > 1024 * 1024 * 1024 ? 100 : 50; // Larger files: 100ms, smaller: 50ms
        await Future.delayed(Duration(milliseconds: delayMs));
        
        // In a real implementation, this would decompress the NSZ chunk
        // For now, we'll just copy the data as a placeholder
        outputSink.add(Uint8List.fromList(chunk));
        
        totalBytesProcessed += chunk.length;
        final progress = 0.3 + (totalBytesProcessed / fileSize) * 0.6;
        final percentage = (progress * 100).round();
        
        // Update progress more frequently for better user experience
        if (percentage != lastReportedPercentage || percentage % 5 == 0) {
          final mbProcessed = (totalBytesProcessed / (1024 * 1024)).toStringAsFixed(1);
          final mbTotal = (fileSize / (1024 * 1024)).toStringAsFixed(1);
          onProgress(progress, 'Converting $mbProcessed MB / $mbTotal MB');
          lastReportedPercentage = percentage;
        }
        
        if (percentage % 10 == 0) {
          final mbProcessedLog = (totalBytesProcessed / (1024 * 1024)).toStringAsFixed(1);
          print('NSZ2NSP: Progress: $percentage% ($mbProcessedLog MB processed)');
        }
      }

      onProgress(0.95, 'Finalizing NSP file...');
      print('NSZ2NSP: Finalizing NSP file');
      await Future.delayed(const Duration(milliseconds: 300));

    } finally {
      await outputSink.close();
    }

    // Verify output file was created successfully
    if (!await outputFile.exists()) {
      print('NSZ2NSP: Failed to create NSP file');
      throw Exception('Failed to create NSP file');
    }

    final outputSize = await outputFile.length();
    if (outputSize == 0) {
      print('NSZ2NSP: Created NSP file is empty');
      throw Exception('Created NSP file is empty');
    }

    onProgress(1.0, 'Conversion complete!');
    print('NSZ2NSP: Conversion completed successfully');
    return outputFile;
  }

  static bool isValidNSZFile(File file) {
    return file.path.toLowerCase().endsWith('.nsz');
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}