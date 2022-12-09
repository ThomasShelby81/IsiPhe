import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isiphe/business/bloc/food_details_bloc/bloc/food_details_bloc.dart';
import 'package:scan/scan.dart';

class FoodEditDetailsBarCodeDetector extends StatefulWidget {
  const FoodEditDetailsBarCodeDetector({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FoodEditDetailsBarCodeDetectorState();
  }
}

class _FoodEditDetailsBarCodeDetectorState
    extends State<FoodEditDetailsBarCodeDetector> {
  late ScanController _scanController;

  late FoodDetailsBloc _foodDetailsBloc;

  late TextEditingController _foodbarcodeTextController;

  @override
  void initState() {
    super.initState();

    _foodDetailsBloc = BlocProvider.of<FoodDetailsBloc>(context);
    _foodbarcodeTextController = TextEditingController();
    _foodbarcodeTextController.addListener(_barcodeTextControllerChanged);
    if (_foodDetailsBloc.state.barcode.isNotEmpty) {
      _foodbarcodeTextController.text = _foodDetailsBloc.state.barcode;
    }
    _scanController = ScanController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodDetailsBloc, FoodDetailsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(CupertinoIcons.barcode_viewfinder),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<FoodDetailsBloc, FoodDetailsState>(
                            builder: (context, state) {
                              if (state.barcode.isNotEmpty) {
                                return Text('Barcode: ${state.barcode}');
                              }
                              return const Text('Verküpfung mit Barcode');
                            },
                          ),
                          Text(
                            'Für eine schnelle Erfassung mittels Scanner',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 13),
                          ),
                          if (kDebugMode)
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Form(
                                  child: Column(
                                children: [
                                  SizedBox(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: TextFormField(
                                        controller: _foodbarcodeTextController,
                                        decoration: const InputDecoration(
                                            labelText: 'Barcode'),
                                        keyboardType: TextInputType.number,
                                        autovalidateMode:
                                            AutovalidateMode.disabled,
                                        autocorrect: false,
                                      ))
                                ],
                              )),
                            )
                        ],
                      )
                    ],
                  ),
                  onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      isDismissible: true,
                      elevation: 10,
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      builder: (c) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Scaffold(
                            appBar: _buildBarcodeScannerAppBar(),
                            body: _buildBarcodeScannerBody(),
                          ),
                        );
                      })),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildBarcodeScannerAppBar() {
    return AppBar(
      bottom: PreferredSize(
        child: Container(
          color: Colors.purpleAccent,
          height: 4,
        ),
        preferredSize: const Size.fromHeight(4),
      ),
      title: const Text('Scanne den Barcode'),
      elevation: 0.0,
      backgroundColor: const Color(0xFF333333),
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Center(
          child: Icon(
            Icons.cancel,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => _scanController.toggleTorchMode(),
            child: const Icon(Icons.flashlight_on),
          ),
        )
      ],
    );
  }

  Widget _buildBarcodeScannerBody() {
    return SizedBox(
      height: 400,
      child: ScanView(
        controller: _scanController,
        scanAreaScale: .7,
        scanLineColor: Colors.greenAccent,
        onCapture: (data) {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _barcodeTextControllerChanged() {
    _foodDetailsBloc
        .add(FoodDetailsBarcodeScanned(_foodbarcodeTextController.text));
  }
}
