// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/login/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/login/bloc/state.dart';
import 'package:master_plan/presentation/pages/login/widgets/dialog_auth.dart';
import 'package:master_plan/presentation/pages/login/widgets/dialog_pay.dart';
import 'package:master_plan/presentation/pages/login/widgets/dialog_version.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CubitLogin>(
        create: (context) => CubitLogin(), child: ContentLogin());
  }
}

class ContentLogin extends StatelessWidget {
  ContentLogin({super.key});

  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController companyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('MasterPlan'),
          actions: [
            Center(child: Text(context.read<CubitMain>().state.version)),
            const SizedBox(width: 10)
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Text('Компания'),
                  // const SizedBox(height: 8),
                  BlocBuilder<CubitLogin, StateLogin>(
                    buildWhen: (previous, current) => previous.company != current.company,
                    builder: (context, state) {
                      companyController.text = state.company;
                      return TextFormField(
                        controller: companyController,
                        // onChanged: (value) => context.read<CubitLogin>().changeCompany(value),
                        decoration: const InputDecoration(labelText: 'Компания'));
                    },
                  ),
                  const SizedBox(height: 12),
                  // const Text('Табельный номер'),
                  // const SizedBox(height: 8),
                  BlocBuilder<CubitLogin, StateLogin>(
                    buildWhen: (previous, current) => previous.login != current.login,
                    builder: (context, state) {
                      loginController.text = state.login;
                      return TextFormField(
                        controller: loginController,
                        // onChanged: (value) => context.read<CubitLogin>().changeLogin(value),
                        decoration: const InputDecoration(labelText: 'Табельный номер'));
                    }
                  ),
                  const SizedBox(height: 12),
                  // const Text('Пароль'),
                  // const SizedBox(height: 8),
                  BlocBuilder<CubitLogin, StateLogin>(
                    buildWhen: (previous, current) => previous.password != current.password,
                    builder: (context, state) {
                      passwordController.text = state.password;
                      return TextFormField(
                        controller: passwordController,
                        // onChanged: (value) => context.read<CubitLogin>().changePassword(value),
                        decoration: const InputDecoration(labelText: 'Пароль'));
                      },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () async {
                        context.read<CubitLogin>().setBtn(loginController.text, passwordController.text, companyController.text);
                        final isResult = await context.read<CubitMain>().save(loginController.text, passwordController.text, companyController.text);
                        switch (isResult) {
                          case 'не оплачено':
                            if (context.mounted) showDialog(context: context,builder: (ctx) => const DialogPay());
                          case 'Директор':
                            break;
                          case 'Начальник':
                            if (context.mounted) Navigator.pushNamed(context, '/chiefPage');
                          case 'Мастер':
                            if (context.mounted) Navigator.pushNamed(context, '/masterPage');
                          case 'Оператор':
                            if (context.mounted) Navigator.pushNamed(context, '/operatorPage');
                          case 'Диспетчер':
                            if (context.mounted) Navigator.pushNamed(context, '/dispatcherPage');
                          case 'Технолог':
                            if (context.mounted) Navigator.pushNamed(context, '/technologistPage');
                          case 'Начальник-мастер':
                            if (context.mounted) Navigator.pushNamed(context, '/chiefMasterPage');
                          case 'Ошибка_версий':
                            if (context.mounted) showDialog(context: context,builder: (BuildContext context) =>const DialogVersion());
                          case 'Ошибка_авторизации_1':
                            if (context.mounted)showDialog(context: context,builder: (BuildContext context) =>const DialogAuth(1));
                          case 'Ошибка_авторизации_2':
                            if (context.mounted)showDialog(context: context,builder: (BuildContext context) =>const DialogAuth(2));
                        }
                        // numberController.clear();
                        // passwordController.clear();
                      },
                      child: BlocBuilder<CubitLogin, StateLogin>(
                        buildWhen: (previous, current) => previous.isSelect != current.isSelect,
                          builder: (context, state) => !state.isSelect
                              ? const Text('Войти')
                              : const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white)))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
