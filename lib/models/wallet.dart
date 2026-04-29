/// Wallet data models for PasaWallet e-wallet system
library;

enum UserType { passenger, driver }

enum TransactionType {
  cashIn,
  payment,
  earnings,
  withdrawal,
  refund,
  commission,
}

enum TransactionStatus { pending, completed, failed, cancelled }

enum CashInMethod { gcash, maya, manual }

enum WithdrawMethod { gcash, maya, manual }

/// Wallet model representing a user's wallet
class Wallet {
  final String walletId;
  final String userId;
  final double balance;
  final UserType userType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Wallet({
    required this.walletId,
    required this.userId,
    required this.balance,
    required this.userType,
    required this.createdAt,
    required this.updatedAt,
  });

  Wallet copyWith({
    String? walletId,
    String? userId,
    double? balance,
    UserType? userType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Wallet(
      walletId: walletId ?? this.walletId,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'walletId': walletId,
      'userId': userId,
      'balance': balance,
      'userType': userType.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      walletId: json['walletId'] as String,
      userId: json['userId'] as String,
      balance: (json['balance'] as num).toDouble(),
      userType: UserType.values.firstWhere((e) => e.name == json['userType']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// Transaction model representing a wallet transaction
class WalletTransaction {
  final String transactionId;
  final String walletId;
  final TransactionType type;
  final double amount;
  final TransactionStatus status;
  final DateTime timestamp;
  final String? rideId;
  final String? description;
  final String? method; // For cash-in/withdrawal method
  final double? commissionRate; // For driver earnings
  final double? commissionAmount; // For driver earnings

  const WalletTransaction({
    required this.transactionId,
    required this.walletId,
    required this.type,
    required this.amount,
    required this.status,
    required this.timestamp,
    this.rideId,
    this.description,
    this.method,
    this.commissionRate,
    this.commissionAmount,
  });

  WalletTransaction copyWith({
    String? transactionId,
    String? walletId,
    TransactionType? type,
    double? amount,
    TransactionStatus? status,
    DateTime? timestamp,
    String? rideId,
    String? description,
    String? method,
    double? commissionRate,
    double? commissionAmount,
  }) {
    return WalletTransaction(
      transactionId: transactionId ?? this.transactionId,
      walletId: walletId ?? this.walletId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      rideId: rideId ?? this.rideId,
      description: description ?? this.description,
      method: method ?? this.method,
      commissionRate: commissionRate ?? this.commissionRate,
      commissionAmount: commissionAmount ?? this.commissionAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'walletId': walletId,
      'type': type.name,
      'amount': amount,
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      if (rideId != null) 'rideId': rideId,
      if (description != null) 'description': description,
      if (method != null) 'method': method,
      if (commissionRate != null) 'commissionRate': commissionRate,
      if (commissionAmount != null) 'commissionAmount': commissionAmount,
    };
  }

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      transactionId: json['transactionId'] as String,
      walletId: json['walletId'] as String,
      type: TransactionType.values.firstWhere((e) => e.name == json['type']),
      amount: (json['amount'] as num).toDouble(),
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      rideId: json['rideId'] as String?,
      description: json['description'] as String?,
      method: json['method'] as String?,
      commissionRate: json['commissionRate'] != null
          ? (json['commissionRate'] as num).toDouble()
          : null,
      commissionAmount: json['commissionAmount'] != null
          ? (json['commissionAmount'] as num).toDouble()
          : null,
    );
  }

  /// Get display title for transaction
  String get displayTitle {
    switch (type) {
      case TransactionType.cashIn:
        return 'Cash In';
      case TransactionType.payment:
        return 'Ride Payment';
      case TransactionType.earnings:
        return 'Ride Earnings';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.refund:
        return 'Refund';
      case TransactionType.commission:
        return 'Platform Commission';
    }
  }

  /// Get display subtitle for transaction
  String get displaySubtitle {
    if (description != null) return description!;
    if (rideId != null) return 'Ride #${rideId!.substring(0, 8)}';
    if (method != null) return 'via $method';
    return '';
  }

  /// Check if transaction is positive (adds money)
  bool get isPositive {
    return type == TransactionType.cashIn ||
        type == TransactionType.earnings ||
        type == TransactionType.refund;
  }

  /// Check if transaction is negative (removes money)
  bool get isNegative {
    return type == TransactionType.payment ||
        type == TransactionType.withdrawal ||
        type == TransactionType.commission;
  }
}

/// Cash-in request model
class CashInRequest {
  final String walletId;
  final double amount;
  final CashInMethod method;
  final String? referenceNumber;

  const CashInRequest({
    required this.walletId,
    required this.amount,
    required this.method,
    this.referenceNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'walletId': walletId,
      'amount': amount,
      'method': method.name,
      if (referenceNumber != null) 'referenceNumber': referenceNumber,
    };
  }
}

/// Withdrawal request model
class WithdrawalRequest {
  final String walletId;
  final double amount;
  final WithdrawMethod method;
  final String? accountNumber;
  final String? accountName;

  const WithdrawalRequest({
    required this.walletId,
    required this.amount,
    required this.method,
    this.accountNumber,
    this.accountName,
  });

  Map<String, dynamic> toJson() {
    return {
      'walletId': walletId,
      'amount': amount,
      'method': method.name,
      if (accountNumber != null) 'accountNumber': accountNumber,
      if (accountName != null) 'accountName': accountName,
    };
  }
}
