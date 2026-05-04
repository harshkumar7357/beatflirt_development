
import 'package:flutter/material.dart';

import '../content/app_drawer.dart';
import '../content/card_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Beat Flirt",style: TextStyle(color:Colors.white,shadows: [
          // Shadow(
          // offset: Offset(2, 2), // X and Y offset
          // blurRadius: 8.0,      // softness of shadow
          //
          // color: Colors.pink.withOpacity(0.6),
          // )
          Shadow(
            blurRadius: 8,
            color: Colors.pink,
            offset: Offset(0, 0),
          ),
          Shadow(
            blurRadius: 16,
            color: Colors.pink,
            offset: Offset(0, 0),
          ),
          Shadow(
            blurRadius: 24,
            color: Colors.pink.withOpacity(0.7),
            offset: Offset(0, 0),
          ),
          Shadow(
            blurRadius: 32,
            color: Colors.pink.withOpacity(0.8),
            offset: Offset(0, 0),
          ),
        ],fontSize: 26),
        ),
      ),
      drawer: Drawer(child: AppDrawer(),),
      backgroundColor: Colors.pink.withOpacity(0.5),
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(8, (index) {
                return CustomCard(
                    cardData: CardData(
                      imageUrl: '',
                      title: 'Card ${index + 1} Title',
                      description: 'Description for card ${index + 1}',
                    ),
                    onSeeMore: () {
                      print('Card ${index + 1} See More clicked');
                    }
                  // Text("Beat Flirt is a Event Management Software In Which People Can Meet And Party Together....",style: TextStyle(color: Colors.white,fontSize: 25),),
                  // Expanded(
                  //   flex:1,
                  //   child: Image(
                  //     image: AssetImage("assets/logo/logo.png"),
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  // Card(
                  //   color: Colors.white,
                  //
                  //   child: Column(
                  //     children: [
                  //       ListView.builder(
                  //         itemCount: CardData.,
                  //         itemBuilder: (context,index){
                  //           return Padding(
                  //               padding: const EdgeInsets.only(bottom: 16),
                  //               child: CustomCard(cardData: CardData(imageUrl: '', title: '', description: ''), onSeeMore: () {},),
                  //           );
                  //         }
                  //       )
                  //
            
                  // ],
                  //   ),
                  //
                  // )
            
                );
              }
              )
            
            ),
          ),
        ),
      ),

    );
  }
}

