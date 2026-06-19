class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.1.0-dev-27803157053-e22c309"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.1.0-dev-27803157053-e22c309_darwin_arm64.zip"
      sha256 "0e2ad5d04fc376aea671b78b99ce56329344906087df4e2699637d389312a691"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.1.0-dev-27803157053-e22c309_darwin_amd64.zip"
      sha256 "245512ed9cc24c588a90b2aeccbafa022d80601552c18c4b31329e66f6e7b88c"
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
    assert_match "gty 0.1.0-dev-27803157053-e22c309 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.1.0-dev-27803157053-e22c309", shell_output("#{bin}/ghosttykitd --version")
  end
end
