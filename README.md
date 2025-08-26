# Barbearia App

Um aplicativo móvel desenvolvido em Flutter para gerenciamento de agendamentos em barbearia. O app permite que usuários visualizem barbeiros disponíveis, agendem horários e gerenciem seus agendamentos.

## 📱 Funcionalidades

- **Autenticação de Usuários**
  - Login
  - Registro de nova conta
  - Persistência de sessão

- **Gestão de Barbeiros**
  - Lista de barbeiros disponíveis
  - Perfil detalhado do barbeiro
  - Especialidades e avaliações

- **Sistema de Agendamentos**
  - Agendamento de horários
  - Visualização de agendamentos
  - Edição de horários
  - Cancelamento de agendamentos

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento multiplataforma
- **Provider**: Gerenciamento de estado
- **Shared Preferences**: Armazenamento local
- **Intl**: Formatação de datas e números

## 🏗️ Arquitetura

O projeto utiliza o padrão MVC (Model-View-Controller) com Provider para gerenciamento de estado:

```
lib/
  ├── models/        # Classes de modelo (User, Barber, Appointment)
  ├── views/         # Telas e widgets
  ├── controllers/   # Lógica de negócio e estado (Providers)
  ├── constants/     # Constantes e configurações
  └── design_system/ # Temas e estilos
```

## ⚙️ Como Rodar o Projeto

### Pré-requisitos

- Flutter SDK (versão 3.x ou superior)
- Dart SDK (versão 3.x ou superior)
- Android Studio / XCode
- Git

### Passos para Execução

1. Clone o repositório:
\`\`\`bash
git clone [URL_DO_REPOSITÓRIO]
\`\`\`

2. Navegue até a pasta do projeto:
\`\`\`bash
cd barber
\`\`\`

3. Instale as dependências:
\`\`\`bash
flutter pub get
\`\`\`

4. Execute o projeto:
\`\`\`bash
flutter run
\`\`\`

### Gerando APK para Android

Para gerar um APK de release:
\`\`\`bash
flutter build apk --release
\`\`\`
O APK será gerado em: \`build/app/outputs/flutter-apk/app-release.apk\`

## 📱 Compatibilidade

- Android 5.0 (API 21) ou superior
- iOS 11 ou superior

## 🔧 Versões das Tecnologias

- Flutter: 3.13.1
- Dart: 3.1.0
- Provider: ^6.0.5
- Shared Preferences: ^2.2.0
- Intl: ^0.18.1


## 👥 Autores

- Reginaldo Viana - Desenvolvedor Principal


