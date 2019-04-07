# Modeling-of-10-bit-Pipeline-ADC-and-10-bit-DAC
This project shows how to model a 10-bit pipeline ADC and a 10-bit DAC using ideal components. Used vdc, vpulse, vcvs, switch, res, cap, vccs to construct the 10-bit ADC based on 1-bit per stage pipelined architecture. Models are built in Cadence using ideal components & VerilogA blocks, & Analysis is done on Matlab.

## 1-bit per stage block
![Ideal_1bit_ADC](https://user-images.githubusercontent.com/27668656/55679555-93ea0d00-58c2-11e9-8a96-1659f74f543b.png)

## 10-bit Pipeline ADC
![Ideal_10bit_ADC](https://user-images.githubusercontent.com/27668656/55679576-d9a6d580-58c2-11e9-9a41-1302f80e25ec.png)

## 10-bit DAC
![Ideal_DAC](https://user-images.githubusercontent.com/27668656/55687814-266fc800-5926-11e9-9249-7a676704fb23.png)

## System Testbench
![Testbench_ADC_Ideal](https://user-images.githubusercontent.com/27668656/55687821-515a1c00-5926-11e9-962a-5af3ec1e90ef.png)

-> Using VerilogA blocks: <br/>
![Testbench_ADC_VerilogA](https://user-images.githubusercontent.com/27668656/55687850-8a928c00-5926-11e9-8e72-1bd2e8923eeb.png) <br/>
*****************
## To analyze the output results:
- Using Cadence:<br/>
Select the transient signal of the DAC's output, then use the "dft" & "dB20" functions in the ADE calculator to plot the output FFT spectrum.<br/>
https://drive.google.com/open?id=1P0Qo3bQ7QQucbzPnD_u01404rpjmt8zj <br/>
- Using Matlab:<br/>
Sample the transient signal of the DAC's output by using the "sample" function in the ADE calculator, then save tha samples in a CSV file, then Run the Matlab code on the CSV data.<br/>
https://drive.google.com/file/d/1yapHM566FUtoERnFrU_xc2nd3FOF-ETe/view <br/>

*****************
### References:
My project on google drive:<br/>
https://drive.google.com/drive/folders/1W9ip4MpMZNf3IQsoFQkhgg6QaUya4Yp4 <br/>
EE288 Lecture Notes:<br/>
https://drive.google.com/drive/folders/12Qqfw_TX1i7dvVVYXksaSdHV4gth1OD5 <br/>
Videos on how to create VerilogA blocks for ADCs:
https://drive.google.com/drive/folders/1GAobRzzFTkD6ywqSdDJUsO5g2C06hh_i <br/>
https://www.youtube.com/channel/UC7jwESeWKLcRbtxHwFS3A7Q/videos 
