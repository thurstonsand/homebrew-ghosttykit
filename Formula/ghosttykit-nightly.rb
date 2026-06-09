class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.1.0-dev-27185529016-8eb2d99"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.1.0-dev-27185529016-8eb2d99_darwin_arm64.zip"
      sha256 "5870cfcdbb90e67340b21afe50509e62e4f83c2b61ea2d4d6bef89a6d758e95d"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.1.0-dev-27185529016-8eb2d99_darwin_amd64.zip"
      sha256 "942e046e7e741098a9c5c33ba43de1586053f18b49a7c65f458883a9c2909a22"
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
    assert_match "gty 0.1.0-dev-27185529016-8eb2d99 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.1.0-dev-27185529016-8eb2d99", shell_output("#{bin}/ghosttykitd --version")
  end
end
