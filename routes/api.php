<?php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\ApartmentController;
use App\Http\Controllers\OwnerController;
use App\Http\Controllers\RenterController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('ownerRegister',[OwnerController::class,'Register']);
Route::post('ownerLogin',[OwnerController::class,'logIn']);
Route::post('ownerVerify', [OwnerController::class, 'verify']);
Route::post('ownerLogout',[OwnerController::class,'logOut'])->middleware('auth:sanctum');

Route::post('renterRegister',[RenterController::class,'Register']);
Route::post('renterLogin',[RenterController::class,'logIn']);
Route::post('renterVerify', [RenterController::class, 'verify']);
Route::post('renterLogout',[RenterController::class,'logOut'])->middleware('auth:sanctum');


Route::post('apartments', [OwnerController::class,'storeApartment'])->middleware('auth:sanctum');

Route::get('apartments', [ApartmentController::class,'showAllApartments']);
Route::get('apartments/{id}', [ApartmentController::class,'showApartment']);


Route::post('adminLogin', [AdminController::class, 'login']);
Route::post('adminLogout', [AdminController::class, 'logout'])->middleware('auth:admin');

Route::middleware(['auth:admin'])->group(function () {
    Route::get('adminPending', [AdminController::class, 'pendingRegistrations']);

    Route::post('adminApproveOwner/{id}', [AdminController::class, 'approveOwner']);
    Route::delete('adminRejectOwner/{id}', [AdminController::class, 'rejectOwner']);

    Route::post('adminApproveRenter/{id}', [AdminController::class, 'approveRenter']);
    Route::delete('adminRejectRenter/{id}', [AdminController::class, 'rejectRenter']);
});

Route::post('apartmentsFilter', [ApartmentController::class, 'filterApartments']);




















