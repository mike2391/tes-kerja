<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;

Route::get('/customers', function () {
    $customers = DB::table('Customer')->get();
    $tth = DB::table('CustomerTTH')->get();
    $tthDetail = DB::table('CustomerTTHDetail')->get();
    $mobileConfig = DB::table('MobileConfig')->get();

    return view('customers', compact('customers', 'tth', 'tthDetail', 'mobileConfig'));
});

Route::get('/', function () {
    return "Laravel jalan!";
});

