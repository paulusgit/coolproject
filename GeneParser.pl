#!usr/bin/perl

($file,$option) = @ARGV;

my $exons = 0;
my $totalexons = 0;
my $genes = 0;
my $newseq = 0;
my $genestart = undef;
my $genend = undef;
my $seqlength = undef;
my $genlength = undef;
my $totalgenlength = undef;
my $orientation = "";
open (FILE, '<',$file) or die ("Cannot open file");
while (my $line = <FILE>) {
	if ($line =~ /.+?Length = (\d+)/) { $seqlength = $1;}
	if ($line =~ /^#\sGene\s(\d+).*?(\w+).*?(\d+)\sexons/) {
		# print "$1 gene\t";
		# print "$2 exons \n";
		$genes = $genes + 1;
		$orientation = $2;
		$exons = $3;
		$totalexons = $totalexons + $exons;
		$newseq = 1; # Newseq is mostly for the repeated internal :)
		}
	if ($option eq "advanced") { # Only for geneid format!
		if ($exons == 1) {
			if ($line =~ /^.*Single\s+(\d+)\s+(\d+)/) {
				$genestart = $1;
				$genend = $2;
				$newseq = 0;
				$genlength = $genend-$genestart;
				print "$genes gene: $exons exons $genestart-$genend ($genlength) [$orientation] \n";
				$totalgenlength += $genlength;
				$genestart = "";
				$genend = "";
				$exons = 0;
			}
		}		
		if ($exons >= 2) {
			if ($newseq == 1 && $line =~ /^.*First\s+?(\d+?)\s/) {
				$genestart = $1;
				$newseq = 0;
			}
			elsif ($newseq == 1 && $line =~ /^Terminal\s+?(\d+)\s+\d+\s/) {
				$genestart = $1;
				$newseq = 0;
			}			
			elsif ($newseq == 1 && $line =~ /^Internal\s+(\d+?)\s/) { 
				$genestart = $1;
				$newseq = 0;
			}
			elsif ($line =~ /^Terminal\s+\d+?\s+(\d+)\s/) {
				$genend = $1;
				$genlength = $genend-$genestart;
				print "$genes gene: $exons exons $genestart-$genend ($genlength) [$orientation] \n";
				$totalgenlength += $genlength;
				$genestart = "";
				$genend = "";
				$exons = 0;
			}	
			elsif ($newseq == 0 && $line =~ /^.*First\s+\d+?\s+(\d+)\s/) {
				$genend = $1;
				$genlength = $genend-$genestart;
				print "$genes gene: $exons exons $genestart-$genend ($genlength) [$orientation] \n";
				$totalgenlength += $genlength;
				$genestart = "";
				$genend = "";
				$exons = 0;
			}
		}	
	}
}
close FILE;	
$avexgen = $totalexons/$genes;
$genedensity = $totalgenlength/$seqlength*100;
$genpermb = $genes/$seqlength*1000000;
print "Total number of genes: $genes \n";
print "Total number of exons: $totalexons \n";
print "Average number of exons/gene: $avexgen \n";
if ($option eq "advanced") { print "Gene density: $genedensity \n";}
print "Genes per Mb: $genpermb";
