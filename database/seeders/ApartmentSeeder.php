<?php

namespace Database\Seeders;

use App\Models\Apartment;
use App\Models\Owner;
use Illuminate\Database\Seeder;

class ApartmentSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Get first owner, or create a demo owner
        $owner = Owner::where('is_verified', true)->first();
        
        if (!$owner) {
            $owner = Owner::create([
                'firstName' => 'Ahmad',
                'lastName' => 'Al-Sham',
                'DateofBirth' => '1985-03-15',
                'Personal_photo' => 'demo/personal.jpg',
                'Id_photo' => 'demo/id.jpg',
                'phone' => '0911111111',
                'password' => bcrypt('password'),
                'is_verified' => true,
            ]);
        }

        $damascusApartments = [
            [
                'Province' => 'Damascus',
                'city' => 'Mazzeh',
                'monthlyPrice' => 450000,
                'rooms' => 3,
                'image' => 'apartments/damascus1.jpg',
            ],
            [
                'Province' => 'Damascus',
                'city' => 'Abu Rummaneh',
                'monthlyPrice' => 520000,
                'rooms' => 4,
                'image' => 'apartments/damascus2.jpg',
            ],
            [
                'Province' => 'Damascus',
                'city' => 'Malki',
                'monthlyPrice' => 380000,
                'rooms' => 2,
                'image' => 'apartments/damascus3.jpg',
            ],
            [
                'Province' => 'Damascus',
                'city' => 'Kafr Sousa',
                'monthlyPrice' => 350000,
                'rooms' => 3,
                'image' => 'apartments/damascus4.jpg',
            ],
            [
                'Province' => 'Damascus',
                'city' => 'Muhajreen',
                'monthlyPrice' => 410000,
                'rooms' => 3,
                'image' => 'apartments/damascus5.jpg',
            ],
            [
                'Province' => 'Damascus',
                'city' => 'Bab Touma',
                'monthlyPrice' => 320000,
                'rooms' => 2,
                'image' => 'apartments/damascus6.jpg',
            ],
            [
                'Province' => 'Damascus',
                'city' => 'Shaalan',
                'monthlyPrice' => 480000,
                'rooms' => 4,
                'image' => 'apartments/damascus7.jpg',
            ],
            [
                'Province' => 'Damascus',
                'city' => 'Qassaa',
                'monthlyPrice' => 290000,
                'rooms' => 2,
                'image' => 'apartments/damascus8.jpg',
            ],
            [
                'Province' => 'Damascus',
                'city' => 'Baramkeh',
                'monthlyPrice' => 400000,
                'rooms' => 3,
                'image' => 'apartments/damascus9.jpg',
            ],
            [
                'Province' => 'Damascus',
                'city' => 'Adawi',
                'monthlyPrice' => 550000,
                'rooms' => 5,
                'image' => 'apartments/damascus10.jpg',
            ],
        ];

        foreach ($damascusApartments as $apartment) {
            Apartment::create([
                'owner_id' => $owner->id,
                'Province' => $apartment['Province'],
                'city' => $apartment['city'],
                'monthlyPrice' => $apartment['monthlyPrice'],
                'rooms' => $apartment['rooms'],
                'image' => $apartment['image'],
            ]);
        }
    }
}

