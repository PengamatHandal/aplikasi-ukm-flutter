<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class UkmProposal extends Model
{
    use HasFactory;
    protected $guarded = []; 

    public function proposer()
    {
        return $this->belongsTo(User::class, 'proposer_id');
    }
}
