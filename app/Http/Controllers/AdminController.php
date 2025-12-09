<?php

namespace App\Http\Controllers;

use App\Models\Admin;
use App\Models\Owner;
use App\Models\Renter;
use Hash;
use Illuminate\Http\Request;

class AdminController extends Controller
{
      public function login(Request $request)
    {
        $request->validate([
            'phone' => 'required',
            'password' => 'required',
        ]);

        $admin = Admin::where('phone', $request->phone)->first();

        if (!$admin || !Hash::check($request->password, $admin->password)) {
            return response()->json([
                'message' => 'incorrect phone / password'
            ], 401);
        }

        $token = $admin->createToken('AdminToken', ['admin'])->plainTextToken;

        return response()->json([
            'message' => 'Admin Logged in successfully',
            'admin'   => $admin,
            'token'   => $token
        ]);
    }

    public function logout(Request $request)
    {
         $request->user()->currentAccessToken()->delete();
        return response()->json([
            'message' => 'Admin Logged out successfully'
        ]);
    }

    public function pendingRegistrations()
    {
        $owners = Owner::where('is_verified', false)->get();
        $renters = Renter::where('is_verified', false)->get();

        return response()->json([
            'pending_owners' => $owners,
            'pending_renters' => $renters
        ]);
    }

    public function approveOwner($id)
    {
        $owner = Owner::findOrFail($id);
        $owner->update(['is_verified' => true]);

        return response()->json([
            'message' => 'Owner approved successfully',
            'owner' => $owner
        ]);
    }

    public function rejectOwner($id)
    {
        $owner = Owner::findOrFail($id);
        $owner->delete();

        return response()->json([
            'message' => 'Owner rejected and deleted successfully'
        ]);
    }

    public function approveRenter($id)
    {
        $renter = Renter::findOrFail($id);
        $renter->update(['is_verified' => true]);

        return response()->json([
            'message' => 'Renter approved successfully',
            'renter' => $renter
        ]);
    }

    public function rejectRenter($id)
    {
        $renter = Renter::findOrFail($id);
        $renter->delete();

        return response()->json([
            'message' => 'Renter rejected and deleted successfully'
        ]);
    }
}


















