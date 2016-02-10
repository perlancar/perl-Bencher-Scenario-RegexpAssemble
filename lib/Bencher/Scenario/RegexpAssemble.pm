package Bencher::Scenario::RegexpAssemble;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

$main::chars = ["a".."z"];

my $code_template_assemble_with_ra = 'my $ra = Regexp::Assemble->new; for (1.. <num> ) { $ra->add(join("", map {$main::chars->[rand @$main::chars]} 1..10)) } $ra->re';
my $code_template_assemble_raw     = 'my @strs; for (1.. <num> ) { push @strs, join("", map {$main::chars->[rand @$main::chars]} 1..10) } my $re = "\\\\A(?:".join("|", map {quotemeta} sort {length($b) <=> length($a)} @strs).")\\\\z"; $re = qr/$re/';

our $scenario = {
    summary => 'Benchmark arbitrary size floating point arithmetics',
    participants => [
        {
            name => 'assemble-with-ra',
            module=>'Regexp::Assemble',
            code_template => $code_template_assemble_with_ra,
            tags => ['assembling'],
        },
        {
            name => 'assemble-raw',
            code_template => $code_template_assemble_raw,
            tags => ['assembling'],
        },
        {
            name => 'match-with-ra',
            module=>'Regexp::Assemble',
            code_template => 'state $re = do { ' . $code_template_assemble_with_ra . ' }; state $str = join("", map {$main::chars->[rand @$main::chars]} 1..10); $str =~ $re',
            tags => ['matching'],
        },
        {
            name => 'match-raw',
            code_template => 'state $re = do { ' . $code_template_assemble_raw     . ' }; state $str = join("", map {$main::chars->[rand @$main::chars]} 1..10); $str =~ $re',
            tags => ['matching'],
        },
    ],
    datasets => [
        {name=>'10str'   , args=>{num=>10   }},
        {name=>'100str'  , args=>{num=>100  }},
        {name=>'1000str' , args=>{num=>1000 }},
        {name=>'10000str', args=>{num=>10000}},
    ],
};

1;
# ABSTRACT:
