import 'package:flutter/material.dart';

class EditPageUserPhotoWidget extends StatefulWidget {
  const EditPageUserPhotoWidget(
      {required this.downloadImageFromGallery,
      required this.fetchImageFromCamera,
      this.imageUrl,
      super.key});

  final VoidCallback downloadImageFromGallery;
  final VoidCallback fetchImageFromCamera;
  final String? imageUrl;

  @override
  State<EditPageUserPhotoWidget> createState() =>
      _EditPageUserPhotoWidgetState();
}

class _EditPageUserPhotoWidgetState extends State<EditPageUserPhotoWidget> {



  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                    contentPadding: EdgeInsets.all(5),
                    children: [
                      SimpleDialogOption(
                        onPressed: () {
                          widget.downloadImageFromGallery();
                          Navigator.pop(context, false);
                        },
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.insert_photo_outlined),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'галлерея',
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          widget.fetchImageFromCamera();
                          Navigator.pop(context, false);
                        },
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined),
                            SizedBox(
                              width: 5,
                            ),
                            Text('камера', style: TextStyle(fontSize: 18))
                          ],
                        ),
                      )
                    ],
                  ));

        },
        child: Container(
            clipBehavior: Clip.antiAlias,
            width: 150,
            height: 150,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: widget.imageUrl == null
                ? Container(
                    child: Icon(Icons.download,
                        size: 50, color: Colors.grey.shade500),
                    color: Colors.grey.shade200,
                  )
                : Image.network(
                    Uri.parse(widget.imageUrl!).replace(queryParameters: {
                      't': DateTime.now().millisecondsSinceEpoch.toString()
                    }).toString(),
                    fit: BoxFit.cover,
                  )),
      ),
    );
  }
}
