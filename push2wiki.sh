#!/bin/bash

set -xe

wikitext=`mktemp`
trap 'rm -f $wikitext' 0

# a 'push2wiki.cfg' file containing a line such as the following is needed:
# (use e.g. the "HTTP Live Headers" Firefox extension to extract the cookie string)
# metalab_wiki_cookie='metalabwikiUserName=SECRET; metalabwikiLoggedOut=SECRET; metalabwikiUserID=SECRET; metalabwikiToken=SECRET; sessionid=SECRET; metalabwiki_session=SECRET'
. ./push2wiki.cfg

wiki_update() {
eval "curl 'https://metalab.at/wiki/index.php?title=Bauteilsortiment&action=submit' --cookie '$metalab_wiki_cookie' -F 'wpTextbox1=<$2' -F 'wpSummary=sortiment.spl-$3-update' $( curl --cookie "$metalab_wiki_cookie" "https://metalab.at/wiki/index.php?title=Bauteilsortiment&action=edit&section=$1" | perl -le '$txt.=$_ while <STDIN>; sub x { print $_[0] if $_[0] !~ /name=['\''"]wp(Preview|Diff|Summary)/}; $txt =~ s/(<input[^>]*name=['\''"]wp[^>]*>)/x($1)/eg;' | perl -pe '/name=['\''"]([^'\''"]*)/; $name=$1; /value=['\''"]([^'\''"]*)/; $value=$1; $_="--form-string '\''$name=$value'\'' ";' )"
}

if [ ".$1" = "." -o ".$1" = ".wikitext" ]; then
	splrun -e sortiment.spl wikitext > $wikitext
	section_bauteile=$( curl -s https://metalab.at/wiki/Bauteilsortiment | grep '^.li class="toclevel' | grep -n '#Bauteile' | cut -f1 -d: )
	wiki_update $section_bauteile $wikitext bauteile
fi

if [ ".$1" = "." -o ".$1" = ".kastenwiki" ]; then
	splrun -e sortiment.spl kastenwiki > $wikitext
	section_kastenplan=$( curl -s https://metalab.at/wiki/Bauteilsortiment | grep '^.li class="toclevel' | grep -n '#Kastenplan' | cut -f1 -d: )
	wiki_update $section_kastenplan $wikitext kastenplan
fi

if [ ".$1" = "." -o ".$1" = ".orderwiki" ]; then
	splrun -e sortiment.spl orderwiki > $wikitext
	section_kastenplan=$( curl -s https://metalab.at/wiki/Bauteilsortiment | grep '^.li class="toclevel' | grep -n '#Naechste_Bestellung' | cut -f1 -d: )
	wiki_update $section_kastenplan $wikitext bestellung
fi

