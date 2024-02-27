Feature: Example d'application web externe

  Background:
    * def sUrl = "https://www.unige.ch/"
    * configure driver = { type: 'msedge', start: true, stop: true, showDriverLog: true, showProcessLog: true, highlight: true, highlightDuration: 10000, addOptions: ['--remote-allow-origins=*'] }

  Scenario: Ouverture d'une page et navigation dans la page
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    Then retry(3).waitFor('{^title}Université de Genève')
    When click('{^a}Facultés')
    Then delay(2000)
    Then retry(3).waitFor('{^a}Économie et management').click()
    Then retry(3).waitFor('{^title}Geneva School of Economics and Management')
    Then delay(2000)
    When click("{^h4}Inscrivez-vous")
    Then retry(3).waitFor('{^title}Inscription - Facult')
    Then retry(3).waitFor('{^a}portail de candidatures').click()
    Then delay(2000)
