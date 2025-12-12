# Quick Start Guide - Bayti Apartment Booking App

## ✅ All Mandatory Requirements Implemented!

Your application is ready to demo! Here's what's working:

### ✓ Requirement 1: User Registration with Phone Number (2 pts)
- Users can register as **Owner** or **Renter**
- Phone number used as unique identifier

### ✓ Requirement 2: Personal Information Collection (2 pts)
- First Name ✓
- Last Name ✓
- Personal Photo ✓
- Date of Birth ✓
- ID Photo ✓

### ✓ Requirement 3: Login/Logout (2 pts)
- Login with phone + password ✓
- Logout button in apartments screen ✓
- Token-based authentication ✓

### ✓ Requirement 4: Browse Apartments & View Details (3 pts)
- List all apartments ✓
- Click to view apartment details ✓
- Location, price, rooms displayed ✓

### ✓ Requirement 5: Admin Approval System
- All registrations require admin approval ✓
- Admin can approve/reject users ✓
- Users cannot login until approved ✓

---

## 🚀 Running the Application

### Step 1: Start Backend (Terminal 1)
```powershell
cd C:\Users\asus\Desktop\Joulie\PLPv1
php artisan migrate:fresh --seed
php artisan serve
```
**Backend will run at:** `http://127.0.0.1:8000`

**Admin Credentials:**
- Phone: `0912345678`
- Password: `000`

### Step 2: Start Flutter App (Terminal 2)
```powershell
cd C:\Users\asus\Desktop\Joulie\PLPv1\apartment_booking_app
flutter pub get
flutter run -d chrome
```

---

## 📝 Demo Flow for Teacher

### 1. Register New User
1. Open app in Chrome
2. Click "Get Started"
3. Select "Renter" or "Owner"
4. Fill in all fields:
   - First Name: John
   - Last Name: Doe
   - Date of Birth: 2000-01-01
   - Phone: 0912345679
   - Password: password123
   - Upload personal photo
   - Upload ID photo
5. Click Register
6. You'll see: "Registered successfully. Wait for admin approval"

### 2. Try to Login (Will Fail - Not Approved Yet)
1. Go back and try to login with the phone and password
2. You'll see: "Account not approved by Admin yet"
3. **This demonstrates the admin approval requirement!**

### 3. Approve User as Admin

**🎉 NEW! Option A: Using the Admin Web Interface (RECOMMENDED)**

1. Go back to the onboarding screen (or open app in new browser tab)
2. Click **"Admin Login"** button at the bottom
3. Login with:
   - Phone: `0912345678`
   - Password: `000`
4. You'll see the Admin Dashboard with all pending users
5. Find your new user in the list
6. Click the green **"Approve"** button
7. Confirm approval
8. Done! ✅

*No Postman needed! Everything is in the web app now!*

**Option B: Using Postman/Insomnia/Thunder Client**

**Login as Admin:**
```
POST http://127.0.0.1:8000/api/adminLogin
Content-Type: application/json

{
  "phone": "0912345678",
  "password": "000"
}
```
Copy the `token` from response.

**View Pending Users:**
```
GET http://127.0.0.1:8000/api/adminPending
Authorization: Bearer YOUR_TOKEN_HERE
```

**Approve Renter (replace {id} with actual ID from pending list):**
```
POST http://127.0.0.1:8000/api/adminApproveRenter/{id}
Authorization: Bearer YOUR_TOKEN_HERE
```

**OR Approve Owner:**
```
POST http://127.0.0.1:8000/api/adminApproveOwner/{id}
Authorization: Bearer YOUR_TOKEN_HERE
```

**Option C: Using PowerShell (Quick Method)**
```powershell
# 1. Login as admin
$adminResponse = Invoke-WebRequest -Uri "http://127.0.0.1:8000/api/adminLogin" -Method POST -Body (@{phone="0912345678"; password="000"} | ConvertTo-Json) -ContentType "application/json"
$token = ($adminResponse.Content | ConvertFrom-Json).token

# 2. Get pending users
$pending = Invoke-WebRequest -Uri "http://127.0.0.1:8000/api/adminPending" -Headers @{Authorization="Bearer $token"}
$pending.Content

# 3. Approve first pending renter (get ID from above output)
$id = 1  # Replace with actual ID
Invoke-WebRequest -Uri "http://127.0.0.1:8000/api/adminApproveRenter/$id" -Method POST -Headers @{Authorization="Bearer $token"}
```

### 4. Login with Approved User
1. Go back to Flutter app
2. Select role (Renter/Owner)
3. Click "Login"
4. Enter phone: 0912345679
5. Enter password: password123
6. Click Login
7. **Success!** You'll see the apartments list

### 5. Browse Apartments
1. View list of apartments
2. Click on any apartment card
3. See full details:
   - Location (City, Province)
   - Monthly Price
   - Number of Rooms
   - Description
4. Click "Contact Owner" button

### 6. Logout
1. Click the logout icon (⬅️) in top-right corner
2. Confirm logout
3. Returns to onboarding screen

---

## 🎯 Key Points to Highlight to Teacher

1. **Complete Registration Flow:**
   - All required fields collected
   - Image upload works on web
   - Phone number validation

2. **Admin Approval System:**
   - Users cannot login without approval
   - Clear error message shown
   - Admin can view pending registrations

3. **Authentication:**
   - Token-based with Laravel Sanctum
   - Logout functionality
   - Secure password hashing

4. **Browse & View Apartments:**
   - Clean, modern UI
   - Click to see details
   - All information displayed

5. **Web-Ready:**
   - Works perfectly on Chrome
   - Image picker works on web
   - Responsive design

---

## 📊 Database Tables

Your database includes:
- `owners` - Owner accounts with approval status
- `renters` - Renter accounts with approval status
- `apartments` - Apartment listings
- `admins` - Admin accounts
- `personal_access_tokens` - API tokens for authentication

---

## 🔧 Troubleshooting

### Backend won't start:
```powershell
php artisan key:generate
php artisan migrate:fresh --seed
php artisan serve
```

### Flutter build errors:
```powershell
cd apartment_booking_app
flutter clean
flutter pub get
flutter run -d chrome
```

### "Database not found" error:
```powershell
New-Item -Path database\database.sqlite -ItemType File -Force
php artisan migrate:fresh --seed
```

### CORS errors in browser:
- Make sure backend is running on `http://127.0.0.1:8000` (not localhost)
- CORS is already configured in Laravel

---

## 📱 Bonus Features Beyond Requirements

- Modern, clean UI design
- Click apartments to view full details
- Smooth navigation
- Confirmation dialogs
- Loading states
- Error handling
- Responsive layout

---

## ✨ Final Checklist Before Demo

- [ ] Backend server running (`php artisan serve`)
- [ ] Flutter app running in Chrome
- [ ] Admin account working (phone: 0912345678, password: 000)
- [ ] Can register new user
- [ ] Login blocked without approval (shows correct error)
- [ ] Can approve user via API
- [ ] Can login after approval
- [ ] Can see apartments list
- [ ] Can click apartment to see details
- [ ] Can logout successfully

---

**You're all set! Good luck with your demo! 🎉**

