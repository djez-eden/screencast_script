#!/usr/bin/perl
#====================================================================
# 
# Description: Script pour lancer un Screencast rapidement.
# 	execute le script et clique sur la fenetre a enregister ou 
#	le bureau, le record ce lance. 
#	/!\ a adapter en fonction des config.
#	/!\ script ecrie completement a l'arache ;-)
#
# Auteur : djez eden <djez[DoT]depannage{AT}gmail(dOt)com>
#
# Video : http://youtu.be/PyQz1uR4BgM
#
# Historique :
#        2014-08 (0.1)
#                -écriture initial
#====================================================================
use strict;
use warnings;
use 5.010;

use Data::Dumper;

#-------------------------------------------------------------------------------
#  Microphone
#-------------------------------------------------------------------------------
chomp( my $card = qx{sed -ne '/\\[Microphone/p' /proc/asound/cards |cut -d ' ' -f 2} );
#say $card;

chomp( my $son = qx{sed -ne '/capture/p' /proc/asound/devices |cut -d ':' -f 2 |tr -d ' []' |tr '-' ',' |sed -ne '/^$card/p'} );
#say $son;

#-------------------------------------------------------------------------------
#  Video
#-------------------------------------------------------------------------------
my @w = qx{xwininfo};
my $w;

map {chomp; if (/\s+(.*):\s+(.*)/) { $w->{$1} = $2 } } (@w);
# say Dumper( $w );
my $dim = $w->{'Width'}
		. 'x'
		. $w->{'Height'};
my $ofs =  '+'
		. $w->{'Absolute upper-left X'}
		. ','
		. $w->{'Absolute upper-left Y'};

#say "$dim $ofs";

#-------------------------------------------------------------------------------
#  Nom du fichier
#-------------------------------------------------------------------------------
chomp( my $dt = qx{date '+%s'} );
my $outfile = 'Screencast_' . $dt;

#-------------------------------------------------------------------------------
#  Execution de avconv
#-------------------------------------------------------------------------------
qx{avconv -y -f alsa -i hw:$son -f x11grab -show_region 1 -s $dim -r 15 -i :0.0$ofs -vcodec libx264 -preset ultrafast $outfile.avi};
