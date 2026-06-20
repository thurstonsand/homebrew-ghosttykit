class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.2.0-dev-27861330914-b9eced4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.2.0-dev-27861330914-b9eced4_darwin_arm64.zip"
      sha256 "268b11e2f6bb3d6d1605a202a6aaad5dc8d13f53313844d58dda1ae81437b2d6"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.2.0-dev-27861330914-b9eced4_darwin_amd64.zip"
      sha256 "5da57459dd35d14cf51150495de5f7a86cf9bce750cb6b8c1894a2468cb370f2"
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
    assert_match "gty 0.2.0-dev-27861330914-b9eced4 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.2.0-dev-27861330914-b9eced4", shell_output("#{bin}/ghosttykitd --version")
  end
end
