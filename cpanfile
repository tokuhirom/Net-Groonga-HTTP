requires 'Data::Page';
requires 'Furl';
requires 'JSON::XS';
requires 'Mouse';
requires 'URI';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

