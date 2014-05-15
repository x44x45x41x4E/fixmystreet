package FixMyStreet::Cobrand::WestBerkshire;
use base 'FixMyStreet::Cobrand::UKCouncils';

use strict;
use warnings;

# non standard west berks end points
sub open311_pre_send {
    my ($self, $row, $open311) = @_;
    $open311->endpoints( { services => 'Services', requests => 'Requests' } );
}

# temporary fix to resolve some issues with west berks
sub open311_zero_result_on_fail {
    1;
}

1;

