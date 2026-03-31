import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _hCtrl = TextEditingController();
  final TextEditingController _wCtrl = TextEditingController();
  final TextEditingController _ageCtrl = TextEditingController();
  double _bmi = 0;
  String _status = "";
  Color _color = Colors.blue;
  bool _isMetric = true;
  String _range = "";

  void _calculate() {
    HapticFeedback.mediumImpact();
    double h = double.tryParse(_hCtrl.text) ?? 0;
    double w = double.tryParse(_wCtrl.text) ?? 0;
    if (h > 0 && w > 0) {
      setState(() {
        if (_isMetric) {
          _bmi = w / ((h / 100) * (h / 100));
          _range = "${(18.5 * (h / 100) * (h / 100)).toStringAsFixed(1)}kg - ${(24.9 * (h / 100) * (h / 100)).toStringAsFixed(1)}kg";
        } else {
          _bmi = (w / (h * h)) * 703;
          _range = "${(18.5 * h * h / 703).toStringAsFixed(1)}lbs - ${(24.9 * h * h / 703).toStringAsFixed(1)}lbs";
        }
        if (_bmi < 18.5) { _status = "Underweight"; _color = Colors.cyan; }
        else if (_bmi < 25) { _status = "Healthy"; _color = Colors.blue; }
        else if (_bmi < 30) { _status = "Overweight"; _color = Colors.orange; }
        else { _status = "Obese"; _color = Colors.red; }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Body Analysis'), backgroundColor: Colors.black),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          SwitchListTile(title: const Text('Use Metric Units'), value: _isMetric, onChanged: (v) => setState(() => _isMetric = v), activeColor: Colors.blue),
          const SizedBox(height: 15),
          _field('Age', _ageCtrl, Icons.calendar_today),
          const SizedBox(height: 15),
          _field(_isMetric ? 'Height (cm)' : 'Height (in)', _hCtrl, Icons.height),
          const SizedBox(height: 15),
          _field(_isMetric ? 'Weight (kg)' : 'Weight (lb)', _wCtrl, Icons.monitor_weight),
          const SizedBox(height: 30),
          SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: _calculate, style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text('Calculate'))),
          if (_bmi > 0) _buildGauge(),
        ]),
      ),
    );
  }

  Widget _field(String l, TextEditingController c, IconData i) => TextField(controller: c, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l, prefixIcon: Icon(i, color: Colors.blue), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)), filled: true, fillColor: Colors.white.withOpacity(0.05)));

  Widget _buildGauge() => Column(children: [
    const SizedBox(height: 30),
    SizedBox(height: 200, child: SfRadialGauge(axes: [RadialAxis(
      minimum: 10, maximum: 40, showLabels: false, showTicks: false,
      axisLineStyle: const AxisLineStyle(thickness: 0.2, color: Color(0xFF1A1A1A)),
      ranges: [GaugeRange(startValue: 10, endValue: 18.5, color: Colors.cyan), GaugeRange(startValue: 18.5, endValue: 24.9, color: Colors.blue), GaugeRange(startValue: 25, endValue: 29.9, color: Colors.orange), GaugeRange(startValue: 30, endValue: 40, color: Colors.red)],
      pointers: [NeedlePointer(value: _bmi, enableAnimation: true, needleColor: Colors.white, knobStyle: const KnobStyle(color: Colors.white))],
      annotations: [GaugeAnnotation(widget: Text(_bmi.toStringAsFixed(1), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)), angle: 90, positionFactor: 0.5)],
    )])),
    Text(_status, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _color)),
    Text("Healthy Range: $_range", style: const TextStyle(color: Colors.blueGrey)),
  ]);
}