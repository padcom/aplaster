SUBDIRS=psimp common cfged module-sim server monitor unit-tests setup 
DISABLED=doc module 

$(MAKECMDGOALS):
	for dir in $(SUBDIRS); do $(MAKE) -C $$dir $@; done
