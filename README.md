# 10X Genomics Piplines Docker Config
---
**From CentOS 7**
## Files
- Dockerfile: docker build instructions
- entrypoint: bash ecript to setup environment for MGI
- lsf templates: config for running in LSF mode
## Additional Software
- bcl2fastq: to run mkfastq [2.17.1]
- redstone: upload fastqs to 10X


## prep
download gatk, cellranger, and bcl2fastq
put in folders
