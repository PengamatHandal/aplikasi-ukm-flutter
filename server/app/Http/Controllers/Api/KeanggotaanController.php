<?php

namespace App\Http\Controllers\Api;

use App\Models\Keanggotaan;
use App\Models\Ukm;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Notifications\NewMemberPending;

class KeanggotaanController extends Controller
{
    public function daftarUkm(Request $request, Ukm $ukm)
    {
        $user = $request->user();

        $jumlahUkmDiikuti = $user->ukmDiikuti()->count(); 

        if ($jumlahUkmDiikuti >= 4) {
            return response()->json(['message' => 'Anda sudah mencapai batas maksimal 4 UKM yang bisa diikuti.'], 403); // 403 Forbidden
        }

        // Cek apakah pendaftaran dibuka
        if (!$ukm->is_pendaftaran_buka) {
            return response()->json(['message' => 'Pendaftaran untuk UKM ini sedang ditutup.'], 403);
        }

        // Cek apakah user sudah terdaftar
        $existing = Keanggotaan::where('user_id', $user->id)->where('ukm_id', $ukm->id)->first();
        if ($existing) {
            return response()->json(['message' => 'Anda sudah terdaftar atau sedang dalam proses di UKM ini.'], 409);
        }

        $ukmAdmin = $ukm->admin;

        if ($ukmAdmin) {
            $ukmAdmin->notify(new NewMemberPending($request->user(), $ukm));
        }

        $keanggotaan = Keanggotaan::create([
            'user_id' => $user->id,
            'ukm_id' => $ukm->id,
            'status' => 'pending',
        ]);

        return response()->json([
            'message' => 'Pendaftaran berhasil! Mohon tunggu konfirmasi dari admin UKM.',
            'data' => $keanggotaan
        ], 201);
    }
}
