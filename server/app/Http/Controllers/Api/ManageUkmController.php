<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Keanggotaan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;

class ManageUkmController extends Controller
{
    public function show(Request $request)
    {

        $admin = $request->user();
        $ukm = $admin->ukmAdmin; 

        if (!$ukm) {
            return response()->json(['message' => 'Anda bukan admin dari UKM manapun atau UKM tidak ditemukan.'], 404);
        }

        $ukm->load(['anggota' => function ($query) {
            $query->where('keanggotaans.status', 'diterima');
        }]);
        
        $pendingAnggota = Keanggotaan::with('user:id,name,nim')
                            ->where('ukm_id', $ukm->id)
                            ->where('status', 'pending')
                            ->latest()
                            ->get();
        
        $approvedAnggota = Keanggotaan::with('user:id,name,nim')
                        ->where('ukm_id', $ukm->id)
                        ->where('status', 'diterima')
                        ->latest()->get();                    

        return response()->json([
            'ukm' => $ukm,
            'pending_anggota' => $pendingAnggota,
            'approved_anggota' => $approvedAnggota,
        ]);
    }

    public function toggleRegistration(Request $request)
    {
        $ukm = $request->user()->ukmAdmin;
        $ukm->is_pendaftaran_buka = !$ukm->is_pendaftaran_buka;
        $ukm->save();

        return response()->json([
            'message' => 'Status pendaftaran berhasil diubah.',
            'is_pendaftaran_buka' => $ukm->is_pendaftaran_buka,
        ]);
    }

    public function approveMember(Request $request, Keanggotaan $keanggotaan)
    {
        if ($request->user()->ukmAdmin->id !== $keanggotaan->ukm_id) {
            return response()->json(['message' => 'Tidak diizinkan.'], 403);
        }
        
        $keanggotaan->status = 'diterima';
        $keanggotaan->save();

        return response()->json(['message' => 'Anggota berhasil disetujui.']);
    }

    public function removeMember(Request $request, Keanggotaan $keanggotaan)
    {
         if ($request->user()->ukmAdmin->id !== $keanggotaan->ukm_id) {
            return response()->json(['message' => 'Tidak diizinkan.'], 403);
        }

        $keanggotaan->delete();

        return response()->json(['message' => 'Anggota berhasil dikeluarkan.']);
    }
}