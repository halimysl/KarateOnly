Feature: Same as Appointment.feature but using dic and fct

  # executé à chaque scénario (d'où le callonce)
  Background:
    * configure driver = { type: 'msedge', start: true, stop: true, showDriverLog: true, showProcessLog: true, highlight: true, highlightDuration: 10000, addOptions: ['--remote-allow-origins=*'] }
    * def oAppoint = callonce read 'classpath:dictionnaire/Appointment.json'
    * def sUrl = oAppoint.urls.homeUrl

  @AppointmentLogin
  @ignore
  Scenario: Log in
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    Then retry(3).waitFor(oAppoint.home.title)
    When click(oAppoint.home.makeAppointment)
    Then match driver.url == oAppoint.urls.logIn
    Then input(oAppoint.username, __arg.user)
    Then input(oAppoint.password, __arg.password)
    Then click(oAppoint.connect)

  @AppointmentLogOut
  @ignore
  Scenario: Log out
    When click(oAppoint.menu)
    Then retry(3).waitFor(oAppoint.disconnect).click()
    Then match driver.url == oAppoint.urls.homeUrl

  @FillForm
  @ignore
  Scenario: Fill form and check the appointment confirmation data
    When retry(3).waitFor(oAppoint.form.formtitle)
    * def facility = driver.select(oAppoint.form.selectFacility, __arg.facilityNum).value
    * if (__arg.readmission){driver.click(oAppoint.form.readmissionBox); sHosptial = 'Yes'} else {sHosptial = 'No'}
    And locate(__arg.medic).click()
    * def program = driver.locate(__arg.medic).value
    And input(oAppoint.form.date, __arg.date)
    And input(oAppoint.form.comment, __arg.comment)
    Then click(oAppoint.form.book)
    Then match driver.url == oAppoint.urls.appointmentSummary

    Then match text(oAppoint.confirm.confDate) == __arg.date
    And match text(oAppoint.confirm.confFacility) == facility
    And match text(oAppoint.confirm.confComment) == __arg.comment
    And match text(oAppoint.confirm.confProgram) == program
    And match text(oAppoint.confirm.confReadmission) == sHosptial

  @HasHistory
  @ignore
  Scenario: Check if any history exists
    When click(oAppoint.menu)
    Then retry(3).waitFor(oAppoint.history).click()
    Then match driver.url == oAppoint.urls.historyUrl
    * def formFilled = __arg.formFilled
    * def noHistory = exists(oAppoint.emptyHistory)
    * if (noHistory && formFilled){ karate.failed('The appointment was not saved in history') }

  Scenario: Log in and Log out
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    * karate.call('@AppointmentLogin', {user: 'John Doe', password: 'ThisIsNotAPassword'})
    Then match driver.url == oAppoint.urls.appointment
    * karate.call('@AppointmentLogOut')

  Scenario: Incorrect log in
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    * karate.call('@AppointmentLogin', {user: 'John Doe', password: 'INCORRECT'})
    Then locate(oAppoint.errors.loginError)

  Scenario: Fill an appointment
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    * karate.call('@AppointmentLogin', {user: 'John Doe', password: 'ThisIsNotAPassword'})
    * karate.call('@FillForm', {facilityNum: 2, readmission: true, medic: oAppoint.form.medicaid, date: '14/01/2034', comment:':)'})
    * karate.call('@AppointmentLogOut')

  Scenario: Fill an appointment and check if there is a history
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    * karate.call('@AppointmentLogin', {user: 'John Doe', password: 'ThisIsNotAPassword'})
    * karate.call('@FillForm', {facilityNum: 2, readmission: true, medic: oAppoint.form.medicaid, date: '14/01/2034', comment:':)'})
    * karate.call('@HasHistory', {formFilled: true})
    * karate.call('@AppointmentLogOut')

  Scenario: Log In without form and check if history empty
    Given driver sUrl
    * print 'debug:', driver.getUrl()
    * karate.call('@AppointmentLogin', {user: 'John Doe', password: 'ThisIsNotAPassword'})
    * karate.call('@HasHistory', {formFilled: false})
    * karate.call('@AppointmentLogOut')