<?php

namespace App\Http\Controllers;

use App\Models\Apartment;
use Illuminate\Http\Request;

class ApartmentController extends Controller
{
    public function showAllApartments()
    {
        $apartments = Apartment::with('owner')->get();
        return response()->json([
            'apartments' => $apartments
        ]);
    }

    public function showApartment($id)
    {
        $apartment = Apartment::with('owner')->findOrFail($id);
        return response()->json([
            'apartment' => $apartment
        ]);
    }
     
   public function filterApartments(Request $request)
{
    $query = Apartment::with('owner');

    $province = $request->input('Province');
    $city = $request->input('city');
    $minPrice = $request->input('min_price');
    $maxPrice = $request->input('max_price');
    $rooms = $request->input('rooms');

    if (!empty($province)) {
        $query->where('Province', $province);
    }

    if (!empty($city)) {
        $query->where('city', $city);
    }

    if (!empty($minPrice)) {
        $query->where('monthlyPrice', '>=', $minPrice);
    }

    if (!empty($maxPrice)) {
        $query->where('monthlyPrice', '<=', $maxPrice);
    }

    if (!empty($rooms)) {
        $query->where('rooms', $rooms);
    }

    $apartments = $query->get();

    return response()->json([
        'apartments' => $apartments
    ]);
}

}




