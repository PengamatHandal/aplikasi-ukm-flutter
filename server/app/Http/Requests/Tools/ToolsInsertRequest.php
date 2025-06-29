<?php

namespace App\Http\Requests\Tools;

use Illuminate\Foundation\Http\FormRequest;
use Tymon\JWTAuth\Facades\JWTAuth;

class ToolsInsertRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        // Only admin
        return JWTAuth::parseToken()->authenticate()->level_akses === '1';
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
         return [
            'nomor_tools'   => 'required|string|max:90|unique:tools,nomor_tools',
            'nama'          => 'required|string|max:255',
            'rak'           => 'string|max:100',
            'nomor_rak'     => 'integer|max:500',
            'tipe'          => 'required|string|max:25',
            'info'          => 'string',
            'gambar'        => 'file|image|mimes:jpg,jpeg,png|max:8048',
            'stok'          => 'integer',
        ];
    }
}
