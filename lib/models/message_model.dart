import 'package:dartchat/models/user_model.dart';

class Message {
  final User sender;
  final String
  time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });
}

// YOU - current user
final User currentUser = User(
  id: 0,
  name: 'Current User',
  imageUrl: 'assets/images/greg.jpg',
);

// USERS
final User tanmoy = User(
  id: 1,
  name: 'Tanmoy',
  imageUrl: 'assets/images/tanmoy.jpg',
);
final User sukanta = User(
  id: 2,
  name: 'Sukanta',
  imageUrl: 'assets/images/sukanta.jpg',
);
final User gairick = User(
  id: 3,
  name: 'Gairick',
  imageUrl: 'assets/images/gairick.jpg',
);
final User manoshi = User(
  id: 4,
  name: 'Manoshi',
  imageUrl: 'assets/images/manoshi.jpg',
);
final User dibya = User(
  id: 5,
  name: 'Dibya',
  imageUrl: 'assets/images/dibya.jpg',
);
final User biswadip = User(
  id: 6,
  name: 'Biswadip',
  imageUrl: 'assets/images/biswadip.jpg',
);
final User pratik = User(
  id: 7,
  name: 'Pratik',
  imageUrl: 'assets/images/pratik.jpg',
);

// FAVORITE CONTACTS
List<User> favorites = [pratik, manoshi, biswadip, dibya, tanmoy];

// EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
  Message(
    sender: pratik,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: tanmoy,
    time: '4:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: sukanta,
    time: '3:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: dibya,
    time: '2:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: biswadip,
    time: '1:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: manoshi,
    time: '12:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  Message(
    sender: gairick,
    time: '11:30 AM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    sender: tanmoy,
    time: '5:30 PM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '4:30 PM',
    text: 'Just walked my doge. She was super duper cute. The best pupper!!',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: tanmoy,
    time: '3:45 PM',
    text: 'How\'s the doggo?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: tanmoy,
    time: '3:15 PM',
    text: 'All the food',
    isLiked: true,
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'Nice! What kind of food did you eat?',
    isLiked: false,
    unread: true,
  ),
  Message(
    sender: tanmoy,
    time: '2:00 PM',
    text: 'I ate so much food today.',
    isLiked: false,
    unread: true,
  ),
];