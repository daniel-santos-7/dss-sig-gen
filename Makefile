GHDL = ghdl
GHDL_OPTS = --workdir=$(WORKDIR)
GHDL_RUNOPTS = --wave=$(WAVESDIR)/$(TBS_TOP).ghw

WORKDIR  = work
WAVESDIR = waves

RTL_SRC  = $(wildcard ./rtl/*.vhd)
TBS_SRC  = $(wildcard ./tbs/*.vhd)

RTL_TOP = sig_gen
TBS_TOP = sig_gen_tb

$(WORKDIR) $(WAVESDIR):
	mkdir $@

.PHONY: analyze elaborate run clean

analyze: $(WORKDIR)
	$(GHDL) analyze $(GHDL_OPTS) $(RTL_SRC) $(TBS_SRC)

elaborate: analyze
	$(GHDL) elaborate $(GHDL_OPTS) $(TBS_TOP)

run: elaborate $(WAVESDIR)
	$(GHDL) run  $(TBS_TOP) $(GHDL_RUNOPTS)

clean:
	$(GHDL) clean $(GHDL_OPTS)
	rm -rf $(WORKDIR) $(WAVESDIR)