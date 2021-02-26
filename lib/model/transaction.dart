import 'dart:math';

import 'package:uuid/uuid.dart';

import 'transaction_type.dart';

export 'package:innout/resource/localization.dart';
export 'package:innout/model/transaction_type.dart';

const String amountKey = 'Amount';
const String timestampKey = 'Timestamp';
const String typeKey = 'TransactionType';
const String descriptionKey = 'Description';
const String uuidKey = 'Uuid';
const String idKey = 'Id';

class Transaction extends Comparable<Transaction> {
  int _createdDateTimestamp;
  int id;
  final String uuid;
  final double amount;
  final String description;
  TransactionType transactionType;

  DateTime get createdDate => DateTime.fromMillisecondsSinceEpoch(_createdDateTimestamp).toLocal();

  Transaction.create({this.amount, this.transactionType, this.description})
      : assert(amount != null && transactionType != null),
        _createdDateTimestamp = DateTime.now().toUtc().millisecondsSinceEpoch,
        uuid = Uuid().v1();

  Transaction.debug({this.amount, DateTime date, this.description})
      : assert(amount != null),
        _createdDateTimestamp = date.toUtc().millisecondsSinceEpoch,
        uuid = Uuid().v1() {
    int index = Random(DateTime.now().millisecondsSinceEpoch).nextInt(TransactionType.values.length);
    transactionType = TransactionType.values.elementAt(index);
  }

  Transaction.fromMap(Map map)
      : this._createdDateTimestamp = map[timestampKey],
        this.amount = map[amountKey],
        this.transactionType = TransactionType.values.elementAt(map[typeKey]),
        this.description = map[descriptionKey],
        this.uuid = map[uuidKey],
        this.id = map[idKey];

  Map<String, dynamic> toMap() => {
        idKey: id,
        timestampKey: _createdDateTimestamp,
        amountKey: amount.toStringAsFixed(2),
        typeKey: transactionType.index,
        descriptionKey: description,
        uuidKey: uuid
      };

  @override
  bool operator ==(Object other) => identical(this, other) || other is Transaction && runtimeType == other.runtimeType && uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  int compareTo(Transaction other) {
    if (this.uuid == other.uuid) return 0;
    return -1;
  }

  @override
  String toString() => "Instance of Transaction: amount: $amount, date: ${this.createdDate}";
}
