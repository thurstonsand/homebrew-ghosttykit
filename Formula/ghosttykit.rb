class Ghosttykit < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.3.0/ghosttykit_0.3.0_darwin_arm64.zip"
      sha256 "827282ec99bc5bc25234588f8f974bfb97f3d6532a3b03479dd46a0ff3998bdb"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.3.0/ghosttykit_0.3.0_darwin_amd64.zip"
      sha256 "de6d5eed9f67873133caee8f67b34abfbd3c8d5b09ac47509e4b678f5c9ab000"
    end
  end

  conflicts_with "ghosttykit-nightly", because: "both install gty and ghosttykitd"

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


      Start Ghostty, then start the GhosttyKit daemon:

        brew services start #{full_name}

      On first start, macOS should ask for permission to let GhosttyKitD control Ghostty.
      Grant access, then verify the install with:

        gty doctor
    EOS
  end

  test do
    assert_match "gty 0.3.0 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.3.0", shell_output("#{bin}/ghosttykitd --version")
  end
end
