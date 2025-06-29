<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => [
        'https://storage.googleapis.com',
        'https://annular-mercury-428001-f7.uc.r.appspot.com',
        'http://localhost:5173'
    ],
    'allowed_origins_patterns' => [
        '/^https?:\/\/(?:[a-zA-Z0-9-]+\.)*annular-mercury-428001-f7\.et\.r\.appspot\.com$/',
    ],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 3600,
    'supports_credentials' => false,
];