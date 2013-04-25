package Net::Groonga::HTTP::Response;
use strict;
use warnings;
use utf8;
use JSON::XS qw(decode_json);
use Data::Page;
use Net::Groonga::Pager;

use Mouse;

has function => (
    is => 'rw',
    required => 1,
);

has args => (
    is => 'rw',
    required => 1,
);

has http_response => (
    is => 'rw',
    required => 1,
);

has data => (
    is => 'rw',
    builder => '_build_data',
);

no Mouse;

sub is_success {
    my $self = shift;
    return $self->http_response->code eq 200 && $self->return_code == 0;
}

sub _build_data {
    my $self = shift;
    return undef if $self->http_response->code ne 200;
    decode_json($self->http_response->content);
}

sub return_code {
    my $self = shift;
    Carp::croak(sprintf("%s:%s", $self->function, $self->http_response->status_line)) unless $self->data;
    $self->data->[0]->[0];
}

sub start_time {
    my $self = shift;
    Carp::croak(sprintf("%s:%s", $self->function, $self->http_response->status_line)) unless $self->data;
    $self->data->[0]->[1];
}

sub elapsed_time {
    my $self = shift;
    Carp::croak(sprintf("%s:%s", $self->function, $self->http_response->status_line)) unless $self->data;
    $self->data->[0]->[2];
}

sub result {
    my $self = shift;
    Carp::croak(sprintf("%s:%s", $self->function, $self->http_response->status_line)) unless $self->data;
    $self->data->[1];
}

sub pager {
    my $self = shift;
    return unless $self->data;
    return unless $self->return_code == 0;

    my $total_entries = $self->data->[1]->[0]->[0]->[0];
    my $limit  = $self->args->{limit}  || 10;
    my $offset = $self->args->{offset} || 0;

    Net::Groonga::Pager->new(
        limit  => $limit,
        offset => $offset,
        total_entries => $total_entries,
    );
}

sub rows {
    my $self = shift;
    return unless $self->data;

    my @rows = @{$self->data->[1]->[0]};
    my $cnt    = shift @rows;
    my $header = shift @rows;
    my @results;
    for my $row (@rows) {
        my %args;
        for (my $i=0; $i<@$header; ++$i) {
            my $key = $header->[$i]->[0];
            my $val = $row->[$i];
            $args{$key} = $val;
        }
        push @results, \%args;
    }
    return @results;
}

1;

