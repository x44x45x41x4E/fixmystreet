package FixMyStreet::Cobrand::Oxfordshire;
use base 'FixMyStreet::Cobrand::UKCouncils';

use strict;
use warnings;

sub council_id { return 2237; }
sub council_area { return 'Oxfordshire'; }
sub council_name { return 'Oxfordshire County Council'; }
sub council_url { return 'oxfordshire'; }
sub is_two_tier { return 1; }

sub base_url {
    return FixMyStreet->config('BASE_URL') if FixMyStreet->config('STAGING_SITE');
    return 'http://fixmystreet.oxfordshire.gov.uk';
}

# Different to councils parent due to this being a two-tier council. If we get
# more, this can be genericised in the parent.
sub problems_clause {
    return { bodies_str => { like => '%2237%' } };
}

sub path_to_web_templates {
    my $self = shift;
    return [
        FixMyStreet->path_to( 'templates/web', $self->moniker )->stringify,
        FixMyStreet->path_to( 'templates/web/fixmystreet' )->stringify
    ];
}

sub enter_postcode_text {
    my ($self) = @_;
    return 'Enter an Oxfordshire postcode, or street name and area';
}

sub disambiguate_location {
    my $self    = shift;
    my $string  = shift;
    return {
        %{ $self->SUPER::disambiguate_location() },
        town   => 'Oxfordshire',
        centre => '51.765765,-1.322324',
        span   => '0.709058,0.849434',
        bounds => [ 51.459413, -1.719500, 52.168471, -0.870066 ],
    };
}

sub example_places {
    return ( 'OX20 1SZ', 'Park St, Woodstock' );
}

# don't send questionnaires to people who used the OCC cobrand to report their problem
sub send_questionnaires { return 0; }

# increase map zoom level so street names are visible
sub default_map_zoom { return 3; }

# let staff hide OCC reports
sub users_can_hide { return 1; }

sub default_show_name { 0 }

sub open311_config {
    my ($self, $row, $h, $params, $revert) = @_;

    $$revert = 1;

    my $extra = $row->extra;
    push @$extra, { name => 'external_id', value => $row->id };

    if ($h->{closest_address}) {
        push @$extra, { name => 'closest_address', value => $h->{closest_address} } 
    }
    if ( $row->used_map || ( !$row->used_map && !$row->postcode ) ) {
        push @$extra, { name => 'northing', value => $h->{northing} };
        push @$extra, { name => 'easting', value => $h->{easting} };
    }
    $row->extra( $extra );

    $params->{extended_description} = 'oxfordshire';
}

sub open311_pre_send {
    my ($self, $row, $open311) = @_;
    $open311->endpoints( { requests => 'open311_service_request.cgi' } );
}

1;

