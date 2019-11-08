Feature: Cadastro de correntista

  Scenario Outline: Correntista cadastrado com sucesso

    Given url "/api/v1/holders"
    And request
    """
    {
      "holder": {
        address: {
          zipCode: <zipCode>,
          street: <street>,
          number: <number>,
          complement: <complement>
        },
        birthDate: <birthDate>,
        cpf: <cpf>,
        accountType: <accountType>,
        name: <name>,
        socialName: <socialName>
      }
    }
    """
    When method POST
    Then status 201
    And match data contains { holderId: "#number" }

    Examples:
      | zipCode  | street          | number | complement | birthDate  | cpf         | accountType | name | socialName |
      | 13035888 | Rua das flores  | 123    | ap.55      | 2000/01/01 | 12123123077 | PJ          | João | João ME    |
      | 13055871 | Rua das plantas | 321    |            | 1990/10/10 | 32128485980 | PF          | João |            |


  Scenario Outline: Correntista cadastrado com falha campos obrigatórios não informados

    Given url "/api/v1/holders"
    And request
    """
    {
      "holder": {
        address: {
          zipCode: <zipCode>,
          street: <street>,
          number: <number>,
          complement: <complement>
        },
        birthDate: <birthDate>,
        cpf: <cpf>,
        accountType: <accountType>,
        name: <name>,
        socialName: <socialName>
      }
    }
    """
    When method POST
    Then status 400
    And match data contains { message: <message> }

    Examples:
      | zipCode  | street         | number | complement | birthDate  | cpf         | accountType | name | socialName | message                         |
      |          | Rua das flores | 123    | ap.55      | 01/01/2000 | 12123123077 | PF          | João | João       | Campo zipCode não informado     |
      | 13035888 |                | 123    | ap.55      | 01/01/2000 | 12123123077 | PF          | João | João       | Campo street não informado      |
      | 13035888 | Rua das flores |        | ap.55      | 2000/01/01 | 12123123077 | PF          | João | João       | Campo number não informado      |
      | 13035888 | Rua das flores | 123    | ap.55      |            | 12123123077 | PF          | João | João       | Campo birthDate não informado   |
      | 13035888 | Rua das flores | 123    | ap.55      | 2000/01/01 |             | PF          | João | João       | Campo cpf não informado         |
      | 13035888 | Rua das flores | 123    | ap.55      | 2000/01/01 | 12123123077 |             | João | João       | Campo accountType não informado |
      | 13035888 | Rua das flores | 123    | ap.55      | 2000/01/01 | 12123123077 | PF          |      | João       | Campo name não informado        |
      | 13035888 | Rua das flores | 123    | ap.55      | 2000/01/01 | 12123123077 | PJ          | João |            | Campo socialName não informado  |


  Scenario Outline: Correntista cadastrado com falha idade menor que 18 anos

    Given url "/api/v1/holders"
    And request
    """
    {
      "holder": {
        address: {
          zipCode: <zipCode>,
          street: <street>,
          number: <number>,
          complement: <complement>
        },
        birthDate: <birthDate>,
        cpf: <cpf>,
        accountType: <accountType>,
        name: <name>,
        socialName: <socialName>
      }
    }
    """
    When method POST
    Then status 412
    And match data contains { message: <message>
    Examples:
      | zipCode  | street         | number | complement | birthDate  | cpf       | accountType | name | socialName | message                                  |
      | 13035888 | Rua das flores | 123    | ap.55      | 2005/01/01 | 121231230 | PF          | João | João       | “Cadastro permitido somente para maiores |

  Scenario Outline: Correntista cadastrado com falha tipo de conta inválido

    Given url "/api/v1/holders"
    And request
    """
    {
      "holder": {
        address: {
          zipCode: <zipCode>,
          street: <street>,
          number: <number>,
          complement: <complement>
        },
        birthDate: <birthDate>,
        cpf: <cpf>,
        accountType: <accountType>,
        name: <name>,
        socialName: <socialName>
      }
    }
    """
    When method POST
    Then status 400
    And match data contains { message: <message> }

    Examples:
      | zipCode  | street         | number | complement | birthDate  | cpf       | accountType | name | socialName | message                             |
      | 13035888 | Rua das flores | 123    | ap.55      | 2000/01/01 | 121231230 | PP          | João | João       | Campo accountType deve ser PF ou PJ |

  Scenario Outline: Correntista cadastrado com falha data de nascimento inválida

    Given url "/api/v1/holders"
    And request
    """
    {
      "holder": {
        address: {
          zipCode: <zipCode>,
          street: <street>,
          number: <number>,
          complement: <complement>
        },
        birthDate: <birthDate>,
        cpf: <cpf>,
        accountType: <accountType>,
        name: <name>,
        socialName: <socialName>
      }
    }
    """
    When method POST
    Then status 412
    And match data contains { message: <message> }

    Examples:
      | zipCode  | street         | number | complement | birthDate | cpf       | accountType | name | socialName | message                                          |
      | 13035888 | Rua das flores | 123    | ap.55      | dataAtual | 121231230 | PF          | João | João       | Data de nascimento deve ser menor que data atual |

  Scenario Outline: Correntista cadastrado com falha data de nascimento inválida devido a formtação

    Given url "/api/v1/holders"
    And request
    """
    {
      "holder": {
        address: {
          zipCode: <zipCode>,
          street: <street>,
          number: <number>,
          complement: <complement>
        },
        birthDate: <birthDate>,
        cpf: <cpf>,
        accountType: <accountType>,
        name: <name>,
        socialName: <socialName>
      }
    }
    """
    When method POST
    Then status 400
    And match data contains { message: <message> }

    Examples:
      | zipCode  | street         | number | complement | birthDate   | cpf       | accountType | name | socialName | message                  |
      | 13035888 | Rua das flores | 123    | ap.55      | 10/10/20000 | 121231230 | PF          | João | João       | Campo birthDate inválido |

  Scenario Outline: Correntista cadastrado com falha documento já cadastrado para outro usuário

    Given url "/api/v1/holders"
    And request
    """
    {
      "holder": {
        address: {
          zipCode: <zipCode>,
          street: <street>,
          number: <number>,
          complement: <complement>
        },
        birthDate: <birthDate>,
        cpf: <cpf>,
        accountType: <accountType>,
        name: <name>,
        socialName: <socialName>
      }
    }
    """
    When method POST
    Then status 412
    And match data contains { message: <message> }

    Examples:
      | zipCode  | street         | number | complement | birthDate  | cpf            | accountType | name | socialName | message                                             |
      | 13035888 | Rua das flores | 123    | ap.55      | 2000/01/01 | cpdAlreadyUsed | PF          | João | João       | Correntista já existente para o documento informado |

  Scenario Outline: Correntista cadastrado com falha zipCode inválido

    Given url "/api/v1/holders"
    And request
    """
    {
      "holder": {
        address: {
          zipCode: <zipCode>,
          street: <street>,
          number: <number>,
          complement: <complement>
        },
        birthDate: <birthDate>,
        cpf: <cpf>,
        accountType: <accountType>,
        name: <name>,
        socialName: <socialName>
      }
    }
    """
    When method POST
    Then status 400
    And match data contains { message: <message> }

    Examples:
      | zipCode    | street         | number | complement | birthDate  | cpf       | accountType | name | socialName | message                |
      | 13.035-888 | Rua das flores | 123    | ap.55      | 2000/01/01 | 121231230 | PF          | João | João       | Campo zipCode inválido |

  Scenario Outline: Correntista cadastrado com falha document inválido pois possui pontuação

    Given url "/api/v1/holders"
    And request
    """
    {
      "holder": {
        address: {
          zipCode: <zipCode>,
          street: <street>,
          number: <number>,
          complement: <complement>
        },
        birthDate: <birthDate>,
        cpf: <cpf>,
        accountType: <accountType>,
        name: <name>,
        socialName: <socialName>
      }
    }
    """
    When method POST
    Then status 400
    And match data contains { message: <message> }

    Examples:
      | zipCode  | street         | number | complement | birthDate  | cpf            | accountType | name | socialName | message                 |
      | 13035888 | Rua das flores | 123    | ap.55      | 2000/01/01 | 121.231.230-12 | PF          | João | João       | Campo document inválido |

  Scenario Outline: Correntista cadastrado com falha cpf inválido pois excedeu o limite de tamanho

    Given url "/api/v1/holders"
    And request
    """
    {
      "holder": {
        address: {
          zipCode: <zipCode>,
          street: <street>,
          number: <number>,
          complement: <complement>
        },
        birthDate: <birthDate>,
        cpf: <cpf>,
        accountType: <accountType>,
        name: <name>,
        socialName: <socialName>
      }
    }
    """
    When method POST
    Then status 400
    And match data contains { message: <message> }

    Examples:
      | zipCode  | street         | number | complement | birthDate  | cpf            | accountType | name | socialName | message                           |
      | 13035888 | Rua das flores | 123    | ap.55      | 2000/01/01 | 12123123012123 | PF          | João | João       | Campo cpf deve conter 11 digitos  |