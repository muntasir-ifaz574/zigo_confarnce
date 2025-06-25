import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zigo_app/src/views/ui/video_conference_screen.dart';

import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _conferenceIDController = TextEditingController();
  bool _showJoinField = false;

  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  String _generateConferenceID() {
    return (100000 + Random().nextInt(900000)).toString();
  }

  Future<void> _fetchProfile() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    print("User ${user}");
    if (user == null) return;

    try {
      final response = await supabase
          .from('profiles')
          .select('name, phone,gender')
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        print('No profile found for user ${user.id}');
        setState(() {
          _profileData = {
            'name': 'No name',
            'phone': 'No phone',
            'gender': 'No gender',
          };
        });
        return;
      }

      setState(() {
        _profileData = Map<String, dynamic>.from(response);
      });
    } catch (e) {
      print('Failed to fetch profile: $e');
    }
  }



  void _startMeeting() {
    final conferenceID = _generateConferenceID();
    final userName = _profileData?['name'] ?? 'User_$userId';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Meeting Started'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Conference ID: $conferenceID'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await Share.share(
                    'Join my Zigo meeting with Conference ID: $conferenceID',
                    subject: 'Zigo Meeting Invite',
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Conference ID shared successfully!')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error sharing ID: $e')),
                    );
                  }
                }
              },
              icon: const Icon(Icons.share),
              label: const Text('Share ID'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kThemeColor,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: conferenceID));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Conference ID copied to clipboard!')),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy ID'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoConferenceScreen(conferenceID: conferenceID,userName: userName,),
                ),
              );
            },
            child: const Text('Continue to Meeting'),
          ),
        ],
      ),
    );
  }

  void _joinMeeting() {
    final conferenceID = _conferenceIDController.text.trim();
    final userName = _profileData?['name'] ?? 'User_$userId';
    if (conferenceID.isEmpty || conferenceID.length != 6 || !RegExp(r'^\d+$').hasMatch(conferenceID)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit Conference ID')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoConferenceScreen(conferenceID: conferenceID,userName: userName,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: const Text('Zigo Meeting'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: _startMeeting,
                icon: const Icon(Icons.video_call),
                label: const Text('Start a Meeting'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kThemeColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _showJoinField = !_showJoinField;
                  });
                },
                icon: const Icon(Icons.meeting_room),
                label: const Text('Join a Meeting'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              if (_showJoinField) ...[
                const SizedBox(height: 20),
                TextField(
                  controller: _conferenceIDController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'Enter 6-digit Conference ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _joinMeeting,
                  child: const Text('Join Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kThemeColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final name = _profileData?['name'] ?? 'No Name';
    final phone = _profileData?['phone'] ?? 'No Phone';
    final gender = _profileData?['gender'] ?? 'No Gender';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(phone),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 40),
              ),
            ),
            decoration: const BoxDecoration(color: Colors.blue),
            otherAccountsPictures: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  gender,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              _showProfileDialog(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await Supabase.instance.client.auth.signOut();
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
          ),

        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Profile Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${_profileData?['name'] ?? 'N/A'}'),
            Text('Email: ${_profileData?['email'] ?? 'N/A'}'),
            Text('Phone: ${_profileData?['phone'] ?? 'N/A'}'),
            Text('Gender: ${_profileData?['gender'] ?? 'N/A'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

}
