cask "healthy-battery" do
  version "1.2.3"
  sha256 "e8c408f9980db530e90cd4c09148aa50af4c781f8ff4e71cf76d2e561b8646d6"

  url "https://github.com/berkinefeavci/healthy-battery/releases/download/v#{version}/Healthy-Battery-#{version}.dmg"
  name "Healthy Battery"
  desc "Menu bar charge limiter and battery monitor"
  homepage "https://github.com/berkinefeavci/healthy-battery"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :ventura

  app "Healthy Battery.app"

  # `brew upgrade` runs `uninstall` too, so it only quits the app. Removing the root helpers there
  # would ask for a password on every upgrade and turn off the LED and power-mode helpers.
  uninstall quit: "io.github.berkinefeavci.cellkeep"

  zap launchctl: [
        "io.github.berkinefeavci.cellkeep.led",
        "io.github.berkinefeavci.cellkeep.powermode",
      ],
      delete:    [
        "/Library/Application Support/CellkeepLED",
        "/Library/Application Support/CellkeepPowerMode",
        "/Library/LaunchDaemons/io.github.berkinefeavci.cellkeep.led.plist",
        "/Library/LaunchDaemons/io.github.berkinefeavci.cellkeep.powermode.plist",
        "/Library/PrivilegedHelperTools/io.github.berkinefeavci.cellkeep.led",
        "/Library/PrivilegedHelperTools/io.github.berkinefeavci.cellkeep.powermode",
      ],
      trash:     [
        "~/Library/Application Support/Cellkeep",
        "~/Library/Preferences/io.github.berkinefeavci.cellkeep.plist",
      ]

  caveats <<~EOS
    Upgrades keep Cellkeep's helpers. To remove them, use Settings → General → Uninstall
    Cellkeep first, or `brew uninstall --zap --cask healthy-battery`.
    Cellkeep's charge limit uses macOS's own charge-limit setting, which stays as it was
    after uninstalling. Reset it in System Settings → Battery if you want to.
  EOS
end
