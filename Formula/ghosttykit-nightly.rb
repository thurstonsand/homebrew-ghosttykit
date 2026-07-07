class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.3.0-dev-28848092204-440e40f"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.3.0-dev-28848092204-440e40f/ghosttykit_0.3.0-dev-28848092204-440e40f_darwin_arm64.zip"
      sha256 "4f068655fe040370eda2b614290e143e9a1b5cda51176e4e0844b8a730913481"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.3.0-dev-28848092204-440e40f/ghosttykit_0.3.0-dev-28848092204-440e40f_darwin_amd64.zip"
      sha256 "c1a67b2e82075f3688d4cdd60adcb52a56b6644188efc80b09b9fa7d6b7bce14"
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
    assert_match "gty 0.3.0-dev-28848092204-440e40f protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.3.0-dev-28848092204-440e40f", shell_output("#{bin}/ghosttykitd --version")
  end
end
