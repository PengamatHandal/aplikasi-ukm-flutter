<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Tymon\JWTAuth\Contracts\JWTSubject;

class User extends Authenticatable implements JWTSubject
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * Get the identifier that will be stored in the subject claim of the JWT.
     *
     * @return mixed
     */
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    /**
     * Return a key value array, containing any custom claims to be added to the JWT.
     *
     * @return array
     */
    public function getJWTCustomClaims()
    {
        return [];
    }
    
    /**
     * The attributes that are mass assignable.
     * Atribut yang bisa diisi secara massal saat membuat/update user.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'nim',
        'email',
        'password',
        'foto_profil_url',
        'role',
    ];

    /**
     * The attributes that should be hidden for serialization.
     * Atribut yang disembunyikan saat data diubah menjadi JSON (untuk keamanan).
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token', 
    ];

    /**
     * The attributes that should be cast.
     * Mengubah tipe data atribut secara otomatis.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];

    public function ukmAdmin()
    {
        return $this->hasOne(Ukm::class, 'user_id');
    }

    public function ukmDiikuti()
    {
        return $this->belongsToMany(Ukm::class, 'keanggotaans')->withPivot('status')->withTimestamps();
    }
}