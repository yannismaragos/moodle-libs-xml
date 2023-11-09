.DEFAULT_GOAL := generate_thirdpartylibs_xml

generate_thirdpartylibs_xml:
	bash generate_libs.sh $(dir)

.PHONY: generate_libs