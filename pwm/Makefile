
TARGET=pwm
TOP=pwm

OBJS+=pwm.v clk_module.v pwm_module.v

ALL: $(TARGET).bit

$(TARGET).json: $(OBJS)
	yosys -p "synth_ice40 -top ${TOP} -json $@" $(OBJS)

$(TARGET)_out.config: $(TARGET).json
	nextpnr-ice40 --up5k --package sg48 --json $(TARGET).json --pcf $(TARGET).pcf --asc $(TARGET).asc --freq 24 --ignore-rel-clk --report $(TARGET)_report.json --detailed-timing-report --opt-timing

$(TARGET).bit: $(TARGET)_out.config
	icepack $(TARGET).asc $(TARGET).bit

flash: $(TARGET).bit
	icesprog --write $(TARGET).bit

clean:
	rm -rf *.blif *.asc *.bit *.json 

.PHONY: all flash clean
