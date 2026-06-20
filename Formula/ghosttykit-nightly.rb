class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.1.0-dev-27860438494-a210097"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.1.0-dev-27860438494-a210097_darwin_arm64.zip"
      sha256 "7ce91b66c8752eb7db790ef6e451d1b823176ce923d290580eaa7f7127f3b60b"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly/ghosttykit_0.1.0-dev-27860438494-a210097_darwin_amd64.zip"
      sha256 "19ccb09126e79b4e27177f1cbcfc457432dc852d4ce100826ca43c46a2b71103"
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
    assert_match "gty 0.1.0-dev-27860438494-a210097 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.1.0-dev-27860438494-a210097", shell_output("#{bin}/ghosttykitd --version")
  end
end
