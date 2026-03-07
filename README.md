# Microbial Clinical Atlas (MCA)
> The first curated clinical knowledge base for the human microbiome

## Introduction
**Microbial Clinical Atlas (MCA)** is a curated knowledge base for translating microbiome readouts into clinically and biologically interpretable insights. MCA organizes microbial information into standardized **Taxon Passports** that capture taxonomic identity, ecological context, clinically relevant associations, and evidence-linked references. The project is designed to support microbiologists and researchers who are beginning microbiome analysis by providing consistent fields, stable identifiers, and structured, reproducible outputs.

## Rationale
Microbiome studies routinely report associations between taxa and clinical or experimental phenotypes, but interpretation is often limited by inconsistent terminology, heterogeneous reporting standards, and fragmented evidence across publications. MCA addresses this gap by (i) standardizing how taxa are described, (ii) attaching explicit evidence (PMIDs) to key claims, and (iii) enabling systematic comparison across taxa and contexts. MCA is intended to function as a reusable reference layer for interpreting sequencing-based microbiome profiles and for generating mechanism-informed hypotheses in translational microbiome research.

## Aims
- **Standardize** curated microbial knowledge into consistent, comparable **Taxon Passports** with stable identifiers.
- **Link evidence** to curated claims using explicit literature references (PMIDs) and structured claim types (e.g., clinical associations).
- **Support interpretation** of microbiome signals in clinical and translational settings by organizing taxa, contexts, and evidence in a reusable framework.
- **Enable reuse** via versioned exports (e.g., XML/structured formats) suitable for web applications and downstream analysis.

## How to use
### Browse the live resource
- Web: https://bioinformatics.ucalgary.ca/MCA/

### Data model overview (high level)
- **Taxon Passports**: one record per curated taxon (stable `passport_id`)
- **Clinical associations**: claim-level records linked to `passport_id`
- **Evidence (PMIDs)**: attached at the claim level for traceable support

