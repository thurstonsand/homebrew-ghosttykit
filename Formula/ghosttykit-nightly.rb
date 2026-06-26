class GhosttykitNightly < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.2.1-dev-28217103689-678e0c4"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.2.1-dev-28217103689-678e0c4/ghosttykit_0.2.1-dev-28217103689-678e0c4_darwin_arm64.zip"
      sha256 "4f04785d70e3bb810ce8756e542d9559561c704631b45bcdaf2468dcc3015cba"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/nightly-0.2.1-dev-28217103689-678e0c4/ghosttykit_0.2.1-dev-28217103689-678e0c4_darwin_amd64.zip"
      sha256 "855aa40d0364fc4ba7f9a723d936b587a0a161ab4f7039dfc5e92947e4bae651"
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
    assert_match "gty 0.2.1-dev-28217103689-678e0c4 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.2.1-dev-28217103689-678e0c4", shell_output("#{bin}/ghosttykitd --version")
  end
end
