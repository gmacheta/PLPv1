<?php namespace App\Http\Controllers;

use App\Helpers\UltraMsgHelper;
use App\Models\Owner;
use App\Models\Renter;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class RenterController extends Controller 
{
    public function Register(Request $request) 
    {
        $request->validate([
            'firstName' => ['required','string'],
            'lastName' => ['required','string'],
            'DateofBirth' => ['required','string'],
            'Personal_photo' => ['required','image','mimes:png,jpg,jpeg,gif','max:4096'],
            'Id_photo' => ['required','image','mimes:png,jpg,jpeg,gif','max:4096'],
            'phone' => ['required','unique:renters,phone'],
            'password' => ['required'],
        ]);

        $personalPhotoPath=null;
        $idPhotoPath=null;

        if($request->hasFile('Personal_photo') && $request->hasFile('Id_photo')) {
            $personalPhotoPath=$request->file('Personal_photo')->store('renters/personal','public');
            $idPhotoPath=$request->file('Id_photo')->store('renters/id','public');
        }

        $renter = Renter::create([
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
        $renter->update(['otp' => $otp]);

        UltraMsgHelper::sendWhatsAppMessage($renter->phone, "$otp");

        return response()->json([
            'message' => ' OTP sent via WhatsApp.',
            'Renter' => $renter,
            'otp'     => $otp
        ]);
    }

    public function logIn(Request $request) 
    {
        $request->validate([
            'phone' => ['required','exists:renters,phone'],
            'password' => ['required'],
        ]);

        $renter = Renter::where('phone', $request->phone)->first();

        
        if (!Auth::guard('renter')->attempt($request->only('phone','password'))) {
            return response()->json([
                'message' => 'phone number/password does not match',
            ], 500);
        }

        
    
        if (!$renter->is_verified) {
            return response()->json([
               'message' => 'Account not approved by Admin yet.'
            ], 403);
        }

        
         $token = $renter->createToken("API TOKEN")->plainTextToken;

        return response()->json([
            'message' => 'Renter Logged In successfully',
            'Renter' => $renter,
            'token' => $token
        ]);
    }

   public function verify(Request $request) 
{
    $request->validate([
        'phone' => 'required|exists:renters,phone',
        'otp' => 'required'
    ]);

    $renter = Renter::where('phone', $request->phone)->first();

    if ($renter->otp == $request->otp) {
        $renter->update([
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
            'message'=> 'Renter Logged Out Successfully!'
        ]);
    }
}
