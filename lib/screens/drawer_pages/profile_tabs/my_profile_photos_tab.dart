import 'dart:io';

import 'package:beatflirt/Api_services/api_services.dart';
import 'package:beatflirt/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyProfilePhotosTab extends StatefulWidget {
  const MyProfilePhotosTab({super.key});

  @override
  State<MyProfilePhotosTab> createState() => _MyProfilePhotosTabState();
}

class _MyProfilePhotosTabState extends State<MyProfilePhotosTab> {
  bool _showApproved = false;
  final ImagePicker _picker = ImagePicker();
  final ApiServices _api = ApiServices();
  bool _isLoading = true;

  List<_PhotoItem> _pendingPhotos = [
    _PhotoItem(mediaId: '', path: 'assets/images/notification-image1.jpg', approved: false),
    _PhotoItem(mediaId: '', path: 'assets/images/notification-image5.jpg', approved: false),
    _PhotoItem(mediaId: '', path: 'assets/images/notification-image4.jpg', approved: false),
  ];
  List<_PhotoItem> _approvedPhotos = [
    _PhotoItem(mediaId: '', path: 'assets/images/notification-image4.jpg', approved: true, isMain: true),
  ];

  @override
  void initState() {
    super.initState();
    _loadPhotosFromApi();
  }

  @override
  Widget build(BuildContext context) {
    final list = _showApproved ? _approvedPhotos : _pendingPhotos;
    final sectionTitle = _showApproved ? 'Approved Photos' : 'Pending Approval';
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 380;
    final cardWidth = isCompact ? width - 64 : 220.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statusTabs(),
        const SizedBox(height: 12),
        if (_showApproved) _infoStrip(),
        if (_showApproved) const SizedBox(height: 16),
        if (_showApproved)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                sectionTitle,
                style: TextStyle(
                  fontSize: isCompact ? 24 : 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addPhoto,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Photo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF220027),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          )
        else
          Text(
            sectionTitle,
            style: TextStyle(
              fontSize: isCompact ? 24 : 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        const SizedBox(height: 14),
        if (_isLoading)
          const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
        else
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: list.map((item) => _photoCard(item, cardWidth)).toList(),
          ),
      ],
    );
  }

  Widget _statusTabs() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF19001F), Color(0xFF490040)],
        ),
      ),
      child: Row(
        children: [
          _pillTab(
            label: 'Approved',
            selected: _showApproved,
            onTap: () => setState(() => _showApproved = true),
          ),
          const Spacer(),
          _pillTab(
            label: 'Pending',
            selected: !_showApproved,
            onTap: () => setState(() => _showApproved = false),
          ),
        ],
      ),
    );
  }

  Widget _pillTab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFF2D87) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _infoStrip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF2D1935)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Only high-quality images are approved. Avoid children, animals, weapons, or contact info.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoCard(_PhotoItem item, double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E0F2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: item.xFile != null
                    ? Image.file(
                        File(item.xFile!.path),
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _fallbackImage(),
                      )
                    : Image.asset(
                        item.path,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _fallbackImage(),
                      ),
              ),
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: item.approved ? const Color(0xFF20B35D) : const Color(0xFFF7D12D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.approved ? 'APPROVED' : 'PENDING',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: const Color(0xFFFF4473),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 14, color: Colors.white),
                    onPressed: () => _deletePhoto(item),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Icon(
                  item.approved ? Icons.check_circle_outline : Icons.access_time,
                  size: 14,
                  color: Colors.black54,
                ),
                const SizedBox(width: 6),
                Text(
                  item.approved
                      ? (item.isMain ? 'Set Main' : 'Approved')
                      : 'Awaiting Approval',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _deletePhoto(_PhotoItem item) {
    _deletePhotoApi(item);
  }

  Future<void> _addPhoto() async {
    final source = await _chooseSource();
    if (source == null) return;

    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (picked == null) return;

    setState(() {
      _pendingPhotos.insert(
        0,
        _PhotoItem(
          mediaId: '',
          path: picked.path,
          approved: false,
          xFile: picked,
        ),
      );
      _showApproved = false;
    });
    final token = await AuthService.getToken();
    if (token != null && token.isNotEmpty) {
      try {
        await _api.addPhoto(
          token: token,
          path: picked.path,
          title: 'New Photo',
        );
        await _loadPhotosFromApi();
      } catch (_) {
        // Keep local fallback photo if API call fails.
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo added to pending approval')),
    );
  }

  Future<ImageSource?> _chooseSource() async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take Photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _fallbackImage() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported_outlined),
    );
  }

  Future<void> _loadPhotosFromApi() async {
    setState(() => _isLoading = true);
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        return;
      }
      final items = await _api.getPhotos(token: token);
      final photos = items.map(_PhotoItem.fromApi).toList();
      if (!mounted) return;
      setState(() {
        _approvedPhotos = photos.where((p) => p.approved).toList();
        _pendingPhotos = photos.where((p) => !p.approved).toList();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deletePhotoApi(_PhotoItem item) async {
    setState(() {
      if (item.approved) {
        _approvedPhotos.remove(item);
      } else {
        _pendingPhotos.remove(item);
      }
    });
    if (item.mediaId.isEmpty) return;
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) return;
      await _api.deletePhoto(token: token, mediaId: item.mediaId);
    } catch (_) {
      // Keep optimistic UI; data will refresh from API later.
    }
  }
}

class _PhotoItem {
  const _PhotoItem({
    required this.mediaId,
    required this.path,
    required this.approved,
    this.xFile,
    this.isMain = false,
  });

  final String mediaId;
  final String path;
  final bool approved;
  final XFile? xFile;
  final bool isMain;

  factory _PhotoItem.fromApi(Map<String, dynamic> json) {
    final path = (json['path'] ?? '').toString();
    final status = (json['status'] ?? '').toString();
    return _PhotoItem(
      mediaId: (json['mediaId'] ?? '').toString(),
      path: path,
      approved: status == 'approved',
      isMain: json['isMain'] == true,
      xFile: path.startsWith('/') ? XFile(path) : null,
    );
  }
}
