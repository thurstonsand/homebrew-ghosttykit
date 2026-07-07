class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.3.0-dev-28843355978-5627354"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.3.0-dev-28843355978-5627354/ghosttykit_0.3.0-dev-28843355978-5627354_darwin_arm64.zip"
      sha256 "574b53e8172bc64cf508ba2e612f588dabb7e507289e1158f6cb94a0a3e83ea8"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.3.0-dev-28843355978-5627354/ghosttykit_0.3.0-dev-28843355978-5627354_darwin_amd64.zip"
      sha256 "df1b33491444162a60cd5438d853bf6cfceeb227540cb7d9875816b0b7c08e32"
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
    assert_match "gty 0.3.0-dev-28843355978-5627354 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.3.0-dev-28843355978-5627354", shell_output("#{bin}/ghosttykitd --version")
  end
end
