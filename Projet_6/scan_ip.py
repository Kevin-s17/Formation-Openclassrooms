import socket
import subprocess
from threading import Thread

host_d = {} #dictionnaire stockant les noms d'hôte récupérés
ping_list = [] #Tableau stockant les IP pinguées
ip_list = [] #Tableau qui stockera les IP
nb_sr = [] #Tableau qui stockera les sous_reseaux entrés par l'utilisateur


#classe définissant le thread de scan d'adresse Ip servant à récupérer le hostname du périphérique réseau
class Scan(Thread):

#Constructeur de la classe prend en argument les paramètres suivants: address : adresse IP à scanner 
    def __init__(self, ip):
        Thread.__init__(self)
        self.ip = ip
#Définition de la méthode Run de notre classe de scan
    def run(self):
        self.lookup(self.ip)
#Méthode de classe permettant de récupérer le hostname du périphérique connecté au réseau. Elle prend en paramètrre la variable de classe représentant l'adresse IP à recherchée
    def lookup(self, ip):
        try:
            hostname, alias, addressip = socket.gethostbyaddr(ip)
            host_d[ip] = hostname #On associe le hostname à l'adresse IP et on les sauve dans le dictionnaire
        except:
            hostname = "Not found"


#classe définissant le thread de ping d'adresse ip servant à ajouter une adresse ip active dans la liste avec un hostname non reconnue par la machine local 
class Ping(Thread):
   def __init__ (self,ip):
      #Constructeur de la classe prend en argument les paramètres suivants: address : adresse IP à ping
      Thread.__init__(self)
      self.ip = ip
#Définition de la méthode Run de notre classe de Ping
   def run(self):
       p = subprocess.Popen(["ping", "-n", "1", "-w", "200", self.ip],
                        stdout=subprocess.PIPE, shell=True).wait() #On utilise la commande de ping en enlevant le pop up de l'invite de commande
       if p == 0:
          if self.ip not in host_d:
             ping_list.append(self.ip) #On ajoute l'ip active dans le tableau si celui ci n'est pas présent dans le dictionnaire  



#programme principal
if __name__ == '__main__':
   sous_reseau = input("Entrez une (ou plusieurs) adresse(s) reseau(x) Format(EX: 192.168.1. ) Entrez 'Stop' pour arreter la saisie.\n\nReseau: ")
   while sous_reseau != "Stop":
      nb_sr.append(sous_reseau)
      sous_reseau = input("Reseau: ")
    
   for sr in nb_sr:
      print("\n\n---------- Réseau ",sr + "0","----------")
      print("\nIP\t\t\t Hostname\n------------------------------------------")

#On définit une plage d'adresses IP à scanner
      for i in range(1, 256):
         ip_list.append(sr + str(i)) #On stock chaques IP dans ip_list

      threadscan_list = []#Tableau qui stockera les threads créés pour la classe Scan
      threadping_list = []#Tableau qui stockera les threads créés pour la classe Ping

#On créée autant de threads qu'il y à d'adresses IP à scanner
      for thread in (Scan(ip) for ip in ip_list) :
         thread.start() #Chaque thread est démarré en même temps
         threadscan_list.append(thread) #On ajoute chaque thread dans le tableau

#On unit tous les threads pour être sûr que tous ceux-ci renvoient leur valeur
      for ts in threadscan_list:
         ts.join()

#On affiche le résultat qui affiche pour chaque machine connectée son nom d'hôte
      for ip, hostname in host_d.items():
         print(ip, "\t\t" , hostname)
                
#On créée autant de threads qu'il y à d'adresses IP à scanner
      for thread in (Ping(ip) for ip in ip_list) :
         thread.start() #Chaque thread est démarré en même temps
         threadping_list.append(thread) #On ajoute chaque thread dans le tableau
           
#On unit tous les threads pour être sûr que tous ceux-ci renvoient leur valeur
      for tp in threadping_list:
         tp.join()

#On affiche le résultat pour chaque machine connecté avec un nom d'hôte introuvable           
      for host in ping_list:
         hostname = "Not Found"
         print(host, "\t\t" , hostname)
 
#On vide le dictionnaire et les listes afin de les remplir avec un nouveau sous-reséau
      host_d = {}
      ping_list = []
      ip_list = []
      threadscan_list = []
      threadping_list = []

   print("-------------- Fin du Scan ---------------") 
