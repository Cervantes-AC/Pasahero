/// Wallet service for managing PasaWallet operations
/// In production, this would integrate with Firebase Cloud Functions
library;

import '../models/wallet.dart';

class WalletService {
  static WalletService? _instance;
  static WalletService get instance => _instance ??= WalletService._();
  WalletService._();

  // Mock data storage (replace with Firebase in production)
  final Map<String, Wallet> _wallets = {};
  final Map<String, List<WalletTransaction>> _transactions = {};

  // Platform commission rate (15-20%)
  static const double commissionRate = 0.17; // 17%

  /// Initialize wallet for a user
  Future<Wallet> createWallet(String userId, UserType userType) async {
    final walletId =
        'wallet_${userId}_${DateTime.now().millisecondsSinceEpoch}';
    final wallet = Wallet(
      walletId: walletId,
      userId: userId,
      balance: 0.0,
      userType: userType,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _wallets[walletId] = wallet;
    _transactions[walletId] = [];

    return wallet;
  }

  /// Get wallet by user ID
  Future<Wallet?> getWalletByUserId(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    return _wallets.values.where((w) => w.userId == userId).firstOrNull;
  }

  /// Get wallet by wallet ID
  Future<Wallet?> getWallet(String walletId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _wallets[walletId];
  }

  /// Check if wallet has sufficient balance
  Future<bool> hasSufficientBalance(String walletId, double amount) async {
    final wallet = await getWallet(walletId);
    if (wallet == null) return false;
    return wallet.balance >= amount;
  }

  /// Process cash-in request
  Future<WalletTransaction> processCashIn(CashInRequest request) async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 1));

    final wallet = _wallets[request.walletId];
    if (wallet == null) {
      throw Exception('Wallet not found');
    }

    // Create transaction
    final transaction = WalletTransaction(
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      walletId: request.walletId,
      type: TransactionType.cashIn,
      amount: request.amount,
      status: TransactionStatus.completed,
      timestamp: DateTime.now(),
      method: request.method.name.toUpperCase(),
      description: 'Cash in via ${request.method.name.toUpperCase()}',
    );

    // Update wallet balance
    _wallets[request.walletId] = wallet.copyWith(
      balance: wallet.balance + request.amount,
      updatedAt: DateTime.now(),
    );

    // Store transaction
    _transactions[request.walletId] = [
      transaction,
      ...(_transactions[request.walletId] ?? []),
    ];

    return transaction;
  }

  /// Reserve fare for ride (check and hold balance)
  Future<bool> reserveFare(String walletId, double fare) async {
    final wallet = await getWallet(walletId);
    if (wallet == null) return false;

    if (wallet.balance < fare) {
      return false;
    }

    // In production, this would create a pending transaction
    // For now, we just verify balance
    return true;
  }

  /// Process ride payment (deduct from passenger wallet)
  Future<WalletTransaction> processRidePayment({
    required String walletId,
    required String rideId,
    required double fare,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final wallet = _wallets[walletId];
    if (wallet == null) {
      throw Exception('Wallet not found');
    }

    if (wallet.balance < fare) {
      throw Exception('Insufficient balance');
    }

    // Create payment transaction
    final transaction = WalletTransaction(
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      walletId: walletId,
      type: TransactionType.payment,
      amount: fare,
      status: TransactionStatus.completed,
      timestamp: DateTime.now(),
      rideId: rideId,
      description: 'Ride payment',
    );

    // Deduct from wallet
    _wallets[walletId] = wallet.copyWith(
      balance: wallet.balance - fare,
      updatedAt: DateTime.now(),
    );

    // Store transaction
    _transactions[walletId] = [transaction, ...(_transactions[walletId] ?? [])];

    return transaction;
  }

  /// Process driver earnings (add to driver wallet with commission)
  Future<List<WalletTransaction>> processDriverEarnings({
    required String walletId,
    required String rideId,
    required double fare,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final wallet = _wallets[walletId];
    if (wallet == null) {
      throw Exception('Wallet not found');
    }

    final commission = fare * commissionRate;
    final netEarnings = fare - commission;

    // Create earnings transaction
    final earningsTransaction = WalletTransaction(
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      walletId: walletId,
      type: TransactionType.earnings,
      amount: netEarnings,
      status: TransactionStatus.completed,
      timestamp: DateTime.now(),
      rideId: rideId,
      description: 'Ride earnings',
      commissionRate: commissionRate,
      commissionAmount: commission,
    );

    // Create commission transaction (for record keeping)
    final commissionTransaction = WalletTransaction(
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch + 1}',
      walletId: walletId,
      type: TransactionType.commission,
      amount: commission,
      status: TransactionStatus.completed,
      timestamp: DateTime.now(),
      rideId: rideId,
      description:
          'Platform commission (${(commissionRate * 100).toStringAsFixed(0)}%)',
    );

    // Add net earnings to wallet
    _wallets[walletId] = wallet.copyWith(
      balance: wallet.balance + netEarnings,
      updatedAt: DateTime.now(),
    );

    // Store transactions
    _transactions[walletId] = [
      earningsTransaction,
      commissionTransaction,
      ...(_transactions[walletId] ?? []),
    ];

    return [earningsTransaction, commissionTransaction];
  }

  /// Process withdrawal request
  Future<WalletTransaction> processWithdrawal(WithdrawalRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    final wallet = _wallets[request.walletId];
    if (wallet == null) {
      throw Exception('Wallet not found');
    }

    if (wallet.balance < request.amount) {
      throw Exception('Insufficient balance');
    }

    // Create pending withdrawal transaction
    final transaction = WalletTransaction(
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      walletId: request.walletId,
      type: TransactionType.withdrawal,
      amount: request.amount,
      status: TransactionStatus.pending,
      timestamp: DateTime.now(),
      method: request.method.name.toUpperCase(),
      description: 'Withdrawal to ${request.method.name.toUpperCase()}',
    );

    // Deduct from wallet immediately (pending approval)
    _wallets[request.walletId] = wallet.copyWith(
      balance: wallet.balance - request.amount,
      updatedAt: DateTime.now(),
    );

    // Store transaction
    _transactions[request.walletId] = [
      transaction,
      ...(_transactions[request.walletId] ?? []),
    ];

    return transaction;
  }

  /// Process refund (cancelled ride)
  Future<WalletTransaction> processRefund({
    required String walletId,
    required String rideId,
    required double amount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final wallet = _wallets[walletId];
    if (wallet == null) {
      throw Exception('Wallet not found');
    }

    // Create refund transaction
    final transaction = WalletTransaction(
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      walletId: walletId,
      type: TransactionType.refund,
      amount: amount,
      status: TransactionStatus.completed,
      timestamp: DateTime.now(),
      rideId: rideId,
      description: 'Ride cancelled - Refund',
    );

    // Add refund to wallet
    _wallets[walletId] = wallet.copyWith(
      balance: wallet.balance + amount,
      updatedAt: DateTime.now(),
    );

    // Store transaction
    _transactions[walletId] = [transaction, ...(_transactions[walletId] ?? [])];

    return transaction;
  }

  /// Get transaction history for a wallet
  Future<List<WalletTransaction>> getTransactionHistory(
    String walletId, {
    int limit = 50,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final transactions = _transactions[walletId] ?? [];
    return transactions.take(limit).toList();
  }

  /// Get today's earnings for driver
  Future<double> getTodayEarnings(String walletId) async {
    final transactions = await getTransactionHistory(walletId);
    final today = DateTime.now();

    double total = 0.0;
    for (final t in transactions) {
      if (t.type == TransactionType.earnings &&
          t.timestamp.year == today.year &&
          t.timestamp.month == today.month &&
          t.timestamp.day == today.day) {
        total += t.amount;
      }
    }
    return total;
  }

  /// Get total earnings for driver
  Future<double> getTotalEarnings(String walletId) async {
    final transactions = await getTransactionHistory(walletId);

    double total = 0.0;
    for (final t in transactions) {
      if (t.type == TransactionType.earnings) total += t.amount;
    }
    return total;
  }

  /// Get today's trip count for driver
  Future<int> getTodayTripCount(String walletId) async {
    final transactions = await getTransactionHistory(walletId);
    final today = DateTime.now();

    return transactions
        .where(
          (t) =>
              t.type == TransactionType.earnings &&
              t.timestamp.year == today.year &&
              t.timestamp.month == today.month &&
              t.timestamp.day == today.day,
        )
        .length;
  }

  /// Initialize mock data for demo
  Future<void> initializeMockData() async {
    // Create passenger wallet
    final passengerWallet = await createWallet(
      'passenger_001',
      UserType.passenger,
    );

    // Add multiple mock transactions for passenger
    final now = DateTime.now();

    // Cash in transactions
    await processCashIn(
      CashInRequest(
        walletId: passengerWallet.walletId,
        amount: 500.0,
        method: CashInMethod.gcash,
      ),
    );

    await processCashIn(
      CashInRequest(
        walletId: passengerWallet.walletId,
        amount: 1000.0,
        method: CashInMethod.maya,
      ),
    );

    // Ride payment transactions
    final ridePayment1 = WalletTransaction(
      transactionId: 'txn_${now.millisecondsSinceEpoch - 86400000}',
      walletId: passengerWallet.walletId,
      type: TransactionType.payment,
      amount: 85.50,
      status: TransactionStatus.completed,
      timestamp: now.subtract(const Duration(days: 1)),
      rideId: 'ride_20260429_001',
      description: 'Ride payment',
    );
    _transactions[passengerWallet.walletId]!.insert(0, ridePayment1);
    _wallets[passengerWallet.walletId] = passengerWallet.copyWith(
      balance: _wallets[passengerWallet.walletId]!.balance - 85.50,
    );

    final ridePayment2 = WalletTransaction(
      transactionId: 'txn_${now.millisecondsSinceEpoch - 172800000}',
      walletId: passengerWallet.walletId,
      type: TransactionType.payment,
      amount: 120.00,
      status: TransactionStatus.completed,
      timestamp: now.subtract(const Duration(days: 2)),
      rideId: 'ride_20260428_005',
      description: 'Ride payment',
    );
    _transactions[passengerWallet.walletId]!.insert(0, ridePayment2);
    _wallets[passengerWallet.walletId] = passengerWallet.copyWith(
      balance: _wallets[passengerWallet.walletId]!.balance - 120.00,
    );

    final ridePayment3 = WalletTransaction(
      transactionId: 'txn_${now.millisecondsSinceEpoch - 259200000}',
      walletId: passengerWallet.walletId,
      type: TransactionType.payment,
      amount: 65.75,
      status: TransactionStatus.completed,
      timestamp: now.subtract(const Duration(days: 3)),
      rideId: 'ride_20260427_003',
      description: 'Ride payment',
    );
    _transactions[passengerWallet.walletId]!.insert(0, ridePayment3);
    _wallets[passengerWallet.walletId] = passengerWallet.copyWith(
      balance: _wallets[passengerWallet.walletId]!.balance - 65.75,
    );

    // Refund transaction
    final refund = WalletTransaction(
      transactionId: 'txn_${now.millisecondsSinceEpoch - 345600000}',
      walletId: passengerWallet.walletId,
      type: TransactionType.refund,
      amount: 50.00,
      status: TransactionStatus.completed,
      timestamp: now.subtract(const Duration(days: 4)),
      rideId: 'ride_20260426_002',
      description: 'Ride cancelled - Refund',
    );
    _transactions[passengerWallet.walletId]!.insert(0, refund);
    _wallets[passengerWallet.walletId] = passengerWallet.copyWith(
      balance: _wallets[passengerWallet.walletId]!.balance + 50.00,
    );

    // Create driver wallet
    final driverWallet = await createWallet('driver_001', UserType.driver);

    // Add some mock earnings
    await processDriverEarnings(
      walletId: driverWallet.walletId,
      rideId: 'ride_001',
      fare: 65.0,
    );

    await processDriverEarnings(
      walletId: driverWallet.walletId,
      rideId: 'ride_002',
      fare: 120.0,
    );

    await processDriverEarnings(
      walletId: driverWallet.walletId,
      rideId: 'ride_003',
      fare: 95.50,
    );
  }
}
