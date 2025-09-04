<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;


class CustomerController extends Controller
{
    public function index()
    {
        return DB::table('Customer')->get();
    }

    public function tth()
    {
        return DB::table('CustomerTTH')->get();
    }

    public function tthDetail($tthNo)
    {
        return DB::table('CustomerTTHDetail')->where('TTHNo', $tthNo)->get();
    }

    public function config()
    {
        return DB::table('MobileConfig')->get();
    }


    public function summaryTTH() {
    $data = DB::table('CustomerTTHDetail')
        ->select('Jenis', DB::raw('SUM(Qty) as total_qty'), 'Unit')
        ->groupBy('Jenis', 'Unit')
        ->get();

    return response()->json($data);
}
public function show($id)
{
    $customer = DB::table('Customer')->where('CustID', $id)->first();
    if (!$customer) {
        return response()->json(['message' => 'Not found'], 404);
    }

    $ttotpList = DB::table('CustomerTTH')
        ->where('CustID', $id)
        ->pluck('TTOTTPNo');

    return response()->json([
        'CustID'     => $customer->CustID,
        'Name'       => $customer->Name,
        'Address'    => $customer->Address,
        'PhoneNo'    => $customer->PhoneNo,
        'TTOTPList'  => $ttotpList,
    ]);
}

public function markReceived($ttottpno)
{
    $updated = DB::table('CustomerTTH')
        ->where('TTOTTPNo', $ttottpno)
        ->update([
            'Received' => 1,
            'ReceivedDate' => now()
        ]);

    if ($updated) {
        return response()->json([
            'status' => 'success',
            'message' => "TTH dengan kode $ttottpno berhasil diupdate"
        ]);
    } else {
        return response()->json([
            'status' => 'error',
            'message' => "Data tidak ditemukan untuk $ttottpno"
        ], 404);
    }
}

public function status($id)
{
    $details = DB::table('CustomerTTH')
        ->where('CustID', $id)
        ->select('Received')
        ->get();

    if ($details->isEmpty()) {
        return response()->json(['status' => 'Belum Diberikan']);
    }

    $total = $details->count();
    $received = $details->where('Received', 1)->count();

    if ($received === 0) {
        $status = 'Belum Diberikan';
    } elseif ($received === $total) {
        $status = 'Sudah Diberikan';
    } else {
        $status = 'Sebagian Diterima';
    }

    return response()->json([
        'status' => $status,
        'total' => $total,
        'received' => $received,
    ]);
}

public function updateTTH(Request $request)
{
    $tthNo = $request->input('tthno');
    $received = $request->input('received');
    $reason = $request->input('failed_reason', null);

    DB::table('CustomerTTH')
        ->where('TTOTTPNo', $tthNo)
        ->update([
            'Received' => $received,
            'ReceivedDate' => now(),
            'Reason' => $reason,
        ]);

    return response()->json(['success' => true]);
}



}
