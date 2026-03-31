import 'package:flutter/material.dart';
import '../service/api_service.dart';

class ApiDataPage extends StatefulWidget {
  const ApiDataPage({super.key});

  @override
  State<ApiDataPage> createState() => _ApiDataPageState();
}

class _ApiDataPageState extends State<ApiDataPage> {
  final ApiService _apiService = ApiService();
  
  List<dynamic> _allBuddies = [];
  List<dynamic> _filteredBuddies = [];
  bool _isLoading = true; // Track loading state manually
  
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  // Fetch data ONCE at the start
  Future<void> _fetchInitialData() async {
    try {
      final data = await _apiService.fetchWorkoutBuddies();
      setState(() {
        _allBuddies = data;
        _filteredBuddies = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load buddies: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Workout Buddies', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBuddyDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),

      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for a partner...',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _filteredBuddies = _allBuddies
                      .where((buddy) => buddy['name']
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: Colors.blue))
              : _filteredBuddies.isEmpty 
                  ? const Center(child: Text("No buddies found.", style: TextStyle(color: Colors.blueGrey)))
                  : ListView.builder(
                      itemCount: _filteredBuddies.length,
                      itemBuilder: (context, index) {
                        final buddy = _filteredBuddies[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          color: Colors.white.withOpacity(0.03),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Colors.blue.withOpacity(0.1)),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.withOpacity(0.2),
                              child: Text(
                                buddy['name'][0].toUpperCase(), 
                                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)
                              ),
                            ),
                            title: Text(
                              buddy['name'], 
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                            ),
                            subtitle: Text(
                              '📍 ${buddy['address']?['city'] ?? 'Unknown City'}',
                              style: const TextStyle(color: Colors.blueGrey),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () {
                                setState(() {
                                  // Remove from both lists to keep them in sync
                                  _allBuddies.removeWhere((item) => item['id'] == buddy['id']);
                                  _filteredBuddies = List.from(_allBuddies);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  void _showAddBuddyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Add Workout Buddy', style: TextStyle(color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController, 
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.blue)),
            ),
            TextField(
              controller: _cityController, 
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'City', labelStyle: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.blueGrey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                setState(() {
                  final newBuddy = {
                    "id": DateTime.now().millisecondsSinceEpoch,
                    "name": _nameController.text,
                    "address": {"city": _cityController.text},
                  };
                  _allBuddies.insert(0, newBuddy);
                  _filteredBuddies = List.from(_allBuddies);
                });
                _nameController.clear();
                _cityController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}