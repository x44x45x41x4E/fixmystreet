package FixMyStreet::Cobrand::Cambridgeshire;
use base 'FixMyStreet::Cobrand::UKCouncils';

use strict;
use warnings;

sub open311_config {
    my ($self, $row, $h, $params, $revert) = @_;

    $$revert = 1;
}

sub open311_pre_send {
    my ($self, $row, $open311) = @_;

    # required to get round issues with CRM constraints
    $row->user->name( $row->user->id . ' ' . $row->user->name );
}

1;

