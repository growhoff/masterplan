import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/login/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/login/bloc/state.dart';
import 'package:master_plan/presentation/pages/login/widgets/dialog_auth.dart';
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

  final TextEditingController numberController = TextEditingController();
  final FocusNode numberFocusNode = FocusNode();

  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MasterPlan'),
          actions: const [Center(child: Text('v2.3.0'))],
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Табельный номер'),
                const SizedBox(height: 8),
                TextFormField(
                    controller: numberController,
                    focusNode: numberFocusNode,
                    decoration: const InputDecoration(labelText: 'Ввод')),
                const SizedBox(height: 8),
                const Text('Пароль'),
                const SizedBox(height: 8),
                TextFormField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    decoration: const InputDecoration(labelText: 'Ввод')),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () async {
                      context.read<CubitLogin>().setBtn();
                      final isResult = await context
                          .read<CubitMain>()
                          .save(numberController.text, passwordController.text);
                      // showDialog
                      switch (isResult) {
                        case 'не оплачено':
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: Text('Приложение не оплачено'),
                                    contentPadding: const EdgeInsets.all(5),
                                    actions: [
                                      MaterialButton(
                                          child: Text(
                                            'ОК',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context, false))
                                    ],
                                  ));
                        case 'Директор':
                          break;
                        case 'Начальник':
                          if (context.mounted)
                            Navigator.pushNamed(context, '/chiefPage');
                        case 'Мастер':
                          if (context.mounted)
                            Navigator.pushNamed(context, '/masterPage');
                        case 'Оператор':
                          if (context.mounted)
                            Navigator.pushNamed(context, '/operatorPage');
                        case 'Ошибка_версий':
                          if (context.mounted)
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    const DialogVersion());
                        case 'Ошибка_авторизации_1':
                          if (context.mounted)
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    const DialogAuth(1));
                        case 'Ошибка_авторизации_2':
                          if (context.mounted)
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    const DialogAuth(2));
                      }
                      numberController.clear();
                      passwordController.clear();
                    },
                    child: BlocBuilder<CubitLogin, StateLogin>(
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
    );
  }
}
