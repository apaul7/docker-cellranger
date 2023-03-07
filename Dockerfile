########################################
# Dockerfile for 10X Genomics Software #
########################################

# Based on...
FROM centos:7

# File Author / Maintainer
MAINTAINER Eddie Belter <ebelter@wustl.edu>

# Build ARGs
ARG program_name=cellranger
ARG program_version=7.1.0

# Environment
ENV TZ America/Chicago
ENV MGI10X_PROGRAM "${program_name}-${program_version}"
ENV MGI10X_APPS_PATH "/apps"
ENV MGI10X_PROGRAM_PATH "${MGI10X_APPS_PATH}/${MGI10X_PROGRAM}"
ENV LSF_SERVERDIR /opt/lsf9/9.1/linux2.6-glibc2.3-x86_64/etc
ENV LSF_LIBDIR /opt/lsf9/9.1/linux2.6-glibc2.3-x86_64/lib
ENV LSF_BINDIR /opt/lsf9/9.1/linux2.6-glibc2.3-x86_64/bin
ENV LSF_ENVDIR /opt/lsf9/conf
ENV PATH "${LSF_BINDIR}:${PATH}"

# Install deps and perl
RUN yum install -y \
	bsdtar \
	ca-certificates \
	file \
	gcc \
	git \
	java-1.8.0-openjdk \
	less \
	libnss-sss \
	make \
	mysql-devel \
	openssl \
	openssl-devel \
	perl \
	perl-core \
	perl-devel \
	sssd-client \
	which \
	unzip \
	vim

# Install bcl2fastq
WORKDIR /tmp/bcl2fastq/
COPY bcl2fastq/bcl2fastq2-v2.20.0.422-Linux-x86_64.rpm .
RUN yum -y --nogpgcheck localinstall bcl2fastq2-v2.20.0.422-Linux-x86_64.rpm
WORKDIR /tmp/
RUN rm -rf bcl2fastq/

# Install program
WORKDIR "${MGI10X_APPS_PATH}"
COPY "${program_name}/${MGI10X_PROGRAM}.tar.gz" "${program_name}.tar.gz"
RUN tar zxf "${program_name}.tar.gz" && \
	rm -f "${program_name}.tar.gz"

# GATK
COPY gatk/gatk-4.0.0.0.zip .
RUN unzip gatk-4.0.0.0.zip && \
  rm -f gatk-4.0.0.0.zip

# entrypoint is the wrapper scipt
WORKDIR /usr/local/bin/
COPY entrypoint .
RUN chmod 777 entrypoint
WORKDIR /
ENTRYPOINT ["/usr/local/bin/entrypoint"]
