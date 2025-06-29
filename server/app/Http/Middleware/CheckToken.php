<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\JWTException;

class CheckToken
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {   
        try {
            if (!JWTAuth::parseToken()->getClaim('sub')) {
                return response()->json([
                    'status' => '401',
                    'error' => 'Unauthorized'
                ], 401);
            }
        } catch(TokenExpiredException $e) {
            return response()->json([
                'status' => '401',
                'error' => 'Token Expired'
            ], 401);
        } catch(JWTException $e) {
            return response()->json([
                'status' => '401',
                'error' => 'Token Empty, Could Not Parsed'
            ], 401);
        } 
        
        return $next($request);
    }
}
