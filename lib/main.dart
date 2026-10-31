import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Dashboard()));

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final rooms = ['Daily Intercession Altar', 'Worship & Grace Stream', 'Spiritual Warfare Watch'];
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        title: const Text('Active Altars', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF111827),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rooms.length,
        itemBuilder: (context, idx) => Card(
          color: const Color(0xFF1F2937),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            title: Text(rooms[idx], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
            subtitle: const Text('Live Audio Stream Active', style: TextStyle(color: Colors.grey, fontSize: 13)),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber, 
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => PrayerRoom(title: rooms[idx]))),
              child: const Text('Join', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}

class PrayerRoom extends StatefulWidget {
  final String title;
  const PrayerRoom({super.key, required this.title});
  @override
  State<PrayerRoom> createState() => _PrayerRoomState();
}

class _PrayerRoomState extends State<PrayerRoom> {
  double _vol = 0.5;
  bool _mute = false;
  int _amens = 20;
  int _seconds = 3600; 
  Timer? _timer;
  
  final List<String> _chat = [
    'Pastor G: Amen! Agreeing in spirit.',
    'Sister E: Let your glory fill this room.'
  ];
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        _timer?.cancel();
        if (mounted) {
          Navigator.pop(context); 
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prayer session has ended. Everyone logged out.', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.amber,
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String time = "${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}";
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [Center(child: Padding(padding: const EdgeInsets.only(right: 16), child: Text(time, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16))))],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1F2937),
            child: Column(
              children: [
                const Icon(Icons.graphic_eq, size: 40, color: Colors.amber),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.withOpacity(0.15), foregroundColor: Colors.amber, side: const BorderSide(color: Colors.amber, width: 1)),
                  onPressed: () => setState(() => _amens++),
                  icon: const Icon(Icons.front_hand, size: 16),
                  label: Text('Amen Agreement ($_amens)', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.music_note, color: Colors.amber),
                Expanded(child: Slider(value: _vol, activeColor: Colors.amber, onChanged: (v) => setState(() => _vol = v))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _chat.length,
              itemBuilder: (context, idx) => Card(
                color: const Color(0xFF1F2937),
                child: Padding(padding: const EdgeInsets.all(12), child: Text(_chat[idx], style: const TextStyle(color: Colors.white, fontSize: 14))),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF111827),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_mute ? Icons.mic_off : Icons.mic, color: _mute ? Colors.red : Colors.green),
                  onPressed: () => setState(() => _mute = !_mute),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white), 
                    decoration: const InputDecoration(hintText: 'Type an Amen...', hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.amber),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        _chat.add('Me: ${_controller.text}');
                        _controller.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
