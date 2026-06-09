class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.1.0-dev-27186183358-1b9910b"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.1.0-dev-27186183358-1b9910b_darwin_arm64.zip"
      sha256 "278c3b32636c53fb8cd2acf4ceb3bf68a368b9a4027b0deffdf196594e59991c"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.1.0-dev-27186183358-1b9910b_darwin_amd64.zip"
      sha256 "dba9e8714ece352e522186477ac1dd69e87dcf7ef8803edd1a4c13510f968e8d"
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
    assert_match "gty 0.1.0-dev-27186183358-1b9910b protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.1.0-dev-27186183358-1b9910b", shell_output("#{bin}/ghosttykitd --version")
  end
end
