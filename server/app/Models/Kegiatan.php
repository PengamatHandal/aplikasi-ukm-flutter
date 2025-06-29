<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Kegiatan extends Model
{
    protected $fillable = [
        'judul', 'deskripsi', 'gambar_url', 'tanggal_acara', 'lokasi', 'ukm_id',
    ];

    public function ukm()
    {
        return $this->belongsTo(Ukm::class);
    }
}
