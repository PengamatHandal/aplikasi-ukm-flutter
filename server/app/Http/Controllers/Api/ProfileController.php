<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class ProfileController extends Controller
{
    public function update(Request $request)
    {
        $user = $request->user();

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'nim' => ['required', 'string', 'max:255', Rule::unique('users')->ignore($user->id)],
            'email' => ['required', 'string', 'email', 'max:255', Rule::unique('users')->ignore($user->id)],
            'foto_profil' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $user->name = $request->name;
        $user->nim = $request->nim;
        $user->email = $request->email;

        if ($request->hasFile('foto_profil')) {
            if ($user->foto_profil_url) {
                $oldPath = str_replace(asset(''), '', $user->foto_profil_url);
                Storage::disk('public')->delete($oldPath);
            }

            $path = $request->file('foto_profil')->store('avatars', 'public');
            $user->foto_profil_url = asset(Storage::url($path));
        }

        $user->save();

        if ($user->role === 'admin_ukm') {
            $user->load('ukmAdmin');
        }

        return response()->json([
            'message' => 'Profil berhasil diperbarui!',
            'user' => $user,
        ]);
    }
}