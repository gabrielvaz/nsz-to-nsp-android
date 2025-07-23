import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'result_screen.dart';
import '../services/nsz_converter.dart';

class ConversionScreen extends StatefulWidget {
  final File file;

  const ConversionScreen({super.key, required this.file});

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  double progress = 0.0;
  String currentStatus = 'Ready to start conversion';
  bool isConverting = false;
  bool hasError = false;
  String? errorMessage;
  String? errorDetails;
  File? outputFile;
  bool hasStarted = false;
  DateTime? conversionStartTime;
  int? estimatedFileSize;

  @override
  void initState() {
    super.initState();
    print('NSZ2NSP: ConversionScreen initialized with file: ${widget.file.path}');
    _initializeFileInfo();
  }

  Future<void> _initializeFileInfo() async {
    try {
      final fileStat = await widget.file.stat();
      setState(() {
        estimatedFileSize = fileStat.size;
      });
    } catch (e) {
      print('NSZ2NSP: Error getting file info: $e');
    }
  }

  String _getEstimatedTime() {
    if (conversionStartTime == null || progress <= 0) return '';
    
    final elapsed = DateTime.now().difference(conversionStartTime!).inMilliseconds;
    if (progress >= 1.0) return 'Completed';
    
    final totalEstimated = (elapsed / progress).round();
    final remaining = totalEstimated - elapsed;
    
    if (remaining < 1000) return 'Almost done...';
    if (remaining < 60000) return '${(remaining / 1000).round()}s remaining';
    if (remaining < 3600000) return '${(remaining / 60000).round()}m remaining';
    return '${(remaining / 3600000).round()}h remaining';
  }

  String _getConversionSpeed() {
    if (conversionStartTime == null || progress <= 0 || estimatedFileSize == null) return '';
    
    final elapsed = DateTime.now().difference(conversionStartTime!).inSeconds;
    if (elapsed <= 0) return '';
    
    final processedBytes = (estimatedFileSize! * progress).round();
    final speedBytesPerSec = processedBytes / elapsed;
    
    if (speedBytesPerSec < 1024) return '${speedBytesPerSec.toStringAsFixed(0)} B/s';
    if (speedBytesPerSec < 1024 * 1024) return '${(speedBytesPerSec / 1024).toStringAsFixed(1)} KB/s';
    return '${(speedBytesPerSec / (1024 * 1024)).toStringAsFixed(1)} MB/s';
  }

  Future<void> _startConversion() async {
    print('NSZ2NSP: Starting conversion for file: ${widget.file.path}');
    
    setState(() {
      isConverting = true;
      hasError = false;
      hasStarted = true;
      progress = 0.0;
      currentStatus = 'Preparing conversion...';
      errorMessage = null;
      errorDetails = null;
      conversionStartTime = DateTime.now();
    });

    try {
      print('NSZ2NSP: Calling NSZConverter.convertNSZToNSP');
      
      outputFile = await NSZConverter.convertNSZToNSP(
        widget.file,
        (progress, status) {
          print('NSZ2NSP: Progress: ${(progress * 100).toInt()}% - $status');
          if (mounted) {
            setState(() {
              this.progress = progress;
              currentStatus = status;
            });
          }
        },
      );

      print('NSZ2NSP: Conversion completed successfully');

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              originalFile: widget.file,
              convertedFile: outputFile!,
            ),
          ),
        );
      }

    } catch (e, stackTrace) {
      print('NSZ2NSP: Conversion error: $e');
      print('NSZ2NSP: Stack trace: $stackTrace');
      
      if (mounted) {
        setState(() {
          hasError = true;
          errorMessage = e.toString();
          errorDetails = stackTrace.toString();
          currentStatus = 'Conversion failed';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isConverting = false;
          if (!hasError) {
            conversionStartTime = null;
          }
        });
      }
    }
  }

  void _retryConversion() {
    print('NSZ2NSP: Retrying conversion');
    _startConversion();
  }

  void _showErrorDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Error Message:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(errorMessage ?? 'Unknown error'),
              const SizedBox(height: 16),
              if (errorDetails != null) ...[
                const Text(
                  'Technical Details:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  errorDetails!,
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NSZ → NSP Conversion'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: isConverting ? null : IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Icon
            Icon(
              hasError ? Icons.error : (isConverting ? Icons.sync : Icons.play_circle),
              size: 64,
              color: hasError ? Colors.red : (isConverting ? Colors.orange : Colors.green),
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              hasError ? 'Conversion Error' : (isConverting ? 'Converting...' : 'Convert File'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // File Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Source file:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(widget.file.path.split('/').last),
                  const SizedBox(height: 8),
                  FutureBuilder<FileStat>(
                    future: widget.file.stat(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          'Size: ${_formatFileSize(snapshot.data!.size)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        );
                      }
                      return const Text('Calculating size...');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Progress Section
            if (hasStarted && !hasError) ...[
              const Text(
                'Conversion progress:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress == 1.0 ? Colors.green : Colors.blue,
                ),
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      if (_getConversionSpeed().isNotEmpty)
                        Text(
                          _getConversionSpeed(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_getEstimatedTime().isNotEmpty)
                        Text(
                          _getEstimatedTime(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      if (isConverting)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      isConverting ? Icons.sync : Icons.info,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        currentStatus,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isConverting) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Please wait while your file is being converted. This may take several minutes for large files.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
            
            // Error Section
            if (hasError) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Conversion Failed',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage ?? 'Unknown error occurred',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: _showErrorDetails,
                          icon: const Icon(Icons.info_outline, size: 16),
                          label: const Text('View Details'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            
            const Spacer(),
            
            // Action Buttons
            if (!isConverting) ...[
              if (!hasStarted || hasError)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: hasError ? _retryConversion : _startConversion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasError ? Colors.orange : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      hasError ? 'Retry Conversion' : 'Start Conversion',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Back to File Selection'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}