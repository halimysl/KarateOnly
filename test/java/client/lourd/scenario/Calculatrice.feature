Feature: calculatrice window

  Scenario: conversion de devise (KRW -> CHF)
    * robot {window:'Calculatrice', fork:'calc', highlight: true, highlightDuration: 1000}
    # fork --> run a console command to start the app
    * click('Ouvrir navigation')
    * click('^Devise')
    * click('^Mettre à jour')
    * delay(50)
    * click('^Effacer')
    * click('Un')
    * click('Zéro')
    * click('Zéro')
    * click('Zéro')
    * def won = locate('^Won').name
    * def chf = locate('^Franc').name
    * def taux = locate('^=').name
    * def won = parseFloat(won.replace(/\D/g, ''))
    * def chf = parseFloat(chf.match(/\d+\.\d+/))
    * def taux = parseFloat(taux.match(/\d+\.\d+/)[0])
    * def calcChf = (won * taux).toFixed(2) //arrondi à deux chiffres après la virgule
    * print "Me: " + calcChf + " Calc: " + chf
    * match parseFloat(calcChf) == chf

  Scenario: Multiplication standard
    * robot {window:'Calculatrice', fork:'calc', highlight: true, highlightDuration: 1000}
    * click('Ouvrir navigation')
    * click('^Standard')
    * click('Effacer')
    * click('Deux')
    * click('^Mult')
    * click('Cinq')
    * click('Est égal à')
    * match locate('#CalculatorResults').name == "L’affichage est 10"