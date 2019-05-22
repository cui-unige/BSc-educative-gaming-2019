# Board game algorithms
""" nombre limité de while, for, if on peut les utiliser pour chacun des objectifs (dynamique du jeu)"""
""" faire algo suivant les controles de flots que l'on pioche """
"""niveaux: novice, étudiant, junior, sénior"""
""" code couleurs pour type et puzzle pour syntaxe"""


# Variables
l = []
team = []
p = {'Alice', 'Bob', 'Alan', 'Lena', 'Edgar'}
nb_team = 5
count = range(1,11)
x = 10
n = 0


# Primitives
def pop(p):
    el = p.pop()
    #l.append(el)
    return el

def sort(l):
    l.sort()
    return l

def reverse(l):
    l.reverse()
    return l

def push(l,x):
    l.append(x)
    return l

def putFirst(l,el):
    l.insert(0,el)
    return None

def alphMin(team,el):
    try:
        min([el]+team)
    except (ValueError,TypeError):
        return None
    return min([el]+team)

def size(l):
    return len(l)-1

def fill():
    return None


# Objectifs (algos)
        
#for avec liste (moyen/difficile)
##def countdown_2(l):
##    for i in count:
##        push(l,i)
##    sort(l)
##    reverse(l)
##    for i in l:
##        print(i)
##    return 'Décollage !!!'
        
#if sans liste (difficile)
##def countdown_3(x):
##    if x > 0:
##        print(x)
##        x = x-1
##        countdown_3(x)
##    return 'Décollage !!!'

#ajouter passagers (facile)
##def add_team_1(p):
##    while p != set():
##        m = pop(p)
##        push(team,m)
##    return team,'prêts pour le décollage'

# ajouter et trier les passagers (difficile)
##def sort_team_1(p):
##    while p != set():
##        m = pop(p)
##        if m == alphMin(team,m):
##            putFirst(team,m)
##        else: push(team,m)
##    return  team ,'prêts pour le décollage'

"""Compte à rebours"""
#while sans liste (facile)
def countdown_1():
    x = 10
    while x != 0:
        print(x)
        x = x-1
    return 'Décollage !!!'

def countdown_2():
    for i = 10 to 0:
        print(i)
    return None

 

"""gérer les membres"""

#Vérifier nombre de passagers(moyen)

def check_team(team):
    for i = 0 to length(team):
        n += 1
        if n == nb_team:
            return 'les ',n,' membres sont à bord'

#Vérifier essence
dist_lune = 1000
conso_fusee = 50
fuel = (dist_lune/conso_fusee)*2
def fill_fuel_1(cur_fuel,volume):
    while cur_fuel < volume:
        fill()
    return "fuel ok"

'''def fill_fuel_2(cur_fuel,volume):
    if cur_fuel >= volume:
        fill()
    else:
        return None'''

#Phases de vol
cur_dist = 0
state = ''
def auto_pilot_1(state,x,y):
    if state in range(x,y):
        fly()
    else:
        return None

def auto_pilot_2(state,x,y):
    while state in range(x,y):
        fly()
    return None


#Check job
team = ['Alice', 'Bob', 'Alan', 'Lena', 'Edgar']
def check_task():
    for i in team:
        if check(i) == 'check':
            continue
        else:
            return 'tasks uncompleted'

#check moteur
right_temp = 50
temp = 0
def check_engine(temp,right_temp):
    if temp > right_temp:
        cool()
    elif temp < right_temp:
        warm()
    else:
        return None


#itinéraire??
# assignier tache aux membres (tableau)
"""vérifier le code"""

# Pour vérifier le code, décrire la sémantique des pièces






        
