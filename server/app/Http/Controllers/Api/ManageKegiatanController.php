<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Kegiatan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class ManageKegiatanController extends Controller
{
    public function index(Request $request)
    {
        $ukm = $request->user()->ukmAdmin;
        if (!$ukm) {
            return response()->json(['message' => 'Anda bukan admin UKM.'], 403);
        }

        $kegiatans = $ukm->kegiatans()->latest()->get();
        return response()->json($kegiatans);
    }

    public function store(Request $request)
    {
        $ukm = $request->user()->ukmAdmin;
        if (!$ukm) {
            return response()->json(['message' => 'Anda bukan admin UKM.'], 403);
        }

        $validator = Validator::make($request->all(), [
            'judul' => 'required|string|max:255',
            'deskripsi' => 'required|string',
            'lokasi' => 'required|string',
            'tanggal_acara' => 'required|date',
            'gambar' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $gambarUrl = null;
        if ($request->hasFile('gambar')) {
            $path = $request->file('gambar')->store('images/kegiatan', 'public');
            $gambarUrl = asset(Storage::url($path));
        }

        $kegiatan = $ukm->kegiatans()->create([
            'judul' => $request->judul,
            'deskripsi' => $request->deskripsi,
            'lokasi' => $request->lokasi,
            'tanggal_acara' => $request->tanggal_acara,
            'gambar_url' => $gambarUrl,
        ]);

        return response()->json(['message' => 'Kegiatan berhasil dibuat!', 'data' => $kegiatan], 201);
    }

    public function update(Request $request, Kegiatan $kegiatan)
    {
        $ukm = $request->user()->ukmAdmin;
        if (!$ukm || $kegiatan->ukm_id !== $ukm->id) {
            return response()->json(['message' => 'Tidak diizinkan.'], 403);
        }
        $kegiatan->update($request->except('gambar'));

        return response()->json(['message' => 'Kegiatan berhasil diperbarui!', 'data' => $kegiatan]);
    }

    public function destroy(Request $request, Kegiatan $kegiatan)
    {
        $ukm = $request->user()->ukmAdmin;
        if (!$ukm || $kegiatan->ukm_id !== $ukm->id) {
            return response()->json(['message' => 'Tidak diizinkan.'], 403);
        }

        if ($kegiatan->gambar_url) {
            $oldPath = str_replace(asset(''), '', $kegiatan->gambar_url);
            Storage::disk('public')->delete($oldPath);
        }
        
        $kegiatan->delete();

        return response()->json(['message' => 'Kegiatan berhasil dihapus.']);
    }
}