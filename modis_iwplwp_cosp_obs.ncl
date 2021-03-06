;***********************************************************************************
; modis_iwplwp_cosp_obs.ncl
;***********************************************************************************
;
; plot global iwp and lwp from modis cosp and modis observations.
;
; levi silvers							jun 2018
;***********************************************************************************
; These files are loaded by default in NCL V6.2.0 and newer
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;***********************************************************************************
begin
;***********************************************************************************
; read in netCDF file
;***********************************************************************************
; variable to read: 
;scale=100.
scale=1.
;
switchnum=1 ; 1 plots IWP, 2 plots LWP

if (switchnum .eq. 1) then 
plotvar="IWP"
else if (switchnum .eq. 2) then
plotvar="LWP"
end if
end if 

if (switchnum .eq. 1) then
  print("plotting IWP")
  varname="iwpmodis" ;kg/m^2 Mean Liq W Path*CPCT
  ; varname1 is for the observations
  varname1="Ice_Path_Mean"
  maintit_mod="Ice Wat Path iwpmodis"
  maintit="Ice_Path_Mean 2010"
  ;plot_levs = (/35.,50.,55.,70.,95.,120.,150.,190.,220.,250.,280./)  ; 11
  plot_levs = (/5.,10.,20.,35.,50.,55.,70.,95.,190.,250.,350./)  ; 11
  plot_colors =   (/2,12,17,20,25,30,35,40,45,50,55,60/) ;12
else if (switchnum .eq. 2) then
print("plotting LWP")
  varname="lwpmodis" ;kg/m^2 Mean Liq W Path*CPCT
  ; varname1 is for the observations
  varname1="Liquid_Path_Mean"
  maintit_mod="Liq Wat Path lwpmodis"
  maintit="Liquid_Path_Mean 2010"
  ; values for lwp 
  plot_levs = (/5.,10.,20.,35.,50.,55.,70.,95.,120.,150.,190./)  ; 11
  ;my_colors_lwp =   (/2, 5,10,15,20,25,30,35,40,45,50,55/) ;12
  plot_colors =   (/2,12,17,20,25,30,35,40,45,50,55,60/) ;12
  my_levels_diff_lwp = (/-25.,-20,-15.,-10.,-5., 0., 5., 10.,15., 20.,25./) ;11
  my_colors_diff_lwp = (/2,5,8,11,14,17,31,34,37,40,43,46/) ; 12
end if
end if
;

modscale=1.e3
;varname="tclmodis" ;%
varnorm="tclmodis" ;%
;modscale=1
;maintit_mod="Cloud Fraction tclmodis"
print("variable to plot: "+varname1)
;***********************************************************************************
;dirin="/work/Levi.Silvers/moddata/misr_pp_am4g10r8_taugt0p3/"

; load modis observations
filein_obs1="/net2/Levi.Silvers/data/modisdata/MYD08_M3_NC.2010.01.C051.V02.nc"
filein_obs2="/net2/Levi.Silvers/data/modisdata/MYD08_M3_NC.2010.02.C051.V02.nc"
filein_obs3="/net2/Levi.Silvers/data/modisdata/MYD08_M3_NC.2010.03.C051.V02.nc"
filein_obs4="/net2/Levi.Silvers/data/modisdata/MYD08_M3_NC.2010.04.C051.V02.nc"
filein_obs5="/net2/Levi.Silvers/data/modisdata/MYD08_M3_NC.2010.05.C051.V02.nc"
filein_obs6="/net2/Levi.Silvers/data/modisdata/MYD08_M3_NC.2010.06.C051.V02.nc"
filein_obs7="/net2/Levi.Silvers/data/modisdata/MYD08_M3_NC.2010.07.C051.V02.nc"
filein_obs8="/net2/Levi.Silvers/data/modisdata/MYD08_M3_NC.2010.08.C051.V02.nc"
filein_obs9="/net2/Levi.Silvers/data/modisdata/MYD08_M3_NC.2010.09.C051.V02.nc"
filein_obs10="/net2/Levi.Silvers/data/modisdata/MYD08_M3_NC.2010.10.C051.V02.nc"
filein_obs11="/net2/Levi.Silvers/data/modisdata/MYD08_M3_NC.2010.11.C051.V02.nc"
filein_obs12="/net2/Levi.Silvers/data/modisdata/MYD08_M3_NC.2010.12.C051.V02.nc"

; load model data modis simulator

model1="c96L32_am4G12r18_2010climo_A_cosp"
;
; path to deck amip data:
path_amip="/archive/oar.gfdl.cmip6/CM4/warsaw_201803/CM4_amip/gfdl.ncrc4-intel16-prod-openmp/pp"
;
; from model output through cosp
infile1="/archive/Levi.Silvers/data/"+model1+"/atmos_month_modis/atmos_month_modis.0002-0011.alltmn.nc"

; from model output
;infile_atm="/archive/Levi.Silvers/data/"+model1+"/atmos/atmos.0002-0011.alltmn.nc"
infile_atm=path_amip+"/atmos/av/annual_36yr/atmos.1979-2014.ann.nc"

  data1 = addfile(filein_obs1,"r")
  data2 = addfile(filein_obs2,"r")
  data3 = addfile(filein_obs3,"r")
  data4 = addfile(filein_obs4,"r")
  data5 = addfile(filein_obs5,"r")
  data6 = addfile(filein_obs6,"r")
  data7 = addfile(filein_obs7,"r")
  data8 = addfile(filein_obs8,"r")
  data9 = addfile(filein_obs9,"r")
  data10 = addfile(filein_obs10,"r")
  data11 = addfile(filein_obs11,"r")
  data12 = addfile(filein_obs12,"r")

maintitle="what are you doing?"
; the lwp needs to be normalized by the total cloud amount
; after norm the difference is taken from r18
print("infile_atm is: "+infile_atm)
  fileatm     = addfile(infile_atm,"r")
  var_toplot = fileatm->$plotvar$(0,:,:)
  var_toplot=var_toplot*1000. ; convert to grams /m2
print("infile is: "+infile1)
  file2= addfile(infile1,"r")
  var_r18 = file2->$varname$(0,:,:) 
  var_tclr18 = file2->$varnorm$(0,:,:)
  var_r18 = modscale*var_r18 
  var_r18_norm = var_r18/var_tclr18 

print("filein_obs1 is: "+filein_obs1)
  t1 = data1->$varname1$(::-1,:)                       
  t2 = data2->$varname1$(::-1,:)                       
  t3 = data3->$varname1$(::-1,:)                       
  t4 = data4->$varname1$(::-1,:)                       
  t5 = data5->$varname1$(::-1,:)                       
  t6 = data6->$varname1$(::-1,:)                       
  t7 = data7->$varname1$(::-1,:)                       
  t8 = data8->$varname1$(::-1,:)                       
  t9 = data9->$varname1$(::-1,:)                       
  t10 = data10->$varname1$(::-1,:)                       
  t11 = data11->$varname1$(::-1,:)                       
  t12 = data12->$varname1$(::-1,:)    
  t_total=(t1+t2+t3+t4+t5+t6+t7+t8+t9+t10+t11+t12)/12                   
  vartoplot=scale*t_total         
  vartoplot!0="lat"
  vartoplot&lat=t1&lat
  vartoplot!1="lon"
  vartoplot&lon=t1&lon
  vartoplot@_FillValue=-999 ; sets _FillValue to -999
  tot_cld_sum=sum(vartoplot)
  print("sum of tot_cld_amt: "+tot_cld_sum)
  print("point values of cloud fraction: "+vartoplot(45,45))

  var_r18_norm!0="lat"
  var_r18_norm&lat=var_r18&lat
  var_r18_norm!1="lon"
  var_r18_norm&lon=var_r18&lon

;---------------------------------------------------------------------
; compute lat weights to determine the global mn
lat  = data1->lat
rad  = 4.0*atan(1.0)/180.0
clat = cos(lat*rad)
;field1_test = where(field1.gt.-900., field1,default_fillvalue("float"))
field1_weighted_ave     = wgt_areaave(vartoplot,clat,1.0,1)
; using 0 instead of 1 as the last parameter of wgt_areaave ave is calculated with 
; available non-missing data. 
print("raw global mean of "+varname1+" is: "+field1_weighted_ave)
;field1_weighted_ave_test     = wgt_areaave(field1_test,clat,1.0,0)
;print("global mean of non missing data "+varname1+" at time "+time+" is: "+field1_weighted_ave_test)
;
posh=flt2string(decimalPlaces(field1_weighted_ave,2,True))
maintitle="modis observations 2010 Cloud Frac"
;***********************************************************************************
; create plot
;***********************************************************************************
; create colors to use in contours
; contour levels

; values for total cloud cover
my_levels = (/0.,10.,20.,30.,40.,50.,60.,65.,70.,75.,80./) ; 11
;my_colors = (/25,28,35,41,46,53,59,65,69,75,79,85,91,95,97,101/) ; 16
my_colors = (/25,35,41,46,59,65,69,75,79,85,95,101/) ; 12
my_levels_diff = (/-2.5,-2,-1.5,-1,-0.5, 0, 0.5, 1,1.5, 2,2.5/) ;11
my_colors_diff = (/30,25,20,15,10,5,76,81,86,91,96,100/) ; 12

;set plot cont/colors to local values
;plot_levs=my_levels_iwp
;plot_colors=my_colors_iwp
;plot_levs_diff=my_levels_diff_lwp
;plot_colors_diff=my_colors_diff_lwp

  ;wks = gsn_open_wks("eps","testplot")          ; send graphics to ps file
  wks = gsn_open_wks("newPDF","testplot")          ; send graphics to ps file
  ;wks = gsn_open_wks("png","testplot")          ; send graphics to PNG file
  ;gsn_define_colormap(wks,"WhBlGrYeRe")
  ;gsn_define_colormap(wks,"BIGrYeOrReVi200")
  ;gsn_define_colormap(wks,"MPL_BuPu")
  ; below probably works well for LWP
  ;gsn_define_colormap(wks,"GMT_drywet")
  ; matlab_jet sucks, but certain people insist on using it for comparison to other figs.
  gsn_define_colormap(wks,"matlab_jet")
  plot=new(3,graphic)


  res                   = True
  res@cnLinesOn            = False
  res@mpProjection      = "Robinson"       ; choose projection
;  res@mpProjection      = "Mollweide"       ; choose projection
  res@mpCenterLonF      = 180.
  res@mpGridAndLimbOn   = True              ; turn on lat/lon lines
  res@mpPerimOn         = False             ; turn off box around plot
  res@mpGridLatSpacingF = 30.               ; spacing for lat lines
  res@mpGridLonSpacingF = 30.               ; spacing for lon lines
  res@lbLabelAngleF          = 90
  res@mpFillOn          = False
  res@gsnDraw          = False
  res@gsnFrame         = False
  ;res@gsnMaximize       = True      ; this influences how much of the page is filled
 
; these commands turn off/on the varname and units at top of image
  res@gsnLeftString = ""
  res@gsnRightString = ""

  res@cnFillOn          = True              ; color plot desired
;  res@cnFillPalette     = "gui_default"     ; set color map: ncl 6.1
  res@cnLineLabelsOn    = False             ; turn off contour lines
  res@cnLevelSelectionMode  = "ExplicitLevels"
  res@cnLevels          = plot_levs
  res@cnFillColors      = plot_colors
  res@txFontHeightF     = 0.015 

  ;res@vpXF            = 0.1                 ; make plot bigger
  ;res@vpYF            = 0.9         
  ;res@vpWidthF        = 0.8
  ;res@vpHeightF       = 0.8

  res@lbLabelFontHeightF  = 0.015           ; label bar font height

  ;res@tiMainString       = "Modis Cloud Particle Size Liq Mean"; add a title
  res@tiMainString       = maintit; add a title
  res@tiMainFontHeightF  = .018                               ; font height
  ;contour1 = gsn_csm_contour_map(wks,file1_reff,res)  ; create the plot
  ;contour1 = gsn_csm_contour_map(wks,file1_modis,res)  ; create the plot
  contour1 = gsn_csm_contour_map(wks,vartoplot,res)  ; create the plot
  plot(0) = contour1

  res@gsnFrame         = False
  res@tiMainString     = "model output "+plotvar
  res@cnLevels          = plot_levs
  res@cnFillColors      = plot_colors
  ;res@cnLevels          = plot_levs_diff
  ;res@cnFillColors      = plot_colors_diff
  ;contour3 = gsn_csm_contour_map(wks,var_r17_norm,res)  ; create the plot
  contour3 = gsn_csm_contour_map(wks,var_toplot,res)  ; create the plot
  plot(1) = contour3

  res@gsnFrame         = False
  tittittit=maintit_mod+" r18"
  res@tiMainString       = tittittit
  res@cnLevels          = plot_levs
  res@cnFillColors      = plot_colors
  ;res@cnLevels          = plot_levs_diff
  ;res@cnFillColors      = plot_colors_diff
  ;contour4 = gsn_csm_contour_map(wks,tdiff4co2,res)  ; create the plot
  print("max and min of var_16_norm: "+max(var_r18_norm)+" "+min(var_r18_norm))
  contour4 = gsn_csm_contour_map(wks,var_r18_norm,res)  ; create the plot
  plot(2) = contour4

  txres               = True
  txres@txFontHeightF = 0.03
  gsn_text_ndc(wks," ",0.5,0.95,txres)

  respanel = True

  gsn_panel(wks,plot,(/3,1/),respanel)
end

