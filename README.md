# sslcert_checker

## SYNOPSIS

    $ echo -n imap.gmail.com|./sslcert_checker.pl --peer-port=993 --timeout=3 --localtime --no-header
    imap.gmail.com	imap.gmail.com	TLSv1_2	/C=US/O=Google Trust Services/CN=Google Internet Authority G3	/C=US/ST=California/L=Mountain View/O=Google LLC/CN=imap.gmail.com	2018-08-21 17:05:37	2018-11-13 17:05:00

## DESCRIPTION

SSL certificate check by Perl

## USAGE

    sslcert_checker.pl --peer-port=995 --timeout=3 --localtime --no-check-certificate --no-header DOMAIN_LIST.txt
    
        DOMAIN_LIST.txt         Plain text file. Domain list separated by line break.(You can also input into STDIN.)
    
        --peer-port             peer port.(default: 443)
        --timeout               timeout sec.(default: 3)
        --localtime             Convert Datetime(not_before, not_after) to localtime.
        --no-check-certificate  Do not check verification of certificate.
        --no-header             Output without header.
        --help                  Print help information.

- Output

    TAB separated text.
    [domain common_name ssl_version subject issuer not_before not_after]

# LICENSE

Copyright (C) Tooru Tsurukawa.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Tooru Tsurukawa <rockbone.g at gmail.com>
