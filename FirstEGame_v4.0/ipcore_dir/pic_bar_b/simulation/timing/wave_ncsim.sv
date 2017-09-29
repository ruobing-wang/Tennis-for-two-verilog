
 
 
 




window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"


      waveform add -signals /pic_bar_b_tb/status
      waveform add -signals /pic_bar_b_tb/pic_bar_b_synth_inst/bmg_port/CLKA
      waveform add -signals /pic_bar_b_tb/pic_bar_b_synth_inst/bmg_port/ADDRA
      waveform add -signals /pic_bar_b_tb/pic_bar_b_synth_inst/bmg_port/DOUTA
console submit -using simulator -wait no "run"
