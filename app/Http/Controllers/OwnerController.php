<?php namespace App\Http\Controllers;

use App\Helpers\UltraMsgHelper;
use App\Models\Apartment;
use App\Models\Owner;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class OwnerController extends Controller 
{
    public function Register(Request $request) 
    {
        $request->validate([
            'firstName' => ['required','string'],
            'lastName' => ['required','string'],
            'DateofBirth' => ['required','string'],
            'Personal_photo' => ['required','image','mimes:png,jpg,jpeg,gif','max:4096'],
            'Id_photo' => ['required','image','mimes:png,jpg,jpeg,gif','max:4096'],
            'phone' => ['required','unique:owners,phone'],
            'password' => ['required'],
        ]);

       /* $personalPhotoPath=null;
        $idPhotoPath=null;

        if($request->hasFile('Personal_photo') || $request->hasFile('Id_photo')) {
            $personalPhotoPath=$request->file('Personal_photo')->store('owners/personal','public');
            $idPhotoPath=$request->file('Id_photo')->store('owners/id','public');
        }*/
            $personalPhotoPath = null;
            $idPhotoPath = null;

            if ($request->hasFile('Personal_photo')) {
            $personalPhotoPath = $request->file('Personal_photo')->store('owners/personal', 'public');
            }

            if ($request->hasFile('Id_photo')) {
            $idPhotoPath = $request->file('Id_photo')->store('owners/id', 'public');
            }


        $owner = Owner::create([
            'firstName' => $request->firstName,
            'lastName' => $request->lastName,
            'DateofBirth' => $request->DateofBirth,
            'Personal_photo' => $personalPhotoPath,
            'Id_photo' => $idPhotoPath,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
            'is_verified' => false, 
        ]);

        $otp = rand(100000, 999999);
        $owner->update(['otp' => $otp]);

        UltraMsgHelper::sendWhatsAppMessage($owner->phone, "$otp");

        return response()->json([
            'message' => ' OTP sent via WhatsApp.',
            'Owner' => $owner,
            'otp'     => $otp
        ]);
    }

    public function logIn(Request $request) 
    {
        $request->validate([
            'phone' => ['required','exists:owners,phone'],
            'password' => ['required'],
        ]);

        $owner = Owner::where('phone', $request->phone)->first();

        
        if (!Auth::guard('owner')->attempt($request->only('phone','password'))) {
            return response()->json([
                'message' => 'phone number/password does not match',
            ], 500);
        }

        
        if (!$owner->is_verified) {
            return response()->json([
            'message' => 'Account not approved by Admin yet.'
         ], 403);
        }

        
         $token = $owner->createToken("API TOKEN")->plainTextToken;

        return response()->json([
            'message' => 'Owner Logged In successfully',
            'Owner' => $owner,
            'token' => $token
        ]);
    }

   public function verify(Request $request) 
   {
    $request->validate([
        'phone' => 'required|exists:owners,phone',
        'otp' => 'required'
    ]);

    $owner = Owner::where('phone', $request->phone)->first();

    if ($owner->otp == $request->otp) {
        $owner->update([
            'is_verified' => false, 
            'otp' => null           
        ]);

        return response()->json([
            'message' => 'OTP Verified Successfully. Awaiting Admin approval.'
        ]);
    }

    return response()->json(['message' => 'Invalid OTP'], 400);
    }

    public function logOut(Request $request) 
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json([
            'message'=> 'Owner Logged Out Successfully!'
        ]);
    }

    public function storeApartment(Request $request)
    {
          $user = Auth::user();

    if (!($user instanceof \App\Models\Owner)) {
        return response()->json([
            'message' => 'Only owners can add apartments.'
        ], 403);
    }
        $request->validate([
            'owner_id'=>'required|exists:owners,id',
            'Province' => 'required|string',
            'city' => 'required|string',
            'monthlyPrice' => 'required|numeric',
            'rooms' => 'required|integer',
            'image' => 'required|image|mimes:jpg,jpeg,png,gif|max:4096',
        ]);

        $apartmentImagePath = null;
        if($request->hasFile('image')) {
           $apartmentImagePath=$request->file('image')->store('apartments','public');
        }


        $apartment = Apartment::create([
            'owner_id' => Auth::id(), 
            'Province' => $request->Province,
            'city' => $request->city,
            'monthlyPrice' => $request->monthlyPrice,
            'rooms' => $request->rooms,
            'image' => $apartmentImagePath, 
        ]);

        return response()->json([
            'message' => 'Apartment added successfully!',
            'apartment' => $apartment
        ]);
    }
}



































    



