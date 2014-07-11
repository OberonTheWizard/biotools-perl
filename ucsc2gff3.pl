#!/usr/bin/perl


MAIN:
{

    print "##gff-version 3\n";
    open(FH, $ARGV[0]);
    my $id = 0;
    while(my $raw = <FH>){
        chomp $raw;
        $id++;
        my @line = split(/\t/, $raw);
        my ($acc, $chr, $start, $end, $e_starts, $e_ends, $name) = ($line[1], $line[2], $line[4], $line[5], $line[9], $line[10], $line[12]);
        # print join("\t", $acc, $chr, $start, $end, $e_starts, $e_ends, $name), "\n";
        $e_start =~ s/,$//;
        $e_end =~ s/,$//;
        my @starts = split(/,/, $e_starts);
        my @ends = split(/,/, $e_ends);

        print join("\t",
                $chr,
                'RefSeq',
                'gene',
                $start + 1,
                $end,
                ".",
                $line[3],
                ".",
                "ID=$id;Name=$name;Accession=$acc"
                ),"\n";
        for(my $i = 0; $i<=$#starts; $i++){
            print join("\t",
                $chr,
                'RefSeq',
                'exon',
                $starts[$i] + 1,
                $ends[$i],
                ".",
                $line[3],
                ".",
                "Parent=$id;"
            ), "\n";
        }
    }
    close(FH);
}
