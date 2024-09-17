# Flutter Chat App

This is a real-time chat application built with Flutter and Firebase. It allows users to sign up, log in, and send messages to other users in real-time.

## Features

- User authentication (sign up, log in, log out)
- Real-time messaging
- User list display
- Dark mode toggle

## Technologies Used

- Flutter
- Firebase Authentication
- Cloud Firestore
- Provider (for state management)

## Project Structure

The project is organized into several key files:

- `home_page.dart`: Displays the list of users and handles navigation to individual chat pages.
- `chat_page.dart`: Manages the chat interface, including sending and displaying messages.
- `settings_page.dart`: Contains the settings page with a dark mode toggle.
- `auth_service.dart`: Handles user authentication operations.
- `chat_service.dart`: Manages chat-related operations, including sending and retrieving messages.

## Setup

1. Clone the repository
2. Ensure you have Flutter installed on your machine
3. Run `flutter pub get` to install dependencies
4. Enable Firebase Authentication and Cloud Firestore in your Firebase console
5. Run the app using `flutter run`

## Usage

1. Launch the app and sign up for a new account or log in with existing credentials
2. On the home page, you'll see a list of other users
3. Tap on a user to start a chat
4. In the chat page, type your message and tap the send button
5. Access the settings page from the drawer to toggle dark mode

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).
