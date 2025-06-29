<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Ukm>
 */
class UkmFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'nama_ukm' => 'UKM ' . fake()->words(2, true),
            'deskripsi' => fake()->paragraph(3),
            'kategori' => fake()->randomElement(['Olahraga', 'Seni', 'Akademik', 'Kerohanian']),
            'is_pendaftaran_buka' => fake()->boolean(),
            'user_id' => User::factory(), // Secara default membuat user baru sebagai admin
        ];
    }
}
