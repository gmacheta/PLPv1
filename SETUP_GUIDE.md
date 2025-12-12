# Bayti - Apartment Booking Application Setup Guide

## Project Overview
This is a complete apartment booking application with:
- **Backend**: Laravel (PHP)
- **Frontend**: Flutter (runs on Chrome/Web)

## Mandatory Requirements Implementation Status ✓

### 1. User Registration with Phone Number ✓ (2 points)
- Users can register as either **Owner** or **Renter**
- Registration uses phone number as unique identifier
- OTP verification via WhatsApp

### 2. Personal Information Required ✓ (2 points)
Both owners and renters must provide:
- ✓ First Name
- ✓ Last Name
- ✓ Personal Photo
- ✓ Date of Birth
- ✓ ID Photo

### 3. Login/Logout Functionality ✓ (2 points)
- ✓ Users can log in with phone + password
- ✓ Users can log out from the app
- ✓ Token-based authentication (Laravel Sanctum)

### 4. Browse Apartments & View Details ✓ (3 points)
- ✓ View list of available apartments
- ✓ Click on apartment to see full details
- ✓ Filter apartments by location, price, rooms

### 5. Admin Approval System ✓
- ✓ All registrations require admin approval before users can login
- ✓ Admin can approve or reject owner/renter registrations

---

## Prerequisites

### Backend Requirements:
- PHP 8.1 or higher
- Composer
- SQLite (included with PHP by default)

### Frontend Requirements:
- Flutter SDK (2.19.1 or higher)
- Chrome Browser

---

## Step-by-Step Setup Instructions

### Part 1: Backend Setup (Laravel)

1. **Install PHP Dependencies**
   ```bash
   cd C:\Users\asus\Desktop\Joulie\PLPv1
   composer install
   ```

2. **Generate Application Key** (if .env needs setup)
   ```bash
   php artisan key:generate
   ```

3. **Create SQLite Database**
   ```bash
   # Create empty database file
   type nul > database\database.sqlite
   ```

4. **Run Database Migrations**
   ```bash
   php artisan migrate
   ```

5. **Seed Admin User**
   ```bash
   php artisan db:seed --class=AdminSeeder
   ```
   
   **Admin Credentials:**
   - Phone: `0912345678`
   - Password: `000`

6. **Create Storage Link** (for image uploads)
   ```bash
   php artisan storage:link
   ```

7. **Start Laravel Server**
   ```bash
   php artisan serve
   ```
   
   ✓ Backend will run at: `http://127.0.0.1:8000`

---

### Part 2: Frontend Setup (Flutter)

1. **Navigate to Flutter App**
   ```bash
   cd apartment_booking_app
   ```

2. **Install Flutter Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run App on Chrome**
   ```bash
   flutter run -d chrome
   ```

   Or use hot reload for development:
   ```bash
   flutter run -d chrome --web-renderer html
   ```

---

## Testing the Application

### Test Flow for Demo:

#### 1. **Register as Renter/Owner**
   - Open app in Chrome
   - Click "Get Started"
   - Select role (Renter or Owner)
   - Fill in registration form:
     - First Name
     - Last Name
     - Date of Birth (YYYY-MM-DD format)
     - Phone number
     - Password
     - Upload Personal Photo
     - Upload ID Photo
   - Submit registration
   - OTP will be sent (shown in response for testing)

#### 2. **Admin Approval** (Use Postman or similar tool)
   
   **Login as Admin:**
   ```
   POST http://127.0.0.1:8000/api/adminLogin
   Body: {
     "phone": "0912345678",
     "password": "000"
   }
   ```
   Copy the `token` from response.
   
   **View Pending Registrations:**
   ```
   GET http://127.0.0.1:8000/api/adminPending
   Headers: {
     "Authorization": "Bearer YOUR_ADMIN_TOKEN"
   }
   ```
   
   **Approve Owner (replace {id} with actual ID):**
   ```
   POST http://127.0.0.1:8000/api/adminApproveOwner/{id}
   Headers: {
     "Authorization": "Bearer YOUR_ADMIN_TOKEN"
   }
   ```
   
   **Approve Renter:**
   ```
   POST http://127.0.0.1:8000/api/adminApproveRenter/{id}
   Headers: {
     "Authorization": "Bearer YOUR_ADMIN_TOKEN"
   }
   ```

#### 3. **Login as Approved User**
   - Go back to Flutter app
   - Select your role (Renter/Owner)
   - Click "Login"
   - Enter phone and password
   - You should now see the apartments list

#### 4. **Browse Apartments**
   - View all available apartments
   - Click on any apartment to see full details
   - Location, price, number of rooms displayed

#### 5. **Logout**
   - Click the logout icon in the top-right corner
   - Confirm logout

---

## API Endpoints Reference

### Authentication
- `POST /api/ownerRegister` - Register as owner
- `POST /api/renterRegister` - Register as renter
- `POST /api/ownerLogin` - Owner login
- `POST /api/renterLogin` - Renter login
- `POST /api/ownerLogout` - Owner logout (requires token)
- `POST /api/renterLogout` - Renter logout (requires token)

### Admin
- `POST /api/adminLogin` - Admin login
- `GET /api/adminPending` - View pending registrations (requires admin token)
- `POST /api/adminApproveOwner/{id}` - Approve owner (requires admin token)
- `POST /api/adminApproveRenter/{id}` - Approve renter (requires admin token)
- `DELETE /api/adminRejectOwner/{id}` - Reject owner (requires admin token)
- `DELETE /api/adminRejectRenter/{id}` - Reject renter (requires admin token)

### Apartments
- `GET /api/apartments` - List all apartments
- `GET /api/apartments/{id}` - View apartment details
- `POST /api/apartments` - Create apartment (owner only, requires token)
- `POST /api/apartmentsFilter` - Filter apartments

---

## Quick Test Commands

### Start Both Servers (use 2 terminal windows):

**Terminal 1 - Backend:**
```bash
cd C:\Users\asus\Desktop\Joulie\PLPv1
php artisan serve
```

**Terminal 2 - Frontend:**
```bash
cd C:\Users\asus\Desktop\Joulie\PLPv1\apartment_booking_app
flutter run -d chrome
```

---

## Troubleshooting

### Backend Issues:

1. **Database Error:**
   ```bash
   # Recreate database
   del database\database.sqlite
   type nul > database\database.sqlite
   php artisan migrate:fresh --seed
   ```

2. **Storage Permission Error:**
   ```bash
   php artisan storage:link
   ```

3. **Composer Dependencies:**
   ```bash
   composer update
   ```

### Frontend Issues:

1. **Flutter Pub Error:**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Chrome Not Detected:**
   ```bash
   flutter devices
   flutter config --enable-web
   ```

3. **CORS Error:**
   - Already handled in Laravel (`config/cors.php`)
   - Make sure backend is running on `http://127.0.0.1:8000`

---

## Project Structure

```
PLPv1/
├── app/                          # Laravel backend
│   ├── Http/Controllers/         # API controllers
│   │   ├── AdminController.php   # Admin approval logic
│   │   ├── OwnerController.php   # Owner registration/login
│   │   ├── RenterController.php  # Renter registration/login
│   │   └── ApartmentController.php
│   └── Models/                   # Database models
├── database/
│   ├── migrations/               # Database schema
│   └── seeders/                  # Admin seeder
├── routes/
│   └── api.php                   # API routes
└── apartment_booking_app/        # Flutter frontend
    ├── lib/
    │   ├── screens/              # UI screens
    │   │   ├── onboarding_screen.dart
    │   │   ├── role_select_screen.dart
    │   │   ├── register_screen.dart
    │   │   ├── login_screen.dart
    │   │   ├── apartments_list_screen.dart
    │   │   └── apartment_detail_screen.dart
    │   └── services/             # API services
    │       ├── auth_service.dart
    │       ├── apartments_service.dart
    │       └── api_client.dart
    └── web/                      # Web-specific files
```

---

## Demo Checklist for Teacher

- [ ] Start Laravel backend server
- [ ] Start Flutter app on Chrome
- [ ] Register new user (show all required fields)
- [ ] Show admin approval needed message
- [ ] Use Postman to approve user as admin
- [ ] Login with approved user
- [ ] Browse apartments list
- [ ] Click apartment to view details
- [ ] Demonstrate logout functionality

---

## Additional Notes

- **WhatsApp OTP**: Currently configured but may require API credentials
- **Image Upload**: Works on web using `image_picker` package
- **Database**: Using SQLite for easy demo setup
- **Authentication**: Laravel Sanctum for API tokens
- **All mandatory requirements**: ✓ Implemented and working

---

## Contact

For issues or questions, refer to the code comments or Laravel/Flutter documentation.

**Good luck with your demo! 🎉**

