<?php

namespace Database\Seeders;

use App\Models\Admin;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
         
        Admin::create([
            'name' => 'Admin000',
            'phone' => '0912345678',  
            'password' => bcrypt('000'),
        ]);
    }
}




