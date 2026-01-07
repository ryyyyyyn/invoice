// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BusinessesTable extends Businesses
    with TableInfo<$BusinessesTable, BusinessRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _logoPathMeta =
      const VerificationMeta('logoPath');
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
      'logo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _invoicePrefixMeta =
      const VerificationMeta('invoicePrefix');
  @override
  late final GeneratedColumn<String> invoicePrefix = GeneratedColumn<String>(
      'invoice_prefix', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _invoiceCounterMeta =
      const VerificationMeta('invoiceCounter');
  @override
  late final GeneratedColumn<int> invoiceCounter = GeneratedColumn<int>(
      'invoice_counter', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _counterYearMeta =
      const VerificationMeta('counterYear');
  @override
  late final GeneratedColumn<int> counterYear = GeneratedColumn<int>(
      'counter_year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _themeColorMeta =
      const VerificationMeta('themeColor');
  @override
  late final GeneratedColumn<String> themeColor = GeneratedColumn<String>(
      'theme_color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        address,
        phone,
        email,
        logoPath,
        invoicePrefix,
        invoiceCounter,
        counterYear,
        themeColor,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'businesses';
  @override
  VerificationContext validateIntegrity(Insertable<BusinessRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('logo_path')) {
      context.handle(_logoPathMeta,
          logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta));
    }
    if (data.containsKey('invoice_prefix')) {
      context.handle(
          _invoicePrefixMeta,
          invoicePrefix.isAcceptableOrUnknown(
              data['invoice_prefix']!, _invoicePrefixMeta));
    }
    if (data.containsKey('invoice_counter')) {
      context.handle(
          _invoiceCounterMeta,
          invoiceCounter.isAcceptableOrUnknown(
              data['invoice_counter']!, _invoiceCounterMeta));
    } else if (isInserting) {
      context.missing(_invoiceCounterMeta);
    }
    if (data.containsKey('counter_year')) {
      context.handle(
          _counterYearMeta,
          counterYear.isAcceptableOrUnknown(
              data['counter_year']!, _counterYearMeta));
    } else if (isInserting) {
      context.missing(_counterYearMeta);
    }
    if (data.containsKey('theme_color')) {
      context.handle(
          _themeColorMeta,
          themeColor.isAcceptableOrUnknown(
              data['theme_color']!, _themeColorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      logoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_path']),
      invoicePrefix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_prefix']),
      invoiceCounter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}invoice_counter'])!,
      counterYear: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}counter_year'])!,
      themeColor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_color']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BusinessesTable createAlias(String alias) {
    return $BusinessesTable(attachedDatabase, alias);
  }
}

class BusinessRow extends DataClass implements Insertable<BusinessRow> {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String? logoPath;
  final String? invoicePrefix;
  final int invoiceCounter;
  final int counterYear;
  final String? themeColor;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BusinessRow(
      {required this.id,
      required this.name,
      required this.address,
      required this.phone,
      required this.email,
      this.logoPath,
      this.invoicePrefix,
      required this.invoiceCounter,
      required this.counterYear,
      this.themeColor,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['address'] = Variable<String>(address);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    if (!nullToAbsent || invoicePrefix != null) {
      map['invoice_prefix'] = Variable<String>(invoicePrefix);
    }
    map['invoice_counter'] = Variable<int>(invoiceCounter);
    map['counter_year'] = Variable<int>(counterYear);
    if (!nullToAbsent || themeColor != null) {
      map['theme_color'] = Variable<String>(themeColor);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BusinessesCompanion toCompanion(bool nullToAbsent) {
    return BusinessesCompanion(
      id: Value(id),
      name: Value(name),
      address: Value(address),
      phone: Value(phone),
      email: Value(email),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      invoicePrefix: invoicePrefix == null && nullToAbsent
          ? const Value.absent()
          : Value(invoicePrefix),
      invoiceCounter: Value(invoiceCounter),
      counterYear: Value(counterYear),
      themeColor: themeColor == null && nullToAbsent
          ? const Value.absent()
          : Value(themeColor),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BusinessRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      invoicePrefix: serializer.fromJson<String?>(json['invoicePrefix']),
      invoiceCounter: serializer.fromJson<int>(json['invoiceCounter']),
      counterYear: serializer.fromJson<int>(json['counterYear']),
      themeColor: serializer.fromJson<String?>(json['themeColor']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String>(address),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'logoPath': serializer.toJson<String?>(logoPath),
      'invoicePrefix': serializer.toJson<String?>(invoicePrefix),
      'invoiceCounter': serializer.toJson<int>(invoiceCounter),
      'counterYear': serializer.toJson<int>(counterYear),
      'themeColor': serializer.toJson<String?>(themeColor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BusinessRow copyWith(
          {int? id,
          String? name,
          String? address,
          String? phone,
          String? email,
          Value<String?> logoPath = const Value.absent(),
          Value<String?> invoicePrefix = const Value.absent(),
          int? invoiceCounter,
          int? counterYear,
          Value<String?> themeColor = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      BusinessRow(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        logoPath: logoPath.present ? logoPath.value : this.logoPath,
        invoicePrefix:
            invoicePrefix.present ? invoicePrefix.value : this.invoicePrefix,
        invoiceCounter: invoiceCounter ?? this.invoiceCounter,
        counterYear: counterYear ?? this.counterYear,
        themeColor: themeColor.present ? themeColor.value : this.themeColor,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('BusinessRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('logoPath: $logoPath, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('invoiceCounter: $invoiceCounter, ')
          ..write('counterYear: $counterYear, ')
          ..write('themeColor: $themeColor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      address,
      phone,
      email,
      logoPath,
      invoicePrefix,
      invoiceCounter,
      counterYear,
      themeColor,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.logoPath == this.logoPath &&
          other.invoicePrefix == this.invoicePrefix &&
          other.invoiceCounter == this.invoiceCounter &&
          other.counterYear == this.counterYear &&
          other.themeColor == this.themeColor &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BusinessesCompanion extends UpdateCompanion<BusinessRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> address;
  final Value<String> phone;
  final Value<String> email;
  final Value<String?> logoPath;
  final Value<String?> invoicePrefix;
  final Value<int> invoiceCounter;
  final Value<int> counterYear;
  final Value<String?> themeColor;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BusinessesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    this.invoiceCounter = const Value.absent(),
    this.counterYear = const Value.absent(),
    this.themeColor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BusinessesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String address,
    required String phone,
    required String email,
    this.logoPath = const Value.absent(),
    this.invoicePrefix = const Value.absent(),
    required int invoiceCounter,
    required int counterYear,
    this.themeColor = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : name = Value(name),
        address = Value(address),
        phone = Value(phone),
        email = Value(email),
        invoiceCounter = Value(invoiceCounter),
        counterYear = Value(counterYear),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<BusinessRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? logoPath,
    Expression<String>? invoicePrefix,
    Expression<int>? invoiceCounter,
    Expression<int>? counterYear,
    Expression<String>? themeColor,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (logoPath != null) 'logo_path': logoPath,
      if (invoicePrefix != null) 'invoice_prefix': invoicePrefix,
      if (invoiceCounter != null) 'invoice_counter': invoiceCounter,
      if (counterYear != null) 'counter_year': counterYear,
      if (themeColor != null) 'theme_color': themeColor,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BusinessesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? address,
      Value<String>? phone,
      Value<String>? email,
      Value<String?>? logoPath,
      Value<String?>? invoicePrefix,
      Value<int>? invoiceCounter,
      Value<int>? counterYear,
      Value<String?>? themeColor,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return BusinessesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      logoPath: logoPath ?? this.logoPath,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      invoiceCounter: invoiceCounter ?? this.invoiceCounter,
      counterYear: counterYear ?? this.counterYear,
      themeColor: themeColor ?? this.themeColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (invoicePrefix.present) {
      map['invoice_prefix'] = Variable<String>(invoicePrefix.value);
    }
    if (invoiceCounter.present) {
      map['invoice_counter'] = Variable<int>(invoiceCounter.value);
    }
    if (counterYear.present) {
      map['counter_year'] = Variable<int>(counterYear.value);
    }
    if (themeColor.present) {
      map['theme_color'] = Variable<String>(themeColor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('logoPath: $logoPath, ')
          ..write('invoicePrefix: $invoicePrefix, ')
          ..write('invoiceCounter: $invoiceCounter, ')
          ..write('counterYear: $counterYear, ')
          ..write('themeColor: $themeColor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, CustomerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _whatsappMeta =
      const VerificationMeta('whatsapp');
  @override
  late final GeneratedColumn<String> whatsapp = GeneratedColumn<String>(
      'whatsapp', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, address, whatsapp, email, notes, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<CustomerRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('whatsapp')) {
      context.handle(_whatsappMeta,
          whatsapp.isAcceptableOrUnknown(data['whatsapp']!, _whatsappMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      whatsapp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}whatsapp']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class CustomerRow extends DataClass implements Insertable<CustomerRow> {
  final int id;
  final String name;
  final String? address;
  final String? whatsapp;
  final String? email;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CustomerRow(
      {required this.id,
      required this.name,
      this.address,
      this.whatsapp,
      this.email,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || whatsapp != null) {
      map['whatsapp'] = Variable<String>(whatsapp);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      whatsapp: whatsapp == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsapp),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CustomerRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      whatsapp: serializer.fromJson<String?>(json['whatsapp']),
      email: serializer.fromJson<String?>(json['email']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'whatsapp': serializer.toJson<String?>(whatsapp),
      'email': serializer.toJson<String?>(email),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CustomerRow copyWith(
          {int? id,
          String? name,
          Value<String?> address = const Value.absent(),
          Value<String?> whatsapp = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      CustomerRow(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address.present ? address.value : this.address,
        whatsapp: whatsapp.present ? whatsapp.value : this.whatsapp,
        email: email.present ? email.value : this.email,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('CustomerRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('whatsapp: $whatsapp, ')
          ..write('email: $email, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, address, whatsapp, email, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.whatsapp == this.whatsapp &&
          other.email == this.email &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomersCompanion extends UpdateCompanion<CustomerRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> whatsapp;
  final Value<String?> email;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.whatsapp = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.address = const Value.absent(),
    this.whatsapp = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CustomerRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? whatsapp,
    Expression<String>? email,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (whatsapp != null) 'whatsapp': whatsapp,
      if (email != null) 'email': email,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CustomersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? address,
      Value<String?>? whatsapp,
      Value<String?>? email,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      whatsapp: whatsapp ?? this.whatsapp,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (whatsapp.present) {
      map['whatsapp'] = Variable<String>(whatsapp.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('whatsapp: $whatsapp, ')
          ..write('email: $email, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CatalogItemsTable extends CatalogItems
    with TableInfo<$CatalogItemsTable, CatalogItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, price, unit, category, description, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_items';
  @override
  VerificationContext validateIntegrity(Insertable<CatalogItemRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogItemRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CatalogItemsTable createAlias(String alias) {
    return $CatalogItemsTable(attachedDatabase, alias);
  }
}

class CatalogItemRow extends DataClass implements Insertable<CatalogItemRow> {
  final int id;
  final String name;
  final double price;
  final String unit;
  final String? category;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CatalogItemRow(
      {required this.id,
      required this.name,
      required this.price,
      required this.unit,
      this.category,
      this.description,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CatalogItemsCompanion toCompanion(bool nullToAbsent) {
    return CatalogItemsCompanion(
      id: Value(id),
      name: Value(name),
      price: Value(price),
      unit: Value(unit),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CatalogItemRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogItemRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      unit: serializer.fromJson<String>(json['unit']),
      category: serializer.fromJson<String?>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'unit': serializer.toJson<String>(unit),
      'category': serializer.toJson<String?>(category),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CatalogItemRow copyWith(
          {int? id,
          String? name,
          double? price,
          String? unit,
          Value<String?> category = const Value.absent(),
          Value<String?> description = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      CatalogItemRow(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        unit: unit ?? this.unit,
        category: category.present ? category.value : this.category,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('CatalogItemRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, price, unit, category, description, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogItemRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.price == this.price &&
          other.unit == this.unit &&
          other.category == this.category &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CatalogItemsCompanion extends UpdateCompanion<CatalogItemRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> price;
  final Value<String> unit;
  final Value<String?> category;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CatalogItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.unit = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CatalogItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double price,
    required String unit,
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : name = Value(name),
        price = Value(price),
        unit = Value(unit),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CatalogItemRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? price,
    Expression<String>? unit,
    Expression<String>? category,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (unit != null) 'unit': unit,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CatalogItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? price,
      Value<String>? unit,
      Value<String?>? category,
      Value<String?>? description,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return CatalogItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TemplatesTable extends Templates
    with TableInfo<$TemplatesTable, TemplateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _templateLogoPathMeta =
      const VerificationMeta('templateLogoPath');
  @override
  late final GeneratedColumn<String> templateLogoPath = GeneratedColumn<String>(
      'template_logo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _schemaJsonMeta =
      const VerificationMeta('schemaJson');
  @override
  late final GeneratedColumn<String> schemaJson = GeneratedColumn<String>(
      'schema_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        templateLogoPath,
        schemaJson,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'templates';
  @override
  VerificationContext validateIntegrity(Insertable<TemplateRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('template_logo_path')) {
      context.handle(
          _templateLogoPathMeta,
          templateLogoPath.isAcceptableOrUnknown(
              data['template_logo_path']!, _templateLogoPathMeta));
    }
    if (data.containsKey('schema_json')) {
      context.handle(
          _schemaJsonMeta,
          schemaJson.isAcceptableOrUnknown(
              data['schema_json']!, _schemaJsonMeta));
    } else if (isInserting) {
      context.missing(_schemaJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TemplateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplateRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      templateLogoPath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}template_logo_path']),
      schemaJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schema_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TemplatesTable createAlias(String alias) {
    return $TemplatesTable(attachedDatabase, alias);
  }
}

class TemplateRow extends DataClass implements Insertable<TemplateRow> {
  final int id;
  final String name;
  final String? description;
  final String? templateLogoPath;
  final String schemaJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TemplateRow(
      {required this.id,
      required this.name,
      this.description,
      this.templateLogoPath,
      required this.schemaJson,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || templateLogoPath != null) {
      map['template_logo_path'] = Variable<String>(templateLogoPath);
    }
    map['schema_json'] = Variable<String>(schemaJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TemplatesCompanion toCompanion(bool nullToAbsent) {
    return TemplatesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      templateLogoPath: templateLogoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(templateLogoPath),
      schemaJson: Value(schemaJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TemplateRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplateRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      templateLogoPath: serializer.fromJson<String?>(json['templateLogoPath']),
      schemaJson: serializer.fromJson<String>(json['schemaJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'templateLogoPath': serializer.toJson<String?>(templateLogoPath),
      'schemaJson': serializer.toJson<String>(schemaJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TemplateRow copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> templateLogoPath = const Value.absent(),
          String? schemaJson,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TemplateRow(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        templateLogoPath: templateLogoPath.present
            ? templateLogoPath.value
            : this.templateLogoPath,
        schemaJson: schemaJson ?? this.schemaJson,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('TemplateRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('templateLogoPath: $templateLogoPath, ')
          ..write('schemaJson: $schemaJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, templateLogoPath,
      schemaJson, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.templateLogoPath == this.templateLogoPath &&
          other.schemaJson == this.schemaJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TemplatesCompanion extends UpdateCompanion<TemplateRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> templateLogoPath;
  final Value<String> schemaJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.templateLogoPath = const Value.absent(),
    this.schemaJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.templateLogoPath = const Value.absent(),
    required String schemaJson,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : name = Value(name),
        schemaJson = Value(schemaJson),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<TemplateRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? templateLogoPath,
    Expression<String>? schemaJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (templateLogoPath != null) 'template_logo_path': templateLogoPath,
      if (schemaJson != null) 'schema_json': schemaJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TemplatesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? templateLogoPath,
      Value<String>? schemaJson,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return TemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      templateLogoPath: templateLogoPath ?? this.templateLogoPath,
      schemaJson: schemaJson ?? this.schemaJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (templateLogoPath.present) {
      map['template_logo_path'] = Variable<String>(templateLogoPath.value);
    }
    if (schemaJson.present) {
      map['schema_json'] = Variable<String>(schemaJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('templateLogoPath: $templateLogoPath, ')
          ..write('schemaJson: $schemaJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices
    with TableInfo<$InvoicesTable, InvoiceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<int> businessId = GeneratedColumn<int>(
      'business_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _templateIdMeta =
      const VerificationMeta('templateId');
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
      'template_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
      'number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _taxMeta = const VerificationMeta('tax');
  @override
  late final GeneratedColumn<double> tax = GeneratedColumn<double>(
      'tax', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _shippingMeta =
      const VerificationMeta('shipping');
  @override
  late final GeneratedColumn<double> shipping = GeneratedColumn<double>(
      'shipping', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _grandTotalMeta =
      const VerificationMeta('grandTotal');
  @override
  late final GeneratedColumn<double> grandTotal = GeneratedColumn<double>(
      'grand_total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _termsMeta = const VerificationMeta('terms');
  @override
  late final GeneratedColumn<String> terms = GeneratedColumn<String>(
      'terms', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customDataJsonMeta =
      const VerificationMeta('customDataJson');
  @override
  late final GeneratedColumn<String> customDataJson = GeneratedColumn<String>(
      'custom_data_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pdfPathMeta =
      const VerificationMeta('pdfPath');
  @override
  late final GeneratedColumn<String> pdfPath = GeneratedColumn<String>(
      'pdf_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        customerId,
        templateId,
        number,
        date,
        dueDate,
        status,
        subtotal,
        discount,
        tax,
        shipping,
        grandTotal,
        notes,
        terms,
        customDataJson,
        pdfPath,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(Insertable<InvoiceRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
          _templateIdMeta,
          templateId.isAcceptableOrUnknown(
              data['template_id']!, _templateIdMeta));
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    } else if (isInserting) {
      context.missing(_discountMeta);
    }
    if (data.containsKey('tax')) {
      context.handle(
          _taxMeta, tax.isAcceptableOrUnknown(data['tax']!, _taxMeta));
    } else if (isInserting) {
      context.missing(_taxMeta);
    }
    if (data.containsKey('shipping')) {
      context.handle(_shippingMeta,
          shipping.isAcceptableOrUnknown(data['shipping']!, _shippingMeta));
    } else if (isInserting) {
      context.missing(_shippingMeta);
    }
    if (data.containsKey('grand_total')) {
      context.handle(
          _grandTotalMeta,
          grandTotal.isAcceptableOrUnknown(
              data['grand_total']!, _grandTotalMeta));
    } else if (isInserting) {
      context.missing(_grandTotalMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('terms')) {
      context.handle(
          _termsMeta, terms.isAcceptableOrUnknown(data['terms']!, _termsMeta));
    }
    if (data.containsKey('custom_data_json')) {
      context.handle(
          _customDataJsonMeta,
          customDataJson.isAcceptableOrUnknown(
              data['custom_data_json']!, _customDataJsonMeta));
    }
    if (data.containsKey('pdf_path')) {
      context.handle(_pdfPathMeta,
          pdfPath.isAcceptableOrUnknown(data['pdf_path']!, _pdfPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}business_id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id'])!,
      templateId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}template_id'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}number'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
      tax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax'])!,
      shipping: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}shipping'])!,
      grandTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}grand_total'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      terms: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}terms']),
      customDataJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}custom_data_json']),
      pdfPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pdf_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class InvoiceRow extends DataClass implements Insertable<InvoiceRow> {
  final int id;
  final int businessId;
  final int customerId;
  final int templateId;
  final String number;
  final DateTime date;
  final DateTime? dueDate;
  final String status;
  final double subtotal;
  final double discount;
  final double tax;
  final double shipping;
  final double grandTotal;
  final String? notes;
  final String? terms;
  final String? customDataJson;
  final String? pdfPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const InvoiceRow(
      {required this.id,
      required this.businessId,
      required this.customerId,
      required this.templateId,
      required this.number,
      required this.date,
      this.dueDate,
      required this.status,
      required this.subtotal,
      required this.discount,
      required this.tax,
      required this.shipping,
      required this.grandTotal,
      this.notes,
      this.terms,
      this.customDataJson,
      this.pdfPath,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['business_id'] = Variable<int>(businessId);
    map['customer_id'] = Variable<int>(customerId);
    map['template_id'] = Variable<int>(templateId);
    map['number'] = Variable<String>(number);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['status'] = Variable<String>(status);
    map['subtotal'] = Variable<double>(subtotal);
    map['discount'] = Variable<double>(discount);
    map['tax'] = Variable<double>(tax);
    map['shipping'] = Variable<double>(shipping);
    map['grand_total'] = Variable<double>(grandTotal);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || terms != null) {
      map['terms'] = Variable<String>(terms);
    }
    if (!nullToAbsent || customDataJson != null) {
      map['custom_data_json'] = Variable<String>(customDataJson);
    }
    if (!nullToAbsent || pdfPath != null) {
      map['pdf_path'] = Variable<String>(pdfPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      businessId: Value(businessId),
      customerId: Value(customerId),
      templateId: Value(templateId),
      number: Value(number),
      date: Value(date),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      status: Value(status),
      subtotal: Value(subtotal),
      discount: Value(discount),
      tax: Value(tax),
      shipping: Value(shipping),
      grandTotal: Value(grandTotal),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      terms:
          terms == null && nullToAbsent ? const Value.absent() : Value(terms),
      customDataJson: customDataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(customDataJson),
      pdfPath: pdfPath == null && nullToAbsent
          ? const Value.absent()
          : Value(pdfPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory InvoiceRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceRow(
      id: serializer.fromJson<int>(json['id']),
      businessId: serializer.fromJson<int>(json['businessId']),
      customerId: serializer.fromJson<int>(json['customerId']),
      templateId: serializer.fromJson<int>(json['templateId']),
      number: serializer.fromJson<String>(json['number']),
      date: serializer.fromJson<DateTime>(json['date']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      status: serializer.fromJson<String>(json['status']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      discount: serializer.fromJson<double>(json['discount']),
      tax: serializer.fromJson<double>(json['tax']),
      shipping: serializer.fromJson<double>(json['shipping']),
      grandTotal: serializer.fromJson<double>(json['grandTotal']),
      notes: serializer.fromJson<String?>(json['notes']),
      terms: serializer.fromJson<String?>(json['terms']),
      customDataJson: serializer.fromJson<String?>(json['customDataJson']),
      pdfPath: serializer.fromJson<String?>(json['pdfPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'businessId': serializer.toJson<int>(businessId),
      'customerId': serializer.toJson<int>(customerId),
      'templateId': serializer.toJson<int>(templateId),
      'number': serializer.toJson<String>(number),
      'date': serializer.toJson<DateTime>(date),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'status': serializer.toJson<String>(status),
      'subtotal': serializer.toJson<double>(subtotal),
      'discount': serializer.toJson<double>(discount),
      'tax': serializer.toJson<double>(tax),
      'shipping': serializer.toJson<double>(shipping),
      'grandTotal': serializer.toJson<double>(grandTotal),
      'notes': serializer.toJson<String?>(notes),
      'terms': serializer.toJson<String?>(terms),
      'customDataJson': serializer.toJson<String?>(customDataJson),
      'pdfPath': serializer.toJson<String?>(pdfPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  InvoiceRow copyWith(
          {int? id,
          int? businessId,
          int? customerId,
          int? templateId,
          String? number,
          DateTime? date,
          Value<DateTime?> dueDate = const Value.absent(),
          String? status,
          double? subtotal,
          double? discount,
          double? tax,
          double? shipping,
          double? grandTotal,
          Value<String?> notes = const Value.absent(),
          Value<String?> terms = const Value.absent(),
          Value<String?> customDataJson = const Value.absent(),
          Value<String?> pdfPath = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      InvoiceRow(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        customerId: customerId ?? this.customerId,
        templateId: templateId ?? this.templateId,
        number: number ?? this.number,
        date: date ?? this.date,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        status: status ?? this.status,
        subtotal: subtotal ?? this.subtotal,
        discount: discount ?? this.discount,
        tax: tax ?? this.tax,
        shipping: shipping ?? this.shipping,
        grandTotal: grandTotal ?? this.grandTotal,
        notes: notes.present ? notes.value : this.notes,
        terms: terms.present ? terms.value : this.terms,
        customDataJson:
            customDataJson.present ? customDataJson.value : this.customDataJson,
        pdfPath: pdfPath.present ? pdfPath.value : this.pdfPath,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('InvoiceRow(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('customerId: $customerId, ')
          ..write('templateId: $templateId, ')
          ..write('number: $number, ')
          ..write('date: $date, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('tax: $tax, ')
          ..write('shipping: $shipping, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('notes: $notes, ')
          ..write('terms: $terms, ')
          ..write('customDataJson: $customDataJson, ')
          ..write('pdfPath: $pdfPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      businessId,
      customerId,
      templateId,
      number,
      date,
      dueDate,
      status,
      subtotal,
      discount,
      tax,
      shipping,
      grandTotal,
      notes,
      terms,
      customDataJson,
      pdfPath,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceRow &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.customerId == this.customerId &&
          other.templateId == this.templateId &&
          other.number == this.number &&
          other.date == this.date &&
          other.dueDate == this.dueDate &&
          other.status == this.status &&
          other.subtotal == this.subtotal &&
          other.discount == this.discount &&
          other.tax == this.tax &&
          other.shipping == this.shipping &&
          other.grandTotal == this.grandTotal &&
          other.notes == this.notes &&
          other.terms == this.terms &&
          other.customDataJson == this.customDataJson &&
          other.pdfPath == this.pdfPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InvoicesCompanion extends UpdateCompanion<InvoiceRow> {
  final Value<int> id;
  final Value<int> businessId;
  final Value<int> customerId;
  final Value<int> templateId;
  final Value<String> number;
  final Value<DateTime> date;
  final Value<DateTime?> dueDate;
  final Value<String> status;
  final Value<double> subtotal;
  final Value<double> discount;
  final Value<double> tax;
  final Value<double> shipping;
  final Value<double> grandTotal;
  final Value<String?> notes;
  final Value<String?> terms;
  final Value<String?> customDataJson;
  final Value<String?> pdfPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.number = const Value.absent(),
    this.date = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.tax = const Value.absent(),
    this.shipping = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.notes = const Value.absent(),
    this.terms = const Value.absent(),
    this.customDataJson = const Value.absent(),
    this.pdfPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  InvoicesCompanion.insert({
    this.id = const Value.absent(),
    required int businessId,
    required int customerId,
    required int templateId,
    required String number,
    required DateTime date,
    this.dueDate = const Value.absent(),
    required String status,
    required double subtotal,
    required double discount,
    required double tax,
    required double shipping,
    required double grandTotal,
    this.notes = const Value.absent(),
    this.terms = const Value.absent(),
    this.customDataJson = const Value.absent(),
    this.pdfPath = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : businessId = Value(businessId),
        customerId = Value(customerId),
        templateId = Value(templateId),
        number = Value(number),
        date = Value(date),
        status = Value(status),
        subtotal = Value(subtotal),
        discount = Value(discount),
        tax = Value(tax),
        shipping = Value(shipping),
        grandTotal = Value(grandTotal),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<InvoiceRow> custom({
    Expression<int>? id,
    Expression<int>? businessId,
    Expression<int>? customerId,
    Expression<int>? templateId,
    Expression<String>? number,
    Expression<DateTime>? date,
    Expression<DateTime>? dueDate,
    Expression<String>? status,
    Expression<double>? subtotal,
    Expression<double>? discount,
    Expression<double>? tax,
    Expression<double>? shipping,
    Expression<double>? grandTotal,
    Expression<String>? notes,
    Expression<String>? terms,
    Expression<String>? customDataJson,
    Expression<String>? pdfPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (customerId != null) 'customer_id': customerId,
      if (templateId != null) 'template_id': templateId,
      if (number != null) 'number': number,
      if (date != null) 'date': date,
      if (dueDate != null) 'due_date': dueDate,
      if (status != null) 'status': status,
      if (subtotal != null) 'subtotal': subtotal,
      if (discount != null) 'discount': discount,
      if (tax != null) 'tax': tax,
      if (shipping != null) 'shipping': shipping,
      if (grandTotal != null) 'grand_total': grandTotal,
      if (notes != null) 'notes': notes,
      if (terms != null) 'terms': terms,
      if (customDataJson != null) 'custom_data_json': customDataJson,
      if (pdfPath != null) 'pdf_path': pdfPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  InvoicesCompanion copyWith(
      {Value<int>? id,
      Value<int>? businessId,
      Value<int>? customerId,
      Value<int>? templateId,
      Value<String>? number,
      Value<DateTime>? date,
      Value<DateTime?>? dueDate,
      Value<String>? status,
      Value<double>? subtotal,
      Value<double>? discount,
      Value<double>? tax,
      Value<double>? shipping,
      Value<double>? grandTotal,
      Value<String?>? notes,
      Value<String?>? terms,
      Value<String?>? customDataJson,
      Value<String?>? pdfPath,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return InvoicesCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      customerId: customerId ?? this.customerId,
      templateId: templateId ?? this.templateId,
      number: number ?? this.number,
      date: date ?? this.date,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      shipping: shipping ?? this.shipping,
      grandTotal: grandTotal ?? this.grandTotal,
      notes: notes ?? this.notes,
      terms: terms ?? this.terms,
      customDataJson: customDataJson ?? this.customDataJson,
      pdfPath: pdfPath ?? this.pdfPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<int>(businessId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (tax.present) {
      map['tax'] = Variable<double>(tax.value);
    }
    if (shipping.present) {
      map['shipping'] = Variable<double>(shipping.value);
    }
    if (grandTotal.present) {
      map['grand_total'] = Variable<double>(grandTotal.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (terms.present) {
      map['terms'] = Variable<String>(terms.value);
    }
    if (customDataJson.present) {
      map['custom_data_json'] = Variable<String>(customDataJson.value);
    }
    if (pdfPath.present) {
      map['pdf_path'] = Variable<String>(pdfPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('customerId: $customerId, ')
          ..write('templateId: $templateId, ')
          ..write('number: $number, ')
          ..write('date: $date, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('tax: $tax, ')
          ..write('shipping: $shipping, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('notes: $notes, ')
          ..write('terms: $terms, ')
          ..write('customDataJson: $customDataJson, ')
          ..write('pdfPath: $pdfPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InvoiceItemsTable extends InvoiceItems
    with TableInfo<$InvoiceItemsTable, InvoiceItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
      'invoice_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<double> qty = GeneratedColumn<double>(
      'qty', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _metadataJsonMeta =
      const VerificationMeta('metadataJson');
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
      'metadata_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        invoiceId,
        name,
        qty,
        unit,
        price,
        discount,
        note,
        metadataJson,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_items';
  @override
  VerificationContext validateIntegrity(Insertable<InvoiceItemRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
          _qtyMeta, qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta));
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    } else if (isInserting) {
      context.missing(_discountMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
          _metadataJsonMeta,
          metadataJson.isAcceptableOrUnknown(
              data['metadata_json']!, _metadataJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceItemRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}invoice_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      qty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}qty'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      metadataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata_json']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $InvoiceItemsTable createAlias(String alias) {
    return $InvoiceItemsTable(attachedDatabase, alias);
  }
}

class InvoiceItemRow extends DataClass implements Insertable<InvoiceItemRow> {
  final int id;
  final int invoiceId;
  final String name;
  final double qty;
  final String unit;
  final double price;
  final double discount;
  final String? note;
  final String? metadataJson;
  final DateTime createdAt;
  const InvoiceItemRow(
      {required this.id,
      required this.invoiceId,
      required this.name,
      required this.qty,
      required this.unit,
      required this.price,
      required this.discount,
      this.note,
      this.metadataJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<int>(invoiceId);
    map['name'] = Variable<String>(name);
    map['qty'] = Variable<double>(qty);
    map['unit'] = Variable<String>(unit);
    map['price'] = Variable<double>(price);
    map['discount'] = Variable<double>(discount);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InvoiceItemsCompanion toCompanion(bool nullToAbsent) {
    return InvoiceItemsCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      name: Value(name),
      qty: Value(qty),
      unit: Value(unit),
      price: Value(price),
      discount: Value(discount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      metadataJson: metadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metadataJson),
      createdAt: Value(createdAt),
    );
  }

  factory InvoiceItemRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceItemRow(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      name: serializer.fromJson<String>(json['name']),
      qty: serializer.fromJson<double>(json['qty']),
      unit: serializer.fromJson<String>(json['unit']),
      price: serializer.fromJson<double>(json['price']),
      discount: serializer.fromJson<double>(json['discount']),
      note: serializer.fromJson<String?>(json['note']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'name': serializer.toJson<String>(name),
      'qty': serializer.toJson<double>(qty),
      'unit': serializer.toJson<String>(unit),
      'price': serializer.toJson<double>(price),
      'discount': serializer.toJson<double>(discount),
      'note': serializer.toJson<String?>(note),
      'metadataJson': serializer.toJson<String?>(metadataJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InvoiceItemRow copyWith(
          {int? id,
          int? invoiceId,
          String? name,
          double? qty,
          String? unit,
          double? price,
          double? discount,
          Value<String?> note = const Value.absent(),
          Value<String?> metadataJson = const Value.absent(),
          DateTime? createdAt}) =>
      InvoiceItemRow(
        id: id ?? this.id,
        invoiceId: invoiceId ?? this.invoiceId,
        name: name ?? this.name,
        qty: qty ?? this.qty,
        unit: unit ?? this.unit,
        price: price ?? this.price,
        discount: discount ?? this.discount,
        note: note.present ? note.value : this.note,
        metadataJson:
            metadataJson.present ? metadataJson.value : this.metadataJson,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('InvoiceItemRow(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('name: $name, ')
          ..write('qty: $qty, ')
          ..write('unit: $unit, ')
          ..write('price: $price, ')
          ..write('discount: $discount, ')
          ..write('note: $note, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, invoiceId, name, qty, unit, price,
      discount, note, metadataJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceItemRow &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.name == this.name &&
          other.qty == this.qty &&
          other.unit == this.unit &&
          other.price == this.price &&
          other.discount == this.discount &&
          other.note == this.note &&
          other.metadataJson == this.metadataJson &&
          other.createdAt == this.createdAt);
}

class InvoiceItemsCompanion extends UpdateCompanion<InvoiceItemRow> {
  final Value<int> id;
  final Value<int> invoiceId;
  final Value<String> name;
  final Value<double> qty;
  final Value<String> unit;
  final Value<double> price;
  final Value<double> discount;
  final Value<String?> note;
  final Value<String?> metadataJson;
  final Value<DateTime> createdAt;
  const InvoiceItemsCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.name = const Value.absent(),
    this.qty = const Value.absent(),
    this.unit = const Value.absent(),
    this.price = const Value.absent(),
    this.discount = const Value.absent(),
    this.note = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InvoiceItemsCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceId,
    required String name,
    required double qty,
    required String unit,
    required double price,
    required double discount,
    this.note = const Value.absent(),
    this.metadataJson = const Value.absent(),
    required DateTime createdAt,
  })  : invoiceId = Value(invoiceId),
        name = Value(name),
        qty = Value(qty),
        unit = Value(unit),
        price = Value(price),
        discount = Value(discount),
        createdAt = Value(createdAt);
  static Insertable<InvoiceItemRow> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<String>? name,
    Expression<double>? qty,
    Expression<String>? unit,
    Expression<double>? price,
    Expression<double>? discount,
    Expression<String>? note,
    Expression<String>? metadataJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (name != null) 'name': name,
      if (qty != null) 'qty': qty,
      if (unit != null) 'unit': unit,
      if (price != null) 'price': price,
      if (discount != null) 'discount': discount,
      if (note != null) 'note': note,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InvoiceItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? invoiceId,
      Value<String>? name,
      Value<double>? qty,
      Value<String>? unit,
      Value<double>? price,
      Value<double>? discount,
      Value<String?>? note,
      Value<String?>? metadataJson,
      Value<DateTime>? createdAt}) {
    return InvoiceItemsCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      name: name ?? this.name,
      qty: qty ?? this.qty,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      note: note ?? this.note,
      metadataJson: metadataJson ?? this.metadataJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (qty.present) {
      map['qty'] = Variable<double>(qty.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItemsCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('name: $name, ')
          ..write('qty: $qty, ')
          ..write('unit: $unit, ')
          ..write('price: $price, ')
          ..write('discount: $discount, ')
          ..write('note: $note, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments
    with TableInfo<$PaymentsTable, PaymentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
      'invoice_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
      'paid_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, invoiceId, type, method, amount, paidAt, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(_paidAtMeta,
          paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta));
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}invoice_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      paidAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_at'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class PaymentRow extends DataClass implements Insertable<PaymentRow> {
  final int id;
  final int invoiceId;
  final String type;
  final String method;
  final double amount;
  final DateTime paidAt;
  final String? note;
  final DateTime createdAt;
  const PaymentRow(
      {required this.id,
      required this.invoiceId,
      required this.type,
      required this.method,
      required this.amount,
      required this.paidAt,
      this.note,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<int>(invoiceId);
    map['type'] = Variable<String>(type);
    map['method'] = Variable<String>(method);
    map['amount'] = Variable<double>(amount);
    map['paid_at'] = Variable<DateTime>(paidAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      type: Value(type),
      method: Value(method),
      amount: Value(amount),
      paidAt: Value(paidAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentRow(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      type: serializer.fromJson<String>(json['type']),
      method: serializer.fromJson<String>(json['method']),
      amount: serializer.fromJson<double>(json['amount']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'type': serializer.toJson<String>(type),
      'method': serializer.toJson<String>(method),
      'amount': serializer.toJson<double>(amount),
      'paidAt': serializer.toJson<DateTime>(paidAt),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PaymentRow copyWith(
          {int? id,
          int? invoiceId,
          String? type,
          String? method,
          double? amount,
          DateTime? paidAt,
          Value<String?> note = const Value.absent(),
          DateTime? createdAt}) =>
      PaymentRow(
        id: id ?? this.id,
        invoiceId: invoiceId ?? this.invoiceId,
        type: type ?? this.type,
        method: method ?? this.method,
        amount: amount ?? this.amount,
        paidAt: paidAt ?? this.paidAt,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('PaymentRow(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('type: $type, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('paidAt: $paidAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, invoiceId, type, method, amount, paidAt, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentRow &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.type == this.type &&
          other.method == this.method &&
          other.amount == this.amount &&
          other.paidAt == this.paidAt &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class PaymentsCompanion extends UpdateCompanion<PaymentRow> {
  final Value<int> id;
  final Value<int> invoiceId;
  final Value<String> type;
  final Value<String> method;
  final Value<double> amount;
  final Value<DateTime> paidAt;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.type = const Value.absent(),
    this.method = const Value.absent(),
    this.amount = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceId,
    required String type,
    required String method,
    required double amount,
    required DateTime paidAt,
    this.note = const Value.absent(),
    required DateTime createdAt,
  })  : invoiceId = Value(invoiceId),
        type = Value(type),
        method = Value(method),
        amount = Value(amount),
        paidAt = Value(paidAt),
        createdAt = Value(createdAt);
  static Insertable<PaymentRow> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<String>? type,
    Expression<String>? method,
    Expression<double>? amount,
    Expression<DateTime>? paidAt,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (type != null) 'type': type,
      if (method != null) 'method': method,
      if (amount != null) 'amount': amount,
      if (paidAt != null) 'paid_at': paidAt,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PaymentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? invoiceId,
      Value<String>? type,
      Value<String>? method,
      Value<double>? amount,
      Value<DateTime>? paidAt,
      Value<String?>? note,
      Value<DateTime>? createdAt}) {
    return PaymentsCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      type: type ?? this.type,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      paidAt: paidAt ?? this.paidAt,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('type: $type, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('paidAt: $paidAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PaymentSchedulesTable extends PaymentSchedules
    with TableInfo<$PaymentSchedulesTable, PaymentScheduleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
      'invoice_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
      'is_paid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_paid" IN (0, 1))'));
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
      'paid_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, invoiceId, title, dueDate, amount, isPaid, paidAt, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_schedules';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentScheduleRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('is_paid')) {
      context.handle(_isPaidMeta,
          isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta));
    } else if (isInserting) {
      context.missing(_isPaidMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(_paidAtMeta,
          paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentScheduleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentScheduleRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}invoice_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      isPaid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_paid'])!,
      paidAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}paid_at']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PaymentSchedulesTable createAlias(String alias) {
    return $PaymentSchedulesTable(attachedDatabase, alias);
  }
}

class PaymentScheduleRow extends DataClass
    implements Insertable<PaymentScheduleRow> {
  final int id;
  final int invoiceId;
  final String title;
  final DateTime dueDate;
  final double amount;
  final bool isPaid;
  final DateTime? paidAt;
  final String? note;
  final DateTime createdAt;
  const PaymentScheduleRow(
      {required this.id,
      required this.invoiceId,
      required this.title,
      required this.dueDate,
      required this.amount,
      required this.isPaid,
      this.paidAt,
      this.note,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<int>(invoiceId);
    map['title'] = Variable<String>(title);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['amount'] = Variable<double>(amount);
    map['is_paid'] = Variable<bool>(isPaid);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentSchedulesCompanion toCompanion(bool nullToAbsent) {
    return PaymentSchedulesCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      title: Value(title),
      dueDate: Value(dueDate),
      amount: Value(amount),
      isPaid: Value(isPaid),
      paidAt:
          paidAt == null && nullToAbsent ? const Value.absent() : Value(paidAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentScheduleRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentScheduleRow(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      title: serializer.fromJson<String>(json['title']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      amount: serializer.fromJson<double>(json['amount']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'title': serializer.toJson<String>(title),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'amount': serializer.toJson<double>(amount),
      'isPaid': serializer.toJson<bool>(isPaid),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PaymentScheduleRow copyWith(
          {int? id,
          int? invoiceId,
          String? title,
          DateTime? dueDate,
          double? amount,
          bool? isPaid,
          Value<DateTime?> paidAt = const Value.absent(),
          Value<String?> note = const Value.absent(),
          DateTime? createdAt}) =>
      PaymentScheduleRow(
        id: id ?? this.id,
        invoiceId: invoiceId ?? this.invoiceId,
        title: title ?? this.title,
        dueDate: dueDate ?? this.dueDate,
        amount: amount ?? this.amount,
        isPaid: isPaid ?? this.isPaid,
        paidAt: paidAt.present ? paidAt.value : this.paidAt,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('PaymentScheduleRow(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('title: $title, ')
          ..write('dueDate: $dueDate, ')
          ..write('amount: $amount, ')
          ..write('isPaid: $isPaid, ')
          ..write('paidAt: $paidAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, invoiceId, title, dueDate, amount, isPaid, paidAt, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentScheduleRow &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.title == this.title &&
          other.dueDate == this.dueDate &&
          other.amount == this.amount &&
          other.isPaid == this.isPaid &&
          other.paidAt == this.paidAt &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class PaymentSchedulesCompanion extends UpdateCompanion<PaymentScheduleRow> {
  final Value<int> id;
  final Value<int> invoiceId;
  final Value<String> title;
  final Value<DateTime> dueDate;
  final Value<double> amount;
  final Value<bool> isPaid;
  final Value<DateTime?> paidAt;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const PaymentSchedulesCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.title = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.amount = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PaymentSchedulesCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceId,
    required String title,
    required DateTime dueDate,
    required double amount,
    required bool isPaid,
    this.paidAt = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime createdAt,
  })  : invoiceId = Value(invoiceId),
        title = Value(title),
        dueDate = Value(dueDate),
        amount = Value(amount),
        isPaid = Value(isPaid),
        createdAt = Value(createdAt);
  static Insertable<PaymentScheduleRow> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<String>? title,
    Expression<DateTime>? dueDate,
    Expression<double>? amount,
    Expression<bool>? isPaid,
    Expression<DateTime>? paidAt,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (title != null) 'title': title,
      if (dueDate != null) 'due_date': dueDate,
      if (amount != null) 'amount': amount,
      if (isPaid != null) 'is_paid': isPaid,
      if (paidAt != null) 'paid_at': paidAt,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PaymentSchedulesCompanion copyWith(
      {Value<int>? id,
      Value<int>? invoiceId,
      Value<String>? title,
      Value<DateTime>? dueDate,
      Value<double>? amount,
      Value<bool>? isPaid,
      Value<DateTime?>? paidAt,
      Value<String?>? note,
      Value<DateTime>? createdAt}) {
    return PaymentSchedulesCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      amount: amount ?? this.amount,
      isPaid: isPaid ?? this.isPaid,
      paidAt: paidAt ?? this.paidAt,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('title: $title, ')
          ..write('dueDate: $dueDate, ')
          ..write('amount: $amount, ')
          ..write('isPaid: $isPaid, ')
          ..write('paidAt: $paidAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $BusinessesTable businesses = $BusinessesTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $CatalogItemsTable catalogItems = $CatalogItemsTable(this);
  late final $TemplatesTable templates = $TemplatesTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $InvoiceItemsTable invoiceItems = $InvoiceItemsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $PaymentSchedulesTable paymentSchedules =
      $PaymentSchedulesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        businesses,
        customers,
        catalogItems,
        templates,
        invoices,
        invoiceItems,
        payments,
        paymentSchedules
      ];
}
