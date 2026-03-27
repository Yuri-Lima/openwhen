# OpenWhen — Testes em dispositivo real (MVP)

Checklist para validar iOS/Android após implementar os itens críticos do MVP.

## Pré-requisitos

- Flutter SDK e Xcode (iOS) / Android Studio (Android)
- Arquivos locais: `lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`
- Conta Apple Developer para push em iOS (APNs configurado no Firebase Console)

## Android

1. `flutter pub get`
2. Conectar dispositivo com USB debugging ou usar emulador com Play Services
3. `flutter run` (ou `flutter build apk --release` + instalar APK)
4. Confirmar permissões: notificações (Android 13+), galeria para foto de perfil, **localização** ao criar carta/cápsula com partilha de GPS e ao abrir com `openRequiresProximity` (deve pedir localização no destinatário)
5. Fluxos mínimos: login → feed → cofre → criar carta/cápsula **com** e **sem** localização / **com** restrição de 10 m → abrir no local e longe do ponto → perfil → alterar foto → configurações → permissão de push

## iOS

1. No iPhone: **Ajustes → Privacidade e segurança → Modo de desenvolvedor** (Developer Mode) ligado, e confiar no Mac quando o Xcode/cabo pedir.
2. Abrir `ios/Runner.xcworkspace` no Xcode e definir **Signing & Capabilities** (time + bundle id)
3. Adicionar capability **Push Notifications** se ainda não existir (FCM)
4. `flutter run` em dispositivo físico (push não valida no simulador da mesma forma)
5. Na primeira execução, aceitar alertas de fotos, notificações e **localização** quando testar envio com GPS ou abertura com proximidade
6. Repetir os mesmos fluxos do Android (incluindo localização nos fluxos de carta/cápsula)

## Firebase (produção)

- Deploy das regras após QA em staging:  
  `firebase deploy --only firestore:rules,storage`
- Validar que leituras/escritas do app não retornam `PERMISSION_DENIED` nos fluxos acima

**Documentação completa:** identificadores do projeto, instalação da Firebase CLI, JDK 21 para Emulator Suite, portas e deploy — ver **[README.md](../README.md#firebase-configuration)** (English) ou **[README.pt-BR.md](../README.pt-BR.md)** (seções *Configuração Firebase* e *Firebase CLI e emuladores*).

## Regressão web (opcional)

- `flutter run -d chrome` — avatar (galeria), abertura de cápsula e feed continuam funcionando; FCM no web exige configuração extra (VAPID / service worker) e pode estar limitado.
