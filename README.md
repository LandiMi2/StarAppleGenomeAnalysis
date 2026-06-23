#  Star Apple Genome Analysis

**Chromosome-scale genome assembly and annotation of the white star apple (*Gambeya albida*)**

This repository documents the commands, parameters, and software versions used to produce the first chromosome-scale, reference-quality genome assembly and annotation of the white star apple (*Gambeya albida*). It accompanies the preprin:

> Landi, M., Muzemil, S., Adediji, A., Ondari, L. *et al.* (2026). **Chromosome-scale genome assembly and annotation of the white star apple (*Gambeya albida*).** *Research Square* (preprint). https://doi.org/10.21203/rs.3.rs-9271727/v1


---

## Genome at a glance

| Metric | Value |
|---|---|
| Estimated haploid genome size | ~822 Mbp |
| Final assembly size | ~814 Mbp |
| Heterozygosity | 0.317% (highly homozygous) |
| Pseudochromosomes | 13 |
| Final N50 | 57 Mbp |
| BUSCO completeness (genome) (eudicots_odb10) | 97.5% |
| BUSCO completeness (protein) (eudicots_odb10) | 92.4% |
| Base-level accuracy (QV, Merqury) | 58.14 |
| Repeat content | ~58.6% |
| Predicted gene models | 33,607 |

---

## Repository structure

The folders are organized in the order of the analysis pipeline:

```
StarAppleGenomeAnalysis/
├── qc/                     # Read quality control & trimming
│   └── qc.sh
├── SizePrediction/         # K-mer based genome size, heterozygosity & ploidy estimation
│   └── kmer.sh
├── asm/                    # De novo genome assembly + assembly comparison
│   └── asm.sh
├── purging/                # Haplotig/duplicate purging (2 rounds) + BUSCO checks
│   └── purge_dups.sh
├── scaffolding/            # Omni-C scaffolding, manual curation & gap filling
│   ├── map.sh
│   └── requirements.txt
├── anno/                   # Transposable element & gene annotation
│   └── TEandGeneAnnotation.sh
├── LICENSE
└── README.md
```

---

## Pipeline overview

```mermaid
flowchart TD
    A[Raw PacBio HiFi reads] -->|fastp QC/trimming| B[Filtered HiFi reads]
    A2[Raw Omni-C reads] -->|fastp QC/trimming| B2[Filtered Omni-C reads]

    B --> C["K-mer profiling
    Jellyfish → GenomeScope2
    FastK → Smudgeplot"]
    C --> D[Genome size, heterozygosity, ploidy]

    B --> E["De novo assembly
    hifiasm / HiCanu / Flye"]
    E --> F[Compare assemblies: QUAST]
    F --> G[Select primary hifiasm assembly]

    G --> H["Purge duplicates
    minimap2 + purge_dups, round 1 & 2"]
    H --> I[BUSCO completeness check]
    I --> J[Purged primary assembly]

    J --> K["Map Omni-C reads
    bwa mem → pairtools"]
    B2 --> K
    K --> L[Scaffolding: YaHS]
    L --> M[Contact map: PretextMap / PretextView]
    M --> N[Manual curation]
    N --> O[Gap filling: LR_Gapcloser]
    O --> P[Chromosome-scale assembly]

    P --> Q["TE annotation: EDTA"]
    P --> R["Gene prediction: Helixer"]
    R --> S["Functional annotation
    eggNOG-mapper · InterProScan · BLASTp"]
    S --> T[Integrate annotations: AGAT]
    Q --> U[Final annotated genome]
    T --> U
```

---

## Software used

| Step | Tool | Notes |
|---|---|---|
| QC / trimming | [fastp](https://github.com/OpenGene/fastp) | v0.23.x |
| Read QC | [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) | |
| K-mer counting | [Jellyfish](https://github.com/gmarcais/Jellyfish) | v2.2.8 |
| Genome profiling | [GenomeScope2](https://github.com/tbenavi1/genomescope2.0) | |
| K-mer pairing / ploidy | [FastK](https://github.com/thegenemyers/FASTK) & [Smudgeplot](https://github.com/KamilSJaron/smudgeplot) | v0.5.4 |
| Assembly | [hifiasm](https://github.com/chhylp123/hifiasm) | v0.16.1 |
| Assembly | [Canu / HiCanu](https://github.com/marbl/canu) | v2.3 |
| Assembly | [Flye](https://github.com/mikolmogorov/Flye) | v2.9.x |
| Assembly QC | [QUAST](https://github.com/ablab/quast) | v5.1.0rc1 |
| Alignment | [minimap2](https://github.com/lh3/minimap2) | v2.24 |
| Duplicate purging | [purge_dups](https://github.com/dfguan/purge_dups) | |
| Completeness | [BUSCO](https://busco.ezlab.org/) | eudicots_odb10 |
| Short-read alignment | [BWA](https://github.com/lh3/bwa) | |
| Hi-C/Omni-C processing | [pairtools](https://github.com/open2c/pairtools) | v1.1.2 |
| BAM handling | [samtools](https://github.com/samtools/samtools) | |
| Scaffolding | [YaHS](https://github.com/c-zhou/yahs) | |
| Contact map curation | [PretextMap / PretextView](https://github.com/sanger-tol) | |
| Gap filling | [LR_Gapcloser](https://github.com/CAFS-bioinformatics/LR_Gapcloser) | |
| Gene prediction | [Helixer](https://github.com/weberlab-hhu/Helixer) | v0.3.6 |
| Functional annotation | [eggNOG-mapper](https://github.com/eggnogdb/eggnog-mapper), [InterProScan](https://github.com/ebi-pf-team/interproscan) | |
| Homology search | [BLAST+](https://blast.ncbi.nlm.nih.gov/) (blastp) | |
| Annotation merging | [AGAT](https://github.com/NBISweden/AGAT) | |
| TE annotation | [EDTA](https://github.com/oushujun/EDTA) | |

Exact version numbers and citations for every tool are listed in the preprint's Methods section and reference list.

---

## Data availability

| Resource | Accession |
|---|---|
| PacBio HiFi reads (SRA) | [SRR33323859](https://www.ncbi.nlm.nih.gov/sra/SRR33323859) |
| Omni-C reads (SRA) | [SRR33422445](https://www.ncbi.nlm.nih.gov/sra/SRR33422445) |
| Genome assembly (GenBank) | [JBNXVW000000000](https://www.ncbi.nlm.nih.gov/nuccore/JBNXVW000000000) |
| Annotation files | [Zenodo, DOI: 10.5281/zenodo.20794479](https://doi.org/10.5281/zenodo.20794479) |

---

## Reproducibility notes

These scripts capture the **literal commands run on the original analysis server** rather than a packaged, push-button pipeline. Before reusing them:

- File paths (e.g. `/data01/mlandi/...`, `/data2/StarApple/...`) are specific to the authors' HPC environment and need to be replaced with your own paths.
- Steps should generally be run in the order the folders are listed above (`qc` → `SizePrediction` → `asm` → `purging` → `scaffolding` → `anno`), since later steps consume the outputs of earlier ones.
- Most tools are easiest to install via [conda/mamba](https://github.com/conda-forge/miniforge) (e.g. via `bioconda`); a few (Helixer, LR_Gapcloser, EDTA) are best installed from source as described in their own repositories.
- The Python environment for the scaffolding/curation step can be created from [`scaffolding/requirements.txt`](scaffolding/requirements.txt).

## Citation

If you use this workflow or the associated genome assembly, please cite the preprint:

```
Landi, M., Muzemil, S., Adediji, A., Ondari, L., et al. (2026).
Chromosome-scale genome assembly and annotation of the white star apple (Gambeya albida).
Research Square. https://doi.org/10.21203/rs.3.rs-9271727/v1
```

## Funding & acknowledgements

Sequencing was funded by the Malimbe Foundation and Inqaba Biotec West Africa. Computational resources were provided by the IITA Bioinformatics Unit. The African BioGenome Project (AfricaBP) supported project coordination and ethical/legal guidance. Full acknowledgements are available in the preprint.

## License

This repository is released under the [MIT License](LICENSE).

## Contact

Michael Landi — IITA / SLU — m.landi@cgiar.org
