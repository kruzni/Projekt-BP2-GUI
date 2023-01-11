from tkinter import *
import mysql.connector
from functools import partial
# def submitact():
#     ID1 = id.get()
#     print(f"The ID is {ID1}")
#     logintodb(ID1)

# def logintodb(ID1):
#     if ID1:
#         db = mysql.connector.connect(host="localhost",
#                                     id = ID1,
#                                     db = "Projekt_Banka_Krvi-2")
#         cursor = db.cursor()
#     else:
#         db = mysql.connector.connect(host="localhost",
#                                     user = user,
#                                     db = "Projekt_Banka_Krvi-2")
#         cursor = db.cursor()
        
#mydb = mysql.connector.connect(host="localhost", user="Ell", database="Projekt_Banka_Krvi-2")
mycursor = mydb.cursor()
mycursor.execute("select * from zaposlenik")
root  = Tk()
root.title('Sustav banke krvi')
root.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')
root.geometry('600x600')
root['bg'] = '#9E5D5D'

# ---------------------- login ----------------------------- #
my_label = Label(root, text = 'Hi mom!')
login1 = Label(root, text = "Enter ID").pack()
ID1 = StringVar()
enter_ID = Entry(root, textvariable=ID1).pack()

def clicki():
    w2=Toplevel()
    w2.title("Sustav Banke krvi")
    w2.geometry("600x600")
    w2.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')
    w2['bg'] = '#9E5D5D'
    

    #---------------CRUD---------------------#
    def w4_crud():
        crud = Toplevel()
        crud.title("Unos novih podataka")
        crud.geometry("600x600")
        crud.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')
        crud['bg'] = '#9E5D5D'


        #-------------ZAPOSLENIK CRUD---------------# 
    
        def zaposlenik_crud():
            zaposlenik = Toplevel()
            zaposlenik.title("Podaci o zaposleniku")
            zaposlenik.geometry("600x600")
            zaposlenik['bg'] = '#9E5D5D'
            zaposlenik.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')
#----READ----#
            def zaposlenik_r():
                zaposlenik_read = Toplevel()
                zaposlenik_read.title("Čitanje i brisanje podataka o zaposleniku")
                zaposlenik_read.geometry("600x600")
                zaposlenik_read['bg'] = '#9E5D5D'
                zaposlenik_read.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')
            #--CREATE---#
            def zaposlenik_cr():
                zaposlenik_c = Toplevel()
                zaposlenik_c.title("Podaci o zaposleniku")
                zaposlenik_c.geometry("600x600")
                zaposlenik_c['bg'] = '#9E5D5D'
                zaposlenik_c.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')
            #---UPDATE---#
            def zaposlenik_up():
                zaposlenik_u = Toplevel()
                zaposlenik_u.title("Podaci o zaposleniku")
                zaposlenik_u.geometry("600x600")
                zaposlenik_u['bg'] = '#9E5D5D'
                zaposlenik_u.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')

            #-----BUTTONI ZA READ-DELETE zaposlenik----#
            zaposlenik_readdel_txt = Label(zaposlenik, text = 'Podatci o zaposleniku').pack()
            zaposlenik_readdel_button = Button(zaposlenik, text = 'Zaposlenik READ-DELETE', command=zaposlenik_r, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()
            
            #-----BUTTONI ZA UPDATE zaposlenik---_-#
            zaposlenik_update_txt = Label(zaposlenik, text = 'Ažuriraj podatke o zaposleniku').pack()
            zaposlenik_update_button = Button(zaposlenik, text = 'Zaposlenik UPDATE', command=zaposlenik_up, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()
            
            #BUTTONI ZA CREATE zaposlenik-----#
            zaposlenik_create_txt = Label(zaposlenik, text = 'Kreiraj zaposlenika').pack()
            zaposlenik_create_button = Button(zaposlenik, text = 'Zaposlenik CREATE', command=zaposlenik_cr, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()
        
        
        
        
        crud_zaposlenik_txt = Label(crud, text = 'Podatci o zaposleniku').pack()
        crud_zaposlenik_button = Button(crud, text = 'Zaposlenik', command=zaposlenik_crud, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()




        #-------------DARIVATELJ RUD----------------#
        def darivatelj_rud():
            darivatelj = Toplevel()
            darivatelj.title("Podaci o darivatelju")
            darivatelj.geometry("600x600")
            darivatelj['bg'] = '#9E5D5D'
            darivatelj.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')   
        

             #----READ-DELETE----#
            def darivatelj_r():
                darivatelj_read = Toplevel()
                darivatelj_read.title("Čitanje i brisanje podataka o darivatelju")
                darivatelj_read.geometry("600x600")
                darivatelj_read['bg'] = '#9E5D5D'
                darivatelj_read.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')
            
            #---UPDATE---#
            def darivatelj_u():
                darivatelj_u = Toplevel()
                darivatelj_u.title("Podaci o darivatelju")
                darivatelj_u.geometry("600x600")
                darivatelj_u['bg'] = '#9E5D5D'
                darivatelj_u.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')

            darivatelj_readdel_txt = Label(darivatelj, text = 'Podatci o Darivatelju').pack()
            darivatelj_readdel_button = Button(darivatelj, text = 'Darivatelj READ-DELETE', command=darivatelj_r, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()

            darivatelj_update_txt = Label(darivatelj, text = 'Ažuriraj podatke o darivateljima').pack()
            darivatelj_update_button = Button(darivatelj, text = 'Darivatelj UPDATE', command=darivatelj_u, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()
   
    #-----BUTTONI ZA darivatelj_rud()------#
        rud_darivatelj_txt = Label(crud, text = 'Podatci o darivatelju').pack()
        rud_darivatelj_button = Button(crud, text = 'Darivatelj', command=darivatelj_rud, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()






        #--------------zaposlenik CRUD--------------#

        def prijevoznik_crud():
            prijevoznik = Toplevel()
            prijevoznik.title("Podaci o prijevozniku")
            prijevoznik.geometry("600x600")
            prijevoznik['bg'] = '#9E5D5D'
            prijevoznik.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')

            #----READ----#
            def prijevoz_r():
                prijevoznik_read = Toplevel()
                prijevoznik_read.title("Čitanje i brisanje podataka o prijevozniku")
                prijevoznik_read.geometry("600x600")
                prijevoznik_read['bg'] = '#9E5D5D'
                prijevoznik_read.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')
            #--CREATE---#
            def prijevoz_c():
                prijevoz_c = Toplevel()
                prijevoz_c.title("Podaci o prijevozniku")
                prijevoz_c.geometry("600x600")
                prijevoz_c['bg'] = '#9E5D5D'
                prijevoz_c.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')
            #---UPDATE---#
            def prijevoz_u():
                prijevoz_u = Toplevel()
                prijevoz_u.title("Podaci o prijevoznik")
                prijevoz_u.geometry("600x600")
                prijevoz_u['bg'] = '#9E5D5D'
                prijevoz_u.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')

            #-----BUTTONI ZA READ-DELETE prijevoznik----#
            prijevoz_readdel_txt = Label(prijevoznik, text = 'Podatci o prijevoznik').pack()
            prijevoz_readdel_button = Button(prijevoznik, text = 'Prijevoz READ-DELETE', command=prijevoz_r, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()
            
            #-----BUTTONI ZA UPDATE prijevoznik---_-#
            prijevoz_update_txt = Label(prijevoznik, text = 'Ažuriraj podatke o prijevozniku').pack()
            prijevoz_update_button = Button(prijevoznik, text = 'Prijevoz UPDATE', command=prijevoz_u, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()
            
            #BUTTONI ZA CREATE prijevoznik-----#
            prijevoz_create_txt = Label(prijevoznik, text = 'Kreiraj prijevoznika').pack()
            prijevoz_create_button = Button(prijevoznik, text = 'Prijevoz CREATE', command=prijevoz_c, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()
        
        #--BUTTONI koji vode u prijevoznik_crud------#
        crud_prijevoznik_txt = Label(crud, text = 'Podatci o prijevozniku').pack()
        crud_prijevoznik_button = Button(crud, text = 'Prijevoznik', command=prijevoznik_crud, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()
            


        #--------------R BOLNICA -------------- #
    
        def bolnica_r():
            bolnica = Toplevel()
            bolnica.title("Podaci o bolnicama")
            bolnica.geometry("600x600")
            bolnica['bg'] = '#9E5D5D'
            bolnica.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')
        r_bolnica_txt = Label(crud, text = 'Podatci o bolnicama').pack()
        r_bolnica_button = Button(crud, text = 'Bolnice', command=bolnica_r, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()







    def w5_popis():
        popis = Toplevel()
        popis.title("Popisi")
        popis.geometry("600x600")
        popis.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')
        popis['bg'] = '#9E5D5D'
        

    def w6_davanje_ovlasti():
        davanje_ovlasti = Toplevel()
        davanje_ovlasti.title("Davanje Ovlasti")
        davanje_ovlasti.iconbitmap('Dapino-Medical-Blood-drop-no-shadow.ico')
        davanje_ovlasti['bg'] = '#9E5D5D'
        davanje_ovlasti.geometry("600x600")
    b4_crud=Button(w2, text = 'CRUD', command=w4_crud, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()
    b5_popis=Button(w2, text = 'Popis', command=w5_popis, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()
    b6_davanje_ovlasti=Button(w2, text = 'Davanje Ovlasti', command=w6_davanje_ovlasti, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()
# # click je potreban kako bi se provjerio ID Admina 

butt = Button(root, text = 'Prijava', command=clicki, fg = 'white', bg='blue', padx=15, pady=15, font='sans-serif').pack()

#---------------------------------------------------#
#Second page



root.mainloop()
