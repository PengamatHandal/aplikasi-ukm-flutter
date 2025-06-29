<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Ukm;
use App\Models\UkmProposal;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class UkmProposalController extends Controller
{
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama_ukm' => 'required|string|max:255|unique:ukms|unique:ukm_proposals',
            'deskripsi' => 'required|string',
            'kategori' => 'required|string|max:100',
            'logo' => 'required|image|mimes:jpeg,png,jpg,gif|max:8048',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $path = $request->file('logo')->store('logos/ukm', 'public');

        $proposal = UkmProposal::create([
            'nama_ukm' => $request->nama_ukm,
            'deskripsi' => $request->deskripsi,
            'kategori' => $request->kategori,
            'logo_path' => $path,
            'proposer_id' => $request->user()->id,
            'status' => 'pending',
        ]);

        return response()->json(['message' => 'Proposal UKM berhasil diajukan!', 'data' => $proposal], 201);
    }

    public function index()
    {
        $proposals = UkmProposal::with('proposer:id,name,nim')->where('status', 'pending')->latest()->get();
        return response()->json($proposals);
    }

    public function approve(UkmProposal $proposal)
    {
        DB::transaction(function () use ($proposal) {
            $proposer = User::find($proposal->proposer_id);

            $newUkm = Ukm::create([
                'nama_ukm' => $proposal->nama_ukm,
                'deskripsi' => $proposal->deskripsi,
                'kategori' => $proposal->kategori,
                'logo_url' => asset('storage/' . $proposal->logo_path),
                'user_id' => $proposer->id, 
                'is_pendaftaran_buka' => false,
            ]);

            $proposer->role = 'admin_ukm';
            $proposer->save();

            $proposal->status = 'approved';
            $proposal->save();
        });

        return response()->json(['message' => 'Proposal UKM telah disetujui.']);
    }

    public function reject(Request $request, UkmProposal $proposal)
    {
        $validator = Validator::make($request->all(), [
            'reason' => 'required|string|max:500',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $proposal->status = 'rejected';
        $proposal->rejection_reason = $request->reason;
        $proposal->save();

        return response()->json(['message' => 'Proposal UKM telah ditolak.']);
    }
}