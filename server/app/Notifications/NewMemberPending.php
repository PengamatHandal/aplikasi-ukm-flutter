<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;
use App\Models\User; // User yang mendaftar
use App\Models\Ukm;  // UKM yang dituju

class NewMemberPending extends Notification
{
    use Queueable;

    protected $applicant;
    protected $ukm;

    public function __construct(User $applicant, Ukm $ukm)
    {
        $this->applicant = $applicant;
        $this->ukm = $ukm;
    }

    public function via(object $notifiable): array
    {
        return ['database']; // Kita akan simpan notifikasi ini di database
    }

    // Mendefinisikan data yang akan disimpan di database
    public function toDatabase(object $notifiable): array
    {
        return [
            'applicant_id' => $this->applicant->id,
            'applicant_name' => $this->applicant->name,
            'ukm_id' => $this->ukm->id,
            'ukm_name' => $this->ukm->nama_ukm,
            'message' => "{$this->applicant->name} telah mendaftar ke UKM {$this->ukm->nama_ukm}. Segera review pendaftarannya."
        ];
    }
}