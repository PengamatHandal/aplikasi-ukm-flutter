<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('ukm_proposals', function (Blueprint $table) {
        $table->id();
        $table->string('nama_ukm');
        $table->text('deskripsi');
        $table->string('kategori');
        $table->string('logo_path'); // Kita simpan path filenya, bukan URL lengkap
        $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending');
        $table->text('rejection_reason')->nullable(); // Alasan jika ditolak

        // Foreign key ke user yang mengajukan
        $table->foreignId('proposer_id')->constrained('users');

        $table->timestamps();
    });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('ukm_proposals');
    }
};
