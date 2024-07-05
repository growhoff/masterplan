import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:master_plan/domain/model/position_staff.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_cubit/chief_staff_cubit.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_staff_list_page/chief_staff_list_widgets/edit_page_user_photo_widget.dart';

import '../../../../../domain/model/area.dart';
import '../../../../../domain/model/staff.dart';
import '../../../../../domain/model/unit.dart';
import '../../../chief/chief_lists_pages/chief_staff_list_page/chief_staff_list_widgets/add_page_user_photo_widget.dart';
import 'chiefs_list_cubit/chiefs_list_cubit.dart';

class EditChiefPage extends StatelessWidget {
  const EditChiefPage({super.key});

  @override
  Widget build(BuildContext context) {
    final positionStaff =
        ModalRoute.of(context)!.settings.arguments as PositionStaffModel;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChiefsListCubit(),
        ),
        BlocProvider(
          create: (context) => StaffCubit(),
        ),
      ],
      child: EditChiefPageView(
        positionStaff: positionStaff,
      ),
    );
  }
}

class EditChiefPageView extends StatefulWidget {
  const EditChiefPageView({required this.positionStaff, super.key});

  final PositionStaffModel positionStaff;

  @override
  State<EditChiefPageView> createState() => _EditChiefPageViewState();
}

class _EditChiefPageViewState extends State<EditChiefPageView> {
  @override
  void initState() {
    context
        .read<ChiefsListCubit>()
        .initEditPage(widget.positionStaff.staffId);
    context.read<ChiefsListCubit>().fioController.text =
        widget.positionStaff.staff.user.fio;
    context.read<ChiefsListCubit>().passwordController.text =
        widget.positionStaff.staff.password;
    context.read<ChiefsListCubit>().numberController.text =
        widget.positionStaff.staff.login;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: const Text('редактирование персонала')),
      body: BlocBuilder<ChiefsListCubit, ChiefsListState>(
        builder: (context, state) {
          if (state.status == ChiefsListStatus.success) {
            return SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddPageUserPhotoWidget(
                      imageUrl:
                          context.read<StaffCubit>().loadedProfileImage?.path,
                      downloadImageFromGallery: () => context
                          .read<StaffCubit>()
                          .addPhotoFromGallery(imageSource: ImageSource.gallery)
                          .then((_) => setState(() {})),
                      fetchImageFromCamera: () => context
                          .read<StaffCubit>()
                          .addPhotoFromGallery(imageSource: ImageSource.camera)
                          .then((_) => setState(() {})),
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
                      controller: context.read<ChiefsListCubit>().fioController,
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
                      controller:
                          context.read<ChiefsListCubit>().numberController,
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
                          context.read<ChiefsListCubit>().passwordController,
                      decoration: const InputDecoration(
                          helperText:
                              'оставьте пустым для автоматической генерации'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Должность',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SingleChildScrollView(
                      child: ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => index ==
                                  context
                                      .read<ChiefsListCubit>()
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
                                                      .read<ChiefsListCubit>()
                                                      .positionsToSelectList
                                                      .length,
                                                  (index) => SimpleDialogOption(
                                                        onPressed: () =>
                                                            setState(() {
                                                          context
                                                              .read<
                                                                  ChiefsListCubit>()
                                                              .addPositionElement(
                                                                  index);
                                                          Navigator.pop(ctx);
                                                        }),
                                                        child: Text(context
                                                            .read<
                                                                ChiefsListCubit>()
                                                            .positionsToSelectList[index]),
                                                      )),
                                            ));
                                  },
                                  icon: Icon(Icons.add))
                              : Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            context
                                                .read<ChiefsListCubit>()
                                                .selectedPositionsList[index],
                                            textAlign: TextAlign.center,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  context
                                                      .read<ChiefsListCubit>()
                                                      .deletePositionElement(
                                                          index,
                                                          context
                                                              .read<
                                                                  ChiefsListCubit>()
                                                              .selectedPositionsList[index]);
                                                });
                                              },
                                              icon: Icon(Icons.delete))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    context
                                        .read<ChiefsListCubit>()
                                        .selectedPositionsList[index] ==
                                        'Начальник'
                                        ? DropdownButton<Unit>(
                                      isExpanded: true,
                                      value: context
                                          .read<ChiefsListCubit>()
                                          .selectedUnit,
                                      onChanged: (Unit? unit) =>
                                          setState(() {
                                            context
                                                .read<ChiefsListCubit>()
                                                .changeUnitsDropDownValue(
                                                index, unit);
                                          }),
                                      items: state.unitsList
                                          .map((Unit unit) =>
                                          DropdownMenuItem(
                                            value: unit,
                                            child: Text(
                                                '${unit.number} ${unit.name}'),
                                          ))
                                          .toList(),
                                    )
                                        : DropdownButton<Area>(
                                      isExpanded: true,
                                      value: context
                                          .read<ChiefsListCubit>()
                                          .areasForPositionsList
                                          .isNotEmpty
                                          ? context
                                          .read<ChiefsListCubit>()
                                          .areasForPositionsList[
                                      index]
                                          : Area(
                                          id: 0,
                                          name: '',
                                          number: '',
                                          unitId: 0),
                                      onChanged: (Area? area) =>
                                          setState(() {
                                            context
                                                .read<ChiefsListCubit>()
                                                .changeAreasDropDownValue(
                                                index, area);
                                          }),
                                      items: state.areasList
                                          .map((Area area) =>
                                          DropdownMenuItem(
                                            value: area,
                                            child: Text(
                                                '${area.number} ${area.name}'),
                                          ))
                                          .toList(),
                                    ),
                                  ],
                          ),
                          separatorBuilder: (ctx, i) => SizedBox(
                            height: 5,
                          ),
                          itemCount: context
                              .read<ChiefsListCubit>()
                              .selectedPositionsList
                              .length +
                              1),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          context
                              .read<ChiefsListCubit>()
                              .updateStaff(widget.positionStaff);
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: const Text('работник изменен')));
                        });
                      },
                      child: const Text('редактировать'),
                    ))
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
