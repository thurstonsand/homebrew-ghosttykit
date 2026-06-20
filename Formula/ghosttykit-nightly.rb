class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.2.1-dev-27861891072-361c135"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.2.1-dev-27861891072-361c135_darwin_arm64.zip"
      sha256 "34d48eaa7996f8727bf34a7330841a3d9ac19b965ba1f79b1a38af5d032eecc1"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.2.1-dev-27861891072-361c135_darwin_amd64.zip"
      sha256 "dff228dc668bea978e6e6ec274539a4f0ab55decb1f3d3490a670028aaa3a584"
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
    assert_match "gty 0.2.1-dev-27861891072-361c135 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.2.1-dev-27861891072-361c135", shell_output("#{bin}/ghosttykitd --version")
  end
end
