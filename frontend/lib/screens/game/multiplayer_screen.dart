import 'package:flutter/material.dart';

class MultiplayerScreen extends StatefulWidget {
  const MultiplayerScreen({Key? key}) : super(key: key);

  @override
  State<MultiplayerScreen> createState() => _MultiplayerScreenState();
}

class _MultiplayerScreenState extends State<MultiplayerScreen> {
  final List<Map<String, dynamic>> _rooms = [
    {'name': 'Fun Room', 'players': '3/6', 'isPrivate': false},
    {'name': 'Pro Players', 'players': '4/8', 'isPrivate': false},
    {'name': 'Beginners', 'players': '2/4', 'isPrivate': false},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Multiplayer'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Join Room'),
              Tab(text: 'Create Room'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRoomList(),
            _buildCreateRoom(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Implement room refresh
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget _buildRoomList() {
    return ListView.builder(
      itemCount: _rooms.length,
      itemBuilder: (context, index) {
        final room = _rooms[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(
              room['isPrivate'] ? Icons.lock : Icons.public,
            ),
            title: Text(room['name']),
            subtitle: Text('Players: ${room['players']}'),
            trailing: ElevatedButton(
              onPressed: () {
                // TODO: Implement join room
              },
              child: const Text('Join'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreateRoom() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Room Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Max Players',
              border: OutlineInputBorder(),
            ),
            items: [2, 4, 6, 8]
                .map((n) => DropdownMenuItem(
                      value: n,
                      child: Text('$n players'),
                    ))
                .toList(),
            onChanged: (value) {
              // TODO: Handle player count change
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement create room
            },
            child: const Text('Create Room'),
          ),
        ],
      ),
    );
  }
}
