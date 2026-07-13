class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.3.0-dev-29227648272-6f336eb"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.3.0-dev-29227648272-6f336eb/ghosttykit_0.3.0-dev-29227648272-6f336eb_darwin_arm64.zip"
      sha256 "4f7de48c7475e9f2555f4ff5cb9bb7a92c973213d08489517587abd3284bfb06"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.3.0-dev-29227648272-6f336eb/ghosttykit_0.3.0-dev-29227648272-6f336eb_darwin_amd64.zip"
      sha256 "4533671fb27fab15ac9e4d2f3b8f00645797b99f23934e227746d8278edee94f"
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
    assert_match "gty 0.3.0-dev-29227648272-6f336eb protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.3.0-dev-29227648272-6f336eb", shell_output("#{bin}/ghosttykitd --version")
  end
end
