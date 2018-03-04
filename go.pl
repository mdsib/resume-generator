#!/usr/bin/perl
use warnings;
use strict;
use Text::Forge;
use JSON;

my $forge = Text::Forge->new;
my $texoutput = "./resume.tex";
my $pdfoutput = "./resume.pdf";
my $txtoutput = "./resume.txt";
my $jsonfile = "./data.json";

my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $jsonfile)
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};

my $data = JSON->new->decode($json_text);

open(my $txtTemplate, '>', $txtoutput) or die "couldnt open txt file";
print $txtTemplate $forge->run('./resume.txt.forge', $data);
close($txtTemplate);

open(my $fh, '>', $texoutput) or die "couldnt open tex file";
print $fh $forge->run('./resume.tex.forge', $data);
close($fh);

system("pdflatex -interaction=batchmode $texoutput $pdfoutput");


print "done\n";
