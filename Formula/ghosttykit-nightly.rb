class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.4.0-dev-29303021562-4fc9b56"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-29303021562-4fc9b56/ghosttykit_0.4.0-dev-29303021562-4fc9b56_darwin_arm64.zip"
      sha256 "1395e2637c8f4a04c12fc93518a4ad9a40a70ce5ab638872dd7e587f76102ba2"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.4.0-dev-29303021562-4fc9b56/ghosttykit_0.4.0-dev-29303021562-4fc9b56_darwin_amd64.zip"
      sha256 "db8ceeeb200621c86a3048fb8726a7ac989e130269ba958d7f2c4c1aeb60764a"
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
    assert_match "gty 0.4.0-dev-29303021562-4fc9b56 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.4.0-dev-29303021562-4fc9b56", shell_output("#{bin}/ghosttykitd --version")
  end
end
