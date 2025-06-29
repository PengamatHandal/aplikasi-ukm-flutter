<?php

namespace Database\Seeders;

use App\Models\Ukm;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class UkmSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $adminFutsal = User::where('email', 'admin.futsal@unpam.ac.id')->first();
        
        Ukm::create([
            'nama_ukm' => 'UKM Futsal Victory',
            'deskripsi' => 'Unit Kegiatan Mahasiswa untuk para pecinta futsal di Universitas Pamulang.',
            'kategori' => 'Olahraga',
            'is_pendaftaran_buka' => true,
            'user_id' => $adminFutsal->id,
        ]);

        $users = User::where('role', 'mahasiswa')->get();
        for ($i=0; $i < 5; $i++) { 
            Ukm::factory()->create([
                'user_id' => $users->random()->id
            ]);
        }
    }
}
