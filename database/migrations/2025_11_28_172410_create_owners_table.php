<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('owners', function (Blueprint $table) {
            $table->id();
            $table->string("firstName");
            $table->string("lastName");
            $table->string("DateofBirth");
            $table->string("Personal_photo");
            $table->string("Id_photo");
            $table->string("phone")->unique();
            $table->string('password');
            $table->boolean('is_verified')->default(false);
            $table->rememberToken();
            $table->timestamps();
        });
    }

   
    public function down(): void
    {
        Schema::dropIfExists('owners');
    }
};
