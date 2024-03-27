import 'package:total_pos/generated/protos/main.pb.dart';
import 'package:total_pos/generated/protos/main.pbgrpc.dart';
import 'package:total_pos/repositories/criteria/criteria.dart' as repository;
import 'package:total_pos/repositories/criteria/filter.dart' as repository;

repository.Filter filterToRepositoryFilter(Filter filter) {
  return repository.Filter(
    filter.field_1,
    switch (filter.operator) {
      FilterOperator.EQUAL => repository.FilterOperator.equal,
      FilterOperator.NOT_EQUAL => repository.FilterOperator.notEqual,
      FilterOperator.GT => repository.FilterOperator.gt,
      FilterOperator.LT => repository.FilterOperator.lt,
      FilterOperator.CONTAINS => repository.FilterOperator.contains,
      FilterOperator.NOT_CONTAINS => repository.FilterOperator.notContains,
      _ => throw 'Filter not found'
    },
    filter.value,
  );
}

repository.Criteria criteriaToRepositoryCriteria(Criteria criteria) {
  final filters = criteria.filters.map(filterToRepositoryFilter).toList();
  return repository.Criteria(filters);
}
