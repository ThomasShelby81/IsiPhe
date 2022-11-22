import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isiphe/ui/screens/food/edit_food_details_screen.dart';
import 'package:scan/scan.dart';

import '../../../business/utils/custom_max_value_input_formatter.dart';

class EditFoodNutritionInfosScreen extends StatefulWidget {
  const EditFoodNutritionInfosScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditFootScreen();
  }
}

class _EditFootScreen extends State {
  late TextEditingController _textEditingController;
  final ScanController _scanController = ScanController();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        title: const Text('Neues Lebensmittel'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditFoodDetailsScreen())),
              child:
                  const Text('Weiter', style: TextStyle(color: Colors.black)),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                  child: Row(
                    children: const [
                      Icon(CupertinoIcons.barcode_viewfinder),
                      Text('Verküpfung mit Barcode')
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
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('Schritt 1: Nährwerte'),
            ),
            Container(
                child: Row(children: [
                  const Text('Protein'),
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      maxLength: 5,
                      minLines: 1,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 50),
                      decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: 20),
                          border: UnderlineInputBorder(),
                          hintText: 'Pflicht',
                          hintStyle: TextStyle(fontSize: 14)),
                      inputFormatters: [CustomMaxValueInputFormatter(2, 1)],
                    ),
                  )
                ]),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid),
                )),
          ],
        ),
      ),
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
          print(data);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
