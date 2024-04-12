import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_cubit/chief_staff_cubit.dart';
import 'chief_staff_list_widgets/add_page_user_photo_widget.dart';

class ChiefStaffAddPage extends StatelessWidget {
  const ChiefStaffAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChiefStaffCubit(),
      child: const ChiefStaffAddPageView(),
    );
  }
}

class ChiefStaffAddPageView extends StatefulWidget {
  const ChiefStaffAddPageView({super.key});

  @override
  State<ChiefStaffAddPageView> createState() => _ChiefStaffAddPageViewState();
}

class _ChiefStaffAddPageViewState extends State<ChiefStaffAddPageView> {
  @override
  void initState() {

    super.initState();
    context.read<ChiefStaffCubit>().fetchDropDownsItems();
    print('заинитилось');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: const Text('добавление персонала')),
      body: BlocBuilder<ChiefStaffCubit, ChiefStaffState>(
        builder: (context, state) {
          if (state is ChiefStaffAddPageState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AddPageUserPhotoWidget(
                      //   imageUrl: context
                      //       .read<ChiefStaffListCubit>()
                      //       .loadedProfileImage
                      //       ?.path,
                      //   downloadImageFromGallery: () => context
                      //       .read<ChiefStaffListCubit>()
                      //       .addPhotoFromGallery(
                      //           imageSource: ImageSource.gallery)
                      //       .then((_) => setState(() {})),
                      //   fetchImageFromCamera: () => context
                      //       .read<ChiefStaffListCubit>()
                      //       .addPhotoFromGallery(
                      //           imageSource: ImageSource.camera)
                      //       .then((_) => setState(() {})),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'ФИО',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller:
                            context.read<ChiefStaffCubit>().fioController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Табельный номер',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: context
                            .read<ChiefStaffCubit>()
                            .numberController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Пароль',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: context
                            .read<ChiefStaffCubit>()
                            .passwordController,
                        decoration: const InputDecoration(
                            helperText:
                                'оставьте пустым для автоматической генерации'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Должность',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      DropdownButton<String>(
                        value: context
                            .read<ChiefStaffCubit>()
                            .selectedPosition,
                        onChanged: (String? value) => setState(() => context
                                .read<ChiefStaffCubit>()
                                .selectedPosition =
                            value ??
                                context
                                    .read<ChiefStaffCubit>()
                                    .selectedPosition),
                        items: state.positionsNamesList
                            .map((String region) => DropdownMenuItem(
                                  value: region,
                                  child: Text(region),
                                ))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Участок',
                        style: TextStyle(fontSize: 18),
                      ),
                      DropdownButton<String>(
                        value:
                            context.read<ChiefStaffCubit>().selectedArea,
                        onChanged: (String? value) => setState(() =>
                            context.read<ChiefStaffCubit>().selectedArea =
                                value ??
                                    context
                                        .read<ChiefStaffCubit>()
                                        .selectedArea),
                        items: state.areasNamesList
                            .map((String region) => DropdownMenuItem(
                                  value: region,
                                  child: Text(region),
                                ))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                          child: ElevatedButton(
                        onPressed: () {
                          context.read<ChiefStaffCubit>().insertStaff();
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: const Text('работник добавлен')));
                          setState(() {});
                        },
                        child: const Text('добавить'),
                      ))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
