import 'package:flutter/material.dart';
import '../../../data/repositories/account_repository.dart';
import '../../../domain/models/account.dart';

class HomeViewModel extends ChangeNotifier {
  final AccountRepository _repository;

  List<Account> _accounts = [];
  bool isLoading = false;

  HomeViewModel(this._repository);

  List<Account> get accounts => _accounts;

  Future<void> loadAccounts() async {
    isLoading = true;
    notifyListeners();

    _accounts = await _repository.getAccounts();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addAccount(Account account) async {
    await _repository.addAccount(account);
    _accounts.add(account);
    notifyListeners();
  }
}
