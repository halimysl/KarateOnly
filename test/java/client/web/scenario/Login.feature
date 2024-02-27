Feature: Example d'application web externe 2

  Background:
    * def sUrl = "https://practicetestautomation.com/"
    * configure driver = { type: 'msedge', start: true, stop: true, showDriverLog: true, showProcessLog: true, highlight: true, highlightDuration: 10000, addOptions: ['--remote-allow-origins=*'] }

  Scenario: Ouverture d'une page et navigation dans la page et login
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    Then retry(3).waitFor('{^title}Practice Test Automation')
    When click('{^a}Practice')
    Then retry(3).waitFor('{^a}Test Login Page').click()
    Then retry(3).waitFor('{^title}Test Login')
    Then input('#username', 'student')
    And input('#password', 'Password123')
    Then delay(2000)
    Then click('{^button}Submit')
    Then retry(3).waitFor('{^h1}Logged In')
    * screenshot()
    Then match driver.url == 'https://practicetestautomation.com/logged-in-successfully/'
    And locate('{^a}Log out').highlight()
    And assert exists('{^a}Log out')
    Then click('{^a}Log out')
    Then match driver.url == 'https://practicetestautomation.com/practice-test-login/'
    Then delay(2000)

  Scenario: Login avec un user qui n'existe pas
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    Then retry(3).waitFor('{^title}Practice Test Automation')
    When click('{^a}Practice')
    Then retry(3).waitFor('{^a}Test Login Page').click()
    Then retry(3).waitFor('{^title}Test Login')
    Then input('#username', 'incorrectUser')
    And input('#password', 'Password123')
    Then click('{^button}Submit')
    Then delay(2000)
    Then match text('{^div}Your username') == 'Your username is invalid!'
    Then delay(2000)

  Scenario: Login avec un mot de passe incorrect
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    Then retry(3).waitFor('{^title}Practice Test Automation')
    When click('{^a}Practice')
    Then retry(3).waitFor('{^a}Test Login Page').click()
    Then retry(3).waitFor('{^title}Test Login')
    Then input('#username', 'student')
    And input('#password', 'incorrectPassword')
    Then click('{^button}Submit')
    Then delay(2000)
    Then match text('{^div}Your password') == 'Your password is invalid!'
    Then delay(2000)