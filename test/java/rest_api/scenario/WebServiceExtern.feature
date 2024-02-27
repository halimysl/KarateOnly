Feature: Exemple de webservice REST externe
    - besoin des infos du proxy
    - besoin d'un certificat
    - pas besoin dans le browser car déjà configuré :)

  Background:
    * url 'https://jsonplaceholder.typicode.com'
    * configure ssl = {keyStore: 'classpath:BITProxyCA.jks'}
    * configure proxy = { uri: 'http://proxy-bvcol.admin.ch:8080',  nonProxyHosts: ['localhost','127.0.0.1','*.admin.ch']}

  Scenario: get all users
    Given path 'users'
    When method get
    Then status 200
    And match $[*].id == '#notnull'
    * def listUser = response
    * print listUser.length
    And assert listUser.length === 10

  Scenario: get a user by their id
    Given path 'users/1'
    When method get
    Then status 200
    And match $[*].id == '#notnull'
    * def user = response
    * print user.name
    And match user.name contains 'Leanne'

  Scenario: Create a user and get it by id
    * def oUser =
    """
    {
      "name": "Halim",
      "username": "aleem",
      "email": "halim.yousef@zas.admin.ch",
      "adress": {
        "street": "La rue de Suisse",
        "suite": "3ème étage",
        "city": "Genève",
        "zipcode": "1212"
      }
    }
    """

    Given path 'users'
    And request oUser
    When method post
    Then status 201
    * print 'debug insert:', response

    * def iID = response.id
    * print 'created ID is: '. iID

    Given path 'users', iID
    When method get
#    Then status 200
#    * print response
#    And match response contains oUser