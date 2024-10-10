#!/bin/bash

STATUS=$(systemctl status nginx | grep -i 'active')
STATUS_INI=${STATUS#*A*: }
STATUS_MID=${STATUS_INI%)*}
STATUS="$STATUS_MID)"

NOME=$(whoami)
HORA=$(uptime | sed 's/u.*//') 

## PARTE OFFLINE

if [ "$STATUS" == "active (running)" ]; then
	RESULTADO=" O Nginx está funcionando!"
elif [ "$STATUS" == "inactive (dead)" ]; then
	RESULTADO=" O Nginx está inativo!"
else
	RESULTADO=$STATUS;
fi
sudo touch status.txt
sudo chmod 777 status.txt
echo "Nome de usuário: $NOME" >> /var/www/html/status.txt
echo "Hora atual: $HORA" >> /var/www/html/status.txt
echo -e "Nginx:$RESULTADO \n" >> /var/www/html/status.txt

## PARTE ONLINE

sudo rm -rf /var/www/html/index.html
sudo touch /var/www/html/index.html
sudo chmod 777 /var/www/html/index.html
sudo echo -e "<!DOCTYPE html>
<html>
 <head>
  <meta charset='utf-8'/>
  <title>Welcome to nginx!</title>
  <style>
        *{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        section {
            background-image: linear-gradient(to bottom right, slateblue, black);
            position: relative;
            height: 100vh;
        }
        body {
            margin: 0;
            text-align: center;
        }
        h2 {color:whitesmoke;
            text-align: center;
            font-size: 40px;
        }
        p {color: white;
            text-align: center;
        }
        #status {
            margin: 50px 0px;
            padding: 10px;
            font-size: 30px;
            position: fixed;
            background-color: black;
            opacity: 0.6;
            border: 3px solid whitesmoke;
            border-radius: 25px;
            box-shadow: 10px 10px 5px lightblue;
            align-items: center;
            left: 50%;
            transform: translateX(-50%);
            width: 600px;
        }
    </style>
 </head>
 <body>
  <section>
   <h2>Esta tela é atualizada a cada 5 minutos</h2>
   <h2>Indicando se o nginx está ativo!</h2>
   <div id="status">
    <p>Nome de usuário: $NOME</p>
    <p>Hora Atual: $HORA</p>
    <p>NGINX: $RESULTADO</p>
   </div>
  </section>
 </body>
</html>" >> /var/www/html/index.html
