from tkinter import *
import cmath
import matplotlib
import matplotlib.pyplot as plt

root = Tk()
root.title("Simple Induction Motor Performance")

def doCalculation(slip):
    #doing all calculation
    z1 = complex(float(result['r1']),float(result['x1']))
    z2 = complex(float(result['r2'])/slip,float(result['x2']))
    zm = complex(float(result['rm']),float(result['xm']))
    i1 = cmath.polar((1.0 * (zm + z2)) / ((z1 * zm) + (z1 * z2) + (z2 * zm)))
    i2 = cmath.polar((1.0 * zm) / ((z1 * zm) + (z1 * z2) + (z2 * zm)))
    im = cmath.polar((1.0 * z2) / ((z1 * zm) + (z1 * z2) + (z2 * zm)))
    ibase = 9.363
    i_1_A = round((ibase * i1[0]),2)
    i_2_A = round((ibase * i2[0]),2)    
    i_m_A = round((ibase * im[0]),2)
    r2_base = float(result["per unit impedance"])
    r2 = float(result["r2"])
    r1 = float(result["r1"])
    #calculation two
    r1_act = round((r1 * r2_base),3)
    r2_act = round((r2 * r2_base),3)
    sec_loss = round(((float(result['phase']) * i_2_A * i_2_A * r2_act)/1000),3)
    sec_input = (float(result['phase']) * (i_2_A)**2 * (r2_act/slip) ) / 1000
    sec_input = round(sec_input,3)
    op = round(((sec_input  - (sec_loss + float(result['friction and windage']) + float(result['stray load'])))),3)
    pri_loss = round(((r1_act * i_1_A * i_1_A * float(result['phase'])) / 1000),3)
    total_loss = round((pri_loss + sec_loss + 0.168 + float(result['friction and windage']) + float(result['stray load'])),3)
    input_power =round(( op + total_loss),3)
    eff = round(((op / input_power) * 100),1)
    speed_sync = (120 * float(result['frequency'])) / 4
    speed = speed_sync * (1 - slip)
    torque = round(((float(result['horse power']) * 5252) / speed),2)
    #store result in a dictionary and return it
    final_result = {}
    final_result['z1'] = z1
    final_result['z2'] = z2
    final_result['zm'] = zm
    final_result['i1'] = i1
    final_result['i2'] = i2
    final_result['im'] = im
    final_result['i_1_A'] = i_1_A
    final_result['i_2_A'] = i_2_A
    final_result['i_m_A'] = i_m_A
    final_result['r1_act'] = r1_act
    final_result['r2_act'] = r2_act
    final_result['sec_input'] = sec_input
    final_result['sec_loss'] = sec_loss
    final_result['op'] = op
    final_result['pri_loss'] = pri_loss
    final_result['input_power'] = input_power
    final_result['total_loss'] = total_loss
    final_result['eff'] = eff
    final_result['torque'] = torque
    final_result['speed'] = speed
    final_result['speed_sync'] = speed_sync
    return final_result

def graphWindow():
    top = Toplevel()
    top.title("Draw Graph Window")
    #label
    slip_title = Label(top,text="Enter Six Assume Slips Value",font=('Arial',12,'bold'),fg="teal")
    slip_1_label = Label(top, text=" Slip 1 ")
    slip_2_label = Label(top,text=" Slip 2 ")
    slip_3_label = Label(top, text= " Slip 3 ")
    slip_4_label = Label(top, text = " Slip 4 ")
    slip_5_label = Label(top, text=" Slip 5 ")
    slip_6_label = Label(top, text=" Slip 6 ")
    #entry
    slip_1_entry = Entry(top,width=20,borderwidth=2)
    slip_2_entry = Entry(top,width=20,borderwidth=2)
    slip_3_entry = Entry(top,width=20,borderwidth=2)
    slip_4_entry = Entry(top,width=20,borderwidth=2)
    slip_5_entry = Entry(top,width=20,borderwidth=2)
    slip_6_entry = Entry(top,width=20,borderwidth=2)
    #Button
    graph_button = Button(top,text='  Draw Graph ',padx=40,pady=20,command=lambda: moveToFinalWindow(slip_1_entry.get(),slip_2_entry.get(),slip_3_entry.get(),slip_4_entry.get(),slip_5_entry.get(),slip_6_entry.get()))
    #layout the label and entry
    slip_title.grid(row=0,column=1,pady=20,columnspan=3)
    slip_1_label.grid(row=1,column=0, padx=5,pady=20)
    slip_1_entry.grid(row=1,column=1,pady=20)
    slip_2_label.grid(row=2,column=0, padx=5,pady=20)
    slip_2_entry.grid(row=2,column=1,pady=20)
    slip_3_label.grid(row=3,column=0, padx=5,pady=20)
    slip_3_entry.grid(row=3,column=1,pady=20)
    slip_4_label.grid(row=1,column=2, padx=5,pady=20)
    slip_4_entry.grid(row=1,column=3,pady=5,padx=20)
    slip_5_label.grid(row=2,column=2, padx=5,pady=20)
    slip_5_entry.grid(row=2,column=3,pady=20,padx=20)
    slip_6_label.grid(row=3,column=2, padx=5,pady=20)
    slip_6_entry.grid(row=3,column=3,pady=20,padx=20)
    graph_button.grid(row=4,column=2,pady=20)


def finalWindow(s,p,t,e,i):
    top = Toplevel()
    top.title("Draw Graph Window")
    #label
    slip_title = Label(top,text="Slip Against Power Output, Torque, and Efficiency",font=('Arial',12,'bold'),fg="teal")
    head_1_label = Label(top, text=" SLIP")
    head_2_label = Label(top,text=" POWER OUTPUT ")
    head_3_label = Label(top, text= " TORQUE ")
    head_4_label = Label(top, text = " EFFICIENCY ")
    head_5_label = Label(top,text=" POWER INPUT ")
    #slip label
    slip_1_label = Label(top, text=str(s[0]))
    slip_2_label = Label(top, text=str(s[1]))
    slip_3_label = Label(top, text=str(s[2]))
    slip_4_label = Label(top, text=str(s[3]))
    slip_5_label = Label(top, text=str(s[4]))
    slip_6_label = Label(top, text=str(s[5]))
    #power output label
    op_1_label = Label(top, text=str(p[0]))
    op_2_label = Label(top, text=str(p[1]))
    op_3_label = Label(top, text=str(p[2]))
    op_4_label = Label(top, text=str(p[3]))
    op_5_label = Label(top, text=str(p[4]))
    op_6_label = Label(top, text=str(p[5]))
    #power input label
    ip_1_label = Label(top,text=str(i[0]))
    ip_2_label = Label(top, text=str(i[1]))
    ip_3_label = Label(top, text=str(i[2]))
    ip_4_label = Label(top, text=str(i[3]))
    ip_5_label = Label(top, text=str(i[4]))
    ip_6_label = Label(top, text=str(i[5]))
    #torque lable
    torque_1_label = Label(top, text=str(t[0]))
    torque_2_label = Label(top, text=str(t[1]))
    torque_3_label = Label(top, text=str(t[2]))
    torque_4_label = Label(top, text=str(t[3]))
    torque_5_label = Label(top, text=str(t[4]))
    torque_6_label = Label(top, text=str(t[5]))
    #efficiency lable
    efficiency_1_label = Label(top, text=str(e[0]))
    efficiency_2_label = Label(top, text=str(e[1]))
    efficiency_3_label = Label(top, text=str(e[2]))
    efficiency_4_label = Label(top, text=str(e[3]))
    efficiency_5_label = Label(top, text=str(e[4]))
    efficiency_6_label = Label(top, text=str(e[5]))
    #Buttons
    op_button = Button(top,text='Slip Vs Power Output',padx=10,pady=10,command=lambda: drawSP(s,p))
    t_button = Button(top,text='Slip Vs Torque ',padx=10,pady=10,command=lambda: drawST(s,t))
    e_button = Button(top,text='Slip Vs Efficiency ',padx=10,pady=10,command=lambda: drawSE(s,e))
    i_button = Button(top,text='Slip Vs Power Input ',padx=10,pady=10,command=lambda: drawSI(s,i))
    #mixed buttons
    et_button = Button(top,text='Efficiency Vs Torque',padx=10,pady=10,command=lambda: drawET(e,t))
    eo_button = Button(top,text='Eff Vs Power Output ',padx=10,pady=10,command=lambda: drawEO(e,p))
    ei_button = Button(top,text='Eff Vs Power Input ',padx=10,pady=10,command=lambda: drawEI(e,i))
    io_button = Button(top,text='Input Vs Output ',padx=10,pady=10,command=lambda: drawIO(i,p))
    to_button = Button(top,text='Torque Vs Output ',padx=10,pady=10,command=lambda: drawTO(t,p))
    ti_button = Button(top,text='Torque Vs Input ',padx=10,pady=10,command=lambda: drawTI(t,i))

    #layout the label and entry
    slip_title.grid(row=0,column=1,pady=20,columnspan=3)
    head_1_label.grid(row=1, column=0,padx=10,pady=20)
    head_2_label.grid(row=1, column=1,padx=10)
    head_3_label.grid(row=1, column=2,padx=10,pady=20)
    head_4_label.grid(row=1, column=3,padx=10)
    head_5_label.grid(row=1,column=4,padx=10,pady=20)
    #row 2
    slip_1_label.grid(row=2,column=0,padx=10,pady=10)
    op_1_label.grid(row=2,column=1,padx=10,pady=10)
    torque_1_label.grid(row=2,column=2,padx=10,pady=10)
    efficiency_1_label.grid(row=2,column=3,padx=10,pady=10)
    ip_1_label.grid(row=2,column=4,padx=10,pady=10)
    #row 3
    slip_2_label.grid(row=3,column=0,padx=10,pady=10)
    op_2_label.grid(row=3,column=1,padx=10,pady=10)
    torque_2_label.grid(row=3,column=2,padx=10,pady=10)
    efficiency_2_label.grid(row=3,column=3,padx=10,pady=10)
    ip_2_label.grid(row=3,column=4,padx=10,pady=10)
    #row4
    slip_3_label.grid(row=4,column=0,padx=10,pady=10)
    op_3_label.grid(row=4,column=1,padx=10,pady=10)
    torque_3_label.grid(row=4,column=2,padx=10,pady=10)
    efficiency_3_label.grid(row=4,column=3,padx=10,pady=10)
    ip_3_label.grid(row=4,column=4,padx=10,pady=10)
    #row 5
    slip_4_label.grid(row=5,column=0,padx=10,pady=10)
    op_4_label.grid(row=5,column=1,padx=10,pady=10)
    torque_4_label.grid(row=5,column=2,padx=10,pady=10)
    efficiency_4_label.grid(row=5,column=3,padx=10,pady=10)
    ip_4_label.grid(row=5,column=4,padx=10,pady=10)
    #row 6
    slip_5_label.grid(row=6,column=0,padx=10,pady=10)
    op_5_label.grid(row=6,column=1,padx=10,pady=10)
    torque_5_label.grid(row=6,column=2,padx=10,pady=10)
    efficiency_5_label.grid(row=6,column=3,padx=10,pady=10)
    ip_5_label.grid(row=6,column=4,padx=10,pady=10)
    #row 7
    slip_6_label.grid(row=7,column=0,padx=10,pady=10)
    op_6_label.grid(row=7,column=1,padx=10,pady=10)
    torque_6_label.grid(row=7,column=2,padx=10,pady=10)
    efficiency_6_label.grid(row=7,column=3,padx=10,pady=10)
    ip_6_label.grid(row=7,column=4,padx=10,pady=10)
    #row 8 for button layout
    i_button.grid(row=8,column=0,padx=10,pady=10)
    op_button.grid(row=8,column=1,padx=10,pady=10)
    t_button.grid(row=8,column=2,padx=10,pady=10)
    e_button.grid(row=8,column=3,padx=10,pady=10)
    to_button.grid(row=8,column=4,padx=10,pady=10)
    #row 9 for button layout
    et_button.grid(row=9,column=0,padx=10,pady=10)
    eo_button.grid(row=9,column=1,padx=10,pady=10)
    ei_button.grid(row=9,column=2,padx=10,pady=10)
    io_button.grid(row=9,column=3,padx=10,pady=10)
    ti_button.grid(row=9,column=4,padx=10,pady=10)

def drawSE(s,e):
    plt.plot(s,e)
    plt.xlabel('slip')
    plt.ylabel('efficiency')
    plt.savefig('slip_eff.png')
    plt.show()
    
def drawSP(s,p):
    plt.plot(s,p)
    plt.xlabel('slip')
    plt.ylabel('power output')
    plt.savefig('slip_power.png')
    plt.show()
    
def drawST(s,t):
    plt.plot(s, t)
    plt.xlabel('slip')
    plt.ylabel('torque')
    plt.savefig('slip_torque.png')
    plt.show()

def drawSI(s,i):
    plt.plot(s,i)
    plt.xlabel("slip values")
    plt.ylabel("Input Power")
    plt.show()
    plt.savefig("slipInput.png") 

def drawEO(e,o):
    plt.plot(e,o)
    plt.xlabel('Efficiency')
    plt.ylabel('Power Output')
    plt.savefig('eff_output.png')
    plt.show()
    
def drawEI(e,i):
    plt.plot(e,i)
    plt.xlabel('Efficiency')
    plt.ylabel('Power Input')
    plt.savefig('eff_input.png')
    plt.show()
    
def drawIO(i,o):
    plt.plot(i,o)
    plt.xlabel('Input Power')
    plt.ylabel('Output Power')
    plt.savefig('input_output.png')
    plt.show()

def drawET(e,t):
    plt.plot(e,t)
    plt.xlabel("Efficiency")
    plt.ylabel("Torque")
    plt.show()
    plt.savefig("eff_torque.png")     

def drawTO(t,o):
    plt.plot(t,o)
    plt.xlabel('Torque')
    plt.ylabel('Output Power')
    plt.savefig('torque_output.png')
    plt.show()

def drawTI(t,i):
    plt.plot(t,i)
    plt.xlabel("Torque")
    plt.ylabel("Input Power")
    plt.show()
    plt.savefig("torque_input.png")  

def moveToFinalWindow(s1,s2,s3,s4,s5,s6):

    global slipValues
    slipValues = {}
    slipValues['slip1'] = s1
    slipValues['slip2'] = s2
    slipValues['slip3'] = s3
    slipValues['slip4'] = s4
    slipValues['slip5'] = s5
    slipValues['slip6'] = s6
    
    form_fill = False
    for item in slipValues:
        if slipValues[item] == "":
            form_fill = False
        else:
            form_fill = True

    if form_fill:
        global slips
        slips = [float(s1),float(s2),float(s3),float(s4),float(s5),float(s6)]
        res1 = doCalculation(float(s1))
        res2 = doCalculation(float(s2))
        res3 = doCalculation(float(s3))
        res4 = doCalculation(float(s4))
        res5 = doCalculation(float(s5))
        res6 = doCalculation(float(s6))
        torque = [res1['torque'],res2['torque'],res3['torque'],res4['torque'],res5['torque'],res6['torque']]
        power_output = [res1['op'],res2['op'],res3['op'],res4['op'],res5['op'],res6['op']]
        efficiency = [res1['eff'],res2['eff'],res3['eff'],res4['eff'],res5['eff'],res6['eff']]
        power_input = [res1['input_power'],res2['input_power'],res3['input_power'],res4['input_power'],res5['input_power'],res6['input_power']]
        finalWindow(slips,power_output,torque,efficiency,power_input)
        return


def computeWindow():
    top = Toplevel()
    top.title("Computation Window")
  
    res = {}
    res = doCalculation(float(result['assume_slip']))
    #result2 label
    calculation_title = Label(top,text=" CALCULATED RESULT ",font=('Arial',12,'bold'),fg="teal")
    r2_act_res = Label(top,text="r2(act) Ω = "+str(res['r2_act']))
    secondary_input_res = Label(top,text="secondary input(kw) = "+str(res['sec_input']))
    secondary_loss_res = Label(top,text="secondary loss (kw)= "+str(res['sec_loss']))
    output_power_res = Label(top,text="output (kw)= "+str(res['op']))
    primary_loss_res = Label(top,text="primary loss(kw) = "+str(res['pri_loss']))
    r1_act_res = Label(top,text="r1(act) Ω = "+str(res['r1_act']))
    total_loss_res = Label(top,text="total losses(kw) = "+str(res['total_loss']))
    input_power_res = Label(top,text="input power(kw) = "+str(res['input_power']))
    efficiency_res = Label(top,text="efficiency(%) = "+str(res['eff']))
    speed_sync_res = Label(top,text="Speed(rpm) = "+str(res['speed_sync']))
    Speed_res = Label(top,text="Speed = "+str(res['speed']))
    torque_res = Label(top,text="Torque = "+str(res['torque']))
    z1_value_label = Label(top,text="z1 = "+str(res['z1']))
    z2_value_label = Label(top,text="z2 = "+str(res['z2']))
    zm_value_label = Label(top,text="zm = "+str(res['zm']))
    i1_value_label = Label(top,text="i1 = "+str(res['i1']))
    i2_value_label = Label(top,text="i2 = "+str(res['i2']))
    im_value_label = Label(top,text="im = "+str(res['im']))
    i1_ampere_label = Label(top,text=" Or " +str(res['i_1_A']) +" A")
    i2_ampere_label = Label(top,text=" Or " +str(res['i_2_A']) +" A")
    im_ampere_label = Label(top,text=" Or " +str(res['i_m_A']) +" A")
    quit_button = Button(top,text='    Close    ',padx=40,pady=20,command=top.destroy)
    graph_button = Button(top,text='  Draw Graph ',padx=40,pady=20,command=graphWindow)
    #arranging the grid fields
    calculation_title.grid(row=2,column=1,padx=20,pady=10)
    z1_value_label.grid(row=3,column=0,padx=20,pady=5)
    z2_value_label.grid(row=3,column=1,padx=20,pady=5)
    zm_value_label.grid(row=3,column=2,padx=20,pady=5)
    i1_value_label.grid(row=4,column=0,padx=20,pady=10)
    i2_value_label.grid(row=4,column=1,padx=20,pady=10)
    im_value_label.grid(row=4,column=2,padx=20,pady=10)
    i1_ampere_label.grid(row=5,column=0,padx=20,pady=10)
    i2_ampere_label.grid(row=5,column=1,padx=20,pady=10)
    im_ampere_label.grid(row=5,column=2,padx=20,pady=10)
    r1_act_res.grid(row=6,column=0,padx=20,pady=10)
    r2_act_res.grid(row=6,column=1,padx=20,pady=10)
    secondary_input_res.grid(row=6,column=2,padx=20,pady=10)
    secondary_loss_res.grid(row=7,column=0,padx=20,pady=10)
    output_power_res.grid(row=7,column=1,padx=20,pady=10)
    primary_loss_res.grid(row=7,column=2,padx=20,pady=10)
    total_loss_res.grid(row=8,column=0,padx=20,pady=10)
    input_power_res.grid(row=8,column=1,padx=20,pady=10)
    efficiency_res.grid(row=8,column=2,padx=20,pady=10)
    speed_sync_res.grid(row=9,column=0,padx=20,pady=10)
    Speed_res.grid(row=9,column=1,padx=20,pady=10)
    torque_res.grid(row=9,column=2,padx=20,pady=10)
    quit_button.grid(row=12,column=1,pady=10)
    graph_button.grid(row=11,column=1,pady=5)
    


def moveNextWindow():
    global result
    result = {}
    result['horse power'] = horse_power_entry.get()
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
    result['phase'] = '3'
    result['frequency'] = '60'
    result['voltage'] = '460'
    result['friction and windage'] = '0.074'
    result['stray load'] = '0.097'
    result['assume_slip'] = assume_slip_input.get()

    form_fill = False
    for item in result:
        if result[item] == "":
            form_fill = False
            error = Label(root,text='Oops...Kindly fill all the entries',fg="red")
            error.grid(row=14,column=1,pady=10,columnspan=2)
        else:
            form_fill = True

    if form_fill:
        computeWindow()
        return


def deleteEntries():
    horse_power_entry.delete(0,"end")
    base_power_entry.delete(0,"end")
    per_unit_voltage_entry.delete(0,"end")
    per_unit_current_entry.delete(0,"end")
    per_unit_impedance_entry.delete(0,"end")
    r1_entry.delete(0,"end")
    r2_entry.delete(0,"end")
    rm_entry.delete(0,"end")
    x1_entry.delete(0,"end")
    x2_entry.delete(0,"end")
    xm_entry.delete(0,"end")
    assume_slip_input.delete(0,"end")


#Creating an entry widget for the welcome window
horse_power_entry = Entry(root,width=20,borderwidth=2)
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
assume_slip_lable = Label(root,text="Assume Slip(s) : ")
assume_slip_input = Entry(root,width=20,borderwidth=2)
#Creating label widget for the welcome window
title = Label(root,text="KWARA STATE UNIVERSITY, MALETE",font=('Arial',12,'bold'),fg='teal')
horse_power_label = Label(root,text="Horse Power")
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
compute_button = Button(root,text="Compute Performance",padx=45,pady=30,command=moveNextWindow)
clear_button = Button(root,text=" Clear Entries ",padx=45,pady=30,command=deleteEntries)
title.grid(row=0,column=1,pady=20,columnspan=2)
#arranging the entry and label in column 1
horse_power_label.grid(row=4,column=0,padx=20)
horse_power_entry.grid(row=4,column=1,pady=10)
base_power_label.grid(row=5,column=0)
base_power_entry.grid(row=5,column=1,pady=10)
per_unit_voltage_label.grid(row=6,column=0,padx=20)
per_unit_voltage_entry.grid(row=6,column=1,pady=10,padx=30)
per_unit_current_label.grid(row=7,column=0,padx=20)
per_unit_current_entry.grid(row=7,column=1,pady=10,padx=30)
per_unit_impedance_label.grid(row=8,column=0,padx=20)
per_unit_impedance_entry.grid(row=8,column=1,pady=10,padx=30)
assume_slip_lable.grid(row=9,column=0,padx=20)
assume_slip_input.grid(row=9,column=1,pady=10,padx=30)
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
compute_button.grid(row=13,column=1,pady=20,padx=20)
clear_button.grid(row=13,column=2)

root.mainloop()
#Next window
