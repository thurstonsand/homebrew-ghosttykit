class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.0.0-dev-3801e6a"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.0.0-dev-3801e6a_darwin_arm64.zip"
      sha256 "d2a0928d83bd10138f61e413b88fa412ae3a12217132be4c87ad25ca4764906d"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.0.0-dev-3801e6a_darwin_amd64.zip"
      sha256 "3f461b755e8639e242aca8346b6e0719f330255612636d333145d03ae6cdb0b5"
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

      macOS should ask for permission to let ghosttykitd control Ghostty.
      After granting access, verify the install with:

        gty doctor
    EOS
  end

  test do
    assert_match "gty 0.0.0-dev-3801e6a protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.0.0-dev", shell_output("#{bin}/ghosttykitd --version")
  end
end
