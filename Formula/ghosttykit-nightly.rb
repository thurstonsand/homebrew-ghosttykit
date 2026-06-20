class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.2.1-dev-27862298975-6a87ac0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.2.1-dev-27862298975-6a87ac0/ghosttykit_0.2.1-dev-27862298975-6a87ac0_darwin_arm64.zip"
      sha256 "df1b31ae94b3834fc0aa66d68ea27857b3fd605e36c163c28d10261f350c2235"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.2.1-dev-27862298975-6a87ac0/ghosttykit_0.2.1-dev-27862298975-6a87ac0_darwin_amd64.zip"
      sha256 "8eea0b81c7e22f8f371d9dfe4ce745aa9bc34ad8f98fd08f1f4bd4c48e48c9e1"
    end
  end

  conflicts_with "ghosttykit", because: "both install gty and ghosttykitd"

  def install
    bin.install "bin/gty"
    prefix.install "GhosttyKitD.app"
    bin.install_symlink prefix/"GhosttyKitD.app/Contents/MacOS/ghosttykitd" => "ghosttykitd"
  end

  service do
    run [opt_prefix/"GhosttyKitD.app/Contents/MacOS/ghosttykitd"]
    keep_alive true
    working_dir var
    log_path var/"log/ghosttykitd.log"
    error_log_path var/"log/ghosttykitd.log"
  end

  def caveats
    <<~EOS
      This formula tracks nightly builds from GhosttyKit main and may break.

      Start Ghostty, then start the GhosttyKit daemon:

        brew services start #{full_name}

      On first start, macOS should ask for permission to let GhosttyKitD control Ghostty.
      Grant access, then verify the install with:

        gty doctor
    EOS
  end

  test do
    assert_match "gty 0.2.1-dev-27862298975-6a87ac0 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.2.1-dev-27862298975-6a87ac0", shell_output("#{bin}/ghosttykitd --version")
  end
end
