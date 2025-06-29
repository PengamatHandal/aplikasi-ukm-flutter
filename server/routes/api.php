<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\KegiatanController;
use App\Http\Controllers\Api\UkmController;
use App\Http\Controllers\Api\KeanggotaanController;
use App\Http\Controllers\Api\UkmProposalController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\ManageUkmController;
use App\Http\Controllers\Api\ManageKegiatanController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\NotificationController;

// =======================================================
// Route Publik (Tidak Perlu Login/Token)
// =======================================================
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);

Route::apiResource('ukm', UkmController::class)->except(['update']);
Route::apiResource('kegiatan', KegiatanController::class)->only(['index', 'show']);


// =======================================================
// Route yang Dilindungi (WAJIB Login & Kirim Token)
// =======================================================
Route::middleware('auth:api')->group(function () {
    Route::get('/auth/user-profile', [AuthController::class, 'userProfile']);
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::post('/auth/refresh', [AuthController::class, 'refresh']);

    Route::post('/ukm/{ukm}/daftar', [KeanggotaanController::class, 'daftarUkm']);

    Route::post('/user/profile', [ProfileController::class, 'update']);

    Route::get('/my-ukm', [UkmController::class, 'myUkms']);
    
    // Mahasiswa mengajukan proposal
    Route::post('/proposal/ukm', [UkmProposalController::class, 'store']);

    // Super Admin melihat daftar proposal
    Route::get('/proposal/ukm', [UkmProposalController::class, 'index']);

    // Super Admin menyetujui proposal
    Route::post('/proposal/ukm/{proposal}/approve', [UkmProposalController::class, 'approve']);
    
    // Super Admin menolak proposal
    Route::post('/proposal/ukm/{proposal}/reject', [UkmProposalController::class, 'reject']);

    Route::get('/manage/ukm', [ManageUkmController::class, 'show']);
    Route::post('/manage/ukm/toggle-registration', [ManageUkmController::class, 'toggleRegistration']);
    Route::post('/manage/ukm/approve/{keanggotaan}', [ManageUkmController::class, 'approveMember']);
    Route::delete('/manage/ukm/remove/{keanggotaan}', [ManageUkmController::class, 'removeMember']);

    Route::get('/manage/kegiatan', [ManageKegiatanController::class, 'index']);
    Route::post('/manage/kegiatan', [ManageKegiatanController::class, 'store']);
    Route::post('/manage/kegiatan/{kegiatan}', [ManageKegiatanController::class, 'update']); // Menggunakan POST untuk update karena ada file upload
    Route::delete('/manage/kegiatan/{kegiatan}', [ManageKegiatanController::class, 'destroy']);

    Route::get('/notifications', [NotificationController::class, 'index']);
    Route::post('/notifications/mark-as-read', [NotificationController::class, 'markAllAsRead']);
});