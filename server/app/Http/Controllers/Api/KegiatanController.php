<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Kegiatan;
use Illuminate\Http\Request;

class KegiatanController extends Controller
{
    public function index(Request $request)
    {
        $query = Kegiatan::with('ukm:id,nama_ukm,kategori,logo_url');

        if ($request->has('search')) {
            $searchTerm = $request->search;
            $query->where('judul', 'like', "%{$searchTerm}%")
                ->orWhere('deskripsi', 'like', "%{$searchTerm}%");
        }

        if ($request->has('kategori')) {
            $kategori = $request->kategori;
            // Filter berdasarkan kategori di dalam relasi ukm
            $query->whereHas('ukm', function ($q) use ($kategori) {
                $q->where('kategori', $kategori);
            });
        }

        if ($request->has('tanggal')) {
            $tanggal = $request->tanggal;
            $query->whereDate('tanggal_acara', $tanggal);
        }

        $kegiatans = $query->latest('tanggal_acara')->paginate(10);

        return response()->json($kegiatans);
    }

    public function show(Kegiatan $kegiatan)
    {
        $kegiatan->load('ukm:id,nama_ukm,logo_url');
        return response()->json($kegiatan);
    }

    public function store(Request $request)
    {
    }

    public function update(Request $request, string $id)
    {
    }

    public function destroy(string $id)
    {
    }
}
