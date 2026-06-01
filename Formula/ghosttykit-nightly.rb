class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.0.0-dev-dba2542"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.0.0-dev-dba2542_darwin_arm64.zip"
      sha256 "9dda61815ea2538fc3714f55002c0d8b5de357c1b10414b6d70dee777880ec26"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.0.0-dev-dba2542_darwin_amd64.zip"
      sha256 "dd9accac9cb1c6492dc77dcb014bdea72230d163332f0382fc5a261ae17574da"
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
    assert_match "gty 0.0.0-dev-dba2542 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.0.0-dev", shell_output("#{bin}/ghosttykitd --version")
  end
end
