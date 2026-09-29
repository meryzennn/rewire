import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import '../core/theme/app_colors.dart';
import '../l10n/app_localizations.dart';

/// Interactive avatar crop and zoom customization dialog.
///
/// Allows user to pan, zoom (pinch, scroll, slider, +/- buttons), and position
/// their picked photo within a circular guide before finalizing their profile picture.
class AvatarCropDialog extends StatefulWidget {
  const AvatarCropDialog({
    super.key,
    required this.imageFile,
    this.initialBytes,
    this.outputDirectory,
  });

  final File imageFile;
  final Uint8List? initialBytes;
  final Directory? outputDirectory;

  @override
  State<AvatarCropDialog> createState() => _AvatarCropDialogState();
}

class _AvatarCropDialogState extends State<AvatarCropDialog> {
  final TransformationController _transformationController =
      TransformationController();
  final GlobalKey _cropKey = GlobalKey();

  Uint8List? _imageBytes;
  double _originalWidth = 0;
  double _originalHeight = 0;
  double _displayWidth = 0;
  double _displayHeight = 0;
  double _sliderScale = 1.0;

  bool _isLoaded = false;
  bool _hasError = false;
  bool _isSaving = false;
  bool _hasInitializedTransform = false;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformChanged);
    _loadImage();
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformChanged);
    _transformationController.dispose();
    super.dispose();
  }

  Future<void> _loadImage() async {
    try {
      final bytes = widget.initialBytes ?? widget.imageFile.readAsBytesSync();
      final decoded = await decodeImageFromList(bytes);
      if (!mounted) return;
      setState(() {
        _imageBytes = bytes;
        _originalWidth = decoded.width.toDouble();
        _originalHeight = decoded.height.toDouble();
        _isLoaded = true;
      });
    } catch (e, stack) {
      debugPrint('AvatarCropDialog _loadImage error: $e\n$stack');
      if (!mounted) return;
      setState(() {
        _hasError = true;
      });
    }
  }

  void _initTransform(double cropDimension) {
    if (_originalWidth <= 0 || _originalHeight <= 0) return;

    if (_originalWidth >= _originalHeight) {
      _displayHeight = cropDimension;
      _displayWidth = cropDimension * (_originalWidth / _originalHeight);
    } else {
      _displayWidth = cropDimension;
      _displayHeight = cropDimension * (_originalHeight / _originalWidth);
    }

    final initialDx = (cropDimension - _displayWidth) / 2.0;
    final initialDy = (cropDimension - _displayHeight) / 2.0;

    _transformationController.value = Matrix4.identity()
      ..translate(initialDx, initialDy);

    _sliderScale = 1.0;
  }

  void _onTransformChanged() {
    final matrix = _transformationController.value;
    final scale = matrix.getMaxScaleOnAxis();
    if (mounted && (_sliderScale - scale).abs() > 0.05) {
      setState(() {
        _sliderScale = scale.clamp(1.0, 4.0);
      });
    }
  }

  void _onSliderChanged(double newScale, double cropDimension) {
    final currentMatrix = _transformationController.value;
    final currentScale = currentMatrix.getMaxScaleOnAxis();
    if (currentScale <= 0) return;

    final scaleDelta = newScale / currentScale;
    final center = Offset(cropDimension / 2, cropDimension / 2);

    final transform = Matrix4.identity()
      ..translate(center.dx, center.dy)
      ..scale(scaleDelta)
      ..translate(-center.dx, -center.dy)
      ..multiply(currentMatrix);

    _transformationController.value = transform;
    setState(() {
      _sliderScale = newScale;
    });
  }

  void _zoomIn(double cropDimension) {
    final newScale = (_sliderScale + 0.3).clamp(1.0, 4.0);
    _onSliderChanged(newScale, cropDimension);
  }

  void _zoomOut(double cropDimension) {
    final newScale = (_sliderScale - 0.3).clamp(1.0, 4.0);
    _onSliderChanged(newScale, cropDimension);
  }

  void _resetTransform(double cropDimension) {
    _initTransform(cropDimension);
    setState(() {});
  }

  Future<void> _saveCrop() async {
    if (_isSaving) return;
    _isSaving = true;

    try {
      final appDir =
          widget.outputDirectory ?? await getApplicationDocumentsDirectory();
      final targetPath =
          '${appDir.path}/pfp_${DateTime.now().millisecondsSinceEpoch}.png';

      Uint8List? pngBytes;
      final boundary =
          _cropKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null && !boundary.debugNeedsPaint) {
        try {
          final image = await boundary.toImage(pixelRatio: 2.0);
          final byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);
          pngBytes = byteData?.buffer.asUint8List();
        } catch (e) {
          debugPrint('RenderRepaintBoundary.toImage error: $e');
        }
      }

      if (pngBytes != null && pngBytes.isNotEmpty) {
        final file = File(targetPath);
        file.writeAsBytesSync(pngBytes, flush: true);
        if (mounted) Navigator.of(context).pop(file);
      } else {
        final file = widget.imageFile.copySync(targetPath);
        if (mounted) Navigator.of(context).pop(file);
      }
    } catch (e) {
      debugPrint('Avatar crop save failed: $e');
      if (mounted) Navigator.of(context).pop(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final cropDimension = (screenWidth - 80).clamp(200.0, 280.0);

    if (_isLoaded && !_hasInitializedTransform) {
      _initTransform(cropDimension);
      _hasInitializedTransform = true;
    }

    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Dialog(
      key: const Key('avatar-crop-dialog'),
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              l10n?.cropPhotoTitle ?? 'Sesuaikan Foto',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n?.cropPhotoHint ?? 'Cubit atau geser untuk zoom dan posisikan',
              style: theme.textTheme.bodySmall?.copyWith(
                color: textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Crop Viewport Area
            if (_hasError)
              Container(
                width: cropDimension,
                height: cropDimension,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('Gagal memuat gambar.'),
              )
            else if (!_isLoaded)
              SizedBox(
                width: cropDimension,
                height: cropDimension,
                child: const Center(child: CircularProgressIndicator()),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Croppable content inside RepaintBoundary
                    RepaintBoundary(
                      key: _cropKey,
                      child: ClipRect(
                        child: SizedBox(
                          width: cropDimension,
                          height: cropDimension,
                          child: Container(
                            color: Colors.black,
                            child: InteractiveViewer(
                              key: const Key('crop-interactive-viewer'),
                              transformationController:
                                  _transformationController,
                              minScale: 0.8,
                              maxScale: 4.0,
                              boundaryMargin: EdgeInsets.all(cropDimension),
                              child: Image.memory(
                                _imageBytes!,
                                width: _displayWidth,
                                height: _displayHeight,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Circular guide overlay with dimmed corners
                    IgnorePointer(
                      child: SizedBox(
                        width: cropDimension,
                        height: cropDimension,
                        child: CustomPaint(
                          painter: _CircleCropGuidePainter(
                            borderColor: Colors.white.withValues(alpha: 0.9),
                            maskColor: Colors.black.withValues(alpha: 0.55),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // Zoom slider controls
            if (_isLoaded && !_hasError)
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.zoom_out_rounded, size: 20),
                    onPressed: () => _zoomOut(cropDimension),
                    tooltip: 'Zoom Out',
                  ),
                  Expanded(
                    child: Slider(
                      value: _sliderScale.clamp(1.0, 4.0),
                      min: 1.0,
                      max: 4.0,
                      onChanged: (val) => _onSliderChanged(val, cropDimension),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.zoom_in_rounded, size: 20),
                    onPressed: () => _zoomIn(cropDimension),
                    tooltip: 'Zoom In',
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    onPressed: () => _resetTransform(cropDimension),
                    tooltip: 'Reset',
                  ),
                ],
              ),

            const SizedBox(height: 12),

            // Actions: Batal / Simpan
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  key: const Key('btn-cancel-crop'),
                  onPressed:
                      _isSaving ? null : () => Navigator.of(context).pop(null),
                  child: Text(l10n?.cancel ?? 'Batal'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  key: const Key('btn-save-crop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: (_isLoaded && !_hasError && !_isSaving)
                      ? _saveCrop
                      : null,
                  child: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n?.save ?? 'Simpan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleCropGuidePainter extends CustomPainter {
  const _CircleCropGuidePainter({
    required this.borderColor,
    required this.maskColor,
  });

  final Color borderColor;
  final Color maskColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Dimmed cutout outside the circle
    final maskPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..fillType = PathFillType.evenOdd;

    final maskPaint = Paint()
      ..color = maskColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(maskPath, maskPaint);

    // Subtle guide circle border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _CircleCropGuidePainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.maskColor != maskColor;
  }
}
