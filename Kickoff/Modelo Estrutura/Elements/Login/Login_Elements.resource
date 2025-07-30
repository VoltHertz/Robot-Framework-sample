*** Variables ***
&{Login} 
#Elements Registro
...  Input_PrimeiroNome=//input[@id="firstname"]
...  Input_UltimoNome=//input[@id="last_name"]
...  Input_Pais=//button[@title="Select Country"]
...  Input_Option_Pais=//input[@aria-activedescendant="bs-select-1-0"]
...  Option_Brasil=//span[contains(text(), "Brazil")]
...  Input_Telefone=//input[@id="phone"]
...  Input_Email=//input[@id="user_email"]
...  Input_Senha=//input[@id="password"]
...  Iframe_reCAPTCHA=//iframe[@title="reCAPTCHA"]
...  Not_Robot=//div[@class="recaptcha-checkbox-border"]
...  Button_Signup=//div[@class="signup_button"]
...  Button_Cookie=//button[@id="cookie_stop"]
#Elements Login
...  Input_EmailLogin=//input[@placeholder="Email"]
...  Input_SenhaLogin=//input[@placeholder="Password"]
...  Button_Logar=//span[contains(text(),"Login")]
...  A_OpcaoLogin=(//a[@href="https://www.phptravels.net/login"])[2]


