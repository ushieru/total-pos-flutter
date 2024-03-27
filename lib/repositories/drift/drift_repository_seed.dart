import 'package:drift/drift.dart';
import 'package:nanoid2/nanoid2.dart';
import 'package:total_pos/grpc/utils/crypt.dart';
import 'package:total_pos/repositories/drift/drift_repository.dart';

extension DatabaseSeed on DritfRepository {
  Future<void> runSeed() async {
    await _createUsers();
    await _createCategoriesAndProducts();
  }

  Future<void> _createUsers() async {
    final admin = await (into(user).insertReturning(UserCompanion(
      id: Value(nanoid()),
      name: const Value('admin'),
      email: const Value('admin@email.com'),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    )));
    await (into(account).insert(AccountCompanion(
      id: Value(nanoid()),
      username: const Value('admin'),
      accountType: const Value('ADMIN'),
      isActive: const Value(1),
      password: Value(Crypt.encrypt('admin')),
      userId: Value(admin.id),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    )));
    final cashier = await (into(user).insertReturning(UserCompanion(
      id: Value(nanoid()),
      name: const Value('cashier'),
      email: const Value('cashier@email.com'),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    )));
    await (into(account).insert(AccountCompanion(
      id: Value(nanoid()),
      username: const Value('cashier'),
      accountType: const Value('CASHIER'),
      isActive: const Value(1),
      password: Value(Crypt.encrypt('cashier')),
      userId: Value(cashier.id),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    )));
    final waiter = await (into(user).insertReturning(UserCompanion(
      id: Value(nanoid()),
      name: const Value('waiter'),
      email: const Value('waiter@email.com'),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    )));
    await (into(account).insert(AccountCompanion(
      id: Value(nanoid()),
      username: const Value('waiter'),
      accountType: const Value('WAITER'),
      isActive: const Value(1),
      password: Value(Crypt.encrypt('waiter')),
      userId: Value(waiter.id),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    )));
  }

  Future<void> _createCategoriesAndProducts() async {
    final pizza = await into(product).insertReturning(ProductCompanion(
      id: Value(nanoid()),
      name: const Value('Pizza'),
      description: const Value('Pizza description'),
      price: const Value(250),
      createAt: Value(DateTime.now()),
      updateAt: Value(DateTime.now()),
    ));
    final hamburger = await into(product).insertReturning(ProductCompanion(
      id: Value(nanoid()),
      name: const Value('Hamburguesa'),
      description: const Value('Hamburguesa description'),
      price: const Value(150),
      createAt: Value(DateTime.now()),
      updateAt: Value(DateTime.now()),
    ));
    final soda = await into(product).insertReturning(ProductCompanion(
      id: Value(nanoid()),
      name: const Value('Soda'),
      description: const Value('Soda description'),
      price: const Value(150),
      createAt: Value(DateTime.now()),
      updateAt: Value(DateTime.now()),
    ));
    final comidas = await into(category).insertReturning(CategoryCompanion(
      id: Value(nanoid()),
      name: const Value('Comidas'),
      createAt: Value(DateTime.now()),
      updateAt: Value(DateTime.now()),
    ));
    final bebidas = await into(category).insertReturning(CategoryCompanion(
      id: Value(nanoid()),
      name: const Value('Bebidas'),
      createAt: Value(DateTime.now()),
      updateAt: Value(DateTime.now()),
    ));
    await into(categoryProduct).insert(CategoryProductCompanion(
      productId: Value(pizza.id),
      categoryId: Value(comidas.id),
    ));
    await into(categoryProduct).insert(CategoryProductCompanion(
      productId: Value(hamburger.id),
      categoryId: Value(comidas.id),
    ));
    await into(categoryProduct).insert(CategoryProductCompanion(
      productId: Value(soda.id),
      categoryId: Value(bebidas.id),
    ));
  }
}
