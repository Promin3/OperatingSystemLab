###################################################################
# doc/docbook/Makefile
# $Id: Makefile.in 14281 2021-06-13 08:02:33Z vruppert $
#
# Builds documentation in various formats from SGML source, and
# allows easy update to the Bochs web site.
#
###################################################################

prefix          = /usr/local
srcdir          = .
abs_srcdir      = /home/kevin/bochs-2.7/doc/docbook
docdir          = $(prefix)/share/doc/bochs
WGET = wget
TARGZ = bochsdoc.tar.gz
RENDERED_DOC_URL = https://bochs.sourceforge.io/doc/docbook/$(TARGZ)

# docbook-utils build if found
DOCBOOK2HTML = not_found
ifeq ($(DOCBOOK2HTML), not_found)
# jade build
HTML_STYLESHEET = $(abs_srcdir)/include/docbook-utils.dsl\#html
JADE = not_found
JADE_ARGS = -t sgml -i html -d $(HTML_STYLESHEET)   # -V nochunks
SGML_VALIDATE = nsgmls -s
DOCBOOK2HTML = $(JADE) $(JADE_ARGS)
endif

DESTDIR=

# name of the major documentation sections
SECTIONS=user documentation development
SECTION_HTML=$(SECTIONS:%=%/index.html)

# these files get installed in addition to the sections
EXTRAS=index.html images

# complete list of what to install
INSTALL_LIST=$(SECTIONS) $(EXTRAS)

# scp to this server (only upload supported)
REMOTE_HOST=web.sf.net

# path of preexisting install on the remote server.  Each section
# will go into a subdirectory of $REMOTE_PATH, as in
# $REMOTE_PATH/user.
REMOTE_PATH=htdocs/doc/docbook

all: $(SECTION_HTML)

user/index.html: $(srcdir)/user/user.dbk
	-mkdir -p user
	cd user; $(DOCBOOK2HTML) user.dbk

documentation/index.html: $(srcdir)/documentation/documentation.dbk
	-mkdir -p documentation
	cd documentation; $(DOCBOOK2HTML) documentation.dbk

development/index.html: $(srcdir)/development/development.dbk
	-mkdir -p development
	cd development; $(DOCBOOK2HTML) development.dbk

fixperm::
	# fix permissions locally so that tar will install things right
	chmod 664 `find $(INSTALL_LIST) -type f -print`
	chmod 775 `find $(INSTALL_LIST) -type d -print`

copy_from_srcdir::
	for i in $(EXTRAS); do if test -e $(srcdir)/$$i -a ! -e $$i; then cp -r $(srcdir)/$$i $$i; fi; done

$(TARGZ): all copy_from_srcdir fixperm
	rm -f $(TARGZ)
	tar cf - --exclude=.svn --exclude=*.dbk $(INSTALL_LIST) | gzip > $(TARGZ)

install: all copy_from_srcdir
	for i in $(DESTDIR)$(docdir); do if test ! -d $$i; then mkdir -p $$i; fi; done
	#for i in $(INSTALL_LIST); do cp -r $$i $(DESTDIR)$(docdir); done
	for i in $(INSTALL_LIST); do tar cf - --exclude=.svn --exclude=*.dbk $$i | ( cd $(DESTDIR)$(docdir); tar xf - ); done

test_sfuser:
	@if test "$$SFUSER" = ""; then SFUSER=`whoami`; export SFUSER; fi; \
	  echo Your Source Forge username is $${SFUSER}.
	@echo 'If this is not correct, set the environment variable $$SFUSER.'

# Upload the stuff to the remote server using scp.  It will assume that your
# local username is the same as your Source Forge username, unless you define
# an environment variable SFUSER. Unpacking must be done with the
# interactive shell (see developer doc).
upload_docs: $(TARGZ)
	# copy to remote
	@echo Uploading documentation to $(REMOTE_PATH)
	if test "$$SFUSER" = ""; then SFUSER=`whoami`; export SFUSER; fi; \
	  scp $(TARGZ) $${SFUSER},bochs@$(REMOTE_HOST):$(REMOTE_PATH);

# Download rendered docs in a TAR file from the Bochs web site using wget.
# This is useful for getting documentation onto platforms that don't have
# docbook tools.
dl_docs::
	rm -f $(TARGZ)
	$(WGET) $(RENDERED_DOC_URL)
	gunzip -c $(TARGZ) | tar xvf -
	touch */*.html

clean:
	# remove generated files
	for S in $(SECTIONS); do \
	  rm -f $$S/*.html $$S/*.htm $$S/*.ps $$S/*.pdf $$S/*.out; \
	done
	rm -f  $(TARGZ)

dist-clean: clean
	rm -f  Makefile
