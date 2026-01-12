
#!/bin/bash
echo "Installing Brave..."
apt install curl
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
apt update
apt install brave-browser

echo "Configurating Brave policies to disable crap..."
mkdir -p /etc/brave/policies/managed
sh -c "cat >> /etc/brave/policies/managed/brave-hardening.json <<EOT
{
  "BraveWalletDisabled": true,
  "BraveAIChatEnabled": false,
  "BraveVPNDisabled": true,

  "BraveSidebarEnabled": false,

  "BraveRewardsDisabled": true
}
EOT"
pkill brave
brave-browser &

echo "Uninstalling LibreOffice..."
apt purge 'libreoffice*' -y
apt autoremove --purge -y
apt autoclean

echo "Installing OnlyOffice..."
mkdir -p ~/.gnupg && chmod 700 ~/.gnupg
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
gpg --export --armor CB2DE8E5 | sudo tee /usr/share/keyrings/onlyoffice.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main" | sudo tee /etc/apt/sources.list.d/onlyoffice.list
apt update
apt install onlyoffice-desktopeditors -y

xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.openxmlformats-officedocument.wordprocessingml.document
xdg-mime default onlyoffice-desktopeditors.desktop application/msword
xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.oasis.opendocument.text

xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.ms-excel
xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.oasis.opendocument.spreadsheet

xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.openxmlformats-officedocument.presentationml.presentation
xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.ms-powerpoint
xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.oasis.opendocument.presentation

xdg-mime default onlyoffice-desktopeditors.desktop text/rtf
xdg-mime default onlyoffice-desktopeditors.desktop application/pdf
