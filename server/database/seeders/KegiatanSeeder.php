<?php

namespace Database\Seeders;

use App\Models\Kegiatan;
use App\Models\Ukm;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class KegiatanSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
     public function run(): void
    {
        // Ambil semua ID UKM yang ada
        $ukmIds = Ukm::pluck('id');

        // Buat 15 kegiatan palsu untuk UKM yang ada secara acak
        for ($i=0; $i < 15; $i++) { 
            Kegiatan::factory()->create([
                'ukm_id' => $ukmIds->random()
            ]);
        }
    }
}
