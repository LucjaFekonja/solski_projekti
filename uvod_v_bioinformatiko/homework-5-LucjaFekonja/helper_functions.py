from Bio import pairwise2
from collections import namedtuple
from typing import Dict, List, Tuple
import pandas as pd
import numpy as np
from scipy.stats import hypergeom

GffEntry = namedtuple(
    "GffEntry",
    [
        "seqname",
        "source",
        "feature",
        "start",
        "end",
        "score",
        "strand",
        "frame",
        "attribute",
    ],
)


GeneDict = Dict[str, GffEntry]


def read_gff(fname: str) -> Dict[str, GffEntry]:
    gene_dict = {}

    with open(fname) as f:
        for line in f:
            if line.startswith("#"):  # Comments start with '#' character
                continue

            parts = line.split("\t")
            parts = [p.strip() for p in parts]

            # Convert start and stop to ints
            start_idx = GffEntry._fields.index("start")
            parts[start_idx] = int(parts[start_idx]) - 1  # GFFs count from 1..
            stop_idx = GffEntry._fields.index("end")
            parts[stop_idx] = int(parts[stop_idx]) - 1  # GFFs count from 1..

            # Split the attributes
            attr_index = GffEntry._fields.index("attribute")
            attributes = {}
            for attr in parts[attr_index].split(";"):
                attr = attr.strip()
                k, v = attr.split("=")
                attributes[k] = v
            parts[attr_index] = attributes

            entry = GffEntry(*parts)

            gene_dict[entry.attribute["gene_name"]] = entry

    return gene_dict


def split_read(read: str) -> Tuple[str, str]:
    """Split a given read into its barcode and DNA sequence. The reads are
    already in DNA format, so no additional work will have to be done. This
    function needs only to take the read, and split it into the cell barcode,
    the primer, and the DNA sequence. The primer is not important, so we discard
    that.

    The first 12 bases correspond to the cell barcode.
    The next 24 bases corresond to the oligo-dT primer. (discard this)
    The reamining bases corresond to the actual DNA of interest.

    Parameters
    ----------
    read: str

    Returns
    -------
    str: cell_barcode
    str: mRNA sequence

    """
    return (read[:12], read[36:])

def map_read_to_gene(read: str, ref_seq: str, genes: GeneDict) -> Tuple[str, float]:
    """
    Align a DNA sequence (read) against a reference sequence, and map it to the best matching gene.

    This function takes a DNA sequence, aligns it to a given reference sequence,
    and determines the best matching gene from a provided gene dictionary.
    It uses local alignment and computes the Hamming distance to evaluate the similarity of the read to gene sequences.
    The function returns the name of the best matching gene and the similarity score.
    You can use 'pairwise2.align.localxs(ref_seq, read, -1, -1)' to perform local alignment.

    Parameters
    ----------
    read: str
        The DNA sequence to be aligned. This sequence should not include the cell barcode or the oligo-dT primer. It represents the mRNA fragment obtained from sequencing.
    ref_seq: str
        The complete reference sequence (e.g., a viral genome) against which the read will be aligned. This sequence acts as a basis for comparison.
    genes: GeneDict
        A dictionary where keys are gene names and values are objects or tuples containing gene start and end positions in the reference sequence. This dictionary is used to identify specific genes within the reference sequence.

    Returns
    -------
    Tuple[str, float]
        - gene: str
            The name of the gene to which the read maps best. If the read aligns best to a non-gene region, return `None`.
        - similarity: float
            The similarity score between the read and the best matching gene sequence, calculated as the Hamming distance. This is a measure of how closely the read matches a gene, with higher values indicating better matches.

    Notes
    -----
    - The function performs local alignment of the read against the reference sequence and each gene segment.
    - If the read aligns better to a region outside of any gene, the function should return `None` for the gene name.
    - The function should handle cases where no alignment is found.
    """
    alignment = pairwise2.align.localxs(ref_seq, read, -1, -1)[0]
    
    start = alignment.start 
    end = alignment.end 
    seq = str(alignment.seqA)[start : end]

    score = 0
    for gene in genes:

        gene_start = genes[gene].start
        gene_end = genes[gene].end
        gene_seq = ref_seq[gene_start : gene_end]

        # gene_score = 0
        # if gene_start >= start and gene_end <= end:
        #     for i in range(gene_end - gene_start): 
        #         if gene_seq[i] == "-" or seq[i] == "-":
        #             continue
        #         elif seq[gene_start - start + i] == gene_seq[i]:
        #             gene_score += 1
        
        gene_score = 0
        if start >= gene_start and start <= gene_end:
            for i in range(min(end - start, gene_end - start)):
                if gene_seq[i] == "-" or seq[i] == "-":
                    continue
                if seq[i] == gene_seq[start - gene_start + i]:
                    gene_score += 1
        
        elif gene_start >= start and gene_start <= end:
            for i in range(min(end - gene_start, gene_end - gene_start)):
                if gene_seq[i] == "-" or seq[i] == "-":
                    continue
                if gene_seq[i] == seq[gene_start - start + i]:
                    gene_score += 1
    
        if score < gene_score:
            score = gene_score / len(seq)
            best_match = gene
        
    if score == 0:
        best_match = None
        score = 1

    return best_match, score


def generate_count_matrix(
    reads: List[str], ref_seq: str, genes: GeneDict, similarity_threshold: float
) -> pd.DataFrame:
    """

    Parameters
    ----------
    reads: List[str]
        The list of all reads that will be aligned.
    ref_seq: str
        The reference sequence that the read should be aligned against.
    genes: GeneDict
    similarity_threshold: float

    Returns
    -------
    count_table: pd.DataFrame
        The count table should be an N x G matrix where N is the number of
        unique cell barcodes in the reads and G is the number of genes in
        `genes`. The dataframe columns should be to a list of strings
        corrsponding to genes and the dataframe index should be a list of
        strings corresponding to cell barcodes. Each cell in the matrix should
        indicate the number of times a read mapped to a gene in that particular
        cell.

    """
    d = dict()
    seen_barcodes = list()
    for i in range(len(reads)): 
        (barcode, mRNA) = split_read(reads[i])
        (gene, score) = map_read_to_gene(mRNA, ref_seq, genes)
        
        if score >= similarity_threshold:
            if gene not in d:
                d[gene] = dict()
            if (gene, barcode) not in seen_barcodes:
                d[gene][barcode] = 1
                seen_barcodes += [(gene, barcode)]
            else:
                d[gene][barcode] += 1

    df = pd.DataFrame(d)
    df.fillna(0, inplace=True)
    return df


def filter_matrix(
    count_matrix: pd.DataFrame,
    min_counts_per_cell: float,
    min_counts_per_gene: float,
) -> pd.DataFrame:
    """Filter a matrix by cell counts and gene counts.
    The cell count is the total number of molecules sequenced for a particular
    cell. The gene count is the total number of molecules sequenced that
    correspond to a particular gene.
    Filtering statistics should be computed on
    the original matrix. E.g. if you filter out the genes first, the filtered
    gene molecules should still count towards the cell counts.

    Parameters
    ----------
    count_matrix: pd.DataFrame
    min_counts_per_cell: float
    min_counts_per_gene: float

    Returns
    -------
    filtered_count_matrix: pd.DataFrame

    """
    row_sums = count_matrix.sum(axis=1)
    col_sums = count_matrix.sum(axis=0)

    rows_to_keep = row_sums[row_sums >= min_counts_per_cell].index
    cols_to_keep = col_sums[col_sums >= min_counts_per_gene].index

    # Filter the DataFrame based on the rows and columns to keep
    filtered_dataframe = count_matrix.loc[rows_to_keep, cols_to_keep]

    # Print or use the resulting DataFrame
    return filtered_dataframe


def normalize_expressions(expression_data: pd.DataFrame) -> pd.DataFrame:
    """
    Normalize expressions by applying natural log-transformation with pseudo count 1,
    and scaling expressions of each sample to sum up to 10000.

    Parameters
    ----------
    expression_data: pd.DataFrame
        Expression matrix with cells as rows and genes as columns.

    Returns
    -------
    normalized_data: pd.DataFrame
        Normalized expression matrix with cells as rows and genes as columns.
        Matrix should have the same shape as the input matrix.
        Matrix should have the same index and column labels as the input matrix.
        Order of rows and columns should remain the same.
        Values in the matrix should be positive or zero.
    """
    log_transformed_data = np.log1p(expression_data)

    sum_per_sample = log_transformed_data.sum(axis=1)
    scaling_factor = 10000 / sum_per_sample
    normalized_data = log_transformed_data.multiply(scaling_factor, axis=0)

    return normalized_data


def hypergeometric_pval(N: int, n: int, K: int, k: int) -> float:
    """
    Calculate the p-value using the following hypergeometric distribution.

    Parameters
    ----------
    N: int
        Total number of genes in the study (gene expression matrix)
    n: int
        Number of genes in your proposed gene set (e.g. from differential expression)
    K: int
        Number of genes in an annotated gene set (e.g. GO gene set)
    k: int
        Number of genes in both annotated and proposed geneset

    Returns
    -------
    p_value: float
        p-value from hypergeometric distribution of finding such or
        more extreme match at random
    """
    return hypergeom.sf(k - 1, N, K, n)
