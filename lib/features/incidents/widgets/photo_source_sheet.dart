import 'package:my_app_incitech_ua/core/theme/app_colors.dart';
import 'package:my_app_incitech_ua/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app_incitech_ua/features/incidents/widgets/picked_xfile_preview.dart';

class PhotoSourceSheet {
  static Future<XFile?> show({
    required BuildContext context,
    required Future<XFile?> Function() onCameraPick,
    required Future<XFile?> Function() onGalleryPick,
    XFile? initialFile,
    String? initialAssetPath,
  }) {
    return showModalBottomSheet<XFile>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _PhotoSourceSheetView(
          onCameraPick: onCameraPick,
          onGalleryPick: onGalleryPick,
          initialFile: initialFile,
          initialAssetPath: initialAssetPath,
        );
      },
    );
  }
}

class _PhotoSourceSheetView extends StatefulWidget {
  const _PhotoSourceSheetView({
    required this.onCameraPick,
    required this.onGalleryPick,
    this.initialFile,
    this.initialAssetPath,
  });

  final Future<XFile?> Function() onCameraPick;
  final Future<XFile?> Function() onGalleryPick;
  final XFile? initialFile;
  final String? initialAssetPath;

  @override
  State<_PhotoSourceSheetView> createState() => _PhotoSourceSheetViewState();
}

class _PhotoSourceSheetViewState extends State<_PhotoSourceSheetView> {
  XFile? _workingFile;
  bool _isLoading = false;

  static const Color _green = AppColors.primaryGreenAlt;
  static const Color _textColor = AppColors.textDark;

  @override
  void initState() {
    super.initState();
    _workingFile = widget.initialFile;
  }

  Future<void> _pickFromCamera() async {
    setState(() => _isLoading = true);
    final file = await widget.onCameraPick();
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (file != null) {
        _workingFile = file;
      }
    });
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isLoading = true);
    final file = await widget.onGalleryPick();
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (file != null) {
        _workingFile = file;
      }
    });
  }

  Widget _buildPlaceholder(double fontSize) {
    return Container(
      color: AppColors.panelNeutralAlt,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 58, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            'Vista previa de la imagen',
            style: TextStyle(
              fontSize: fontSize * 1.05,
              color: Colors.grey.shade700,
              fontFamily: AppTextStyles.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final fontSize = w * 0.040;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: AppColors.panelLight,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Adjuntar fotografía',
              style: TextStyle(
                fontSize: fontSize * 1.35,
                fontWeight: FontWeight.w700,
                fontFamily: AppTextStyles.fontFamily,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    icon: Icons.camera_alt,
                    label: 'Tomar foto',
                    onTap: _pickFromCamera,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    icon: Icons.image,
                    label: 'Elegir de galería',
                    onTap: _pickFromGallery,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 155,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PickedXFilePreview(
                      file: _workingFile,
                      assetPath: widget.initialAssetPath,
                      width: double.infinity,
                      height: 155,
                      borderRadius: 18,
                      fit: BoxFit.cover,
                      placeholder: _buildPlaceholder(fontSize),
                    ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _workingFile),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Confirmar imagen',
                  style: TextStyle(
                    fontSize: fontSize * 1.08,
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _green,
                  side: const BorderSide(color: _green, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    fontSize: fontSize * 1.08,
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  static const Color _green = AppColors.primaryGreenAlt;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final fontSize = w * 0.040;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 95,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _green, size: 36),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




