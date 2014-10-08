use strict;
use utf8;
use Test::More;
use KiiCloud::REST;

$ENV{KII_REQ_DEBUG} = 1; ## $kii->req returns HTTP::Request object

my $kii = KiiCloud::REST->new(app_id => 'test', app_key => '123');

my $resource = $kii->user;
isa_ok $resource, 'KiiCloud::REST::Resource::User';

subtest create => sub {
    my $req = $kii->user->create(
        loginName   => 'tonkichi', 
        displayName => 'とんきち',
        country     => 'JP',
        password    => 'unkounko',
    );
    
    is $req->header('Content-Type'), 'application/vnd.kii.RegistrationRequest+json';
    is $req->header('x-kii-appid'), $kii->app_id;
    is $req->header('x-kii-appkey'), $kii->app_key;
};

done_testing;
