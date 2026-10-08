Write-Host "[+] Ativando adb root..." -ForegroundColor Cyan
adb root
Start-Sleep -Seconds 2

$androidCommands = @"
CONSCRYPT_DIR=\$(ls -d /apex/com.android.conscrypt*/cacerts | tail -n 1)
mount -t tmpfs tmpfs "\$CONSCRYPT_DIR"
cp /system/etc/security/cacerts/* "\$CONSCRYPT_DIR/"
cp /data/misc/user/0/cacerts-added/9a5ba575.0 "\$CONSCRYPT_DIR/"
chmod 644 "\$CONSCRYPT_DIR/"*
chown root:root "\$CONSCRYPT_DIR/"*
chcon u:object_r:system_file:s0 "\$CONSCRYPT_DIR/"*
stop; start
"@

Write-Host "[+] Injetando certificado no Conscrypt APEX e reiniciando a UI..." -ForegroundColor Green
$androidCommands | adb shell

Write-Host "[✔] Processo concluído! Aguarde a interface do Android reiniciar." -ForegroundColor Yellow
