import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:async'; // Required for the Timer

class ActiveWorkoutPage extends StatefulWidget {
  const ActiveWorkoutPage({super.key});

  @override
  State<ActiveWorkoutPage> createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage> {
  late ConfettiController _confettiController;
  
  // Timer Logic
  Timer? _timer;
  int _seconds = 0;
  
  // Workout Data (Simulating the table in your image)
  final List<Map<String, dynamic>> _deadliftSets = [
    {"set": 1, "prev": "60 kg x 5", "kg": "60", "reps": "5", "done": true},
    {"set": 2, "prev": "100 kg x 3", "kg": "100", "reps": "3", "done": true},
    {"set": 3, "prev": "120 kg x 1", "kg": "120", "reps": "1", "done": false},
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  void _finishWorkout() {
    _timer?.cancel();
    _confettiController.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Center(child: Text("FINISH! 🏆", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
        content: Text("Total Time: ${_formatTime(_seconds)}\nGreat work today!", textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Done", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: _finishWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Finish", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text("Morning Workout", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text(_formatTime(_seconds), style: const TextStyle(color: Colors.blueGrey, fontSize: 18)),
              const SizedBox(height: 10),
              const Text("Notes", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              // Exercise Header: Deadlift
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Deadlift", style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz, color: Colors.grey)),
                ],
              ),

              // Pro Tip Note (Yellow highlight from image)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(color: Colors.yellow.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.yellow, size: 18),
                    SizedBox(width: 8),
                    Text("Watch back rounding", style: TextStyle(color: Colors.yellow, fontSize: 13)),
                  ],
                ),
              ),

              // The Sets Table
              _buildSetTableHeader(),
              ..._deadliftSets.map((set) => _buildSetRow(set)).toList(),

              const SizedBox(height: 20),
              
              // Action Buttons
              _buildBottomButton("+ Add Set", Colors.white10, Colors.white),
              const SizedBox(height: 10),
              _buildBottomButton("Add Exercises", Colors.blue.withOpacity(0.1), Colors.blue),
              const SizedBox(height: 10),
              _buildBottomButton("Cancel Workout", Colors.red.withOpacity(0.05), Colors.redAccent),
            ],
          ),
          
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.blue, Colors.white, Colors.cyan],
          ),
        ],
      ),
    );
  }

  Widget _buildSetTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text("Set", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12))),
          Expanded(flex: 2, child: Text("Previous", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12))),
          Expanded(flex: 2, child: Text("kg", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12))),
          Expanded(flex: 2, child: Text("Reps", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12))),
          Expanded(flex: 1, child: Icon(Icons.check, size: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSetRow(Map<String, dynamic> data) {
    bool isDone = data['done'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isDone ? Colors.blue.withOpacity(0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text("${data['set']}", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text("${data['prev']}", textAlign: TextAlign.center, style: const TextStyle(color: Colors.blueGrey, fontSize: 13))),
          Expanded(flex: 2, child: _smallTextField(data['kg'])),
          Expanded(flex: 2, child: _smallTextField(data['reps'])),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () => setState(() => data['done'] = !data['done']),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDone ? Colors.blue : Colors.white10,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(Icons.check, size: 18, color: isDone ? Colors.white : Colors.blueGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallTextField(String initialValue) {
    return Container(
      height: 35,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: initialValue,
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildBottomButton(String text, Color bgColor, Color textColor) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(backgroundColor: bgColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
    );
  }
}