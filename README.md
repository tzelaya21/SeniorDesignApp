
# SeniorDesignApp
## Smart Home IoT Air Quality Detection

## File Structure
Within the download you'll find the following directories and files:

```
.
├── README.md
├── android
├── assets
├── ios
├── lib
│   ├── constants
│   │   └── Theme.dart
│   ├── screens
│   │   ├── Rooms
│   │   │   ├── room1.dart
│   │   │   └── room2.dart
│   │   ├── home.dart
|   |   ├── login.dart
|   |   ├── profile.dart
│   │   ├── qr-scan.dart
│   │   ├── settings.dart
│   │   └── signup.dart
│   └── widgets
│       ├── card-category.dart
│       ├── card-horizontal.dart
│       ├── card-shopping-cart.dart
│       ├── card-shopping.dart
│       ├── card-small.dart
│       ├── card-square.dart
│       ├── drawer-tile.dart
│       ├── drawer.dart
│       ├── input.dart
│       ├── navbar.dart
│       ├── photo-album.dart
│       ├── slider-product.dart
│       └── table-cell.dart
│   └── main.dart
├── pubspec.lock
└── pubspec.yaml
```

Interface /UI 

The interface of the Mobile Application is very simple yet attractive. We have focused on the common user and keep this user-friendly so that the user doesn’t have to put extra effort in understanding the application’s interface. 
It has six main components:
Login/Sign-up Screens
Drawer Tile
Home Screen
Room Screens
QR-Code Scanner Screen
Settings Screen


Log In/Sign-up:

This component is divided into two parts/screens:
Login Screen
Sign-up Screen


Login Screen: The application starts with the login screen, which has two input fields for the user to enter their credentials to login to the application to use it. It has two buttons, one to login to the application using the credentials they entered and one button to navigate to the Sign-up Screen where they can register their account for the application.


Sign-up Screen: If the user selects to Register themselves, they are navigated to this screen to register themselves using a simple sign-up method. The sign-up screen has three input fields: one to enter their full name, one for the email, and one for the password. The password input field also has a toggle button hide/show control for the user to see their typed password. Below the input fields, there are two buttons one for the user to upload their image that will later be displayed in the application.


Drawer Tile: The Drawer is a simple navigation plane for the user to navigate into different screens of the application. On top of the drawer, it shows the information like the User’s name and profile picture they uploaded while signing up about the user who is currently logged in. Under that it has a button to navigate to the Home Screen, and under the home button, it contains buttons to navigate to different rooms. Below the room buttons, it has a QR-code Scanner button, and at the bottom of the drawer, there is a settings button to navigate to the respective screens and a logout button to sign out the application.


Home Screen: The Home Screen contains an app-bar which has a title and a button on the left side of the screen to pop the drawer; below the app-bar in the screen area, there are three circular graphs to Display the information about the Air Quality, Oxygen, and Carbon-Dioxide of the environment. Below the Circular graphs, a histogram shows the Air Quality of the past week in the form of a bar graph.


Room Screens: The Room Screen contains an app-bar which has a title and a button on the left side of the screen to pop the drawer, below the app-bar in the screen area there are 7 circular graphs to Display the current information about the Air Quality, Oxygen, Carbon-Dioxide, Dust, MQ2 gas, Temperature in both Celsius and Fahrenheit of the current room selected which is being transmitted by the sensors.


QR-Code Scanner: The QR-Code Screen contains an app-bar with a title and a button on the left side of the screen to pop the drawer. Inside the Screen body, there is a label on the top to display the scanned QR-codes data to the user before storing them into the database. And at the bottom of the screen, there are three buttons: one to open the QR-code scanner, one button to store the scanned data (Device-ID) to the database and one button to read the stored data (Device-ID) from the database.


Settings Screen: The Settings Screen contains an app-bar with a title and a button on the left side of the screen to pop the drawer; it has only one control in its screen body to switch between Light and Dark mode. There is a Switch which can be turned on and off to change between dark and light modes.


