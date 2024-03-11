import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/login/bloc/cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CubitLogin>(
      create: (context) => CubitLogin(),
      child: ContentLogin());
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
          actions: const [Center(child: Text('version'))],
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
                      onPressed: () async{
                        final isResult = await context.read<CubitMain>().save(numberController.text, passwordController.text);
                        // showDialog
                        switch(isResult){
                          case 'Начальник': if (context.mounted) Navigator.pushNamed(context, '/chiefPage');
                          case 'Мастер': if (context.mounted) Navigator.pushNamed(context, '/masterPage');
                          case 'Оператор': if (context.mounted) Navigator.pushNamed(context, '/operatorPage');
                        }
                        
                        numberController.clear();
                        passwordController.clear();
                      }, 
                      child: const Text('Войти')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}