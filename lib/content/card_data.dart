import 'package:flutter/material.dart';

// Model class for card data
class CardData {
  final String imageUrl;
  final String title;
  final String description;

  CardData({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

class CardListScreen extends StatelessWidget {
  // Your 8 cards data
  final List<CardData> cardsData = [
    CardData(
      imageUrl: 'assets/logo/logo.png',
      title: 'The Thunder Party',
      description: 'Get ready for a night of great music, vibrant energy, and an atmosphere designed for unforgettable moments.From the first beat to the last ...',
    ),
    CardData(
      imageUrl: 'assets/logo/logo.png',
      title: 'Card 2 Title',
      description: 'This is the description for card 2. It contains some detailed information.',
    ),
    // Add remaining 6 cards...
    CardData(
      imageUrl: 'assets/logo/logo.png',
      title: 'Card 8 Title',
      description: 'This is the description for card 8. It contains some detailed information.',
    ),
    CardData(
      imageUrl: 'assets/logo/logo.png',
      title: 'Card 8 Title',
      description: 'This is the description for card 8. It contains some detailed information.',
    ),
    CardData(
      imageUrl: 'assets/logo/logo.png',
      title: 'Card 8 Title',
      description: 'This is the description for card 8. It contains some detailed information.',
    ),
    CardData(
      imageUrl: 'assets/logo/logo.png',
      title: 'Card 8 Title',
      description: 'This is the description for card 8. It contains some detailed information.',
    ),
    CardData(
      imageUrl: 'assets/logo/logo.png',
      title: 'Card 8 Title',
      description: 'This is the description for card 8. It contains some detailed information.',
    ),
    CardData(
      imageUrl: 'assets/logo/logo.png',
      title: 'Card 8 Title',
      description: 'This is the description for card 8. It contains some detailed information.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card List'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: cardsData.length,
        itemBuilder: (context, index) {
          return CustomCard(
            cardData: cardsData[index],
            onSeeMore: () {
              // Handle see more action
              print('See more clicked for ${cardsData[index].title}');
            },
          );
        },
      ),
    );
  }
}

// Reusable Card Widget
class CustomCard extends StatelessWidget {
  final CardData cardData;
  final VoidCallback onSeeMore;

  const CustomCard({
    Key? key,
    required this.cardData,
    required this.onSeeMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                cardData.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.error),
                  );
                },
              ),
            ),
            SizedBox(height: 12),

            // Title
            Text(
              cardData.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            // Description
            Text(
              cardData.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12),

            // See More Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onSeeMore,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('See More'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}