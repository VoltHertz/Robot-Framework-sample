*** Settings ***




*** Variables ***
&{home}
...    A_Signup=//strong[contains(text(), "Account")] 
#A_Signup=//a[@href="https://www.phptravels.net/signup"] 
#...    A_Register=//strong[contains(text(), "Signup")]
...    a_voos=//a[contains(text(),"flights")] 
...    A_Visto=//a[@href="https://www.phptravels.net/visa"]    



*** Keywords ***
