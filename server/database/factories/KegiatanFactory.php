<?php

namespace Database\Factories;

use App\Models\Ukm;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Kegiatan>
 */
class KegiatanFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
     public function definition(): array
    {
        return [
            'judul' => fake()->sentence(4),
            'deskripsi' => fake()->paragraph(5),
            'lokasi' => fake()->randomElement(['Aula Rektorat', 'Gedung A Ruang 401', 'Lapangan Utama']),
            'tanggal_acara' => fake()->dateTimeBetween('+1 week', '+3 months'),
            'ukm_id' => Ukm::factory(), // Secara default membuat UKM baru untuk kegiatan ini
        ];
    }
}
