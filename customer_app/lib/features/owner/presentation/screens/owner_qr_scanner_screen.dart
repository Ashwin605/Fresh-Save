import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/network/result.dart';
import '../../data/repositories/owner_reservation_repository_provider.dart';
import '../../domain/models/owner_reservation_models.dart';
import '../providers/owner_state_provider.dart';
import '../widgets/reservations/pickup_confirmation_sheet.dart';

class OwnerQrScannerScreen extends ConsumerStatefulWidget {
  final String? initialCode;
  const OwnerQrScannerScreen({super.key, this.initialCode});

  @override
  ConsumerState<OwnerQrScannerScreen> createState() =>
      _OwnerQrScannerScreenState();
}

class _OwnerQrScannerScreenState extends ConsumerState<OwnerQrScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialCode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _processCode(widget.initialCode!);
      });
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _processCode(String rawCode) async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    String reservationCode = rawCode;
    // Attempt JSON parse in case payload is {"reservationCode": "FS-123"}
    try {
      final decoded = jsonDecode(rawCode);
      if (decoded is Map<String, dynamic> &&
          decoded.containsKey('reservationCode')) {
        reservationCode = decoded['reservationCode'] as String;
      }
    } catch (_) {
      // Not JSON, assume raw string
    }

    final storeId = ref.read(ownerStateProvider).activeStore?.id;
    if (storeId == null) {
      setState(() {
        _errorMessage = 'No active store selected.';
        _isProcessing = false;
      });
      return;
    }

    final result = await ref
        .read(ownerReservationRepositoryProvider)
        .getStoreReservations(
          storeId: storeId,
          reservationCode: reservationCode,
        );

    if (!mounted) return;

    result.when(
      success: (data) {
        if (data.items.isEmpty) {
          setState(() {
            _errorMessage =
                'Reservation not found or belongs to another store.';
            _isProcessing = false;
          });
          // Resume scanning after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _errorMessage = null;
              });
            }
          });
          return;
        }

        final reservation = data.items.first;

        if (reservation.status == ReservationStatus.cancelled) {
          setState(() {
            _errorMessage = 'Reservation has been cancelled.';
            _isProcessing = false;
          });
          return;
        }

        if (reservation.status == ReservationStatus.expired) {
          setState(() {
            _errorMessage = 'Reservation has expired.';
            _isProcessing = false;
          });
          return;
        }

        if (reservation.status == ReservationStatus.completed) {
          setState(() {
            _errorMessage = 'Reservation has already been completed.';
            _isProcessing = false;
          });
          return;
        }

        // Show confirmation sheet
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) =>
              PickupConfirmationSheet(reservation: reservation),
        ).then((_) {
          // If sheet is dismissed, allow scanning again
          if (mounted) {
            setState(() {
              _isProcessing = false;
              _errorMessage = null;
            });
          }
        });
      },
      failure: (error) {
        setState(() {
          _errorMessage = error.toString();
          _isProcessing = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          if (widget.initialCode == null)
            MobileScanner(
              controller: _scannerController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                  _processCode(barcodes.first.rawValue!);
                }
              },
            ),

          // Scanner overlay frame
          if (widget.initialCode == null)
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Container(
                    width: 200,
                    height: 2,
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),

          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),

          if (_errorMessage != null)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
