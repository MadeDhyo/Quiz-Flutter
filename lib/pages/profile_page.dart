import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Required for File

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notif = true;
  String _goal = "Weight Loss";
  
  // Logic to store the picked image
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)), 
        backgroundColor: Colors.black
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // PROFILE PIC SECTION
            GestureDetector(
              onTap: _pickImage, // Tap the circle to change photo
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    // If _imageFile is null, show icon. Otherwise, show the photo.
                    backgroundImage: NetworkImage('https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/1175ec97-918e-45b4-a8f3-5ef39c8ba18c/dh1i1yi-8325a9c4-5b79-4a1d-b5a6-cbd093d03525.png/v1/fill/w_400,h_400,q_80,strp/muslim_guts_ramadan_pfp_by_didromon_dh1i1yi-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NDAwIiwicGF0aCI6Ii9mLzExNzVlYzk3LTkxOGUtNDViNC1hOGYzLTVlZjM5YzhiYTE4Yy9kaDFpMXlpLTgzMjVhOWM0LTViNzktNGExZC1iNWE2LWNiZDA5M2QwMzUyNS5wbmciLCJ3aWR0aCI6Ijw9NDAwIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.-HPCh2Al0rbclJoN8sOwHOK2WO5uDUo4el6HqO2mRZw'),
                    child: _imageFile == null 
                        ? const Icon(Icons.person, size: 60, color: Colors.blue) 
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                      child: const Icon(Icons.edit, size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 15),
            const Text("Made Dhyo", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("NIM: 32789112", style: TextStyle(color: Colors.blueGrey)),
            
            const SizedBox(height: 30),
            const Align(alignment: Alignment.centerLeft, child: Text("Achievements", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 15),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                _badge("🔥 7 Day Streak", Colors.orange),
                _badge("💧 Water Master", Colors.blue),
                _badge("🏆 BMI Pro", Colors.purple),
              ]),
            ),
            
            const Divider(height: 40, color: Colors.white10),
            
            const Align(alignment: Alignment.centerLeft, child: Text("Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            CheckboxListTile(
              title: const Text('Enable Notifications'), 
              secondary: const Icon(Icons.notifications_none, color: Colors.blue),
              value: _notif, 
              onChanged: (v) => setState(() => _notif = v!)
            ),
            
            const SizedBox(height: 20),
            const Align(alignment: Alignment.centerLeft, child: Text("Fitness Goal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            RadioListTile(title: const Text('Weight Loss'), value: 'Weight Loss', groupValue: _goal, onChanged: (v) => setState(() => _goal = v!), activeColor: Colors.blue),
            RadioListTile(title: const Text('Muscle Gain'), value: 'Muscle Gain', groupValue: _goal, onChanged: (v) => setState(() => _goal = v!), activeColor: Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _badge(String t, Color c) => Container(
    margin: const EdgeInsets.only(right: 10),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: c.withOpacity(0.3))),
    child: Text(t, style: TextStyle(color: c, fontWeight: FontWeight.bold)),
  );
}