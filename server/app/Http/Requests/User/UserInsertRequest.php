<?php

namespace App\Http\Requests\User;

use Illuminate\Foundation\Http\FormRequest;
use Tymon\JWTAuth\Facades\JWTAuth;

class UserInsertRequest extends FormRequest
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
            'email'         => 'required|email|max:255|unique:user,email',
            'password'      => 'required|string|min:8',
            'level_akses'   => 'required|integer|in:1,2,3',
            'foto_profil'   => 'required|file|image|mimes:jpg,jpeg,png|max:2048',
            'no_telepon'    => 'required|String|max:15',
            'nama'          => 'required|string|max:255',
        ];
    }
}
