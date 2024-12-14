class DbColumn {
  String _definition = '';
  bool _isNullable = true;
  String? _defaultValue;
  bool _isUnique = false;

  /// Start with INTEGER type
  DbColumn.integer() {
    _definition = 'INTEGER';
  }

  /// Start with TEXT type
  DbColumn.text() {
    _definition = 'TEXT';
  }

  /// Start with REAL type
  DbColumn.real() {
    _definition = 'REAL';
  }

  /// Start with BOOLEAN type (stored as INTEGER)
  DbColumn.boolean() {
    _definition = 'INTEGER';
    _defaultValue = '0';
  }

  /// Start with DATETIME type (stored as TEXT)
  DbColumn.datetime() {
    _definition = 'TEXT';
  }

  /// Make column auto-incrementing primary key
  DbColumn autoIncrement() {
    _definition = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    _isNullable = false;
    return this;
  }

  /// Make column primary key
  DbColumn primaryKey() {
    _definition += ' PRIMARY KEY';
    _isNullable = false;
    return this;
  }

  /// Make column not nullable
  DbColumn notNull() {
    _isNullable = false;
    return this;
  }

  /// Set default value for column
  DbColumn defaultValue(dynamic value) {
    if (value is String) {
      _defaultValue = '"$value"';
    } else {
      _defaultValue = value.toString();
    }
    return this;
  }

  /// Make column unique
  DbColumn unique() {
    _isUnique = true;
    return this;
  }

  /// Convert column definition to SQLite string
  @override
  String toString() {
    final List<String> parts = [_definition];

    if (!_isNullable) {
      parts.add('NOT NULL');
    }

    if (_defaultValue != null) {
      parts.add('DEFAULT $_defaultValue');
    }

    if (_isUnique) {
      parts.add('UNIQUE');
    }

    return parts.join(' ');
  }
}
