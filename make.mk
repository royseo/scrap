# Site hosting XNAT
NITRC = http :// www . nitrc . org / ir
SHELL =/ bin / bash
# Obtain the list of subjects to retrieve from NITRC
SUBJECTS = $ ( shell cat Subjects_Baltimore )
.PHONY : clean all allT1 allT1_brain allrest allsymlinks
all : sessionid allT1 allT1_brain allrest allsymlinks
allT1 : $ ( SUBJECTS :%= subjects /%/ visit1 / T1 . nii . gz )
allT1_brain : $ ( SUBJECTS :%= subjects /%/ visit1 / T1_brain . nii . gz )
allrest : $ ( SUBJECTS :%= subjects /%/ visit1 / rest . nii . gz )
allsymlinks : $ ( SUBJECTS :%= visit1 /%)
sessionid :
	@echo -n " Username : " ;\
	read username ;\
	curl -- user $$username $ ( NITRC ) / REST / JSESSION > $@
subjects /%/ visit1 / T1 . nii . gz : | sessionid
		mkdir -p `dirname $@ `; \
		curl -- cookie JSESSIONID =`cat sessionid ` $ ( NITRC ) / data / projects / fcon_1000 /
	subjects / $ */ experiments / $ */ scans / ALL / resources / NIfTI / files /
	scan_mprage_anonymized . nii . gz > $@
$subjects /%/ visit1 / T1_brain . nii . gz : | sessionid
	mkdir -p `dirname $@ `; \
	curl -- cookie JSESSIONID =`cat sessionid ` ( NITRC ) / data / projects / fcon_1000 /
		subjects / $ */ experiments / $ */ scans / ALL / resources / NIfTI / files /
		scan_mprage_skullstripped . nii . gz > $@
subjects /%/ visit1 / rest . nii . gz : | sessionid
	mkdir -p `dirname $@ `; \
	curl -- cookie JSESSIONID =`cat sessionid ` $ ( NITRC ) / data / projects / fcon_1000 /
		subjects / $ */ experiments / $ */ scans / ALL / resources / NIfTI / files / scan_rest .
		nii . gz > $@
visit1 /%:
	ln -s ../ subjects / $ */ visit1 $@
clean :
	rm - rf subjects ; \
	rm - rf visit1 /*; \
	rm -f sessionid