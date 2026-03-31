import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _waterGlasses = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daily Progress", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)
            ),
            const SizedBox(height: 10),

            // Visual: Progress Ring with restored vibrant blue
            Center(
              child: SizedBox(
                height: 240,
                child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      showLabels: false, 
                      showTicks: false, 
                      startAngle: 270, 
                      endAngle: 270,
                      axisLineStyle: const AxisLineStyle(
                        thickness: 0.15,
                        cornerStyle: CornerStyle.bothCurve,
                        color: Color(0xFF222222), // Slightly lighter grey so the track is visible
                        thicknessUnit: GaugeSizeUnit.factor,
                      ),
                      pointers: const <GaugePointer>[
                        RangePointer(
                          value: 75, 
                          width: 0.15, 
                          cornerStyle: CornerStyle.bothCurve, 
                          color: Colors.blue, // Vibrant Blue restored
                          sizeUnit: GaugeSizeUnit.factor,
                        ),
                      ],
                      annotations: const [
                        GaugeAnnotation(
                          widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '75%', 
                                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)
                              ),
                              Text(
                                'Daily Goal', 
                                style: TextStyle(fontSize: 14, color: Colors.blueGrey)
                              ),
                            ],
                          ),
                          angle: 90, positionFactor: 0.1,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "Quick Trackers", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
            ),
            const SizedBox(height: 15),
            
            // Re-adding the vibrant tracker cards
            _buildCard(
              "Water Intake", 
              "$_waterGlasses / 8 Glasses", 
              Icons.local_drink, 
              Colors.blue, 
              () => setState(() => _waterGlasses++)
            ),
            
            const SizedBox(height: 12),
            
            _buildCard(
              "Daily Steps", 
              "8,432 Steps", 
              Icons.directions_run, 
              Colors.cyan, 
              () {}
            ),
            
            const SizedBox(height: 12),
            
            _buildCard(
              "Calories Burned", 
              "450 kcal", 
              Icons.fireplace_rounded, 
              Colors.orangeAccent, 
              () {}
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String sub, IconData icon, Color col, VoidCallback tap) {
    return Card(
      elevation: 0,
      color: col.withOpacity(0.1), // Increased opacity to make the color visible
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), 
        side: BorderSide(color: col.withOpacity(0.3), width: 1.5) // Thicker, more colorful border
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: col.withOpacity(0.2),
            shape: BoxShape.circle
          ),
          child: Icon(icon, color: col, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(sub, style: const TextStyle(color: Colors.blueGrey)),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle, size: 32), 
          color: col, 
          onPressed: tap
        ),
      ),
    );
  }
}