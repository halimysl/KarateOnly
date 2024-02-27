Feature: Same as Login.feature but using dic and fct

  Background:
    * configure driver = { type: 'msedge', start: true, stop: true, showDriverLog: true, showProcessLog: true, highlight: true, highlightDuration: 10000, addOptions: ['--remote-allow-origins=*'] }
    * def oLogin = callonce read 'classpath:dictionnaire/Login.json'
    * def sUrl = oLogin.urls.homeUrl

  @PracticeLogin
  @ignore
  Scenario: Log in
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    Then retry(3).waitFor(oLogin.home.title)
    When click(oLogin.home.practiceLink)
    Then retry(3).waitFor(oLogin.home.linkToLogin).click()
    Then retry(3).waitFor(oLogin.login)
    Then input(oLogin.user, __arg.user)
    Then input(oLogin.password, __arg.password)
    Then click(oLogin.connect)

  Scenario: Correct LogIn and LogOut
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    * karate.call('@PracticeLogin', {user: 'student', password: 'Password123'})
    Then match driver.url == oLogin.urls.logInSuccess
    And assert exists(oLogin.disconnect)
    Then click(oLogin.disconnect)
    Then match driver.url == oLogin.urls.logIn
    Then delay(2000)

  Scenario: Incorrect User
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    * karate.call('@PracticeLogin', {user: 'BAD', password: 'Password123'})
    Then match text(oLogin.error) == oLogin.errors.userError

  Scenario: Incorrect Password
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    * karate.call('@PracticeLogin', {user: 'student', password: 'BAD'})
    Then match text(oLogin.error) == oLogin.errors.passwordError