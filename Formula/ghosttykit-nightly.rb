class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.2.1-dev-28226635800-d666813"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.2.1-dev-28226635800-d666813/ghosttykit_0.2.1-dev-28226635800-d666813_darwin_arm64.zip"
      sha256 "0504a6b761e0eeb99832d2ea4b1e6252d4f28a19bdb904b1af06e36a433ef482"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.2.1-dev-28226635800-d666813/ghosttykit_0.2.1-dev-28226635800-d666813_darwin_amd64.zip"
      sha256 "1421a1e7be34f52eb83ebda6bf38c2d2537c8457e15a705454684d3cf01b891d"
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
    assert_match "gty 0.2.1-dev-28226635800-d666813 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.2.1-dev-28226635800-d666813", shell_output("#{bin}/ghosttykitd --version")
  end
end
