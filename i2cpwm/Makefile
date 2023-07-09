
TARGET=i2cpwm
TOP=i2cpwm

OBJS+=i2cpwm.v clk.v pwm.v i2c_slave.v

ALL: $(TARGET).bit

$(TARGET).json: $(OBJS)
	yosys -p "synth_ice40 -top ${TOP} -json $@" $(OBJS)

$(TARGET)_out.config: $(TARGET).json
	nextpnr-ice40 --lp1k --package cm36 --json $(TARGET).json --pcf $(TARGET).pcf --asc $(TARGET).asc --freq 48

$(TARGET).bit: $(TARGET)_out.config
	icepack $(TARGET).asc $(TARGET).bit

flash: $(TARGET).bit
	icesprog --write $(TARGET).bit

clean:
	rm -rf *.blif *.asc *.bit *.json 

.PHONY: all flash clean
