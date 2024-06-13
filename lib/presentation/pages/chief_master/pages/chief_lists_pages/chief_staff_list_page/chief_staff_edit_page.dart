import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_cubit/chief_staff_cubit.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_list_widgets/edit_page_user_photo_widget.dart';

import '../../../../../../domain/model/staff.dart';

class ChiefStaffEditPage extends StatelessWidget {
  const ChiefStaffEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final staff = ModalRoute.of(context)!.settings.arguments as Staff;
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

  final Staff staff;

  @override
  State<ChiefStaffEditPageView> createState() => _ChiefStaffEditPageViewState();
}

class _ChiefStaffEditPageViewState extends State<ChiefStaffEditPageView> {
  @override
  void initState() {
    context
        .read<ChiefStaffCubit>()
        .fetchDropDownsItems(staffId: widget.staff.id);
    super.initState();
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
          if (state.status == ChiefStaffStatus.success) {
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
                                  userId: widget.staff.userId,
                                  imageSource: ImageSource.gallery);
                          setState(() {});
                        },
                        fetchImageFromCamera: () {
                          context
                              .read<ChiefStaffCubit>()
                              .updateProfileImageFromGallery(
                                  imageName: widget.staff.login,
                                  userId: widget.staff.userId,
                                  imageSource: ImageSource.camera)
                              .then((_) => setState(() {}));
                        },
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
                        decoration:
                            InputDecoration(hintText: widget.staff.user.fio),
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
                        controller:
                            context.read<ChiefStaffCubit>().numberController,
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
                        controller:
                            context.read<ChiefStaffCubit>().passwordController,
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
                      // DropdownButton<String>(
                      //   value: context.read<ChiefStaffCubit>().selectedPosition,
                      //   onChanged: (String? value) => setState(() =>
                      //       context.read<ChiefStaffCubit>().selectedPosition =
                      //           value ??
                      //               context
                      //                   .read<ChiefStaffCubit>()
                      //                   .selectedPosition),
                      //   items: state.positionsNamesList
                      //       .map((String region) => DropdownMenuItem(
                      //             value: region,
                      //             child: Text(region),
                      //           ))
                      //       .toList(),
                      // ),
                      ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => index ==
                                  context
                                      .read<ChiefStaffCubit>()
                                      .selectedPositionsList
                                      .length
                              ? IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => SimpleDialog(
                                              title: Text('выберите должность'),
                                              children: List.generate(
                                                  context
                                                      .read<ChiefStaffCubit>()
                                                      .positionsToSelectList
                                                      .length,
                                                  (index) => SimpleDialogOption(
                                                        onPressed: () =>
                                                            setState(() {
                                                          context
                                                              .read<
                                                                  ChiefStaffCubit>()
                                                              .selectedPositionsList
                                                              .add(context
                                                                  .read<
                                                                      ChiefStaffCubit>()
                                                                  .positionsToSelectList[index]);

                                                          context
                                                              .read<
                                                                  ChiefStaffCubit>()
                                                              .positionsToSelectList
                                                              .remove(context
                                                                  .read<
                                                                      ChiefStaffCubit>()
                                                                  .positionsToSelectList[index]);
                                                          Navigator.pop(ctx);
                                                        }),
                                                        child: Text(context
                                                            .read<
                                                                ChiefStaffCubit>()
                                                            .positionsToSelectList[index]),
                                                      )),
                                            ));
                                  },
                                  icon: Icon(Icons.add))
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      context
                                          .read<ChiefStaffCubit>()
                                          .positionsToSelectList
                                          .add(context
                                              .read<ChiefStaffCubit>()
                                              .selectedPositionsList[index]);

                                      context
                                          .read<ChiefStaffCubit>()
                                          .selectedPositionsList
                                          .remove(context
                                              .read<ChiefStaffCubit>()
                                              .selectedPositionsList[index]);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Text(
                                      context
                                          .read<ChiefStaffCubit>()
                                          .selectedPositionsList[index],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                          separatorBuilder: (ctx, i) => const SizedBox(
                                height: 5,
                              ),
                          itemCount: context
                                  .read<ChiefStaffCubit>()
                                  .selectedPositionsList
                                  .length +
                              1),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Участок',
                        style: TextStyle(fontSize: 18),
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: context.read<ChiefStaffCubit>().selectedArea,
                        onChanged: (String? value) => setState(() => context
                                .read<ChiefStaffCubit>()
                                .selectedArea =
                            value ??
                                context.read<ChiefStaffCubit>().selectedArea),
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
