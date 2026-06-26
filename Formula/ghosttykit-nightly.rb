class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.2.1-dev-28224930403-b1cbef0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.2.1-dev-28224930403-b1cbef0/ghosttykit_0.2.1-dev-28224930403-b1cbef0_darwin_arm64.zip"
      sha256 "3d8fc7c29f347ad506479ee339e8dfb4a6022728d24acafc78f1799b25d39166"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.2.1-dev-28224930403-b1cbef0/ghosttykit_0.2.1-dev-28224930403-b1cbef0_darwin_amd64.zip"
      sha256 "7f6af2e13573f551c2ed154f18168a053111876b3cb940055f3351a3efeefe4b"
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
    assert_match "gty 0.2.1-dev-28224930403-b1cbef0 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.2.1-dev-28224930403-b1cbef0", shell_output("#{bin}/ghosttykitd --version")
  end
end
