import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'conversion_screen.dart';
import '../services/permission_manager.dart';

class FileSelectionScreen extends StatefulWidget {
  const FileSelectionScreen({super.key});

  @override
  State<FileSelectionScreen> createState() => _FileSelectionScreenState();
}

class _FileSelectionScreenState extends State<FileSelectionScreen> {
  File? selectedFile;
  bool isLoading = false;
  double loadingProgress = 0.0;
  String loadingStatus = '';
  DateTime? loadingStartTime;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final hasPermission = await PermissionManager.checkStoragePermissions();
    if (!hasPermission) {
      final granted = await PermissionManager.requestStoragePermissions();
      if (!granted) {
        _showPermissionDialog();
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
            'The app needs permission to access storage to select and save files.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                PermissionManager.openAppSettings();
              },
              child: const Text('Settings'),
            ),
          ],
        );
      },
    );
  }

  String _getEstimatedTime() {
    if (loadingStartTime == null) return '';
    
    final elapsed = DateTime.now().difference(loadingStartTime!).inMilliseconds;
    if (loadingProgress <= 0) return '';
    
    final totalEstimated = (elapsed / loadingProgress).round();
    final remaining = totalEstimated - elapsed;
    
    if (remaining < 1000) return 'Almost done...';
    if (remaining < 60000) return '${(remaining / 1000).round()}s remaining';
    return '${(remaining / 60000).round()}m remaining';
  }

  Future<void> _updateProgress(double progress, String status) async {
    if (mounted) {
      setState(() {
        loadingProgress = progress;
        loadingStatus = status;
      });
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> _pickFile() async {
    setState(() {
      isLoading = true;
      loadingProgress = 0.0;
      loadingStatus = 'Opening file picker...';
      loadingStartTime = DateTime.now();
    });

    try {
      print('NSZ2NSP: Starting file picker...');
      await _updateProgress(0.1, 'Opening file picker...');
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      print('NSZ2NSP: File picker result: ${result != null}');
      await _updateProgress(0.3, 'Processing selection...');

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        print('NSZ2NSP: Selected file: ${file.path}');
        
        await _updateProgress(0.5, 'Validating file format...');
        
        // Validate that the file is NSZ
        if (!file.path.toLowerCase().endsWith('.nsz')) {
          print('NSZ2NSP: Invalid file extension');
          _showError('Please select a valid NSZ file');
          return;
        }
        
        await _updateProgress(0.7, 'Checking file accessibility...');
        
        if (await file.exists()) {
          await _updateProgress(0.85, 'Reading file information...');
          final fileSize = await file.length();
          print('NSZ2NSP: File exists, size: $fileSize bytes');
          
          await _updateProgress(1.0, 'File loaded successfully!');
          
          setState(() {
            selectedFile = file;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Loaded ${_formatFileSize(fileSize)} NSZ file'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          print('NSZ2NSP: File does not exist');
          _showError('File not found');
        }
      } else {
        print('NSZ2NSP: No file selected');
        await _updateProgress(0.0, 'No file selected');
      }
    } catch (e) {
      print('NSZ2NSP: Error selecting file: $e');
      _showError('Error selecting file: $e');
    } finally {
      setState(() {
        isLoading = false;
        loadingProgress = 0.0;
        loadingStatus = '';
        loadingStartTime = null;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
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
        title: const Text('Select NSZ File'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.folder_open,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const Text(
              'Select an NSZ file',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose the .nsz file you want to convert to .nsp',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            
            // Progress Bar Section
            if (isLoading) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.hourglass_empty, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Loading File...',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${(loadingProgress * 100).toInt()}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: loadingProgress,
                      backgroundColor: Colors.blue.shade100,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      minHeight: 6,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            loadingStatus,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          _getEstimatedTime(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            if (selectedFile != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected File:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedFile!.path.split('/').last,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<FileStat>(
                      future: selectedFile!.stat(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            'Size: ${_formatFileSize(snapshot.data!.size)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          );
                        }
                        return const Text('Calculating size...');
                      },
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Location: ${selectedFile!.parent.path}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _pickFile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Loading...'),
                        ],
                      )
                    : const Text(
                        'Select NSZ File',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            if (selectedFile != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ConversionScreen(file: selectedFile!),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Continue to Conversion',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}