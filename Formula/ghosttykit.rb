class Ghosttykit < Formula
  desc "Ghostty terminal companion toolkit"
  homepage "https://github.com/thurstonsand/ghosttykit"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.1.0/ghosttykit_v0.1.0_darwin_arm64.zip"
      sha256 "ffe986562fc544fb656a7af65439848420bbeda5dd2ada02a94a41fe16a46315"
    else
      url "https://github.com/thurstonsand/ghosttykit/releases/download/v0.1.0/ghosttykit_v0.1.0_darwin_amd64.zip"
      sha256 "8e00712fb6a58dd7000b770c4e754b30d9f0727ea36d3732238914e5f9809747"
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
      Start Ghostty, then start the GhosttyKit daemon:

        brew services start #{full_name}

      On first start, macOS should ask for permission to let GhosttyKitD control Ghostty.
      Grant access, then verify the install with:

        gty doctor
    EOS
  end

  test do
    assert_match "gty v0.1.0 protocol=", shell_output("#{bin}/gty version")
    assert_match "ghosttykitd 0.0.0-dev", shell_output("#{bin}/ghosttykitd --version")
  end
end
