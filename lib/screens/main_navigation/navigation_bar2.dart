import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage1> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const ChatsTab(),
    const MapsTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // important for transparent bottom nav
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.white.withOpacity(0.2),
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: _currentIndex,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.pinkAccent,
                unselectedItemColor: Colors.black.withOpacity(0.5),
                showSelectedLabels: true,
                showUnselectedLabels: true,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat),
                    label: "Chats",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map),
                    label: "Maps",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ========================================
// Home Tab
// ========================================
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  final List<Map<String, String>> stories = const [
    {'name': 'Alice', 'avatar': 'https://i.pravatar.cc/150?img=1'},
    {'name': 'Bob', 'avatar': 'https://i.pravatar.cc/150?img=2'},
    {'name': 'Cathy', 'avatar': 'https://i.pravatar.cc/150?img=3'},
    {'name': 'David', 'avatar': 'https://i.pravatar.cc/150?img=4'},
  ];

  final List<Map<String, String>> feedItems = const [
    {
      'username': 'Alice',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'image': 'https://picsum.photos/400/300',
      'caption': 'Enjoying the sunset 🌅',
    },
    {
      'username': 'Bob',
      'avatar': 'https://i.pravatar.cc/150?img=2',
      'image': 'https://picsum.photos/401/300',
      'caption': 'Chilling at the beach 🏖️',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // AppBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FlirtMate',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  color: Colors.pinkAccent,
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Stories
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                        NetworkImage(stories[index]['avatar']!),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        stories[index]['name']!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Feed
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: feedItems.length,
              itemBuilder: (context, index) {
                final item = feedItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(item['avatar']!),
                        ),
                        title: Text(
                          item['username']!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.zero, bottom: Radius.circular(16)),
                        child: Image.network(
                          item['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          item['caption']!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.favorite_border,
                                    color: Colors.pinkAccent),
                                onPressed: () {}),
                            const Text("Like"),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ========================================
// Placeholder Tabs
// ========================================
class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key});

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  final TextEditingController _controller = TextEditingController();
  final String currentUserId = 'user1'; // Replace with Firebase Auth uid
  final String chatWithUserId = 'user2'; // Replace with chat target

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .doc(getChatId(currentUserId, chatWithUserId))
                .collection('messages')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final messages = snapshot.data!.docs;
              return ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  bool isMe = msg['senderId'] == currentUserId;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.pinkAccent : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg['text'],
                        style: TextStyle(color: isMe ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.pinkAccent),
                onPressed: () async {
                  if (_controller.text.trim().isEmpty) return;
                  await FirebaseFirestore.instance
                      .collection('chats')
                      .doc(getChatId(currentUserId, chatWithUserId))
                      .collection('messages')
                      .add({
                    'senderId': currentUserId,
                    'text': _controller.text.trim(),
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  _controller.clear();
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  String getChatId(String a, String b) => a.hashCode <= b.hashCode ? '$a-$b' : '$b-$a';
}


//  ========================================================================================
//    MAPS TAB
//  ========================================================================================
class MapsTab extends StatefulWidget {
  const MapsTab({super.key});

  @override
  State<MapsTab> createState() => _MapsTabState();
}

class _MapsTabState extends State<MapsTab> {
  final Set<Marker> _markers = {};
  final LatLng _center = const LatLng(37.7749, -122.4194); // Example

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(data['lat'], data['lng']),
            infoWindow: InfoWindow(title: data['name']),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _center, zoom: 12),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}

// ========================================================================================
// PROFILE TAB
// ========================================================================================

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final TextEditingController _nameController = TextEditingController();
  bool isVerified = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
                labelText: "Name", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text("Verification: "),
              isVerified
                  ? const Icon(Icons.verified, color: Colors.green)
                  : ElevatedButton(
                onPressed: () {
                  // Implement ID upload & validation logic
                },
                child: const Text("Verify ID"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () async {
                // Save profile info to Firestore
              },
              child: const Text("Save Profile"))
        ],
      ),
    );
  }
}
//
// // ====================================
// // Home Screen with Floating GlassNav
// // ====================================
// class HomeScreen1 extends StatefulWidget {
//   const HomeScreen1({super.key});
//   @override
//   State<HomeScreen1> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen1> {
//   int _currentIndex = 0;
//
//   final List<Widget> _pages = [
//     const HomeTab(),
//     const ChatsTab(),
//     const MapsTab(),
//     const ProfileTab(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true, // For floating nav
//       body: _pages[_currentIndex],
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(30),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(30),
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.3),
//                   width: 1.5,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4)),
//                 ],
//               ),
//               child: BottomNavigationBar(
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 currentIndex: _currentIndex,
//                 type: BottomNavigationBarType.fixed,
//                 selectedItemColor: Colors.pinkAccent,
//                 unselectedItemColor: Colors.white,
//                 showSelectedLabels: true,
//                 showUnselectedLabels: true,
//                 onTap: (index) => setState(() => _currentIndex = index),
//                 items: const [
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.home), label: "Home"),
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.chat), label: "Chats"),
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.map), label: "Maps"),
//                   BottomNavigationBarItem(
//                       icon: Icon(Icons.person), label: "Profile"),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ====================================
// // Home Tab
// // ====================================
// class HomeTab extends StatelessWidget {
//   const HomeTab({super.key});
//
//   final List<Map<String, String>> stories = const [
//     {'name': 'Alice', 'avatar': 'https://i.pravatar.cc/150?img=1'},
//     {'name': 'Bob', 'avatar': 'https://i.pravatar.cc/150?img=2'},
//     {'name': 'Cathy', 'avatar': 'https://i.pravatar.cc/150?img=3'},
//     {'name': 'David', 'avatar': 'https://i.pravatar.cc/150?img=4'},
//   ];
//
//   final List<Map<String, String>> feedItems = const [
//     {
//       'username': 'Alice',
//       'avatar': 'https://i.pravatar.cc/150?img=1',
//       'image': 'https://picsum.photos/400/300',
//       'caption': 'Enjoying the sunset 🌅',
//     },
//     {
//       'username': 'Bob',
//       'avatar': 'https://i.pravatar.cc/150?img=2',
//       'image': 'https://picsum.photos/401/300',
//       'caption': 'Chilling at the beach 🏖️',
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         children: [
//           // App Bar
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'FlirtMate',
//                   style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       foreground: Paint()
//                         ..shader = LinearGradient(colors: [
//                           Colors.pinkAccent,
//                           Colors.purpleAccent
//                         ]).createShader(const Rect.fromLTWH(0, 0, 200, 70))),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(12)),
//                   child: IconButton(
//                     icon: const Icon(Icons.notifications),
//                     color: Colors.pinkAccent,
//                     onPressed: () {},
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Stories
//           SizedBox(
//             height: 110,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: stories.length,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               itemBuilder: (context, index) {
//                 final story = stories[index];
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: Column(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                             gradient: LinearGradient(colors: [
//                               Colors.pinkAccent,
//                               Colors.purpleAccent
//                             ]),
//                             shape: BoxShape.circle),
//                         padding: const EdgeInsets.all(2),
//                         child: CircleAvatar(
//                           radius: 30,
//                           backgroundImage: NetworkImage(story['avatar']!),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         story['name']!,
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           // Feed
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               itemCount: feedItems.length,
//               itemBuilder: (context, index) {
//                 final item = feedItems[index];
//                 return Container(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Colors.white.withOpacity(0.8),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 10,
//                           offset: const Offset(0, 5))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ListTile(
//                         leading: CircleAvatar(
//                           backgroundImage: NetworkImage(item['avatar']!),
//                         ),
//                         title: Text(
//                           item['username']!,
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                       ),
//                       ClipRRect(
//                         borderRadius: const BorderRadius.vertical(
//                             bottom: Radius.circular(20)),
//                         child: Image.network(
//                           item['image']!,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           height: 220,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(12),
//                         child: Text(
//                           item['caption']!,
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                         child: Row(
//                           children: [
//                             IconButton(
//                                 icon: const Icon(Icons.favorite_border,
//                                     color: Colors.pinkAccent),
//                                 onPressed: () {}),
//                             const Text("Like"),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// // ====================================
// // Chats Tab Premium
// // ====================================
// class ChatsTab extends StatelessWidget {
//   const ChatsTab({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.chat_bubble_outline,
//               size: 80, color: Colors.pinkAccent.withOpacity(0.7)),
//           const SizedBox(height: 20),
//           const Text(
//             "Real-time Chats Coming Soon!",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             "Premium version supports one-to-one chats with notifications.",
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ====================================
// // Maps Tab Premium
// // ====================================
// class MapsTab extends StatelessWidget {
//   const MapsTab({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return GoogleMap(
//       initialCameraPosition:
//       const CameraPosition(target: LatLng(37.7749, -122.4194), zoom: 12),
//       myLocationEnabled: true,
//       myLocationButtonEnabled: true,
//       markers: {
//         const Marker(
//             markerId: MarkerId('user1'),
//             position: LatLng(37.7749, -122.4194),
//             infoWindow: InfoWindow(title: 'Nearby User')),
//       },
//     );
//   }
// }
//
// // ====================================
// // Profile Tab Premium
// // ====================================
// class ProfileTab extends StatelessWidget {
//   const ProfileTab({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: ListView(
//         children: [
//           Center(
//             child: Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 60,
//                   backgroundImage:
//                   const NetworkImage('https://i.pravatar.cc/150?img=1'),
//                 ),
//                 Positioned(
//                     bottom: 0,
//                     right: 4,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.pinkAccent,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 2),
//                       ),
//                       child: const Padding(
//                         padding: EdgeInsets.all(6.0),
//                         child: Icon(Icons.edit, color: Colors.white, size: 20),
//                       ),
//                     ))
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextField(
//             decoration: InputDecoration(
//               labelText: "Name",
//               border:
//               OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextField(
//             decoration: InputDecoration(
//               labelText: "Relationship Intent",
//               border:
//               OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                   colors: [Colors.pinkAccent, Colors.purpleAccent]),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: TextButton(
//                 onPressed: () {},
//                 child: const Text(
//                   "Verify ID",
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 )),
//           )
//         ],
//       ),
//     );
//   }
// }