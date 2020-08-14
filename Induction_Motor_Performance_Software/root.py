from tkinter import *
import cmath

root = Tk()
root.title("Simple Induction Motor Performance")

def computeWindow():
    top = Toplevel()
    top.title("Computation Window")
    #Creating label widget for the welcome window
    title_label = Label(top,text=" INPUT  DATA  ")
    center_label = Label(top,text="  -  ")
    horse_power_label = Label(top,text="Horse Power :  "+result["horse power"])
    voltage_label = Label(top,text="Voltage (V) :  "+result["voltage"])
    phase_label = Label(top,text="Phases :  "+result["phase"])
    frequency_label = Label(top,text="Frequency (Hz) :  "+result["frequency"])
    base_power_label = Label(top,text="Per Unit Base Power(KW) :  "+result["base power"])
    per_unit_voltage_label = Label(top,text="Per Unit Base Voltage(V) :  "+result["per unit voltage"])
    per_unit_current_label = Label(top,text="Per Unit Base Current(A) :  "+result["per unit current"])
    per_unit_impedance_label = Label(top,text="Per Unit Base Impedance :  "+result["per unit impedance"])
    r1_label = Label(top,text="r1 (p.u) :  "+result["r1"])
    r2_label = Label(top,text="r2 (p.u) :  "+result["r2"])
    rm_label = Label(top,text="rm (p.u) :  "+result["rm"])
    x1_label = Label(top,text="x1 (p.u) :  "+result["x1"])
    x2_label = Label(top,text="x2 (p.u) :  "+result["x2"])
    xm_label = Label(top,text="xm (p.u) :  "+result["xm"])
    friction_and_windage_label = Label(top,text="Friction and Windage (kw) :  "+result["friction and windage"])
    stray_load_label = Label(top,text="Stray-Load Loss (kw) :  "+result["stray load"])
    assume_slip_label = Label(top,text="Slip (s) : "+result["assume_slip"])
    #doing all calculation
    z1 = complex(float(result['r1']),float(result['x1']))
    z2 = complex(float(result['r2'])/float(result['assume_slip']),float(result['x2']))
    zm = complex(float(result['rm']),float(result['xm']))
    i1 = (1.0 * (zm + z2)) / ((z1 * zm) + (z1 * z2) + (z2 * zm))
    i1 = cmath.polar(i1)
    i2 = (1.0 * zm) / ((z1 * zm) + (z1 * z2) + (z2 * zm))
    i2 = cmath.polar(i2)
    im = (1.0 * z2) / ((z1 * zm) + (z1 * z2) + (z2 * zm))
    im = cmath.polar(im)
    ibase = 9.363

    #formular used
    i1_label = Label(top,text="I1 = V(Zm + Z2) / ( Z1*Zm + Z1*Z2 + Z2*Zm) ")
    i2_label = Label(top,text="I2 = V*Zm / ( Z1*Zm + Z1*Z2 + Z2*Zm) ")
    im_label = Label(top,text="Im = V*Z2 / ( Z1*Zm + Z1*Z2 + Z2*Zm) ")
    z1_label = Label(top,text="Z1 = r1 + jx1 ")
    z2_label = Label(top,text="Z2 = r2/s + jx2 ")
    zm_label = Label(top,text="Zm = rm + jxm ")
    v_label = Label(top,text="V = 460V = 1.0 p.u")
    ibase_label = Label(top,text="Ibase = 9.363 (Refer to table)")

    global final_result
    final_result = {}
    I_1 = ibase * i1[0]
    I_2 = ibase * i2[0]
    R2_base = float(result["per unit impedance"])
    R_2 = float(result["r2"])
    R_1 = float(result['r1'])
    final_result['i_1'] = I_1
    final_result['i_2'] = I_2
    final_result['r2_base'] = R2_base
    final_result['r2'] = R_2
    final_result['r1'] = R_1
    #results
    z1_value_label = Label(top,text="z1 = "+str(z1))
    z2_value_label = Label(top,text="z2 = "+str(z2))
    zm_value_label = Label(top,text="zm = "+str(zm))
    i1_value_label = Label(top,text="i1 = "+str(i1))
    i2_value_label = Label(top,text="i2 = "+str(i2))
    im_value_label = Label(top,text="im = "+str(im))
    i1_ampere_label = Label(top,text=" Or " +str(ibase * i1[0]) +" A")
    i2_ampere_label = Label(top,text=" Or " +str(ibase * i2[0]) +" A")
    im_ampere_label = Label(top,text=" Or " +str(ibase * im[0]) +" A")
    calculation_title = Label(top,text=" FORMULAR USED ")
    calculation_result = Label(top,text=" RESULTS ")

    continue_button = Button(top,text='    Continue    ',command=finalCalculation)
    quit_button = Button(top,text='    Quit    ',command=top.destroy)
    #arranging the grid fields
    title_label.grid(row=0,column=1,padx=20,pady=10)
    horse_power_label.grid(row=1,column=0,padx=30,pady=10)
    voltage_label.grid(row=2,column=0,padx=30,pady=10)
    phase_label.grid(row=3,column=0,padx=30,pady=10)
    frequency_label.grid(row=4,column=0,padx=30,pady=10)
    assume_slip_label.grid(row=5,column=0,padx=30,pady=10)
    base_power_label.grid(row=1,column=1,padx=30,pady=10)
    per_unit_voltage_label.grid(row=2,column=1,padx=30,pady=10)
    per_unit_current_label.grid(row=3,column=1,padx=30,pady=10)
    per_unit_impedance_label.grid(row=4,column=1,padx=30,pady=10)

    r1_label.grid(row=1,column=2,padx=30,pady=10)
    r2_label.grid(row=2,column=2,padx=30,pady=10)
    rm_label.grid(row=3,column=2,padx=30,pady=10)
    x1_label.grid(row=4,column=2,padx=30,pady=10)
    x2_label.grid(row=5,column=1,padx=30,pady=10)
    xm_label.grid(row=5,column=2,padx=30,pady=10)
    stray_load_label.grid(row=6,column=0,padx=30,pady=10)
    friction_and_windage_label.grid(row=6,column=1,padx=30,pady=10)


    calculation_title.grid(row=7,column=1,padx=20,pady=10)
    i1_label.grid(row=8,column=0,padx=20,pady=5)
    i2_label.grid(row=8,column=1,padx=20,pady=5)
    im_label.grid(row=8,column=2,padx=20,pady=5)
    z1_label.grid(row=9,column=0,padx=20,pady=10)
    z2_label.grid(row=9,column=1,padx=20,pady=10)
    zm_label.grid(row=9,column=2,padx=20,pady=10)
    v_label.grid(row=10,column =0,padx=20,pady=5)
    ibase_label.grid(row=10,column=1,padx=20,pady=5)
    calculation_result.grid(row=11,column=1,padx=20,pady=10)
    z1_value_label.grid(row=12,column=0,padx=20,pady=5)
    z2_value_label.grid(row=12,column=1,padx=20,pady=5)
    zm_value_label.grid(row=12,column=2,padx=20,pady=5)
    i1_value_label.grid(row=13,column=0,padx=20,pady=10)
    i2_value_label.grid(row=13,column=1,padx=20,pady=10)
    im_value_label.grid(row=13,column=2,padx=20,pady=10)
    i1_ampere_label.grid(row=14,column=0,padx=20,pady=10)
    i2_ampere_label.grid(row=14,column=1,padx=20,pady=10)
    im_ampere_label.grid(row=14,column=2,padx=20,pady=10)
    continue_button.grid(row=15,column=1,pady=10)
    quit_button.grid(row=16,column=1,pady=5)

def moveNextWindow():
    global result
    result = {}
    result['horse power'] = horse_power_entry.get()
    result['voltage'] = voltage_entry.get()
    result['phase'] = phase_entry.get()
    result['frequency'] = frequency_entry.get()
    result['base power'] = base_power_entry.get()
    result['per unit voltage'] = per_unit_voltage_entry.get()
    result['per unit current'] = per_unit_current_entry.get()
    result['per unit impedance'] = per_unit_impedance_entry.get()
    result['r1'] = r1_entry.get()
    result['r2'] = r2_entry.get()
    result['rm'] = rm_entry.get()
    result['x1'] = x1_entry.get()
    result['x2'] = x2_entry.get()
    result['xm'] = xm_entry.get()
    result['friction and windage'] = friction_and_windage_entry.get()
    result['stray load'] = stray_load_entry.get()
    result['assume_slip'] = assume_slip_input.get()

    form_fill = False
    for item in result:
        if result[item] == "":
            form_fill = False
            error = Label(root,text='Oops...Kindly fill all the entries')
            error.grid(row=14,column=2)
        else:
            form_fill = True

    if form_fill:
        computeWindow()
        return

def finalCalculation():
    top = Toplevel()
    top.title("Continuation Of Computational Window")

    ibase_label = Label(top,text = "Ibase = 9.363 (Refer to table)")
    r2_act_label = Label(top,text="r2_act = r2 x base impedance")
    secondary_input_label = Label(top,text="secondary input = phase x I2 x I2 x (r2_act / slip)")
    secondary_loss_label = Label(top,text="secondary loss = phase x I² x r2_act")
    output_power_label = Label(top,text="output power = Sec input - (Sec loss + friction and windage + stray-load loss)")
    primary_loss_label = Label(top,text="primary loss = phase x I² x r1_act")
    r1_act_label = Label(top,text="r1_act = r1 x base impedance")
    total_loss_label = Label(top,text="total losses = Pri loss + Sec loss + Iron loss + friction & windage + stray-load loss")
    input_power_label = Label(top,text="input power = output power + total losses")
    efficiency_label = Label(top,text="efficiency = output power / input power")
    power_factor_label = Label(top,text="power factor = cos(θ) of I")
    speed_sync_label = Label(top,text="Speed(async) = (120 x F) / p")
    Speed_label = Label(top,text="Speed = Synchronous(r/mm) x (1 - Slip)")
    torque_label = Label(top,text="Torque = (Horse Power x 5252) / Speed")
    #result calculation
    r2_act_cal = final_result['r2'] * final_result['r2_base']
    sec_input = (float(result['phase']) * pow(final_result['i_2'],2) * (r2_act_cal / float(result['assume_slip']))) / 1000
    sec_loss = (float(result['phase']) * pow(final_result['i_2'],2) * r2_act_cal) / 1000
    op = (sec_input  - (sec_loss + float(result['friction and windage']) + float(result['stray load']))) / 1000
    r1_act_cal = final_result['r1'] * final_result['r2_base']
    pri_loss = (r1_act_cal * pow(final_result['i_1'],2) * float(result['phase'])) / 1000
    total_loss = pri_loss + sec_loss + float(result['rm']) + float(result['friction and windage']) + float(result['stray load'])
    input_power = op + total_loss
    eff = (op / input_power) * 100
    speed_sync = (120 * float(result['frequency'])) / 4
    speed = speed_sync * (1 - float(result['assume_slip']))
    torque = ((op / 0.746) * 5252) / speed
    #result label
    result_title_label = Label(top,text=" Formular Needed ")
    r2_act_res = Label(top,text="r2_act (ohms) = "+str(r2_act_cal))
    secondary_input_res = Label(top,text="secondary input(kw) = "+str(sec_input))
    secondary_loss_res = Label(top,text="secondary loss (kw)= "+str(sec_loss))
    output_power_res = Label(top,text="output power (kw)= "+str(op))
    primary_loss_res = Label(top,text="primary loss(kw) = "+str(pri_loss))
    r1_act_res = Label(top,text="r1_act = "+str(r1_act_cal))
    total_loss_res = Label(top,text="total losses(kw) = "+str(total_loss))
    input_power_res = Label(top,text="input power(kw) = "+str(input_power))
    efficiency_res = Label(top,text="efficiency(%) = "+str(eff))
    #power_factor_label = Label(top,text="power factor = cos(θ) of I")
    speed_sync_res = Label(top,text="Speed(rpm) = "+str(speed_sync))
    Speed_res = Label(top,text="Speed = "+str(speed))
    torque_res = Label(top,text="Torque = "+str(torque))
    button = Button(top,text='    Draw Graph  ',command=top.destroy)

    #grid settings
    result_title_label.grid(row=0,column=1,padx=20,pady=20)
    output_power_label.grid(row=1,column=0,pady=10,padx=10)
    secondary_loss_label.grid(row=1,column=1,pady=10,padx=10)
    ibase_label.grid(row=1,column=2,pady=10,padx=10)
    r2_act_label.grid(row=2,column=0,pady=10,padx=10)
    secondary_input_label.grid(row=2,column=1,pady=10,padx=10)
    r1_act_label.grid(row=2,column=2,pady=10,padx=10)
    total_loss_label.grid(row=3,column=0,pady=10,padx=10)
    input_power_label.grid(row=3,column=1,pady=10,padx=10)
    efficiency_label.grid(row=3,column=2,pady=10,padx=10)
    power_factor_label.grid(row=4,column=0,pady=10,padx=10)
    speed_sync_label.grid(row=4,column=1,pady=10,padx=10)
    Speed_label.grid(row=4,column=2,pady=10,padx=10)
    torque_label.grid(row=5,column=0,pady=10,padx=10)
    result_title_label.grid(row=6,column=1,pady=5)

    r2_act_res.grid(row=7,column=0,padx=10,pady=10)
    secondary_input_res.grid(row=7,column=1,padx=10,pady=10)
    secondary_loss_res.grid(row=7,column=2,padx=10,pady=10)
    output_power_res.grid(row=8,column=0,padx=10,pady=10)
    primary_loss_res.grid(row=8,column=1,padx=10,pady=10)
    r1_act_res.grid(row=8,column=2,padx=10,pady=10)
    total_loss_res.grid(row=9,column=0,padx=10,pady=10)
    input_power_res.grid(row=9,column=1,padx=10,pady=10)
    efficiency_res.grid(row=9,column=2,padx=10,pady=10)
    speed_sync_res.grid(row=10,column=0,padx=10,pady=10)
    Speed_res.grid(row=10,column=1,padx=10,pady=10)
    torque_res.grid(row=10,column=2,padx=10,pady=10)
    button.grid(row=11,column=1)

#Creating an entry widget for the welcome window
horse_power_entry = Entry(root,width=20,borderwidth=2)
voltage_entry = Entry(root,width=20,borderwidth=2)
phase_entry = Entry(root,width=20,borderwidth=2)
frequency_entry = Entry(root,width=20,borderwidth=2)
base_power_entry = Entry(root,width=20,borderwidth=2)
per_unit_voltage_entry = Entry(root,width=20,borderwidth=2)
per_unit_current_entry = Entry(root,width=20,borderwidth=2)
per_unit_impedance_entry = Entry(root,width=20,borderwidth=2)
r1_entry = Entry(root,width=20,borderwidth=2)
r2_entry = Entry(root,width=20,borderwidth=2)
rm_entry = Entry(root,width=20,borderwidth=2)
x1_entry = Entry(root,width=20,borderwidth=2)
x2_entry = Entry(root,width=20,borderwidth=2)
xm_entry = Entry(root,width=20,borderwidth=2)
friction_and_windage_entry = Entry(root,width=20,borderwidth=2)
stray_load_entry = Entry(root,width=20,borderwidth=2)
assume_slip_lable = Label(root,text="Assume Slip(s) : ")
assume_slip_input = Entry(root,width=20,borderwidth=2)
#Creating label widget for the welcome window
title = Label(root,text="Kwara State University, Malete")
horse_power_label = Label(root,text="Horse Power")
voltage_label = Label(root,text="Voltage (V)")
phase_label = Label(root,text="Phases")
frequency_label = Label(root,text="Frequency (Hz)")
base_power_label = Label(root,text="Per Unit Base Power(KW)")
per_unit_voltage_label = Label(root,text="Per Unit Base Voltage(V)")
per_unit_current_label = Label(root,text="Per Unit Base Current(A)")
per_unit_impedance_label = Label(root,text="Per Unit Base Impedance")
r1_label = Label(root,text="r1 (p.u)")
r2_label = Label(root,text="r2 (p.u)")
rm_label = Label(root,text="rm (p.u)")
x1_label = Label(root,text="x1 (p.u)")
x2_label = Label(root,text="x2 (p.u)")
xm_label = Label(root,text="xm (p.u)")
friction_and_windage_label = Label(root,text="Friction and Windage (kw)")
stray_load_label = Label(root,text="Stray-Load Loss (kw)")
compute_button = Button(root,text="Compute Performance",padx=45,pady=30,command=moveNextWindow)

title.grid(row=0,column=2,pady=20,)
#arranging the entry and label in column 1
horse_power_label.grid(row=4,column=0,padx=20)
horse_power_entry.grid(row=4,column=1,pady=10)
voltage_label.grid(row=5,column=0)
voltage_entry.grid(row=5,column=1,pady=10)
phase_label.grid(row=6,column=0)
phase_entry.grid(row=6,column=1,pady=10)
frequency_label.grid(row=7,column=0)
frequency_entry.grid(row=7,column=1,pady=10)
base_power_label.grid(row=8,column=0)
base_power_entry.grid(row=8,column=1,pady=10)
per_unit_voltage_label.grid(row=9,column=0,padx=20)
per_unit_voltage_entry.grid(row=9,column=1,pady=10,padx=30)
per_unit_current_label.grid(row=10,column=0,padx=20)
per_unit_current_entry.grid(row=10,column=1,pady=10,padx=30)
per_unit_impedance_label.grid(row=11,column=0,padx=20)
per_unit_impedance_entry.grid(row=11,column=1,pady=10,padx=30)
assume_slip_lable.grid(row=12,column=0,padx=20)
assume_slip_input.grid(row=12,column=1,pady=10,padx=30)

r1_label.grid(row=4,column=2,padx=20)
r1_entry.grid(row=4,column=3,pady=10,padx=20)
r2_label.grid(row=5,column=2)
r2_entry.grid(row=5,column=3,pady=10,padx=20)
rm_label.grid(row=6,column=2)
rm_entry.grid(row=6,column=3,pady=10,padx=20)
x1_label.grid(row=7,column=2)
x1_entry.grid(row=7,column=3,pady=10)
x2_label.grid(row=8,column=2)
x2_entry.grid(row=8,column=3,pady=10)
xm_label.grid(row=9,column=2)
xm_entry.grid(row=9,column=3,pady=10)
friction_and_windage_label.grid(row=10,column=2)
friction_and_windage_entry.grid(row=10,column=3,pady=10)
stray_load_label.grid(row=11,column=2)
stray_load_entry.grid(row=11,column=3,pady=10)

compute_button.grid(row=13,column=2,pady=20)

root.mainloop()

#Next window
