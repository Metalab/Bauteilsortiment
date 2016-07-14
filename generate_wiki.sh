#!/bin/bash

set -xe

if [ ".$1" = "." -o ".$1" = ".wikitext" ]; then
	splrun -e sortiment.spl wikitext
	section_bauteile=$( curl -s https://metalab.at/wiki/Bauteilsortiment | grep '^.li class="toclevel' | grep -n '#Bauteile' | cut -f1 -d: )
#	wiki_update $section_bauteile $wikitext bauteile
fi

if [ ".$1" = "." -o ".$1" = ".kastenwiki" ]; then
	splrun -e sortiment.spl kastenwiki
	section_kastenplan=$( curl -s https://metalab.at/wiki/Bauteilsortiment | grep '^.li class="toclevel' | grep -n '#Kastenplan' | cut -f1 -d: )
#	wiki_update $section_kastenplan $wikitext kastenplan
fi

if [ ".$1" = "." -o ".$1" = ".orderwiki" ]; then
	splrun -e sortiment.spl orderwiki
	section_kastenplan=$( curl -s https://metalab.at/wiki/Bauteilsortiment | grep '^.li class="toclevel' | grep -n '#Naechste_Bestellung' | cut -f1 -d: )
#	wiki_update $section_kastenplan $wikitext bestellung
fi

