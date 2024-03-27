import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:total_pos/ui/routes/admin/user/route_admin_users_provider.dart';
import 'package:total_pos/ui/widgets/dialogs/dialog_create_new_user.dart';
import 'package:total_pos/ui/widgets/tables/table_user.dart';

class RouteAdminUsers extends ConsumerWidget {
  static const routeName = "admin.users";
  static const routePath = "/admin/users";
  const RouteAdminUsers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = ref.read(routeAdminUsersProvider.notifier);
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: ListView(children: [
              SizedBox(
                  width: double.maxFinite,
                  child: Card(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: ElevatedButton(
                              onPressed: () async {
                                final payload =
                                    await DialogCreateNewUser.show(context);
                                if (payload == null) return;
                                methods.createUser(
                                    payload.name,
                                    payload.email,
                                    payload.username,
                                    payload.password,
                                    payload.accountType,
                                    payload.isActive);
                              },
                              child: const Text('Nuevo usuario'))))),
              const SizedBox(
                  width: double.maxFinite,
                  child: Card(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TableUsers(),
                  )))
            ])));
  }
}
