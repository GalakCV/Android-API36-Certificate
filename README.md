# Inject CA Certificate into Conscrypt APEX (Android 14+ / API 34–36)

## Português

### O que o script faz

Este script PowerShell injeta um certificado de CA (Autoridade Certificadora) na store de certificados confiáveis do sistema Android, usando o módulo **Conscrypt APEX**. Ele é voltado para dispositivos com **root** e serve principalmente para interceptação de tráfego HTTPS (por exemplo, com Burp Suite, mitmproxy ou Charles) em testes de segurança e análise de aplicativos.

Passos executados:

1. Coloca o ADB em modo root (`adb root`).
2. Localiza o diretório de cacerts dentro do Conscrypt APEX.
3. Monta um `tmpfs` sobre esse diretório (sobreposição temporária em memória).
4. Copia os certificados do sistema e o certificado do usuário (`9a5ba575.0`) para dentro dele.
5. Ajusta permissões, dono e contexto SELinux.
6. Reinicia a UI do Android (`stop; start`) para aplicar as mudanças.

### Relação entre a API 36 e a instalação de certificados

Até o Android 13, os certificados de CA do sistema ficavam em `/system/etc/security/cacerts/`, e bastava copiar o certificado para lá (com a partição `/system` montada como gravável) para que todo o sistema confiasse nele.

A partir do **Android 14 (API 34)**, o conjunto de CAs do sistema passou a ser entregue por um **módulo atualizável Conscrypt via APEX**, agora localizado em `/apex/com.android.conscrypt*/cacerts`. Esse diretório é de somente leitura e protegido, então a abordagem antiga de editar `/system` deixou de funcionar.

Além disso, desde o Android 7 (API 24), certificados adicionados pelo usuário (em `/data/misc/user/0/cacerts-added/`) **não são mais confiáveis por padrão** pelos aplicativos — apenas os CAs do sistema são. Por isso é necessário promover o certificado do usuário para a store do sistema.

Nas versões mais recentes, incluindo a **API 36 (Android 16)**, esse modelo baseado em APEX continua em vigor. A técnica usada aqui — montar um `tmpfs` sobre o diretório de cacerts do Conscrypt e preenchê-lo com os certificados do sistema mais o certificado desejado — é a forma atual de instalar um CA confiável em nível de sistema sem modificar partições protegidas. A sobreposição é temporária e desaparece ao reiniciar o dispositivo.

### Pré-requisitos

- Dispositivo ou emulador Android com root.
- ADB instalado e no PATH.
- Certificado do usuário já presente como `9a5ba575.0` em `/data/misc/user/0/cacerts-added/`.

---

## English

### What the script does

This PowerShell script injects a CA (Certificate Authority) certificate into the Android system trust store using the **Conscrypt APEX** module. It targets **rooted** devices and is primarily used for HTTPS traffic interception (for example, with Burp Suite, mitmproxy, or Charles) during security testing and app analysis.

Steps performed:

1. Puts ADB into root mode (`adb root`).
2. Locates the cacerts directory inside the Conscrypt APEX.
3. Mounts a `tmpfs` over that directory (a temporary in-memory overlay).
4. Copies the system certificates and the user certificate (`9a5ba575.0`) into it.
5. Fixes permissions, ownership, and SELinux context.
6. Restarts the Android UI (`stop; start`) to apply the changes.

### Relation between API 36 and certificate installation

Up to Android 13, system CA certificates lived in `/system/etc/security/cacerts/`, and installing a trusted CA was as simple as copying the certificate there (with `/system` mounted as writable).

Starting with **Android 14 (API 34)**, the system CA set is delivered by an **updatable Conscrypt module via APEX**, now located at `/apex/com.android.conscrypt*/cacerts`. This directory is read-only and protected, so the old approach of editing `/system` no longer works.

In addition, since Android 7 (API 24), user-added certificates (in `/data/misc/user/0/cacerts-added/`) are **no longer trusted by default** by apps — only system CAs are. That is why the user certificate must be promoted into the system store.

In the most recent releases, including **API 36 (Android 16)**, this APEX-based model remains in place. The technique used here — mounting a `tmpfs` over the Conscrypt cacerts directory and populating it with the system certificates plus the desired certificate — is the current way to install a system-level trusted CA without modifying protected partitions. The overlay is temporary and is lost on reboot.

### Requirements

- Rooted Android device or emulator.
- ADB installed and on PATH.
- User certificate already present as `9a5ba575.0` in `/data/misc/user/0/cacerts-added/`.

