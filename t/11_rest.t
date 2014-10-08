use strict;
use Test::More;
use KiiCloud::REST;

my $kii = KiiCloud::REST->new(app_id => 'test', app_key => '123');
isa_ok $kii, 'KiiCloud::REST';
can_ok $kii, qw/uri endpoint_base_url app_id app_key agent/;

subtest uri_nopath => sub {
    my $uri = $kii->uri;
    isa_ok $uri, 'URI::http';
    is $uri->as_string, $kii->endpoint_base_url;
};

subtest uri_with_path => sub {
    my $uri = $kii->uri('path/to/hoge');
    isa_ok $uri, 'URI::http';
    is $uri->as_string, $kii->endpoint_base_url. '/path/to/hoge';
};

subtest agent => sub {
    is $kii->agent, $KiiCloud::REST::AGENT;
};

done_testing;
