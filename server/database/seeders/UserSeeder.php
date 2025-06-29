<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::create([
            'name' => 'Super Admin',
            'nim' => '297654123',
            'email' => 'superadmin@unpam.ac.id',
            'password' => Hash::make('tes'),
            'role' => 'super_admin',
        ]);

        User::create([
            'name' => 'Futsal Base Community',
            'nim' => '221011407652',
            'email' => 'admin.futsal@unpam.ac.id',
            'password' => Hash::make('tes'),
            'role' => 'admin_ukm',
        ]);

        User::factory(20)->create();
    }
}
