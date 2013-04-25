package Net::Groonga::Pager;
use strict;
use warnings;
use utf8;

use Mouse;

has offset => (is => 'ro', isa => 'Int', required => 1);
has limit  => (is => 'ro', isa => 'Int', required => 1);
has total_entries => (is => 'ro', isa => 'Int', required => 1);

no Mouse;

sub has_next {
    my ($self) = @_;
    return $self->limit + $self->offset < $self->total_entries;
}

1;
