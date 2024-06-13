import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddPageUserPhotoWidget(
                      imageUrl: context
                          .read<ChiefStaffCubit>()
                          .loadedProfileImage
                          ?.path,
                      downloadImageFromGallery: () => context
                          .read<ChiefStaffCubit>()
                          .addPhotoFromGallery(imageSource: ImageSource.gallery)
                          .then((_) => setState(() {})),
                      fetchImageFromCamera: () => context
                          .read<ChiefStaffCubit>()
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
                      controller: context.read<ChiefStaffCubit>().fioController,
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
                                      .read<ChiefStaffCubit>()
                                      .selectedPositionsList
                                      .length
                              ? IconButton(
                                  onPressed: () {
                                    context
                                                .read<ChiefStaffCubit>()
                                                .positionsToSelectList
                                                .length ==
                                            1
                                        ? setState(() {
                                            context
                                                .read<ChiefStaffCubit>()
                                                .addLastPositionElement();
                                          })
                                        : showDialog(
                                            context: context,
                                            builder: (ctx) => SimpleDialog(
                                                  title: Text(
                                                      'выберите должность'),
                                                  children: List.generate(
                                                      context
                                                          .read<
                                                              ChiefStaffCubit>()
                                                          .positionsToSelectList
                                                          .length,
                                                      (index) =>
                                                          SimpleDialogOption(
                                                            onPressed: () =>
                                                                setState(() {
                                                              context
                                                                  .read<
                                                                      ChiefStaffCubit>()
                                                                  .addPositionElement(
                                                                      index);
                                                              Navigator.pop(
                                                                  ctx);
                                                            }),
                                                            child: Text(context
                                                                .read<
                                                                    ChiefStaffCubit>()
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
                                                .read<ChiefStaffCubit>()
                                                .selectedPositionsList[index],
                                            textAlign: TextAlign.center,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                               setState(() {
                                                 context
                                                     .read<ChiefStaffCubit>()
                                                     .deletePositionElement(
                                                     index,
                                                     context
                                                         .read<
                                                         ChiefStaffCubit>()
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
                                    DropdownButton<String>(
                                      isExpanded: true,
                                      value: context
                                          .read<ChiefStaffCubit>()
                                          .areasForPositionsList[index],
                                      onChanged: (String? value) =>
                                          setState(() {
                                        context
                                            .read<ChiefStaffCubit>()
                                            .changeAreasDropDownValue(
                                                index, value);
                                      }),
                                      items: state.areasNamesList
                                          .map(
                                              (String area) => DropdownMenuItem(
                                                    value: area,
                                                    child: Text(area),
                                                  ))
                                          .toList(),
                                    ),
                                  ],
                                ),
                          separatorBuilder: (ctx, i) => SizedBox(
                                height: 5,
                              ),
                          itemCount: context
                                  .read<ChiefStaffCubit>()
                                  .selectedPositionsList
                                  .length +
                              1),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    // const Text(
                    //   'Участок',
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          context.read<ChiefStaffCubit>().insertStaff();
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: const Text('работник добавлен')));
                        });
                      },
                      child: const Text('добавить'),
                    ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
