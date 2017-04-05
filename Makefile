NAME=sift
VERSION=0.9.0
ITERATION=1.lru
PREFIX=/usr/local/bin
LICENSE=GPL-3.0
VENDOR="Sven Taute"
MAINTAINER="Ryan Parman"
DESCRIPTION="A fast and powerful open source alternative to grep."
URL=https://sift-tool.org
RHEL=$(shell rpm -q --queryformat '%{VERSION}' centos-release)

#-------------------------------------------------------------------------------

all: info clean compile package move

#-------------------------------------------------------------------------------

.PHONY: info
info:
	@ echo "NAME:        $(NAME)"
	@ echo "VERSION:     $(VERSION)"
	@ echo "ITERATION:   $(ITERATION)"
	@ echo "PREFIX:      $(PREFIX)"
	@ echo "LICENSE:     $(LICENSE)"
	@ echo "VENDOR:      $(VENDOR)"
	@ echo "MAINTAINER:  $(MAINTAINER)"
	@ echo "DESCRIPTION: $(DESCRIPTION)"
	@ echo "URL:         $(URL)"
	@ echo "RHEL:        $(RHEL)"
	@ echo " "

#-------------------------------------------------------------------------------

.PHONY: clean
clean:
	rm -Rf /tmp/installdir* sift*

#-------------------------------------------------------------------------------

.PHONY: compile
compile:
	wget -O sift_$(VERSION)_linux_amd64.tar.gz https://sift-tool.org/downloads/sift/sift_$(VERSION)_linux_amd64.tar.gz
	tar zxvf sift_$(VERSION)_linux_amd64.tar.gz
	mv ./sift_$(VERSION)_linux_amd64/sift ./sift

#-------------------------------------------------------------------------------

.PHONY: package
package:

	# Main package
	fpm \
		-s dir \
		-t rpm \
		-n $(NAME) \
		-v $(VERSION) \
		-m $(MAINTAINER) \
		--iteration $(ITERATION) \
		--license $(LICENSE) \
		--vendor $(VENDOR) \
		--prefix $(PREFIX) \
		--url $(URL) \
		--description $(DESCRIPTION) \
		--rpm-defattrfile 0755 \
		--rpm-digest md5 \
		--rpm-compression gzip \
		--rpm-os linux \
		--rpm-auto-add-directories \
		--template-scripts \
		sift \
	;

#-------------------------------------------------------------------------------

.PHONY: move
move:
	mv *.rpm /vagrant/repo/
