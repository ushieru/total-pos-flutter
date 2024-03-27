import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:total_pos/generated/protos/main.pbgrpc.dart';
import 'package:total_pos/grpc/client.dart';
import 'package:total_pos/ui/routes/admin/route_admin_dashboard.dart';
import 'package:total_pos/ui/routes/cashier/route_cashier_dashboard.dart';
import 'package:total_pos/ui/routes/waiter/route_waiter_tables.dart';
import 'package:total_pos/ui/utils/session.dart';

class RouteLogin extends StatelessWidget {
  static const routeName = "/login";
  const RouteLogin({super.key});

  void onLogin(BuildContext context, String username, String password) async {
    await GrpcClientSingleton()
        .authClient
        .login(LoginRequest(username: username, password: password))
        .then((loginResponse) {
      SessionSingleton().token = loginResponse.token;
      SessionSingleton().account = loginResponse.account;
      switch (loginResponse.account.accountType) {
        case AccountType.ADMIN:
          Navigator.pushNamedAndRemoveUntil(
              context, RouteAdminDashboard.routeName, (route) => false);
        case AccountType.CASHIER:
          Navigator.pushNamedAndRemoveUntil(
              context, RouteCashierDashboard.routeName, (route) => false);
        case AccountType.WAITER:
          Navigator.pushNamedAndRemoveUntil(
              context, RouteWaiterTables.routeName, (route) => false);
      }
    }).catchError((error) {
      if (error is GrpcError) {
        showToast(error.message ?? '', position: ToastPosition.bottom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(
        body: SizedBox(
            width: double.maxFinite,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 400,
                      child: Card(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Column(children: [
                                const Text('Total POS'),
                                TextFormField(
                                    controller: userController,
                                    decoration: const InputDecoration(
                                        hintText: 'Nombre de usuario')),
                                TextFormField(
                                    controller: passwordController,
                                    obscureText: true,
                                    onFieldSubmitted: (_) => onLogin(
                                        context,
                                        userController.text,
                                        passwordController.text),
                                    decoration: const InputDecoration(
                                        hintText: 'Password')),
                                const SizedBox(height: 15),
                                ElevatedButton(
                                    onPressed: () {
                                      onLogin(context, userController.text,
                                          passwordController.text);
                                    },
                                    child: const Text('Ingresar')),
                              ]))))
                ])));
  }
}
