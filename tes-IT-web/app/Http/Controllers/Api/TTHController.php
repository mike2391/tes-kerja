<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Customer;
use App\Models\CustomerTTH;
use App\Models\CustomerTTHDetail;

class TTHController extends Controller
{
    // list semua customer dengan hadiah
    public function index()
    {
        $data = CustomerTTH::with(['customer'])->get();
        return response()->json($data);
    }

    // detail hadiah per dokumen
    public function detail($tthNo)
    {
        $data = CustomerTTHDetail::where('TTHNo', $tthNo)->get();
        return response()->json($data);
    }
}
