# find "device" by "node"
## device = struct platform_device
## node = struct device_node (node on DTS)
## ref:
##  include/linux/of_platform.h:of_find_device_by_node()
##  drivers/ata/pata_octeon_cf.c:octeon_cf_probe()
##  arch/mips/boot/dts/cavium-octeon/octeon_3xxx.dts:bootbus:cf0

[DTS]
fpga,dma-engine-handle = <&sdma1>

[C]
struct device_node *dma_node;
struct platform_device *dma_dev;
struct device_node *node;

node = pSpiDev->dev.of_node;
dma_node = of_parse_phandle(node, "fpga,dma-engine-handle", 0);
if (dma_node) {
    dma_dev = of_find_device_by_node(dma_node);
    if (dma_dev) {
        ...
    }
}
