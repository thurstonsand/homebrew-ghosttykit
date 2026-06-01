class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.1.0-dev-26738616940-abca2b4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.1.0-dev-26738616940-abca2b4_darwin_arm64.zip"
      sha256 "4ce10d30e23fed6c82d12572835d76d898e8a07d7c8354c2f69be90b6f52e7df"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.1.0-dev-26738616940-abca2b4_darwin_amd64.zip"
      sha256 "817642b7e003ae04102b542e6a0212b6308f15094443ab06cc982ef4b9fa2e1c"
    end
  end

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
    assert_match "gty 0.1.0-dev-26738616940-abca2b4 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.0.0-dev", shell_output("#{bin}/ghosttykitd --version")
  end
end
