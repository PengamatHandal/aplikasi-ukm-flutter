<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Ukm extends Model
{
    use HasFactory;

    protected $fillable = [
        'nama_ukm', 'deskripsi', 'logo_url', 'kategori', 'is_pendaftaran_buka', 'user_id',
    ];

    protected $casts = [
        'is_pendaftaran_buka' => 'boolean', 
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    public function admin()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function kegiatans()
    {
        return $this->hasMany(Kegiatan::class);
    }

    public function anggota()
    {
        return $this->belongsToMany(User::class, 'keanggotaans')->withPivot('status')->withTimestamps();
    }

    
}
