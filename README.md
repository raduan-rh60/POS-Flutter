# Flutter POS Application

This Flutter project is a mobile application designed for managing orders, sales, and customer details for a POS platform. It integrates with a backend server for operations like placing orders, updating status, and managing sales.

---

## Features
- Place new orders with customer details.
- Update the status of orders.
- View general sales.
- Delete sales records with animated snackbar notifications.
- Integration with REST APIs for backend communication.

---

## Installation

### Prerequisites
1. **Flutter**: Make sure Flutter SDK is installed. You can download it from [Flutter's official website](https://flutter.dev/docs/get-started/install).
2. **Android Studio**: Install Android Studio for Android development.
3. **Backend API**: Ensure the backend server is running locally or accessible remotely.

### Steps
1. Clone this repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd flutter-ecommerce-app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Connect your device or start an emulator.
5. Run the application:
   ```bash
   flutter run
   ```

---

## Backend API Endpoints
### 1. Place Order
- **Endpoint**: `POST /api/sale/save`
- **Request Body**:
  ```json
  {
    "customerName": "string",
    "customerAddress": "string",
    "customerPhone": "string",
    "note": "string",
    "discount": "number",
    "totalAmount": "number",
    "orderType": "string",
    "orderStatus": "string",
    "transactionType": "string",
    "totalPurchasePrice": "number"
  }
  ```

### 2. Update Order Status
- **Endpoint**: `PATCH /api/cart/status?cartStatus={status}`
- **Request Parameters**:
  - `cartStatus` (string): The new status of the cart.

### 3. Delete Sale
- **Endpoint**: `DELETE /api/sale/{id}`

---

## Important Files
- **`main.dart`**: Entry point of the application.
- **API Service Files**: Contains methods to interact with the backend.
- **`order_details.dart`**: Handles displaying details of specific orders.
- **Snackbar Implementation**: Provides animated notifications.

---

## Troubleshooting

### Common Issues
1. **Build Failures**:
   - Ensure Gradle version compatibility. Recommended version: `7.4.2`.
   - Use JDK 11 for best compatibility.

2. **API Errors**:
   - Verify the backend server is running and accessible.
   - Check the endpoint URLs in the code.

3. **Device Connection**:
   - Ensure USB debugging is enabled on the device.
   - Use `flutter doctor` to check for connected devices.

---

## Contributing
Feel free to fork this project, make your changes, and submit a pull request. Contributions are always welcome!

---

## License
This project is licensed under the MIT License. See `LICENSE` for more information.
