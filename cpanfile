requires 'perl', '5.008001';
requires 'Furl';
requires 'URI';
requires 'JSON';
requires 'String::CamelCase';
requires 'HTTP::Request';
requires 'HTTP::Headers';
requires 'Module::Pluggable';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

