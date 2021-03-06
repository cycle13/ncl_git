; load necessary libraries

 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
 load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

; path to data
path_to_wc="/Users/silvers/data"
walkcell="/WalkerCell/gauss_d"
file_pre="/19790101"

; name of output file
fileout="myqrad"

; for gcm
exper="/c8x160L33_am4p0_25km_wlkr_ctl"
;in_cloud=path_to_wc+walkcell+exper+"/mymy_clouds.nc"
in_cloud=path_to_wc+walkcell+exper+"/mymy_clouds_cfl.nc"
in_psi=path_to_wc+walkcell+exper+"/mymy_psi.nc"
;in_tdt=path_to_wc+walkcell+exper+"/mymy_tdt.nc"
in_tdt=path_to_wc+walkcell+exper+"/mymy_tdt_cfl.nc"

;in_crm_tdt=path_to_wc+walkcell+"/c96L33_am4p0_50x2000_nh_2km_wlkr_4K/mymy_crm_tdt.nc"
;in_crm_tmn=path_to_wc+walkcell+"/c50x2000L33_am4p0_2km_wlkr_4K/mymy_crm_tmn.nc"
in_crm_tmn=path_to_wc+walkcell+"/c10x4000L33_am4p0_1km_wlkr_4K/mymy_crm_tmn.nc"
  print("incoming file is: "+in_cloud)
  print("incoming file is: "+in_tdt)
  print("incoming file is: "+in_crm_tmn)
; for crm
in_rh_crm=path_to_wc+walkcell+"/mymy_cl_crm.nc"
in_psi_crm=path_to_wc+walkcell+"/mymy_psi_crm.nc"
  print("incoming file is: "+in_rh_crm)
  print("incoming file is: "+in_psi_crm)

data_cloud=addfile(in_cloud,"r")
data_tdt=addfile(in_tdt,"r")
data_psi=addfile(in_psi,"r")

data_crm_tmn=addfile(in_crm_tmn,"r")
;data_rh_crm=addfile(in_rh_crm,"r")
;data_psi_crm=addfile(in_psi_crm,"r")

var1="tdtlw_gcm" ; time, grid_y, grid_x
;var1="tdtconv_gcm" ; time, grid_y, grid_x
;var1="tdtls_gcm" ; time, grid_y, grid_x
;var1="tdt_totcl_gcm" ; conv + ls

crm_res="1km"
;hor_x_crm=ispan(2,4000,2)
hor_x_crm=ispan(1,4000,1)

var2="mystream"
var3="pfull"
var4="psi_"+crm_res
var5="tdtlw_"+crm_res
var6="tdtsw_gcm" 
var7="tdtsw_"+crm_res
var8="tdtconv_gcm"
var9="tdtls_"+crm_res ; heating due to large scale condensation
;var8="tdt_totcl_gcm" ; conv + ls heating
var10="tdtls_gcm" ; ls heating

field_lw_gcm    = data_tdt->$var1$(:,:,:)
field_sw_gcm    = data_tdt->$var6$(:,:,:)
field_tclh_gcm  = data_tdt->$var8$(:,:,:)
field_tlslh_gcm  = data_tdt->$var10$(:,:,:)
field_psi  = data_psi->$var2$(:,:,:)

field_press  = data_crm_tmn->$var3$(:)

field_psi_crm = data_crm_tmn->$var4$(:,:)
field_lw_crm  = data_crm_tmn->$var5$(:,:)
field_sw_crm  = data_crm_tmn->$var7$(:,:)
field_ls_crm  = data_crm_tmn->$var9$(:,:)

;
  print("dimsizes of field cloud are: "+dimsizes(field_lw_gcm))
  print("conv heating gcm max is: ="+max(field_tclh_gcm))
  print("ls heating gcm max is: ="+max(field_tlslh_gcm))
  print("lw gcm max is: ="+max(field_lw_gcm))
  print("lw crm max is: ="+max(field_lw_crm))
  print("ls heating crm max is: ="+max(field_ls_crm))
  print("---------------------------------------------")
  print("dimsizes of field clodu are: "+dimsizes(field_lw_gcm))
  print("---------------------------------------------")


plot_type="newPDF"
wks = gsn_open_wks(plot_type,fileout)

;my_levels1 = (/-5,-4.5,-4,-3.5,-3 \
;               -2.5,-2,-1.5,-1,-0.5, \
;               0,0.5,1.0,1.5,2, \
;               2.5,3.0,4.5,5.0 /); 19

my_levels1 = (/-8,-5,-4.5,-4,-3.5,-3 \
               -2.5,-2,-1.5,-1,-0.5, \
               0,0.5,1.0,1.5,2, \
               2.5,3.0,4.5,5.0,15.0 /); 19

;my_levels_psi = (/-5500,-4500,-3500,-2500,-1500,-500, \
;                   500, 1500, 2500,3500,4500,5500  /) ; 9
my_levels_psi = (/-7500,-6500,-5500,-4500,-3500,-2500,-1500,-500, \
                   500, 1500, 2500,3500,4500,5500,6500,7500  /) 

my_levels1_crm = (/1,3,5,7,9, \
               11,13,15,17,19, \
               21,23,25,27,29, \
               31,33,35,37,39, \
               41,43 /) ; 22

; for cmp_b2r there are 64 colors, transition is at about 31
my_colors1 = (/3,5,8,11,14, \
               16,18,21,24,27,31, \
               35,38,41,44,47, \
               50,53,57,60,63,65 /); ,\


my_col_psi = (/11,15,18,23,31,\
               39,47,\
               55,71,\
               79,87,91/) ;10 

;gsn_define_colormap(wks,"BlAqGrYeOrRe")

figurenumber = 1 ; 1 is defualt
;; 3 --> 3 month hov of 50x2000
;; 1 --> two panel figure of gcm and crm
;; 2 --> same as 3 
if (figurenumber .lt. 2) then

gsn_define_colormap(wks,"cmp_b2r")

;; start default plots----------------------------------------------------------
 plot = new(8,graphic)

; create resource for plot
 res = True     

 res@gsnDraw          = False
 res@gsnFrame         = False

; set up vertical axis limits
 res@cnInfoLabelOn            = False
 res@cnFillOn                 = True 
; res@cnFillMode               = "RasterFill"       ; Raster Mode
 res@cnLinesOn                = False
 ;res@cnLevelSelectionMode = "ManualLevels"
 res@cnLevelSelectionMode = "ExplicitLevels"
 res@cnLevels            = my_levels1
 res@cnFillColors        = my_colors1
; res@cnLinesOn             = False
 res@trYReverse               = True     ; reverse the y-axis
 res@gsnYAxisIrregular2Log = True    ; Convert Y axis to logarithmic
; res@cnMinLevelValF       = 0.
; res@cnMaxLevelValF       = 70.
 res@cnLineLabelInterval  = 0                   ; label every other line
; res@cnLevelSpacingF      = 5.0
 res@vpWidthF          = .5 ; vpWidth and Height control box size
 res@vpHeightF         = .5 ; default for both is 0.6 in NDC units

 res@lbLabelBarOn      = False

; these commands turn off/on the varname and units at top of image
 res@gsnLeftString = ""
 res@gsnRightString = ""
 res@trYMaxF      = 100000
 res@trYMinF      = 10000
 res@trXMaxF      = 4000
 res@trXMinF      = 2
 res@tmXBMode     = "Explicit"
 res@tmXBValues   = (/25,1000,2000,3000,4000/)
 res@tmXBLabels   = (/"0","1000","2000","3000","4000"/)
 res@tmYLMode     = "Explicit"
 res@tmYLValues   = (/100000,80000,60000,40000,20000,10000/)
 res@tmYLLabels    = (/"1000","800","600","400","200","100"/)
 res@tiXAxisString     = "km"
 res@tiYAxisString     = "Pressure (hPa) "

ensind=2
epsilon1="ent0p9"
mainTitle="Heating Rates (K/d) for "+crm_res+" (top) and GCM(bot) "+epsilon1

plot_a=field_lw_gcm
plot_d=field_sw_gcm
plot_e=field_tclh_gcm
plot_h=field_lw_gcm+field_sw_gcm
plot_j=field_tlslh_gcm
psiplot=field_psi
hor_x=ispan(25,4000,25)
print("dimsizes of hor_x are: "+dimsizes(hor_x))

plot_b=field_lw_crm
plot_c=field_sw_crm
plot_f=field_ls_crm
plot_g=field_lw_crm+field_sw_crm
psiplot_b=field_psi_crm
;hor_x_crm=ispan(2,4000,2)
;hor_x_crm=ispan(1,4000,1)
print("dimsizes of hor_x_crm are: "+dimsizes(hor_x_crm))

plot_a!0="plev"
plot_a&plev=field_press
psiplot!0="plev"
psiplot&plev=field_press
plot_a!1="xdim"
plot_a&xdim=hor_x
psiplot!1="xdim"
psiplot&xdim=hor_x

plot_d!0="plev"
plot_d&plev=field_press
plot_d!1="xdim"
plot_d&xdim=hor_x

plot_e!0="plev"
plot_e&plev=field_press
plot_e!1="xdim"
plot_e&xdim=hor_x

plot_h!0="plev"
plot_h&plev=field_press
plot_h!1="xdim"
plot_h&xdim=hor_x

plot_j!0="plev"
plot_j&plev=field_press
plot_j!1="xdim"
plot_j&xdim=hor_x


plot_b!0="plev"
plot_b&plev=field_press
psiplot_b!0="plev"
psiplot_b&plev=field_press
plot_b!1="xdim"
plot_b&xdim=hor_x_crm
psiplot_b!1="xdim"
psiplot_b&xdim=hor_x_crm

plot_c!0="plev"
plot_c&plev=field_press
plot_c!1="xdim"
plot_c&xdim=hor_x_crm

plot_f!0="plev"
plot_f&plev=field_press
plot_f!1="xdim"
plot_f&xdim=hor_x_crm

plot_g!0="plev"
plot_g&plev=field_press
plot_g!1="xdim"
plot_g&xdim=hor_x_crm

; for gcm
res@gsnCenterString = "LW"
plot_gcm = gsn_csm_contour(wks,plot_a(:,:,ensind),res)
res@gsnCenterString = "SW"
plot_sw_gcm = gsn_csm_contour(wks,plot_d(:,:,ensind),res)
res@gsnCenterString = "Conv"
plot_tclh_gcm = gsn_csm_contour(wks,plot_e(:,:,ensind),res)
res@gsnCenterString = "LS"
plot_tlslh_gcm = gsn_csm_contour(wks,plot_j(:,:,ensind),res)
res@gsnCenterString = "Qrad"
plot_qrad_gcm = gsn_csm_contour(wks,plot_h(:,:,ensind),res)

; for crm
;res@cnFillMode               = "RasterFill"       ; Raster Mode
; ;plot_rh = gsn_csm_contour(wks,plot_a(:,::-1,ensind),res)
res@gsnCenterString = "LW"
plot_lw_crm = gsn_csm_contour(wks,plot_b(:,:),res)
res@gsnCenterString = "SW"
plot_sw_crm = gsn_csm_contour(wks,plot_c(:,:),res)
res@gsnCenterString = "LS "
plot_ls_crm = gsn_csm_contour(wks,plot_f(:,:),res)
res@gsnCenterString = "Qrad "
plot_qrad_crm = gsn_csm_contour(wks,plot_g(:,:),res)
 
 res2 = True     
 res2@gsnDraw               = False
 res2@gsnFrame              = False
 res2@cnLevels              = my_levels_psi
 res2@cnInfoLabelOn         = False
 res2@cnLevelSelectionMode = "ExplicitLevels"
 res2@cnMonoLineDashPattern = False
 res2@cnLineDashPatterns = (/2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0/)
 res2@cnLinesOn             = True
 res2@cnLineLabelsOn        = False
 res2@cnLineThicknessF      = 2
 res2@trYReverse            = True     ; reverse the y-axis
 res2@gsnYAxisIrregular2Log = True    ; Convert Y axis to logarithmic
 res2@trYMaxF      = 100000
 res2@trYMinF      = 10000
 res2@trXMaxF      = 4000
 res2@trXMinF      = 2
 res2@tmXBMode     = "Explicit"
 res2@tmXBValues   = (/25,1000,2000,3000,4000/)
 ;res2@tmXBLabels   = ""+res2@tmXBValues
 res2@tmXBLabels   = (/"0","1000","2000","3000","4000"/)
 ;res2@tmYLMode     = "Explicit"
 ;;res2@tmYLValues   = (/100000,80000,60000,40000,20000,10000/)
 ;;res2@tmYLValues   = (/10000,20000,40000,60000,80000,100000/)
 ;;res2@tmYLLabels   = ""+res2@tmYLValues
 res2@vpWidthF          = .5 ; vpWidth and Height control box size
 res2@vpHeightF         = .5 ; default for both is 0.6 in NDC units
 res2@lbLabelBarOn      = False
; these commands turn off/on the varname and units at top of image
 res2@gsnLeftString = ""
 res2@gsnRightString = ""
 res2@tiXAxisString     = " "
 res2@tiYAxisString     = "height "

; for gcm 
plot_psi = gsn_csm_contour(wks,psiplot(:,:,ensind),res2)
;;plot_psi = gsn_csm_contour(wks,psiplot(:,::-1,ensind),res2)

; for crm
plot_psi_b = gsn_csm_contour(wks,psiplot_b(:,:),res2)

;overlay(plot_gcm,plot_psi)
;overlay(plot_lw_crm,plot_psi_b)

; top row
plot(0) = plot_qrad_crm
plot(1) = plot_lw_crm
;plot(2) = plot_qrad_crm
plot(2) = plot_ls_crm

; bottom row
plot(4) = plot_qrad_gcm
plot(5) = plot_gcm
plot(6) = plot_tlslh_gcm
plot(7) = plot_tclh_gcm

;plot(2) = gsn_csm_contour(wks,plot_a(:,:,ensind+1),res)
;plot(3) = gsn_csm_contour(wks,plot_a(:,:,ensind+2),res)
;;plot(1) = gsn_csm_contour(wks,psiplot(:,:,ensind),res2)


resP                         = True
;resP@txString                = "good grief"
resP@txString                = mainTitle
resP@gsnPanelLabelBar        = True
;resP@vpWidthF          = 2.0 ; vpWidth and Height control box size
;resP@vpHeightF         = 0.86 ; default for both is 0.6 in NDC units
;resP@lbLabelFontHeightF      = 0.012
resP@lbLabelFontHeightF      = 0.022

gsn_panel(wks,plot,(/2,4/),resP)
;
end if

end
