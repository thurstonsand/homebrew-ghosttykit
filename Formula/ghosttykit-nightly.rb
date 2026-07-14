class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.4.0-dev-29303388878-6d4cd8e"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-29303388878-6d4cd8e/ghosttykit_0.4.0-dev-29303388878-6d4cd8e_darwin_arm64.zip"
      sha256 "01dc266c1d3d27c38a95cbd3ef30e2ec8de6d1ad693dc419dbb9cb0df04e82f0"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-29303388878-6d4cd8e/ghosttykit_0.4.0-dev-29303388878-6d4cd8e_darwin_amd64.zip"
      sha256 "0e405140b55e462f67758a5c370c7e583d86f437b7ff33d5bf278603ecb9f7a1"
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
    assert_match "gty 0.4.0-dev-29303388878-6d4cd8e protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.4.0-dev-29303388878-6d4cd8e", shell_output("#{bin}/ghosttykitd --version")
  end
end
