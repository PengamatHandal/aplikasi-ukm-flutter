<?php

namespace Database\Seeders;

use App\Models\Keanggotaan;
use App\Models\Ukm;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class KeanggotaanSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $mahasiswaUsers = User::where('role', 'mahasiswa')->get();
        $ukms = Ukm::all();

        // Daftarkan setiap mahasiswa ke 1 sampai 3 UKM secara acak
        foreach ($mahasiswaUsers as $user) {
            $ukmToJoin = $ukms->random(rand(1, 3));
            foreach ($ukmToJoin as $ukm) {
                Keanggotaan::create([
                    'user_id' => $user->id,
                    'ukm_id' => $ukm->id,
                    'status' => fake()->randomElement(['pending', 'diterima', 'ditolak']),
                ]);
            }
        }
    }
}
