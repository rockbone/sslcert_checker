# sslcert_checker

## DESCRIPTION

SSL certificate check by Perl

## USAGE

    sslcert_checker.pl --peer-port=995 --timeout=3 --localtime --no-check-certificate --no-header
    
        --peer-port             peer port.(default: 443)
        --timeout               timeout sec.(default: 3)
        --localtime             Convert Datetime(not_before, not_after) to localtime.
        --no-check-certificate  Do not check verification of certificate.
        --no-header             Output without header.
        --help                  Print help information.

- Output

    TAB separated text.
    [domain common_name ssl_version issuer subject subject_name issuer_name not_before not_after]

# LICENSE

Copyright (C) Tooru Tsurukawa.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Tooru Tsurukawa <rockbone.g at gmail.com>
