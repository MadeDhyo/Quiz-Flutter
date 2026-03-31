import 'package:flutter/material.dart';
import 'active_workout_page.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout'), backgroundColor: Colors.black),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("QUICK START", style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            // "Start an Empty Workout" Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ActiveWorkoutPage())),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                child: const Text('START AN EMPTY WORKOUT', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            
            const SizedBox(height: 30),
            const Text("MY TEMPLATES", style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            _buildTemplateCard("Pull (Lat Focused + Bicep)", "Lat Pulldown, Seated Row, Hammer Curls..."),
            _buildTemplateCard("Push (Chest + Tricep)", "Bench Press, Incline Press, Chest Fly..."),
            _buildTemplateCard("Legs (Quad Focused)", "Squat, Leg Extension, Calf Raise..."),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard(String title, String exercises) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: Colors.white.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.white12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(exercises, style: const TextStyle(color: Colors.blueGrey, fontSize: 12)),
        trailing: const Icon(Icons.more_vert),
      ),
    );
  }
}