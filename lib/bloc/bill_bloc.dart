import 'package:rxdart/rxdart.dart';

import 'package:innout/model/transaction.dart';
import 'package:innout/resource/repository.dart';

export 'package:innout/model/transaction.dart';

class BillBloc {
  static final instance = BillBloc._();

  BillBloc._();

  final _billFetcher = BehaviorSubject<List<Transaction>>();

  Stream<List<Transaction>> get allTransactions => _billFetcher.stream;

  List<Transaction> _transactions = [];

  init() {
    Repository.instance.getAllTransactions().then((value) {
      _transactions = value;

//      _transactions.add(Transaction.debug(date: DateTime(2020, 1, 1), amount: 102));
//      _transactions.add(Transaction.debug(date: DateTime(2020, 1, 2), amount: -1));
//      _transactions.add(Transaction.debug(date: DateTime(2020, 2, 3), amount: 203));
//      _transactions.add(Transaction.debug(date: DateTime(2019, 9, 1), amount: 2019));
//      _transactions.add(Transaction.debug(date: DateTime(2018, 8, 1), amount: -2018));
//      _transactions.add(Transaction.debug(date: DateTime(2016, 6, 1), amount: 2016));

      _billFetcher.sink.add(_transactions.toList());
    });
  }

  addTransaction(Transaction transaction) {
    Repository.instance.addTransaction(transaction).then((id) {
      transaction.id = id;
      _transactions.add(transaction);
      _billFetcher.sink.add(_transactions);
    });
  }

  removeTransaction(Transaction transaction) {
    Repository.instance.deleteTransaction(transaction).then((_) {
      _transactions.remove(transaction);
      _billFetcher.sink.add(_transactions);
    });
  }

  dispose() {
    _billFetcher.close();
  }
}
