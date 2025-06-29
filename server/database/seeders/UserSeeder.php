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
        // 1. Buat Super Admin
        User::create([
            'name' => 'Super Admin',
            'nim' => '000000000000',
            'email' => 'superadmin@unpam.ac.id',
            'password' => Hash::make('password'),
            'role' => 'super_admin',
        ]);

        // 2. Buat Admin UKM
        User::create([
            'name' => 'Admin UKM Futsal',
            'nim' => '111111111111',
            'email' => 'admin.futsal@unpam.ac.id',
            'password' => Hash::make('password'),
            'role' => 'admin_ukm',
        ]);

        // 3. Buat 20 user mahasiswa menggunakan factory
        User::factory(20)->create();
    }
}
