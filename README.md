O Problema

A partir do Android 14 (API 34+), a Google alterou a arquitetura do sistema ao isolar o repositório de certificados dentro do módulo Conscrypt APEX (/apex/com.android.conscrypt/cacerts/).

Tentativas de escrita direta em /system/etc/security/cacerts/ resultam em erro de Read-only file system.

Montagens tmpfs tradicionais na pasta antiga do sistema são ignoradas pelo serviço KeyChain.

A Solução

Este script automatiza o bypass montando um sistema de arquivos temporário (tmpfs) diretamente sobre o caminho ativo do módulo Conscrypt APEX, copiando as CAs nativas do sistema + a CA do usuário (9a5ba575.0), aplicando o contexto SELinux correto e reiniciando o ecossistema Android (stop; start).

Pré-requisitos

Emulador Android rodando em modo Root (adb root).

Certificado do proxy previamente instalado na aba de Usuário (garantindo que o arquivo exista em /data/misc/user/0/cacerts-added/).

Como Usar (PowerShell)

Execute no terminal do host:

.\inject-ca.ps1
