<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\CustomerController;


Route::get('/test', function () {
    return response()->json([
        'status' => 'success',
        'message' => 'API jalan'
    ]);
});

Route::get('/customers', [CustomerController::class, 'index']);
Route::get('/tth', [CustomerController::class, 'tth']);
Route::get('/tth/{tthNo}', [CustomerController::class, 'tthDetail']);
Route::get('/config', [CustomerController::class, 'config']);
Route::get('/summary-tth', [CustomerController::class, 'summaryTTH']);
Route::get('/customers/{id}', [CustomerController::class, 'show']);
Route::get('/customers/{id}/status', [CustomerController::class, 'status']);
Route::post('/tth/receive/{ttottpno}', [CustomerController::class, 'markReceived']);
Route::post('/tth/update', [CustomerController::class, 'updateTTH']);



Route::get('/test', function () {
    return response()->json(['message' => 'API jalan!']);
});
