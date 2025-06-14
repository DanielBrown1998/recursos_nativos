# Flutter Recursos Nativos - Projeto de Demonstração

Este projeto é um aplicativo Flutter desenvolvido como parte do aprendizado sobre a integração de recursos nativos em dispositivos móveis. Ele serve como um exemplo prático de como utilizar diversas funcionalidades do hardware e do sistema operacional através de plugins Flutter.

## Visão Geral

O objetivo principal deste aplicativo é demonstrar a implementação de funcionalidades nativas comuns, como:

*   Acesso à câmera do dispositivo.
*   Gerenciamento de permissões em tempo de execução.
*   Obtenção da localização geográfica (GPS).
*   Armazenamento local de dados.
*   (Opcional: Adicionar outros recursos que seu projeto específico possa cobrir, como mapas, sensores, etc.)

Este projeto foi inspirado e/ou desenvolvido com base nos aprendizados do curso [Flutter: Recursos Nativos da Alura](https://cursos.alura.com.br/formacao-flutter-recursos-nativos).

## Funcionalidades Demonstradas

*   **Gerenciamento de Permissões:**
    *   Solicitação de permissões para câmera, localização, etc., utilizando o plugin `permission_handler`.
    *   Verificação do status das permissões antes de tentar acessar o recurso.
*   **Acesso à Câmera:**
    *   Captura de fotos utilizando o plugin `camera`.
    *   Exibição de um preview da câmera.
    *   (Opcional: Captura de vídeos).
*   **Geolocalização:**
    *   Obtenção da localização atual do dispositivo (latitude e longitude) usando o plugin `geolocator`.
    *   Tratamento de casos onde o serviço de localização está desabilitado ou permissões são negadas.
*   **Armazenamento Local:**
    *   Exemplo de como salvar e recuperar dados simples (ex: preferências do usuário, pequenos tokens) utilizando `shared_preferences`.
    *   (Opcional: Demonstração de `sqflite` para armazenamento de dados estruturados em um banco de dados SQLite local).
*   **(Opcional) Integração com Mapas:**
    *   Exibição de mapas e marcadores (ex: usando `google_maps_flutter` ou `flutter_map`).
*   **(Opcional) Uso de Sensores:**
    *   Leitura de dados de sensores como acelerômetro ou giroscópio (ex: usando `sensors_plus`).

## Tecnologias e Plugins Utilizados

*   **Flutter:** Framework de UI para construir aplicativos compilados nativamente.
*   **Dart:** Linguagem de programação utilizada pelo Flutter.
*   **Plugins Flutter:**
    *   `permission_handler`: Para solicitar e verificar permissões do dispositivo.
    *   `camera`: Para interagir com a câmera do dispositivo.
    *   `geolocator`: Para obter dados de geolocalização.
    *   `shared_preferences`: Para armazenamento local de dados chave-valor simples.
    *   (Adicionar outros plugins relevantes como `image_picker`, `path_provider`, `sqflite`, `google_maps_flutter`, `sensors_plus`, etc., conforme utilizados no seu projeto).
*   **Gerenciamento de Estado:** (Mencionar o método utilizado, ex: Provider, BLoC, GetX, Riverpod, setState).

## Estrutura do Projeto (Exemplo)

