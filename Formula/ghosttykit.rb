class Ghosttykit < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.4.0/ghosttykit_0.4.0_darwin_arm64.zip"
      sha256 "16e46a8f4c451c633686fe9acde9849a353396c7608e1746cf6fe7b597f925bc"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.4.0/ghosttykit_0.4.0_darwin_amd64.zip"
      sha256 "87d0801354b4925372313566e5c4a19d00f3f16240f26abeda76e1e0bc6cb09e"
    end
  end

  conflicts_with "ghosttykit-nightly", because: "both install gty and ghosttykitd"

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


      Start Ghostty, then start the GhosttyKit daemon:

        brew services start #{full_name}

      On first start, macOS should ask for permission to let GhosttyKitD control Ghostty.
      Grant access, then verify the install with:

        gty doctor
    EOS
  end

  test do
    assert_match "gty 0.4.0 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.4.0", shell_output("#{bin}/ghosttykitd --version")
  end
end
