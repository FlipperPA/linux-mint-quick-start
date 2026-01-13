
#!/bin/bash
echo "Installing Brave..."
sudo apt -y install ca-certificates curl gnupg
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
sudo apt -y update
sudo apt -y install brave-browser

echo "Updating Brave managed policies (hard lock)..."
sudo mkdir -p /etc/brave/policies/managed
sudo tee /etc/brave/policies/managed/brave-hardening.json >/dev/null <<'JSON'
{
  "BraveWalletDisabled": true,
  "BraveAIChatEnabled": false,
  "BraveVPNDisabled": 1,
  "BraveSidebarEnabled": false,
  "BraveRewardsDisabled": true,
  "BraveTalkDisabled": true,

  "BraveP3AEnabled": false,
  "MetricsReportingEnabled": false,
  "CrashReportingEnabled": false,

  "ImportOnFirstRun": false,
  "ImportBookmarks": false,
  "ImportHistory": false,
  "ImportSavedPasswords": false,
  "ImportSearchEngine": false,

  "DefaultBrowserSettingEnabled": false
}
JSON
echo "Setting Brave as default browser..."
xdg-settings set default-web-browser brave-browser.desktop
xdg-mime default brave-browser.desktop x-scheme-handler/http
xdg-mime default brave-browser.desktop x-scheme-handler/https
xdg-mime default brave-browser.desktop text/html
python3 - <<'PY'
import json, pathlib

path = pathlib.Path.home() / ".config/cinnamon/spices/grouped-window-list@cinnamon.org/2.json"
data = json.loads(path.read_text())

pins = data.get("pinned-apps", {}).get("value", [])
# Remove firefox
pins = [p for p in pins if p != "firefox.desktop"]
# Add brave (prefer near the front, after nemo if present)
if "brave-browser.desktop" not in pins:
    if "nemo.desktop" in pins:
        i = pins.index("nemo.desktop") + 1
        pins.insert(i, "brave-browser.desktop")
    else:
        pins.insert(0, "brave-browser.desktop")

data["pinned-apps"]["value"] = pins

path.write_text(json.dumps(data, indent=4))
print("Updated pinned-apps.value:", pins)
PY
pkill -f brave-browser || true
pkill -f brave || true
brave-browser &
cinnamon --replace &

echo "Uninstalling LibreOffice..."
sudo apt purge 'libreoffice*' -y
sudo apt autoremove --purge -y
sudo apt autoclean

echo "Installing OnlyOffice..."
sudo mkdir -p ~/.gnupg && chmod 700 ~/.gnupg
curl -fsSL https://download.onlyoffice.com/repo/onlyoffice.key | sudo gpg --dearmor -o /usr/share/keyrings/onlyoffice-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/onlyoffice-archive-keyring.gpg] https://download.onlyoffice.com/repo/debian squeeze main" | sudo tee /etc/apt/sources.list.d/onlyoffice.list > /dev/null
download.onlyoffice.com/repo/debian squeeze main" | sudo tee /etc/apt/sources.list.d/onlyoffice.list
sudo apt -y update
sudo apt -y install onlyoffice-desktopeditors

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