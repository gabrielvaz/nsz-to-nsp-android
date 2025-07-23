# 📱 Guia de Publicação - NSZ2NSP Converter

## ⚠️ AVISO IMPORTANTE

Este aplicativo **NÃO DEVE** ser publicado na Google Play Store conforme indicado no PRD original. A publicação de aplicativos relacionados à conversão de ROMs de Nintendo Switch pode violar as diretrizes da Play Store e resultar em:

- Suspensão da conta de desenvolvedor
- Remoção do aplicativo
- Ações legais da Nintendo

**Recomendação:** Distribuir via APK direto, GitHub Releases ou F-Droid.

---

## 📋 Preparação para Publicação (Caso Procedam)

### 1. Informações Básicas do App

**Nome do App:** NSZ2NSP Converter  
**Package Name:** com.example.nsz_to_nsp_converter  
**Versão:** 1.0.0  
**Build Number:** 1  
**Categoria:** Ferramentas  
**Classificação Etária:** +12 (devido ao conteúdo relacionado a jogos)

### 2. Descrições de Loja

#### Título Curto (30 caracteres)
```
NSZ2NSP Converter
```

#### Descrição Curta (80 caracteres)
```
Converta arquivos NSZ para NSP diretamente no seu Android
```

#### Descrição Completa
```
🎮 NSZ2NSP Converter - Converta seus Backups Legais

O NSZ2NSP Converter permite converter arquivos .nsz para .nsp diretamente no seu dispositivo Android, sem necessidade de computador ou conhecimento técnico avançado.

✨ RECURSOS PRINCIPAIS:
• Interface intuitiva e fácil de usar
• Conversão local sem conexão com internet
• Suporte a arquivos grandes (2GB+)
• Barra de progresso em tempo real
• Criação automática de pasta de destino
• Suporte a orientação vertical e horizontal

📱 COMO USAR:
1. Aceite os termos de uso responsável
2. Selecione seu arquivo .nsz
3. Inicie a conversão
4. Arquivo .nsp salvo em Download/NSZ2NSP

⚖️ USO LEGAL:
Este aplicativo destina-se EXCLUSIVAMENTE para conversão de backups pessoais legítimos de jogos que você possui. O usuário assume total responsabilidade pelo uso adequado.

🔐 PRIVACIDADE:
• Nenhum dado é coletado
• Processamento 100% local
• Não requer conexão com internet
• Sem anúncios ou trackers

📋 REQUISITOS:
• Android 8.0 (API 26) ou superior
• Permissão de armazenamento
• Espaço livre equivalente ao arquivo original

IMPORTANTE: Use apenas com backups legais de jogos que você possui.
```

#### Descrição Técnica para Desenvolvedores
```
Aplicativo desenvolvido em Flutter para conversão de arquivos NSZ para NSP em dispositivos Android. 

Implementa:
- Interface Material Design 3
- Gerenciamento de permissões nativo
- Processamento de arquivos grandes
- Suporte a múltiplas orientações
- Arquitetura limpa com separação de responsabilidades
```

### 3. Palavras-chave (ASO)
```
nsz, nsp, converter, nintendo, switch, backup, rom, arquivo, jogos, ferramentas
```

### 4. Configurações de Privacidade

#### Política de Privacidade (OBRIGATÓRIA)
**URL:** Deve criar em: https://app-privacy-policy-generator.nisrulz.com/

**Conteúdo sugerido:**
- O aplicativo não coleta dados pessoais
- Processamento local de arquivos
- Permissões utilizadas apenas para acesso a arquivos
- Nenhum dado é enviado para servidores externos

### 5. Classificação de Conteúdo

**Categoria:** Ferramentas  
**Público-alvo:** Geral (com aviso sobre uso responsável)  
**Classificação:** +12 (devido ao contexto de jogos)

**Questões de Classificação:**
- Violência: Nenhuma
- Conteúdo Sexual: Nenhum  
- Linguagem Imprópria: Nenhuma
- Drogas: Nenhuma
- Jogos/Apostas: Não se aplica

### 6. Permissões Utilizadas

```xml
<!-- Armazenamento -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
```

**Justificativas:**
- **READ_EXTERNAL_STORAGE:** Ler arquivos NSZ selecionados pelo usuário
- **WRITE_EXTERNAL_STORAGE:** Salvar arquivos NSP convertidos
- **MANAGE_EXTERNAL_STORAGE:** Acesso completo para Android 11+

### 7. Assets Necessários

#### Ícones do App
- **Ícone Adaptativo:** 512x512px (já incluído)
- **Ícone Legado:** 1024x1024px
- **Feature Graphic:** 1024x500px

#### Screenshots (Obrigatórios)
Localização: `publicar-app/screenshots/`

Necessário capturar:
1. **Tela de Onboarding** - Mostrando aviso legal
2. **Tela de Seleção** - Interface de seleção de arquivo
3. **Tela de Conversão** - Processo com barra de progresso
4. **Tela de Resultado** - Conversão concluída

**Formatos:** PNG ou JPEG, 16:9 ou 9:16, min. 320px

### 8. Preparação do APK/AAB

#### Para Desenvolvimento
```bash
flutter build apk --debug
```

#### Para Produção (Release)
```bash
# Gerar keystore (primeira vez)
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Build release
flutter build appbundle --release
```

### 9. Configurações de Publicação

#### Preço
- **Gratuito** (recomendado)
- Sem compras no app

#### Distribuição
- **Países:** Brasil, Estados Unidos, Europa
- **Dispositivos:** Apenas telefones e tablets Android

#### Configurações Avançadas
- **Instalação Externa:** Permitir
- **Compatibilidade:** Android 8.0+
- **Arquitetura:** arm64-v8a, armeabi-v7a

### 10. Checklist Pré-Publicação

- [ ] APK/AAB assinado e testado
- [ ] Screenshots em múltiplas resoluções
- [ ] Política de privacidade criada e hospedada
- [ ] Descrições traduzidas (pt-BR, en-US)
- [ ] Ícones em todas as resoluções
- [ ] Feature graphic criado
- [ ] Teste em dispositivos reais
- [ ] Verificação de conformidade legal
- [ ] Backup de todos os assets

### 🚨 ALTERNATIVAS RECOMENDADAS

1. **GitHub Releases**
   - Distribuição direta via APK
   - Sem restrições de conteúdo
   - Controle total da distribuição

2. **F-Droid**
   - Loja de apps open source
   - Mais permissiva para ferramentas
   - Público-alvo técnico

3. **Site Próprio**
   - Distribuição independente
   - Download direto do APK
   - Evita políticas restritivas

---

## 📞 Contato e Suporte

Para dúvidas sobre o desenvolvimento ou publicação:
- Documentação técnica em `/docs`
- Issues no repositório GitHub
- Email: [seu-email@exemplo.com]

---

*Este guia foi gerado automaticamente. Revise todas as informações antes da publicação.*