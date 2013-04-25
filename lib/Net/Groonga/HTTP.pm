package Net::Groonga::HTTP;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.01";

use JSON::XS qw(encode_json decode_json);
use Furl;
use URI;
use Net::Groonga::HTTP::Response;

use Mouse;

has end_point => ( is => 'ro' );

has ua => (
    is => 'ro',
    default => sub {
        Furl->new(
            agent => "Net::Groonga::HTTP",
            timeout => 3
        )
    }
);

no Mouse;

sub construct_api_url {
    my ($self, $name, %args) = @_;
    my $url = $self->end_point;
    $url =~ s!/$!!;
    my $uri = URI->new("$url/$name");
    $uri->query_form(%args);
    $uri;
}

sub call {
    my ($self, $function, %args) = @_;
    my $url = $self->construct_api_url($function, %args);
    my $res = $self->ua->get($url);
    return Net::Groonga::HTTP::Response->new(
        function      => $function,
        http_response => $res,
        args          => \%args,
    );
}

my @functions = qw(
    table_create
    status
    select
    delete
);
for my $function (@functions) {
    no strict 'refs';
    *{__PACKAGE__ . "::${function}"} = sub {
        my ($self, %args) = @_;
        $self->call($function, %args);
    };
}

sub load {
    my ($self, %args) = @_;
    $args{values} = encode_json($args{values}) if ref $args{values};
    return $self->call('load', %args);
}


1;
__END__

=encoding utf-8

=head1 NAME

Net::Groonga::HTTP - Client library for Groonga httpd.

=head1 SYNOPSIS

    use Net::Groonga::HTTP;

    my $groonga = Net::Groonga::HTTP->new(
        end_point => 'http://127.0.0.1:10041/d/',
    );
    my $res = $groonga->status();
    use Data::Dumper; warn Dumper($res);


=head1 DESCRIPTION

Net::Groonga::HTTP is a client library for Groonga http server.

Groonga is a fast full text search engine. Please look L<http://groonga.org/>.

=head1 LICENSE

Copyright (C) tokuhirom.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

tokuhirom E<lt>tokuhirom@gmail.comE<gt>

=cut

