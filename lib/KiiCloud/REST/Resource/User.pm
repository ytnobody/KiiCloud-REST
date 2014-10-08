package KiiCloud::REST::Resource::User;
use strict;
use warnings;
use parent 'KiiCloud::REST::Resource';

sub create {
    my ($self, %opts) = @_;
    $self->rest->req(POST => 'users', type => 'application/vnd.kii.RegistrationRequest+json', data => {%opts});      
}

1;
