# Teste Empresta Bem Melhor

Projeto desenvolvido para o teste técnico da Empresta Bem


# 📱 App de Simulação de Empréstimos

Este é um aplicativo desenvolvido como avaliação técnica para uma vaga Flutter. O objetivo é permitir que usuários simulem empréstimos informando valor, instituições, convênios e quantidade de parcelas. O app consome uma API REST fornecida previamente.

## 🔧 Tecnologias utilizadas

- **Flutter com Dart**
- **HTTP client:** http
- **Máscara de moeda:** `flutter_multi_formatter` 
- **Consumo de API REST**

## 📁 Estrutura do projeto

```bash
lib/
├── controllers/              # Lógica e estado da aplicação
├── core/
│   ├── constants/            # Constantes da API
│   ├── models/               # Modelos de dados (DTOs)
│   ├── services/             # Comunicação com a API 
├── pages/                    # Telas principais
├── widgets/                  # Componentes reutilizáveis
│    ├── input                # Widgets para inserçao de dados 
└── main.dart                 # Ponto de entrada

```
##Funcionalidades

- Campo obrigatório para valor do empréstimo com máscara de moeda.

- Seleção de múltiplas instituições e convênios (com dados da API).

- Seleção de quantidade de parcelas (36, 48, 60, 72, 84).

- Envio dos dados para a API com exibição dos resultados:

- Instituição

- Valor solicitado

- Parcelas x valor (com destaque)

- Taxa de juros ao mês

##🔗 API

A Api configurada que será utilizada está em: https://github.com/JeffersonSouzaMachado/api_comparador
após clonar o repositório execute:
    - composer install
    - php artisan serve (se for rodar no localhost, se for rodar em servidor local utilize php artisan serve --host=IP-DO-SERVIDOR --port=8000 )

##Device
Para que acessar a api, ajuste o IP do HOST em:
- lib/core/constants/const_url.dart
  - Alterando a constante k_BASE_URL com o ip do HOST, exemplo:
    - const String k_BASE_URL = 'http://192.168.0.12';
