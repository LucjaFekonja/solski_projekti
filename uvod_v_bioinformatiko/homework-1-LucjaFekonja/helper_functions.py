from typing import Tuple, Generator, List

from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord


def codons(seq: str) -> Generator[str, None, None]:
    """Walk along the string, three nucleotides at a time. Cut off excess."""
    for i in range(0, len(seq) - 2, 3):
        yield seq[i:i + 3]


def extract_gt_orfs(record, start_codons, stop_codons, validate_cds=True, verbose=False):
    """Extract the ground truth ORFs as indicated by the NCBI annotator in the
    gene coding regions (CDS regins) of the genome.

    Parameters
    ----------
    record: SeqRecord
    start_codons: List[str]
    stop_codons: List[str]
    validate_cds: bool
        Filter out NCBI provided ORFs that do not fit our ORF criteria.
    verbose: bool

    Returns
    -------
    List[Tuple[int, int, int]]
        tuples of form (strand, start_loc, stop_loc). Strand should be either 1
        for reference strand and -1 for reverse complement.

    """
    cds_regions = [f for f in record.features if f.type == "CDS"]

    orfs = []
    for region in cds_regions:
        loc = region.location
        seq = record.seq[loc.start.position:loc.end.position]
        if region.strand == -1:
            seq = seq.reverse_complement()
            
        if not validate_cds:
            orfs.append((region.strand, loc.start.position, loc.end.position))
            continue

        try:
            assert seq[:3] in start_codons, "Start codon not found!"
            assert seq[-3:] in stop_codons, "Stop codon not found!"
            # Make sure there are no stop codons in the middle of the sequence
            for codon in codons(seq[3:-3]):
                assert (
                    codon not in stop_codons
                ), f"Stop codon {codon} found in the middle of the sequence!"

            # The CDS looks fine, add it to the ORFs
            orfs.append((region.strand, loc.start.position, loc.end.position))

        except AssertionError as ex:
            if verbose:
                print(
                    "Skipped CDS at region [%d - %d] on strand %d"
                    % (loc.start.position, loc.end.position, region.strand)
                )
                print("\t", str(ex))
                
    # Some ORFs in paramecium have lenghts not divisible by 3. Remove these
    orfs = [orf for orf in orfs if (orf[2] - orf[1]) % 3 == 0]

    return orfs


def find_orfs(sequence, start_codons, stop_codons):
    """Find possible ORF candidates in a single reading frame.

    Parameters
    ----------
    sequence: Seq
    start_codons: List[str]
    stop_codons: List[str]

    Returns
    -------
    List[Tuple[int, int]]
        tuples of form (start_loc, stop_loc)

    """
    genes = []    
    found_start = False
    n = 0

    # Find the start and stop codons in the sequence
    for codon in codons(sequence):

        # If codon is in start_codons, we save the start index
        if found_start == False and codon in start_codons:
            start_index = n
            found_start = True

        # If codon is in stop_codons, we save the stop index
        if found_start == True and codon in stop_codons:
            stop_index = n + 3
            genes += [(start_index, stop_index)]
            found_start = False
        n += 3

    return genes


def find_all_orfs(sequence, start_codons, stop_codons):
    """Find ALL the possible ORF candidates in the sequence using all six
    reading frames.

    Parameters
    ----------
    sequence: Seq
    start_codons: List[str]
    stop_codons: List[str]

    Returns
    -------
    List[Tuple[int, int, int]]
        tuples of form (strand, start_loc, stop_loc). Strand should be either 1
        for reference strand and -1 for reverse complement.

    """
    all_orfs = []
    for i in range(3):
        orfs = find_orfs(sequence[i:], start_codons, stop_codons)
        for orf in orfs:
            all_orfs += [(1, orf[0] + i, orf[1] + i)]

        reverse_complement = sequence[::-1].replace("A", "B").replace("T", "A").replace("B", "T").replace("C", "D").replace("G", "C").replace("D", "G")
        reverse_orfs = find_orfs(reverse_complement[i:], start_codons, stop_codons)
        for orf in reverse_orfs:
            all_orfs += [(-1, len(sequence) - orf[1] - i, len(sequence) - orf[0] - i)]

    return all_orfs


def translate_to_protein(seq):
    """Translate a nucleotide sequence into a protein sequence.

    Parameters
    ----------
    seq: str

    Returns
    -------
    str
        The translated protein sequence.

    """
    dictionary = {"GCT": "A", "GCC": "A", "GCA": "A", "GCG": "A", 
                  "TGT": "C", "TGC": "C", 
                  "GAT": "D", "GAC": "D",
                  "GAA": "E", "GAG": "E", 
                  "TTT": "F", "TTC": "F", 
                  "GGT": "G", "GGC": "G", "GGA": "G", "GGG": "G",
                  "CAT": "H", "CAC": "H", 
                  "ATT": "I", "ATC": "I", "ATA": "I", 
                  "AAA": "K", "AAG": "K", 
                  "TTA": "L", "TTG": "L", "CTT": "L", "CTC": "L", "CTA": "L", "CTG": "L", 
                  "ATG": "M", 
                  "AAT": "N", "AAC": "N",
                  "CCT": "P", "CCC": "P", "CCA": "P", "CCG": "P", 
                  "CAA": "Q", "CAG": "Q", 
                  "CGT": "R", "CGC": "R", "CGA": "R", "CGG": "R", "AGA": "R", "AGG": "R", 
                  "TCT": "S", "TCC": "S", "TCA": "S", "TCG": "S", "AGT": "S", "AGC": "S", 
                  "ACT": "T", "ACC": "T", "ACA": "T", "ACG": "T", 
                  "GTT": "V", "GTC": "V", "GTA": "V", "GTG": "V", 
                  "TGG": "W", 
                  "TAT": "Y", "TAC": "Y", 
                  "TAA": "", "TGA": "", "TAG": ""}
    protein_seq = ""
    for codon in codons(seq):
        protein_seq += dictionary[codon]
    return protein_seq



def find_all_orfs_nested(sequence, start_codons, stop_codons):
    """Bonus problem: Find ALL the possible ORF candidates in the sequence using
    the updated definition of ORFs.

    Parameters
    ----------
    sequence: Seq
    start_codons: List[str]
    stop_codons: List[str]

    Returns
    -------
    List[Tuple[int, int, int]]
        tuples of form (strand, start_loc, stop_loc). Strand should be either 1
        for reference strand and -1 for reverse complement.

    """
    raise NotImplementedError()
