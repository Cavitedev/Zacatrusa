import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zacatrusa/settings/material_color_data.dart';

import '../../../settings/settings_controller.dart';
import 'color_radio_button_setting_dialog.dart';
import 'radio_button_setting_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajustes"),
      ),
      body: ListView(
        children: [
          RadioButtonSettingDialog<String>(
              name: "Familia de Letra",
              dialogTitle: "Elija tipo de letra",
              provider: settingsFontFamilyControllerProvider,
              messageValues: const {
                "Roboto": "Roboto",
                "Open Sans": "Open Sans",
                "Oswald": "Oswald",
              },
              onChanged: (value) {
                ref.read(settingsControllerProvider).updateFontfamily(value);
              }),
          const Divider(),
          RadioButtonSettingDialog<double?>(
              name: "Tamaño de Letra",
              dialogTitle: "Elija el tamaño de letra",
              provider: settingsFontSizeControllerProvider,
              messageValues: {
                null: "Por Defecto",
                0.8: "XXS",
                0.9: "XS",
                1: "S",
                1.1: "M",
                1.2: "L",
                1.4: "XL",
              },
              onChanged: (value) {
                ref.read(settingsControllerProvider).updateFontSize(value);
              }),
          const Divider(),
          ColorRadioButtonSettingDialog<int>(
              name: "Color primario",
              dialogTitle: "Elija un color primario",
              provider: settingsPrimaryColorIndexControllerProvider,
              messageValues: colorsValues(),
              onChanged: (value) {
                ref
                    .read(settingsControllerProvider)
                    .updatePrimaryColorIndex(value);
              }),
        ],
      ),
    );
  }

  Map<int, MaterialColorData> colorsValues() {
    return Map.fromEntries(
        Iterable<int>.generate(Colors.primaries.length).map((index) {
      MaterialColorData colorData = MaterialColorData.fromIndex(index);
      return MapEntry(index, colorData);
    }));
  }
}
