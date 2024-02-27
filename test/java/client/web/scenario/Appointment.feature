Feature: Example d'application web externe 3

  Background:
    * def sUrl = "https://katalon-demo-cura.herokuapp.com/"
    * configure driver = { type: 'msedge', start: true, stop: true, showDriverLog: true, showProcessLog: true, highlight: true, highlightDuration: 10000, addOptions: ['--remote-allow-origins=*'] }

  Scenario: Log in + Book an appointment and check history + log out
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    Then retry(3).waitFor('{^title}CURA Healthcare Service')
    When click('{^a}Make Appointment')
    Then retry(3).waitFor('{^h2}Login')
    Then match driver.url == 'https://katalon-demo-cura.herokuapp.com/profile.php#login'
    Then input('#txt-username', 'John Doe')
    And  input('#txt-password', 'ThisIsNotAPassword')
    Then delay(2000)
    When click('{^button}Login')
    Then delay(1000)
    Then match driver.url == 'https://katalon-demo-cura.herokuapp.com/#appointment'
    Then retry(3).waitFor('{^h2}Make Appointment')
    Then delay(2000)
    Then select('select[name=facility]', 2)
    Then delay(2000)
    And locate('#chk_hospotal_readmission').click()
    And locate('#radio_program_medicaid').click()
    And input('#txt_visit_date', '14/01/2025')
    And input('#txt_comment', 'This is a very interesting comment :)')
    * screenshot()
    Then delay(2000)
    When click('{^button}Book')
    Then retry(3).waitFor('{^h2}Appointment Confirmation')
    # Where the information of the form correct saved ?
    Then match driver.url == 'https://katalon-demo-cura.herokuapp.com/appointment.php#summary'
    And match text('#facility') == 'Seoul CURA Healthcare Center'
    And match text('#hospital_readmission') == 'Yes'
    And match text('#program') == 'Medicaid'
    And match text('#visit_date') == '14/01/2025'
    And match text('#comment') == 'This is a very interesting comment :)'
    * screenshot()
    Then delay(2000)
    # Was the form correctly saved in the history ?
    When click('#menu-toggle')
    Then delay(1000)
    Then retry(3).waitFor('{^a}History').click()
    Then match driver.url == 'https://katalon-demo-cura.herokuapp.com/history.php#history'
    * def noHistory = exists('{^p}No appointment')
    * print noHistory
    * if (noHistory) karate.fail('The appointment was not saved in history')
    * screenshot()
    Then delay(2000)
    # can the user log out ?
    When click('#menu-toggle')
    Then delay(1000)
    Then retry(3).waitFor('{^a}Logout').click()
    Then match driver.url == 'https://katalon-demo-cura.herokuapp.com/'
    Then delay(2000)

  Scenario: Login incorrect
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    Then retry(3).waitFor('{^title}CURA Healthcare Service')
    When click('{^a}Make Appointment')
    Then retry(3).waitFor('{^h2}Login')
    Then match driver.url == 'https://katalon-demo-cura.herokuapp.com/profile.php#login'
    Then input('#txt-username', 'arfkgmaglna')
    And  input('#txt-password', 'kjafbkgkaa')
    Then delay(2000)
    When click('{^button}Login')
    Then locate('{^p}Login failed').highlight()
    Then delay(2000)








