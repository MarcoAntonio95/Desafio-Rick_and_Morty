# Desafio Rick and Morty

Tratasse de um aplicativo de desafio, onde é consumido e manipulado os dados de uma API publica do Rick and Morty, neste caso os dados são os personagens da série animada.

Tecnologias / Padrão de Arquitetura / Framework presentes:
 - Swift 5
 - MVVM-C
 - Coordinator Pattern
 - Observer Pattern
 - Delegate
 - RxSwift
 - SwiftJSON
 - Alamofire
 - XCTest/XCUItest
 - SOLID
 
Estrutura Basica do projeto 

- O projeto foi dividido em 2 "Flows" um flow responsavel pela listagem de todos os personagens, de acordo com o filtro atual e outro flow responsavél pela apresentação dos detalhes do personagem selecionado na lista.

Pontos de destaque do projeto

- RxSwift
    - Utilização do Rx para deixar o projeto mais interativo e uma resposta mais rapida quando precisamos fazer uma atualização dos dados apresentado na UI;

- Alamofire
    - Requisições e download de informações de uma maneira simplicada  e eficiente;
    
- Modo offline
    - O projeto após a primeira execução com internet faz o download do JSON e permite a utilização da aplicação em modo offline;

- Testes
    - Utilização do framework oficial Apple para testar as regras de négocio e a interface da aplicação;
 
 - SOLID
    - Utilização de alguns conceitos e aprendizado dos conceitos SOLID.

