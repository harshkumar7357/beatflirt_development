import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/legacy.dart';

class CurrencyInfo {
  final String code;
  final String symbol;
  final double rate;

  CurrencyInfo({required this.code, required this.symbol, required this.rate});
}

class PaymentState {
  final CurrencyInfo currency;
  final bool isLoading;
  final String? error;

  PaymentState({required this.currency, this.isLoading = false, this.error});

  PaymentState copyWith({
    CurrencyInfo? currency,
    bool? isLoading,
    String? error,
  }) {
    return PaymentState(
      currency: currency ?? this.currency,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentNotifier()
    : super(
        PaymentState(
          currency: CurrencyInfo(code: 'USD', symbol: '\$', rate: 1.0),
        ),
      ) {
    _initCurrency();
  }

  Future<void> _initCurrency() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 1. Check Cache (Expires in 24 hours)
      final lastUpdate = prefs.getInt('currency_last_update') ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      
      if (now - lastUpdate < 24 * 60 * 60 * 1000) {
        final cachedCode = prefs.getString('currency_code');
        final cachedSymbol = prefs.getString('currency_symbol');
        final cachedRate = prefs.getDouble('currency_rate');

        if (cachedCode != null && cachedSymbol != null && cachedRate != null) {
          state = state.copyWith(
            currency: CurrencyInfo(code: cachedCode, symbol: cachedSymbol, rate: cachedRate),
          );
          return;
        }
      }

      state = state.copyWith(isLoading: true);

      // 2. Fetch from ipwho.is (Silent fallback on 429)
      final response = await Dio().get(
        'https://ipwho.is/',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
          validateStatus: (status) => status != null && status < 500, // Handle 429 gracefully
        ),
      );

      if (response.statusCode == 200 && response.data != null && response.data['success'] == true) {
        final currencyData = response.data['currency'];
        final detectedCurrency = currencyData['code'] ?? 'USD';
        final symbol = currencyData['symbol'] ?? '\$';
        final rate = (currencyData['exchange_rate'] as num?)?.toDouble() ?? 1.0;

        final newCurrency = CurrencyInfo(
          code: detectedCurrency,
          symbol: symbol,
          rate: rate,
        );

        // 3. Save to Cache
        await prefs.setString('currency_code', detectedCurrency);
        await prefs.setString('currency_symbol', symbol);
        await prefs.setDouble('currency_rate', rate);
        await prefs.setInt('currency_last_update', now);

        state = state.copyWith(isLoading: false, currency: newCurrency);
      } else {
        // Just stop loading, keep default USD
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      // Silently catch everything (Network errors, Rate limits, etc.)
      state = state.copyWith(isLoading: false);
    }
  }

  String formatPrice(double priceInUSD) {
    final localPrice = priceInUSD * state.currency.rate;
    final formatter = NumberFormat.currency(
      symbol: state.currency.symbol,
      decimalDigits: state.currency.code == 'INR' ? 0 : 2,
    );
    return formatter.format(localPrice);
  }
}

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>(
  (ref) => PaymentNotifier(),
);
