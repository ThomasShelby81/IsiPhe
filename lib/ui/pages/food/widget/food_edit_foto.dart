import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../business/bloc/food_details_bloc/bloc/food_details_bloc.dart';

class FoodEditFoto extends StatefulWidget {
  const FoodEditFoto({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FoodEditFotoState();
  }
}

class _FoodEditFotoState extends State<FoodEditFoto> {
  late ImagePicker _picker;

  late FoodDetailsBloc _foodDetailsBloc;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();

    _foodDetailsBloc = BlocProvider.of<FoodDetailsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodDetailsBloc, FoodDetailsState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.4,
              margin: const EdgeInsets.only(top: 10),
              child: _previewImages(state.imageFile, state.pickImageError),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  child: const Text('Kamera'),
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.camera);
                  },
                ),
                ElevatedButton(
                  child: const Text('Gallerie'),
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.gallery);
                  },
                )
              ],
            )
          ],
        ),
      );
    });
  }

  Widget _previewImages(XFile? imageFile, dynamic pickImageError) {
    final Text? retrieveError = _getRetrieveErrorWidget(pickImageError);
    if (retrieveError != null) {
      return retrieveError;
    }
    if (imageFile != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: Semantics(
          label: 'image_picker_example_picked_image',
          child: Image.file(File(imageFile.path)),
        ),
      );
    } else if (pickImageError != null) {
      return Text(
        'Pick image error: $pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'Kein Bild ausgewählt',
        textAlign: TextAlign.center,
      );
    }
  }

  Text? _getRetrieveErrorWidget(dynamic pickImageError) {
    if (pickImageError != null) {
      final Text result = Text(pickImageError!);
      pickImageError = null;
      return result;
    }
    return null;
  }

  Future<void> _onImageButtonPressed(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
          source: source, maxHeight: 1024, maxWidth: 768);
      if (pickedFile != null) {
        _foodDetailsBloc.add(FoodDetailsFotoTaken(pickedFile));
      }
    } catch (e) {
      _foodDetailsBloc.add(FoodDetailsPickFotoFailed(e));
    }
  }
}
