import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_cubit/chief_staff_cubit.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_list_widgets/edit_page_user_photo_widget.dart';

import '../../../../../domain/model/staff_model.dart';

class ChiefStaffEditPage extends StatelessWidget {
  const ChiefStaffEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final staff = ModalRoute.of(context)!.settings.arguments as StaffModel;
    return BlocProvider(
      create: (context) => ChiefStaffCubit(),
      child: ChiefStaffEditPageView(
        staff: staff,
      ),
    );
  }
}

class ChiefStaffEditPageView extends StatefulWidget {
  const ChiefStaffEditPageView({required this.staff, super.key});

  final StaffModel staff;

  @override
  State<ChiefStaffEditPageView> createState() => _ChiefStaffEditPageViewState();
}

class _ChiefStaffEditPageViewState extends State<ChiefStaffEditPageView> {
  @override
  void initState() {
    super.initState();
    context.read<ChiefStaffCubit>().fetchDropDownsItems(
        selectedRegionId: widget.staff.user.areaId,
        selectedPositionId: widget.staff.user.positionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: const Text('редактирование работника')),
      body: BlocBuilder<ChiefStaffCubit, ChiefStaffState>(
        builder: (context, state) {
          if (state is ChiefStaffState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EditPageUserPhotoWidget(
                        imageUrl: widget.staff.user.photo,
                        downloadImageFromGallery: () {
                          context
                              .read<ChiefStaffCubit>()
                              .updateProfileImageFromGallery(
                                  imageName: widget.staff.login,
                                  userId: widget.staff.userId, imageSource: ImageSource.gallery)
                              .then((_) => setState(() {}));
                        }, fetchImageFromCamera: () { context
                          .read<ChiefStaffCubit>()
                          .updateProfileImageFromGallery(
                          imageName: widget.staff.login,
                          userId: widget.staff.userId, imageSource: ImageSource.camera)
                          .then((_) => setState(() {})); },
                      ),
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
                        decoration: InputDecoration(
                            hintText: widget.staff.user.fio),
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
                        decoration:
                            InputDecoration(hintText: widget.staff.login),
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
                        decoration: InputDecoration(
                            hintText: widget.staff.password,
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
                        onChanged: (String? value) => setState( () =>
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
                          context
                              .read<ChiefStaffCubit>()
                              .updateStaff(staffModel: widget.staff);
                          Navigator.pop(context, false);
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: const Text('работник изменен')));
                        },
                        child: const Text('изменить'),
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
