package FixMyStreet::Cobrand::Bromley;
use parent 'FixMyStreet::Cobrand::UKCouncils';

use strict;
use warnings;

sub council_id { return 2482; }
sub council_area { return 'Bromley'; }
sub council_name { return 'Bromley Council'; }
sub council_url { return 'bromley'; }

sub base_url {
    return FixMyStreet->config('BASE_URL') if FixMyStreet->config('STAGING_SITE');
    return 'https://fix.bromley.gov.uk';
}

sub path_to_web_templates {
    my $self = shift;
    return [
        FixMyStreet->path_to( 'templates/web', $self->moniker )->stringify,
        FixMyStreet->path_to( 'templates/web/fixmystreet' )->stringify
    ];
}

sub disambiguate_location {
    my $self    = shift;
    my $string  = shift;

    my $town = 'Bromley';
    # Bing turns High St Bromley into Bromley High St which is in 
    # Bromley by Bow.
    $town .= ', BR1' if $string =~ /^high\s+st(reet)?$/i;
    $town = '' if $string =~ /orpington/i;
    return {
        %{ $self->SUPER::disambiguate_location() },
        town => $town,
        centre => '51.366836,0.040623',
        span   => '0.154963,0.24347',
        bounds => [ 51.289355, -0.081112, 51.444318, 0.162358 ],
    };
}

sub example_places {
    return ( 'BR1 3UH', 'Glebe Rd, Bromley' );
}

sub map_type {
    'Bromley';
}

sub on_map_default_max_pin_age {
    return '1 month';
}

# Bromley pins always yellow
sub pin_colour {
    my ( $self, $p, $context ) = @_;
    return 'yellow';
}

sub recent_photos {
    my ( $self, $area, $num, $lat, $lon, $dist ) = @_;
    $num = 3 if $num > 3 && $area eq 'alert';
    return $self->problems->recent_photos( $num, $lat, $lon, $dist );
}

sub send_questionnaires {
    return 0;
}

sub ask_ever_reported {
    return 0;
}

sub process_extras {
    my $self = shift;
    $self->SUPER::process_extras( @_, [ 'first_name', 'last_name' ] );
}

sub contact_email {
    my $self = shift;
    return join( '@', 'info', 'bromley.gov.uk' );
}
sub contact_name { 'Bromley Council (do not reply)'; }

sub reports_per_page { return 20; }

sub tweak_all_reports_map {
    my $self = shift;
    my $c = shift;

    if ( !$c->stash->{ward} ) {
        $c->stash->{map}->{longitude} = 0.040622967881348;
        $c->stash->{map}->{latitude} = 51.36690161822;
        $c->stash->{map}->{any_zoom} = 0;
        $c->stash->{map}->{zoom} = 11;
    }
}

sub title_list {
    return ["MR", "MISS", "MRS", "MS", "DR"];
}

sub open311_config {
    my ($self, $row, $h, $params) = @_;

    $params->{revert}++;

    my $extra = $row->extra;
    if ( $row->used_map || ( !$row->used_map && !$row->postcode ) ) {
        push @$extra, { name => 'northing', value => $h->{northing} };
        push @$extra, { name => 'easting', value => $h->{easting} };
    }
    push @$extra, 
        { name => 'report_url',
          value => $h->{url} },
        { name => 'service_request_id_ext',
          value => $row->id },
        { name => 'report_title',
          value => $row->title },
        { name => 'public_anonymity_required',
          value => $row->anonymous ? 'TRUE' : 'FALSE' },
        { name => 'email_alerts_requested',
          value => 'FALSE' }, # always false as can never request them
        { name => 'requested_datetime',
          value => DateTime::Format::W3CDTF->format_datetime($row->confirmed->set_nanosecond(0)) },
        { name => 'email',
          value => $row->user->email };

    # make sure we have last_name attribute present in row's extra, so
    # it is passed correctly to Bromley as attribute[]
    if ( $row->cobrand ne 'bromley' ) {
        my ( $firstname, $lastname ) = ( $row->name =~ /(\w+)\.?\s+(.+)/ );
        push @$extra, { name => 'last_name', value => $lastname };
    }

    $row->extra( $extra );

    $params->{always_send_latlong} = 0;
    $params->{send_notpinpointed} = 1;
    $params->{use_service_as_deviceid} = 0;
    $params->{extended_description} = 0;
}

1;

