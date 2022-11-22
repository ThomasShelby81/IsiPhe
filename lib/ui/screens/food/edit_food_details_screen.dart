import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:scan/scan.dart';

import '../../../business/utils/custom_max_value_input_formatter.dart';
import '../../routes/widgets/dots_indicator.dart';

class EditFoodDetailsScreen extends StatefulWidget {
  const EditFoodDetailsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditFoodDetailsScreenState();
  }
}

class _EditFoodDetailsScreenState extends State {
  static const _kDuration = Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final List<Widget> _pages = <Widget>[
    const EditFoodNutritionInfosWidget(),
    const EditFoodDetailsWidget()
  ];

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
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
              onTap: () => Navigator.of(context).pop(),
              child: const Text('Speichern',
                  style: TextStyle(color: Colors.black)),
            ),
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(children: [
            PageView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _pageController,
                children: _pages),
            Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  color: Colors.grey[800]?.withOpacity(0.5),
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: DotsIndicator(
                    _pageController,
                    _pages.length,
                    (value) {
                      _pageController.animateToPage(value,
                          duration: _kDuration, curve: _kCurve);
                    },
                  )),
                ))
          ])),
    );
  }
}

class EditFoodNutritionInfosWidget extends StatefulWidget {
  const EditFoodNutritionInfosWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditFoodDetailsWidget();
  }
}

class _EditFoodDetailsWidget extends State {
  late TextEditingController _textEditingController;

  final ScanController _scanController = ScanController();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  color: Colors.black, width: 1.0, style: BorderStyle.solid),
            )),
      ],
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

class EditFoodDetailsWidget extends StatefulWidget {
  const EditFoodDetailsWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditFoodDetailsWidgetState();
  }
}

class _EditFoodDetailsWidgetState extends State {
  late TextEditingController _textEditingControllerFoodName;
  late TextEditingController _textEditingControllerVendor;

  late TextEditingController _popupDialogTextController;

  late String? grammPerServiergroesse;

  @override
  void initState() {
    super.initState();

    _textEditingControllerFoodName = TextEditingController();
    _textEditingControllerVendor = TextEditingController();
    _popupDialogTextController = TextEditingController();

    grammPerServiergroesse = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text('Schritt 2: Lebensmittel-Details'),
        ),
        Container(
            child: Row(children: [
              const Text('Protein'),
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: _textEditingControllerFoodName,
                      maxLength: 20,
                      minLines: 1,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 50),
                      decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: 20),
                          border: UnderlineInputBorder(),
                          hintText: 'Name Lebensmittel (Pflicht)',
                          hintStyle: TextStyle(fontSize: 14)),
                    ),
                    TextField(
                      controller: _textEditingControllerVendor,
                      maxLength: 20,
                      minLines: 1,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 50),
                      decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: 20),
                          border: UnderlineInputBorder(),
                          hintText: 'Hersteller',
                          hintStyle: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              )
            ]),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: Colors.black, width: 1.0, style: BorderStyle.solid),
            )),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text('Schritt 3: Serviergrößen'),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: Colors.black, width: 1.0, style: BorderStyle.solid),
          ),
          child: SizedBox(
            height: 300,
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                _buildOption('Millilitter', false),
                _buildOption('Gramm', false),
                _buildOption('Stück', true),
                _buildOption('Scheibe', true)
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildOption(String label, bool grammAbfrage) {
    Text textServiergroesse = const Text(
      '(... Gramm)',
      style: TextStyle(fontSize: 10),
    );

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        child: Center(
            child: Column(
          children: [
            Text(label),
            Text(' $grammPerServiergroesse Gramm',
                style: const TextStyle(fontSize: 10)),
          ],
        )),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: Colors.black, width: 1.0, style: BorderStyle.solid),
        ),
      ),
      onTap: () async {
        var value = await openDialog(label);
        setState(() {
          grammPerServiergroesse = value;
        });
      },
    );
  }

  Future<String?> openDialog(
    String labelServiergroesse,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Bitte erfasse die Gramm pro $labelServiergroesse'),
            content: TextField(
              decoration:
                  InputDecoration(hintText: 'Gramm pro $labelServiergroesse'),
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.right,
              inputFormatters: [CustomMaxValueInputFormatter(2, 1)],
              controller: _popupDialogTextController,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(_popupDialogTextController.text);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }
}
