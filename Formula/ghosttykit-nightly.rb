class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.2.1-dev-28222757690-96f1303"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.2.1-dev-28222757690-96f1303/ghosttykit_0.2.1-dev-28222757690-96f1303_darwin_arm64.zip"
      sha256 "d5720a38c8d92221e46e2ce740a7506b3ce02e8005c5f4058e31c289f6c144d0"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.2.1-dev-28222757690-96f1303/ghosttykit_0.2.1-dev-28222757690-96f1303_darwin_amd64.zip"
      sha256 "401b86df7247a375197f711106c6ab445a2e72e25ce2c9e181290d9860feedcb"
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
    assert_match "gty 0.2.1-dev-28222757690-96f1303 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.2.1-dev-28222757690-96f1303", shell_output("#{bin}/ghosttykitd --version")
  end
end
