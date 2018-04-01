#!/usr/bin/perl
use File::Path qw( make_path );
use JSON;
use Text::Forge;
use strict;
use warnings;

my $outDir = "./output/";

if (!-d $outDir) {
    make_path $outDir or die "can't create output directory";
}

my $forge = Text::Forge->new;
my $texoutput = $outDir . "resume.tex";
my $txtoutput = $outDir . "resume.txt";
# pdflatex takes output file and dir separately
my $pdfoutput = "resume.pdf";
my $jsonfile = "./data.json";



my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $jsonfile)
      or die("Can't open \$filename\": $!\n");
   local $/;
   <$json_fh>
};

my $data = JSON->new->decode($json_text);

open(my $txtTemplate, '>', $txtoutput) or die "couldnt open txt file";
print $txtTemplate $forge->run('./templates/resume.txt.forge', $data);
close($txtTemplate);

open(my $fh, '>', $texoutput) or die "couldnt open latex file";
print $fh $forge->run('./templates/resume.tex.forge', $data);
close($fh);

system("pdflatex -interaction=batchmode -output-directory=$outDir $texoutput $pdfoutput");


print "done\n";
