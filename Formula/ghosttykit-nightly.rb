class GhosttykitNightly < Formula
  BASE_VERSION = "0.0.0".freeze
  COMMIT = "f4d167d".freeze

  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "#{BASE_VERSION}-dev-#{COMMIT}"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_#{COMMIT}_darwin_arm64.zip"
      sha256 "38e5f72e4082908b9b53e7081242b8fe20e898f66386d622e564921792ac8a7c"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_#{COMMIT}_darwin_amd64.zip"
      sha256 "94829e7b8e9219ba97bcd7b51ebfe01368f997a64a0de98760695c9b3d7ab48a"
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
    assert_match "gty #{COMMIT} protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.0.0-dev", shell_output("#{bin}/ghosttykitd --version")
  end
end
