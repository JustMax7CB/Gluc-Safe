# Gluc Safe NodeJS Push Notification Server

This is a NodeJS server that handles pushing notifications to users for the Gluc Safe mobile application. The server checks the user's medication records and sends a push notification to the user if a medication reminder time and the current time is the same. The notification includes the name of the medication and the amount of pills.

## Setup

To set up the server, follow these steps:

1. Clone the repository to your local machine
2. Install the necessary packages by running the command `npm install`
3. Create a Firebase project and configure it for Cloud Messaging
4. Download the Firebase Admin SDK JSON file and place it in the root directory of the project


5. Start the server by running the command `node server`

## Usage

To use the server, you need to have the Gluc Safe mobile application installed on your device and have an account set up.

When the server runs, it checks the medication records of each user every minute. If a medication reminder time and the current time is the same, the server sends a push notification to the user's device via Firebase Cloud Messaging. The notification includes the name of the medication and the amount of pills.

## Technologies Used

This project uses the following technologies:

- NodeJS
- Firebase Cloud Messaging

## Contributing

If you want to contribute to this project, feel free to submit a pull request. Before submitting a pull request, please make sure that your changes are thoroughly tested and that the project still works as expected.

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

