<?php

namespace App\Http\Requests\User;

use Illuminate\Foundation\Http\FormRequest;
use Tymon\JWTAuth\Facades\JWTAuth;

class UserUpdateRequest extends FormRequest
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
        $userId = $this->route('id'); // Misal, 'id' adalah parameter di route untuk update

         return [
            'email'         => 'required|email|max:255|unique:user,email,' . $userId,
            'level_akses'   => 'required|integer|in:1,2,3',
            'no_telepon'    => 'required|String|max:15',
            'nama'          => 'required|string|max:255',
        ];
    }
}
