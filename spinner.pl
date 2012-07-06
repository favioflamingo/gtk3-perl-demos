#!/usr/bin/perl
#
# Spinner
#
# GtkSpinner allows to show that background activity is on-going.
#

use strict;
use warnings;

use Gtk3 '-init';
use Glib 'TRUE', 'FALSE';

my $window;
my ( $spinner, $spinner2 );
do_spinner();

Gtk3->main();

sub do_spinner {
    if ( !$window ) {
        $window = Gtk3::Dialog->new();
        $window->set_title('GtkSpinner');
        $window->set_resizable(FALSE);
        $window->add_button( 'gtk-close', 1 );

        $window->signal_connect( response => sub { Gtk3->main_quit } );
        $window->signal_connect( destroy  => sub { Gtk3->main_quit } );

        my $icon = 'gtk-logo-rgb.gif';
        if ( -e $icon ) {
            my $pixbuf = Gtk3::Gdk::Pixbuf->new_from_file('gtk-logo-rgb.gif');
            my $transparent = $pixbuf->add_alpha( TRUE, 0xff, 0xff, 0xff );
            $window->set_icon($transparent);
        }

        my $box = Gtk3::Box->new( 'vertical', 5 );
        $window->get_content_area()->add($box);
        $box->set_border_width(5);
        $box->set_homogeneous(FALSE);

        # Sensitive
        my $hbox = Gtk3::Box->new( 'horizontal', 5 );
        $hbox->set_homogeneous(FALSE);
        $spinner = Gtk3::Spinner->new();
        $hbox->add($spinner);
        $hbox->add( Gtk3::Entry->new() );
        $box->add($hbox);

        # Disabled
        $hbox = Gtk3::Box->new( 'horizontal', 5 );
        $hbox->set_homogeneous(FALSE);
        $spinner2 = Gtk3::Spinner->new();
        $hbox->add($spinner2);
        $hbox->add( Gtk3::Entry->new() );
        $box->add($hbox);
        $hbox->set_sensitive(FALSE);

        my $play_btn = Gtk3::Button->new_from_stock('gtk-media-play');
        $play_btn->signal_connect( clicked => \&on_play_clicked );
        $box->add($play_btn);

        my $stop_btn = Gtk3::Button->new_from_stock('gtk-media-stop');
        $stop_btn->signal_connect( clicked => \&on_stop_clicked );
        $box->add($stop_btn);

        on_play_clicked( undef, undef );

    }

    if ( !$window->get_visible ) {
        $window->show_all();
    } else {
        $window->destroy();
    }

    return $window;
}

sub on_play_clicked {
    $spinner->start();
    $spinner2->start();
}

sub on_stop_clicked {
    $spinner->stop();
    $spinner2->stop();
}

1;
