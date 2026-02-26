import 'dart:io';
import 'package:flutter/material.dart';
import 'video_preview.dart';

class MediaProof extends StatelessWidget {
  final File? file;
  final VoidCallback onPickImage;
  final VoidCallback onPickVideo;
  final VoidCallback onRemove;

  const MediaProof({
    super.key,
    required this.file,
    required this.onPickImage,
    required this.onPickVideo,
    required this.onRemove,
  });

  bool _isVideo(String path) {
    final lowerPath = path.toLowerCase();
    return lowerPath.endsWith('.mp4') ||
        lowerPath.endsWith('.mov') ||
        lowerPath.endsWith('.avi');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          "ATTACH PROOF (OPTIONAL)",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Colors.grey,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        if (file == null)
          Row(
            children: [
              Expanded(
                child: _buildPickerButton(
                  Icons.camera_alt_outlined,
                  "Photo",
                  onPickImage,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPickerButton(
                  Icons.videocam_outlined,
                  "Video",
                  onPickVideo,
                ),
              ),
            ],
          )
        else
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _isVideo(file!.path)
                      ? VideoPreview(file: file!)
                      : Image.file(file!, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPickerButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
