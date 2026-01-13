
#!/bin/bash
echo "Installing Brave..."
sudo apt -y install curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
sudo apt -y update
sudo apt -y install brave-browser
echo "Configurating Brave policies to disable crap..."
sudo mkdir -p /etc/brave/policies/managed
sudo sh -c "cat >> /etc/brave/policies/managed/brave-hardening.json <<EOT
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
sudo apt purge 'libreoffice*' -y
sudo apt autoremove --purge -y
sudo apt autoclean

echo "Installing OnlyOffice..."
sudo mkdir -p ~/.gnupg && chmod 700 ~/.gnupg
sudo gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
sudo gpg --export --armor CB2DE8E5 | sudo tee /usr/share/keyrings/onlyoffice.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main" | sudo tee /etc/apt/sources.list.d/onlyoffice.list
sudo apt update
sudo apt install onlyoffice-desktopeditors -y

sudo xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.openxmlformats-officedocument.wordprocessingml.document
sudo xdg-mime default onlyoffice-desktopeditors.desktop application/msword
sudo xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.oasis.opendocument.text

sudo xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
sudo xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.ms-excel
sudo xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.oasis.opendocument.spreadsheet

sudo xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.openxmlformats-officedocument.presentationml.presentation
sudo xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.ms-powerpoint
sudo xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.oasis.opendocument.presentation

sudo xdg-mime default onlyoffice-desktopeditors.desktop text/rtf
sudo xdg-mime default onlyoffice-desktopeditors.desktop application/pdf