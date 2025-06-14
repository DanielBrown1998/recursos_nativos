import '../services/account_service.dart';
import '../../domain/models/account.dart';

class AccountRepository {
  final AccountService _service;

  AccountRepository(this._service);

  Future<List<Account>> getAccounts() async {
    return _service.fetchAccounts();
  }

  Future<void> addAccount(Account account) async {
    await _service.addAccount(account);
  }
}
