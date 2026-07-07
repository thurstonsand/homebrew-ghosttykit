class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.3.0-dev-28844854757-e568636"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.3.0-dev-28844854757-e568636/ghosttykit_0.3.0-dev-28844854757-e568636_darwin_arm64.zip"
      sha256 "6472ef085a3f1cc3dff8a0ddef5d868d41fa17eea5db63c893391398331a23bc"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.3.0-dev-28844854757-e568636/ghosttykit_0.3.0-dev-28844854757-e568636_darwin_amd64.zip"
      sha256 "a0e20fb50fa777ca4ef40ceaa292c03960d017ae5de6239318ed971e76445fbb"
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
    assert_match "gty 0.3.0-dev-28844854757-e568636 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.3.0-dev-28844854757-e568636", shell_output("#{bin}/ghosttykitd --version")
  end
end
