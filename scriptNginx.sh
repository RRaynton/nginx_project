#!/bin/bash

STATUS=$(systemctl status nginx | grep -i 'active')	#Salva a linha que contem o status (a atividade) do nginx
STATUS=${STATUS#*A*: } && STATUS="${STATUS%)*})"	#Salva tudo após o ": " e antes do ")" e ao final adiciona um parentese a string
							#"    Active: active (running) data..." -> "active (running" -> "active (running)"
							#"    Active: inactive (dead) data..." -> "inactive (dead" -> "inactive (dead)"

NOME=$(whoami)			#Captura o nome do usuário
HORA=$(uptime | sed 's/u.*//')	#Captura a hora atual, como uptime retorna "hh:mm:ss up hh:mm ..."
				#Utiliza-se o sed para trocar o texto iniciando no "u" até o final, por vazio.
				#"hh:mm:ss up hh:mm ..." -> "hh:mm:ss "

## PARTE OFFLINE

if [ "$STATUS" == "active (running)" ]; then	#Se o status for ativo
	RESULTADO=" O Nginx está funcionando!"	#A resposta será que o Nginx está funcionando
elif [ "$STATUS" == "inactive (dead)" ]; then	#Se não for ativo e for inativo
	RESULTADO=" O Nginx está inativo!"	#A resposta será que o Nginx está inativo
else						#caso não seja nem ativo nem inativo
	RESULTADO=$STATUS;			#Resultado será o status encontrado
fi

sudo touch /var/log/status.log				#Cria ou atualiza o status.log
sudo chmod 777 /var/log/status.log	
echo "Nome de usuário: $NOME" >> /var/log/status.log	#Salva o nome de usuário no arquivo de log
echo "Hora atual: $HORA" >> /var/log/status.log		#Salva a hora atual no arquivo de log
echo -e "Nginx:$RESULTADO \n" >> /var/log/status.log	#Salva o status do nginx no arquivo de log

## PARTE ONLINE

sudo touch /var/www/html/index.html				#Cria ou atualiza a página html index.html
sudo chmod 777 /var/www/html/index.html
echo -e "<!DOCTYPE html>
<html>
 <head>
  <meta charset='utf-8'/>
  <title>Status do Nginx</title>
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
    <p>Nome de usuário: $NOME</p> <!--Paragrafo com o nome do usuário-->
    <p>Hora Atual: $HORA</p>	  <!--#Parágrafo com a hora atual-->
    <p>NGINX: $RESULTADO</p>	  <!--#Parágrafo com o status do Nginx-->
   </div>
  </section>
 </body>
</html>" > /var/www/html/index.html	#Salva sem concatenar as informações no arquivo html
