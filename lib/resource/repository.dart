import 'package:innout/model/transaction.dart';
import 'db_provider.dart';

export 'package:innout/model/transaction.dart';

class Repository {
  Repository._();

  static final Repository instance = Repository._();

  Future<void> deleteTransaction(Transaction transaction) => DBProvider.db.deleteTransaction(transaction);

  Future<int> addTransaction(Transaction transaction) => DBProvider.db.addTransaction(transaction);

  Future<void> updateTransaction(Transaction transaction) => DBProvider.db.updateTransaction(transaction);

  Future<List<Transaction>> getAllTransactions() => DBProvider.db.getAllTransactions();

  Future<int> getNextId() => DBProvider.db.getNextId();
}
