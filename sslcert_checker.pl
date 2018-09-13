#!/usr/bin/env perl
use strict;
use warnings;
use Carp ();
use Getopt::Long qw/:config posix_default no_ignore_case bundling auto_help/;
use IO::Socket::SSL;
use Net::SSLeay;
use Time::Piece;

use constant {
    DEF_PEER_PORT   => 443,
    DEF_TIMEOUT     => 3,
};

GetOptions(\my %opt, qw/
    peer_port=i
    timeout=i
    localtime
    no-header
    no-check-certificate
    help
/);

usage() if $opt{help};

if (!$opt{"no-header"}) {
    print join("\t", qw/domain common_name ssl_version subject issuer subject_name issuer_name not_before not_after/) . "\n";
}

while (<>) {
    my %i;
    chomp($i{domain} = $_);
    my $sock = IO::Socket::SSL->new(
        PeerAddr    => "$i{domain}",
        PeerPort    => $opt{"peer-port"} || DEF_PEER_PORT,
        Timeout     => $opt{timeout}     || DEF_TIMEOUT,
        ($opt{"no-check-certificate"} ? (SSL_verify_mode => SSL_VERIFY_NONE) : ()),
    );
    if (!$sock) {
        warn "[$i{domain}] $! $@";
        next;
    }
    my @certs = $sock->peer_certificates();
    my $server_cert = $certs[0];
    $i{common_name}  = $sock->peer_certificate('commonName');
    $i{ssl_version}  = $sock->get_sslversion();
    $i{issuer}       = $sock->peer_certificate('issuer');
    $i{subject}      = $sock->peer_certificate('subject');
    $i{subject_name} = Net::SSLeay::X509_NAME_oneline(Net::SSLeay::X509_get_subject_name($server_cert));
    $i{issuer_name}  = Net::SSLeay::X509_NAME_oneline(Net::SSLeay::X509_get_issuer_name($server_cert));
    $i{not_before}   = Net::SSLeay::P_ASN1_TIME_get_isotime(Net::SSLeay::X509_get_notBefore($server_cert));
    $i{not_after}    = Net::SSLeay::P_ASN1_TIME_get_isotime(Net::SSLeay::X509_get_notAfter($server_cert));
    for my $key (qw/not_before not_after/){
        if ($opt{localtime}){
            $i{$key} = localtime(Time::Piece->strptime($i{$key}, '%Y-%m-%dT%H:%M:%SZ')->epoch())->strftime('%Y-%m-%d %H:%M:%S');
        }
        else {
            $i{$key} = Time::Piece->strptime($i{$key}, '%Y-%m-%dT%H:%M:%SZ')->strftime('%Y-%m-%d %H:%M:%S');
        }
    }
    print join("\t", @i{qw/domain common_name ssl_version issuer subject subject_name issuer_name not_before not_after/}) . "\n";
}

sub usage {
    exit print <<USAGE;
Usage:
    sslcert_checker.pl --peer-port=995 --timeout=3 --localtime --no-check-certificate --no-header

        --peer-port             peer port.(default: 443)
        --timeout               timeout sec.(default: 3)
        --localtime             Convert Datetime(not_before, not_after) to localtime.
        --no-check-certificate  Do not check verification of certificate.
        --no-header             Output without header.
        --help                  Print help information.
USAGE
}
