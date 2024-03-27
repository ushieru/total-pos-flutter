enum FilterOperator {
  equal,
  notEqual,
  gt,
  lt,
  contains,
  notContains,
}

String filterOperatorToString(FilterOperator operator) {
  switch (operator) {
    case FilterOperator.equal:
      return '=';
    case FilterOperator.notEqual:
      return '<>';
    case FilterOperator.gt:
      return '>';
    case FilterOperator.lt:
      return '<';
    case FilterOperator.contains:
      return 'CONTAINS';
    case FilterOperator.notContains:
      return 'NOT CONTAINS';
  }
}

class Filter {
  Filter(this.field, this.operator, this.value);

  final String field;
  final FilterOperator operator;
  final String value;

  @override
  String toString() {
    return '$field ${filterOperatorToString(operator)} ?';
  }
}
