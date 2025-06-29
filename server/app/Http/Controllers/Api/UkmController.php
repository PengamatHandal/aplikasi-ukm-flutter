<?php

namespace App\Http\Controllers\Api;
use Illuminate\Support\Facades\Validator;

use App\Http\Controllers\Controller;
use App\Models\Ukm;
use Illuminate\Http\Request;
use App\Models\User;

use Illuminate\Support\Facades\Storage;

class UkmController extends Controller
{
    public function index()
    {
        $ukms = Ukm::with('admin:id,name')->latest()->get();
        return response()->json($ukms);
    }

    public function show(Ukm $ukm)
    {
        $ukm->load('kegiatans', 'anggota'); 
        return response()->json($ukm);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama_ukm' => 'required|string|max:255|unique:ukms',
            'deskripsi' => 'required|string',
            'kategori' => 'required|string|max:100',
            'logo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:8048', 
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $adminUser = $request->user();
        $logoUrl = null;

        if ($request->hasFile('logo')) {
            // Simpan file ke folder public/storage/logos/ukm dan dapatkan path-nya
            $path = $request->file('logo')->store('logos/ukm', 'public');
            $logoUrl = asset(Storage::url($path));
        }

        $ukm = Ukm::create([
            'nama_ukm' => $request->nama_ukm,
            'deskripsi' => $request->deskripsi,
            'kategori' => $request->kategori,
            'logo_url' => $logoUrl, // Simpan URL ke database
            'user_id' => $adminUser->id,
            'is_pendaftaran_buka' => false,
        ]);

        $adminUser->role = 'admin_ukm';
        $adminUser->save();

        return response()->json([
            'message' => 'UKM berhasil dibuat!',
            'data' => $ukm
        ], 201);
    }

    public function myUkms(Request $request)
    {
        $user = $request->user();

        $ukms = $user->ukmDiikuti()->where('status', 'diterima')->get();

        return response()->json($ukms);
    }

    public function update(Request $request, string $id)
    {
    }

    public function destroy(Request $request, Ukm $ukm)
    {
        // $user = $request->user();

        // // Otorisasi: Pastikan hanya super_admin atau pemilik UKM yang bisa menghapus
        // if ($user->role !== 'super_admin' && $user->id !== $ukm->user_id) {
        //     return response()->json(['message' => 'Anda tidak memiliki izin untuk menghapus UKM ini.'], 403);
        // }

        $adminId = $ukm->user_id;

        if ($ukm->getRawOriginal('logo_url')) {
            Storage::disk('public')->delete($ukm->getRawOriginal('logo_url'));
        }
        
        $ukm->delete();

        $formerAdmin = User::find($adminId);

        if ($formerAdmin) {
            $formerAdmin->role = 'mahasiswa';
            $formerAdmin->save();
        }

        return response()->json(['message' => 'UKM berhasil dihapus dan role admin telah direset.']);
    }
}
