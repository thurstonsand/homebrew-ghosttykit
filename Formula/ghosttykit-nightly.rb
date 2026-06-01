class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.0.0-dev-a670ba9"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.0.0-dev-a670ba9_darwin_arm64.zip"
      sha256 "9dd970f27ac0dc4f483493dd152dbb7dd31759f170a8ed9a514501dd772a1570"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.0.0-dev-a670ba9_darwin_amd64.zip"
      sha256 "444670fe1a9f18931ed761cb766e651f9dd0ff4a79a7ef08c471f03dc70e8a70"
    end
  end

  def install
    bin.install "bin/gty"
    bin.install "bin/ghosttykitd"
  end

  service do
    run [opt_bin/"ghosttykitd"]
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

      macOS should ask for permission to let ghosttykitd control Ghostty.
      After granting access, verify the install with:

        gty doctor
    EOS
  end

  test do
    assert_match "gty 0.0.0-dev-a670ba9 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.0.0-dev", shell_output("#{bin}/ghosttykitd --version")
  end
end
