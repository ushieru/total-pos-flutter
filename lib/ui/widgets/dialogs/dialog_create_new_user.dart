import 'package:flutter/material.dart';
import 'package:total_pos/generated/protos/main.pb.dart';

class DialogCreateNewUser extends StatefulWidget {
  const DialogCreateNewUser({super.key});

  static Future<DialogCreateNewUserPayload?> show(BuildContext context) async {
    return showDialog<DialogCreateNewUserPayload?>(
        context: context, builder: (context_) => const DialogCreateNewUser());
  }

  @override
  State<DialogCreateNewUser> createState() => _DialogCreateNewUserState();
}

class _DialogCreateNewUserState extends State<DialogCreateNewUser> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  AccountType accountType = AccountType.CASHIER;
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo Usuario'),
      content: SingleChildScrollView(
          child: ListBody(children: <Widget>[
        TextFormField(
          autofocus: true,
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Correo'),
        ),
        TextFormField(
          controller: userController,
          decoration: const InputDecoration(labelText: 'Usuario'),
        ),
        TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(labelText: 'Contraseña'),
          obscureText: true,
        ),
        const Text('Rol'),
        DropdownButton(
          value: accountType,
          icon: const Icon(Icons.arrow_downward),
          onChanged: (AccountType? value) {
            if (value == null) return;
            setState(() => accountType = value);
          },
          items: AccountType.values
              .map((AccountType accountType) => DropdownMenuItem(
                    value: accountType,
                    child: Text(accountType.name),
                  ))
              .toList(),
        ),
        const Text('Estado'),
        Row(children: [
          const Text('Activo'),
          Checkbox(
              value: isActive,
              onChanged: (value) {
                if (value == null) return;
                setState(() => isActive = value);
              })
        ]),
      ])),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Crear'),
          onPressed: () {
            Navigator.of(context).pop(DialogCreateNewUserPayload(
                nameController.text,
                emailController.text,
                userController.text,
                passwordController.text,
                accountType,
                isActive));
          },
        ),
      ],
    );
  }
}

class DialogCreateNewUserPayload {
  final String name;
  final String email;
  final String username;
  final String password;
  final AccountType accountType;
  final bool isActive;

  DialogCreateNewUserPayload(this.name, this.email, this.username,
      this.password, this.accountType, this.isActive);
}
