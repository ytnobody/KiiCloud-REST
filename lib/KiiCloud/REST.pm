package KiiCloud::REST;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";
our $ENDPOINT_BASE_URL = 'https://api-jp.kii.com/api/apps';
our $TIMEOUT = 5;
our $AGENT;
our $JSON;
our $AUTOLOAD;

use Furl;
use JSON;
use URI;
use Module::Pluggable search_path => __PACKAGE__.'::Resource', sub_name => 'resources', require => 1;
use String::CamelCase ();
use HTTP::Request;
use HTTP::Headers;

use Class::Accessor::Lite (
    ro => [qw/endpoint_base_url app_id app_key/],
    new => 0,
);

__PACKAGE__->resources;

sub AUTOLOAD {
    my $self = shift;
    my $package = __PACKAGE__;
    my ($method) = $AUTOLOAD =~ /^$package\:\:(.+?)$/;
    my $subclass = join '::', $package, 'Resource', String::CamelCase::camelize($method);
    $subclass->new(rest => $self);
}

sub new {
    my ($class, %opts) = @_;
    $opts{endpoint_base_url} ||= $ENDPOINT_BASE_URL;
    bless { %opts }, $class;
}

sub uri {
    my ($self, $path) = @_;
    my $uri = URI->new($self->endpoint_base_url);
    if ($path) {
        $path = "/$path" unless $path =~ /^\//;
        $uri->path($uri->path. $path);
    }
    $uri;
}

sub agent {
    $AGENT ||= Furl->new( agent => __PACKAGE__.'/'.$VERSION, timeout => $TIMEOUT );
    $AGENT;
}

sub json {
    $JSON ||= JSON->new->utf8(1);
    $JSON;
}

sub make_req {
    my ($self, $method, $path, %opts) = @_;

    my $type = $opts{type};
    my $data = $opts{data};

    my $uri = $self->uri($self->app_id. '/'. $path);

    my $header = HTTP::Headers->new;
    $header->header(
        'Content-Type' => $type,
        'x-kii-appid'  => $self->app_id,
        'x-kii-appkey' => $self->app_key
    );

    my $content = $self->json->encode($data);

    HTTP::Request->new($method => $uri, $header, $content);
}

sub req {
    my $self = shift;
    my $req = $self->make_req(@_);
    $ENV{KII_REQ_DEBUG} ? $req : $self->agent->request($req);
}

sub DESTROY {}

1;
__END__

=encoding utf-8

=head1 NAME

KiiCloud::REST - It's new $module

=head1 SYNOPSIS

    use KiiCloud::REST;

=head1 DESCRIPTION

KiiCloud::REST is ...

=head1 LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=cut

