---KT76C transponder for the AirfoilLabs C172SP

panel_image     =img_add("KT76C.png",0,0,700,170)
dig_46redL      ="font:digital-7-mono.ttf; size:46px; color: red; halign:left;  valign:center;"
ari_22redR      ="font:arimo_bold.ttf;     size:22px; color: red; halign:right; valign:center;"

------------------------------------------------------------------------------------------
   ----Display Modes----
------------------------------------------------------------------------------------------
xpdr_code=canvas_add(0,0,700,170, function()
   _txt("",dig_46redL,400,53)
end)
visible(xpdr_code,false)

xpdr_SBY=canvas_add(0,0,700,170, function()
   _txt("SBY",ari_22redR,330,65)
end)
visible(xpdr_SBY,false)

xpdr_test=canvas_add(0,0,700,170, function()
   _txt("FL",ari_22redR,125,72)
   _txt("ALT",ari_22redR,282,43)
   _txt("ON",ari_22redR,330,43)
   _txt("R",ari_22redR,370,43)
   _txt("SBY",ari_22redR,330,65)
   _txt("-",dig_46redL,100,53)
   _txt("888",dig_46redL,130,53)
   _txt("8888",dig_46redL,400,53)
end)
visible(xpdr_test,false)

xpdr_R=canvas_add(0,0,700,170, function()
   _txt("R",ari_22redR,370,43)
end)
visible(xpdr_R,false)

xpdr_ON=canvas_add(0,0,700,170, function()
   _txt("ON",ari_22redR,330,43)
end)
visible(xpdr_ON,false)

xpdr_ALT=canvas_add(0,0,700,170, function()
   _txt("ALT",ari_22redR,282,43)
   _txt("FL",ari_22redR,125,72)
end)
visible(xpdr_ALT,false)

xpdr_mns=canvas_add(0,0,700,170, function()
   _txt("-",dig_46redL,100,53)
end)
visible(xpdr_mns,false)

---Dial
temp_dial=canvas_add(0,0,86,86, function()
   _circle(43,43,43)
   _fill("#000000")
   _circle(43,43,33)
   _fill("#1c1c1c")
   _move_to(86,36)
   _line_to(76,43)
   _line_to(86,50)
   _line_to(86,36)
   _fill("#ffffff")
end)
move(temp_dial,597,44,nil,nil)
rotate(temp_dial,145)
------------------------------------------------------------------------------------------
   ----Transponder code----
------------------------------------------------------------------------------------------
function transponder_callback(cod1,cod2,cod3,cod4,lit1,lit2,lit3,lit4,line2,line3,line4,alt_v)
   dig1=tostring(cod1)
   dig2=tostring(cod2)
   dig3=tostring(cod3)
   dig4=tostring(cod4)   
    
   canvas_draw(xpdr_code, function()  
     if lit1 == 1 then _txt(dig1,dig_46redL,400,53) end
     if lit2 == 1 and line2 ==0 then _txt(dig2,dig_46redL,425,53) else _txt("-",dig_46redL,425,53)end  
     if lit3 == 1 and line3 ==0 then _txt(dig3,dig_46redL,450,53) else _txt("-",dig_46redL,450,53)end   
     if lit4 == 1 and line4 ==0 then _txt(dig4,dig_46redL,475,53) else _txt("-",dig_46redL,475,53)end    
   end)

   canvas_draw(xpdr_ALT, function()
      _txt("ALT",ari_22redR,282,43)
      _txt("FL",ari_22redR,125,72)
      _txt(tostring(string.format("%03.0f",alt_v)),dig_46redL,130,53)
   end)
end

------------------------------------------------------------------------------------------
   ----Fetch Dial position----
------------------------------------------------------------------------------------------
xpdr_dial=0
function switch_pos(pos)
  xpdr_dial=var_round(pos,0)
  rotate(temp_dial,145+(xpdr_dial*45))
end

------------------------------------------------------------------------------------------
   ----Visibility----
------------------------------------------------------------------------------------------
function visibility_callback(alt,minus,on,sby,tx,tst)
  visible(xpdr_ALT,alt==1)
  visible(xpdr_mns,minus==1)
  visible(xpdr_ON,on==1)
  visible(xpdr_SBY,sby==1)
  visible(xpdr_R,tx==1)
  visible(xpdr_test,tst==1)
  visible(xpdr_code,alt==1 or on==1 or sby==1)
end

------------------------------------------------------------------------------------------
   ----Buttons & Dials----
------------------------------------------------------------------------------------------
function ident()
    xpl_command("172/xpdr/xpdr_idt")
end
button_add(nil, nil,22,37,43,25,ident)
function digit_0()
    xpl_command("172/xpdr/xpdr_p_0")
end
button_add(nil, nil,22,140,43,25,digit_0)
function digit_1()
    xpl_command("172/xpdr/xpdr_p_1")
end
button_add(nil, nil,85,140,40,25,digit_1)
function digit_2()
    xpl_command("172/xpdr/xpdr_p_2")
end
button_add(nil, nil,148,140,40,25,digit_2)
function digit_3()
    xpl_command("172/xpdr/xpdr_p_3")
end
button_add(nil, nil,211,140,40,25,digit_3)
function digit_4()
    xpl_command("172/xpdr/xpdr_p_4")
end
button_add(nil, nil,274,140,40,25,digit_4)
function digit_5()
    xpl_command("172/xpdr/xpdr_p_5")
end
button_add(nil, nil,337,140,40,25,digit_5)
function digit_6()
    xpl_command("172/xpdr/xpdr_p_6")
end
button_add(nil, nil,400,140,40,25,digit_6)
function digit_7()
    xpl_command("172/xpdr/xpdr_p_7")
end
button_add(nil, nil,463,140,40,25,digit_7)

function clr()
    xpl_command("172/xpdr/xpdr_clr")
end
button_add(nil, nil,550,140,40,25,clr)
function vfr()
     xpl_command("172/xpdr/xpdr_vfr")
end
button_add(nil, nil,640,140,40,25,vfr)

dial_pos=0
function dial_callback(dir)
   dial_pos=var_cap(dial_pos+dir,0,4)
   rotate(temp_dial,145+(dial_pos*45))
   if dial_pos < xpdr_dial then
     xpl_command("172/com_XPDR_mode_Turn_left")
   elseif dial_pos > xpdr_dial then
	 xpl_command("172/com_XPDR_mode_Turn_right")
   end
end
dial_add(nil,597,47,86,86,dial_callback)
------------------------------------------------------------------------------------------
   ----Data buss----
------------------------------------------------------------------------------------------
xpl_dataref_subscribe("172/xpdr/xpdr_CODE1","INT",
                      "172/xpdr/xpdr_CODE2","INT",
		      "172/xpdr/xpdr_CODE3","INT",
		      "172/xpdr/xpdr_CODE4","INT",
                      "172/xpdr/xpdr_CODE1_lit","FLOAT",					  
                      "172/xpdr/xpdr_CODE2_lit","FLOAT",
                      "172/xpdr/xpdr_CODE3_lit","FLOAT",
		      "172/xpdr/xpdr_CODE4_lit","FLOAT",
		      "172/xpdr/xpdr_LINE2","INT",
		      "172/xpdr/xpdr_LINE3","INT",
		      "172/xpdr/xpdr_LINE4","INT",
                      "172/xpdr/xpdr_density_alt","FLOAT",transponder_callback)
					  
xpl_dataref_subscribe("172/av_panel/xpdr/xpdr_mode","FLOAT",switch_pos)

xpl_dataref_subscribe("172/xpdr/xpdr_alt_lit","INT",
                      "172/xpdr/xpdr_minus_lit","INT",
		      "172/xpdr/xpdr_on_lit","INT",
		      "172/xpdr/xpdr_sby_lit","INT",
		      "172/xpdr/xpdr_transmit_lit","INT",
		      "172/xpdr/xpdr_tst_lit","INT",visibility_callback)
