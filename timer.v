/* Verilog netlist generated by SCUBA Diamond (64-bit) 3.10.2.115 */
/* Module Version: 1.2 */
/* C:\Program Files\Iscc\diamond\3.10_x64\ispfpga\bin\nt64\scuba.exe -w -n timer -lang verilog -synth lse -bus_exp 7 -bb -type efb -arch xo2c00 -freq 50 -static_tc -tc -tc_mode CTCM -tc_o STATIC -tc_div 1 -tc_top 65535 -tc_ocr 32767 -tc_sa_oflow -tc_ctr -dev 7000  */
/* Mon Jun 04 13:13:00 2018 */


`timescale 1 ns / 1 ps
module timer (tc_clki, tc_rstn, tc_int, tc_oc)/* synthesis NGD_DRC_MASK=1 */;
    input wire tc_clki;
    input wire tc_rstn;
    output wire tc_int;
    output wire tc_oc;

    wire scuba_vhi;
    wire scuba_vlo;

    VHI scuba_vhi_inst (.Z(scuba_vhi));

    VLO scuba_vlo_inst (.Z(scuba_vlo));

    defparam EFBInst_0.UFM_INIT_FILE_FORMAT = "HEX" ;
    defparam EFBInst_0.UFM_INIT_FILE_NAME = "NONE" ;
    defparam EFBInst_0.UFM_INIT_ALL_ZEROS = "ENABLED" ;
    defparam EFBInst_0.UFM_INIT_START_PAGE = 0 ;
    defparam EFBInst_0.UFM_INIT_PAGES = 0 ;
    defparam EFBInst_0.DEV_DENSITY = "7000L" ;
    defparam EFBInst_0.EFB_UFM = "DISABLED" ;
    defparam EFBInst_0.TC_ICAPTURE = "DISABLED" ;
    defparam EFBInst_0.TC_OVERFLOW = "ENABLED" ;
    defparam EFBInst_0.TC_ICR_INT = "OFF" ;
    defparam EFBInst_0.TC_OCR_INT = "OFF" ;
    defparam EFBInst_0.TC_OV_INT = "OFF" ;
    defparam EFBInst_0.TC_TOP_SEL = "ON" ;
    defparam EFBInst_0.TC_RESETN = "ENABLED" ;
    defparam EFBInst_0.TC_OC_MODE = "STATIC" ;
    defparam EFBInst_0.TC_OCR_SET = 32767 ;
    defparam EFBInst_0.TC_TOP_SET = 65535 ;
    defparam EFBInst_0.GSR = "ENABLED" ;
    defparam EFBInst_0.TC_CCLK_SEL = 1 ;
    defparam EFBInst_0.TC_MODE = "CTCM" ;
    defparam EFBInst_0.TC_SCLK_SEL = "PCLOCK" ;
    defparam EFBInst_0.EFB_TC_PORTMODE = "NO_WB" ;
    defparam EFBInst_0.EFB_TC = "ENABLED" ;
    defparam EFBInst_0.SPI_WAKEUP = "DISABLED" ;
    defparam EFBInst_0.SPI_INTR_RXOVR = "DISABLED" ;
    defparam EFBInst_0.SPI_INTR_TXOVR = "DISABLED" ;
    defparam EFBInst_0.SPI_INTR_RXRDY = "DISABLED" ;
    defparam EFBInst_0.SPI_INTR_TXRDY = "DISABLED" ;
    defparam EFBInst_0.SPI_SLAVE_HANDSHAKE = "DISABLED" ;
    defparam EFBInst_0.SPI_PHASE_ADJ = "DISABLED" ;
    defparam EFBInst_0.SPI_CLK_INV = "DISABLED" ;
    defparam EFBInst_0.SPI_LSB_FIRST = "DISABLED" ;
    defparam EFBInst_0.SPI_CLK_DIVIDER = 1 ;
    defparam EFBInst_0.SPI_MODE = "MASTER" ;
    defparam EFBInst_0.EFB_SPI = "DISABLED" ;
    defparam EFBInst_0.I2C2_WAKEUP = "DISABLED" ;
    defparam EFBInst_0.I2C2_GEN_CALL = "DISABLED" ;
    defparam EFBInst_0.I2C2_CLK_DIVIDER = 1 ;
    defparam EFBInst_0.I2C2_BUS_PERF = "100kHz" ;
    defparam EFBInst_0.I2C2_SLAVE_ADDR = "0b1000010" ;
    defparam EFBInst_0.I2C2_ADDRESSING = "7BIT" ;
    defparam EFBInst_0.EFB_I2C2 = "DISABLED" ;
    defparam EFBInst_0.I2C1_WAKEUP = "DISABLED" ;
    defparam EFBInst_0.I2C1_GEN_CALL = "DISABLED" ;
    defparam EFBInst_0.I2C1_CLK_DIVIDER = 1 ;
    defparam EFBInst_0.I2C1_BUS_PERF = "100kHz" ;
    defparam EFBInst_0.I2C1_SLAVE_ADDR = "0b1000001" ;
    defparam EFBInst_0.I2C1_ADDRESSING = "7BIT" ;
    defparam EFBInst_0.EFB_I2C1 = "DISABLED" ;
    defparam EFBInst_0.EFB_WB_CLK_FREQ = "50.0" ;
    EFB EFBInst_0 (.WBCLKI(scuba_vlo), .WBRSTI(scuba_vlo), .WBCYCI(scuba_vlo), 
        .WBSTBI(scuba_vlo), .WBWEI(scuba_vlo), .WBADRI7(scuba_vlo), .WBADRI6(scuba_vlo), 
        .WBADRI5(scuba_vlo), .WBADRI4(scuba_vlo), .WBADRI3(scuba_vlo), .WBADRI2(scuba_vlo), 
        .WBADRI1(scuba_vlo), .WBADRI0(scuba_vlo), .WBDATI7(scuba_vlo), .WBDATI6(scuba_vlo), 
        .WBDATI5(scuba_vlo), .WBDATI4(scuba_vlo), .WBDATI3(scuba_vlo), .WBDATI2(scuba_vlo), 
        .WBDATI1(scuba_vlo), .WBDATI0(scuba_vlo), .PLL0DATI7(scuba_vlo), 
        .PLL0DATI6(scuba_vlo), .PLL0DATI5(scuba_vlo), .PLL0DATI4(scuba_vlo), 
        .PLL0DATI3(scuba_vlo), .PLL0DATI2(scuba_vlo), .PLL0DATI1(scuba_vlo), 
        .PLL0DATI0(scuba_vlo), .PLL0ACKI(scuba_vlo), .PLL1DATI7(scuba_vlo), 
        .PLL1DATI6(scuba_vlo), .PLL1DATI5(scuba_vlo), .PLL1DATI4(scuba_vlo), 
        .PLL1DATI3(scuba_vlo), .PLL1DATI2(scuba_vlo), .PLL1DATI1(scuba_vlo), 
        .PLL1DATI0(scuba_vlo), .PLL1ACKI(scuba_vlo), .I2C1SCLI(scuba_vlo), 
        .I2C1SDAI(scuba_vlo), .I2C2SCLI(scuba_vlo), .I2C2SDAI(scuba_vlo), 
        .SPISCKI(scuba_vlo), .SPIMISOI(scuba_vlo), .SPIMOSII(scuba_vlo), 
        .SPISCSN(scuba_vlo), .TCCLKI(tc_clki), .TCRSTN(tc_rstn), .TCIC(scuba_vlo), 
        .UFMSN(scuba_vhi), .WBDATO7(), .WBDATO6(), .WBDATO5(), .WBDATO4(), 
        .WBDATO3(), .WBDATO2(), .WBDATO1(), .WBDATO0(), .WBACKO(), .PLLCLKO(), 
        .PLLRSTO(), .PLL0STBO(), .PLL1STBO(), .PLLWEO(), .PLLADRO4(), .PLLADRO3(), 
        .PLLADRO2(), .PLLADRO1(), .PLLADRO0(), .PLLDATO7(), .PLLDATO6(), 
        .PLLDATO5(), .PLLDATO4(), .PLLDATO3(), .PLLDATO2(), .PLLDATO1(), 
        .PLLDATO0(), .I2C1SCLO(), .I2C1SCLOEN(), .I2C1SDAO(), .I2C1SDAOEN(), 
        .I2C2SCLO(), .I2C2SCLOEN(), .I2C2SDAO(), .I2C2SDAOEN(), .I2C1IRQO(), 
        .I2C2IRQO(), .SPISCKO(), .SPISCKEN(), .SPIMISOO(), .SPIMISOEN(), 
        .SPIMOSIO(), .SPIMOSIEN(), .SPIMCSN7(), .SPIMCSN6(), .SPIMCSN5(), 
        .SPIMCSN4(), .SPIMCSN3(), .SPIMCSN2(), .SPIMCSN1(), .SPIMCSN0(), 
        .SPICSNEN(), .SPIIRQO(), .TCINT(tc_int), .TCOC(tc_oc), .WBCUFMIRQ(), 
        .CFGWAKE(), .CFGSTDBY());



    // exemplar begin
    // exemplar end

endmodule
