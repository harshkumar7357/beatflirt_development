import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beatflirt/Api_services/api_services.dart';
import 'package:beatflirt/core/services/auth_services.dart';

class ValidationState {
  final String status; // 'none', 'pending', 'approved', 'rejected'
  final String? rejectionReason;
  final bool isLoading;
  final String? error;

  ValidationState({
    this.status = 'none',
    this.rejectionReason,
    this.isLoading = false,
    this.error,
  });

  ValidationState copyWith({
    String? status,
    String? rejectionReason,
    bool? isLoading,
    String? error,
  }) {
    return ValidationState(
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ValidationNotifier extends Notifier<ValidationState> {
  final ApiServices _api = ApiServices();

  @override
  ValidationState build() {
    Future.microtask(() => checkStatus());
    return ValidationState(isLoading: true);
  }

  Future<void> checkStatus() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        state = state.copyWith(isLoading: false, error: 'Unauthorized');
        return;
      }

      final data = await _api.getValidationStatus(token: token);
      state = state.copyWith(
        isLoading: false,
        status: data['status'] ?? 'none',
        rejectionReason: data['rejectionReason'],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> submit({required String selfiePath, required String idCardPath}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Unauthorized');

      // Read files and convert to Base64
      final selfieFile = File(selfiePath);
      final idCardFile = File(idCardPath);

      final selfieBase64 = base64Encode(await selfieFile.readAsBytes());
      final idCardBase64 = base64Encode(await idCardFile.readAsBytes());

      await _api.submitValidation(
        token: token,
        selfiePath: 'data:image/jpeg;base64,$selfieBase64',
        idCardPath: 'data:image/jpeg;base64,$idCardBase64',
      );

      state = state.copyWith(isLoading: false, status: 'pending');
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final validationProvider = NotifierProvider<ValidationNotifier, ValidationState>(ValidationNotifier.new);
