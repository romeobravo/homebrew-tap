class PeonPoke < Formula
  desc "Trackpad haptic notifications on Mac for when your AI coding agent needs you"
  homepage "https://github.com/romeobravo/peon-poke"
  url "https://github.com/romeobravo/peon-poke/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "1c9911039f9086cfd371c4bcc0062c5d1603c75aaac2875dae2f0e7af3886a83"
  license "MIT"

  depends_on :macos

  def install
    system "make", "CC=#{ENV.cc}"
    libexec.install "peon-poke", "config.json"
    libexec.install "adapters", "plugins", "bin"
    chmod 0755, libexec/"peon-poke"
    bin.install_symlink libexec/"bin/poke" => "poke"
    bin.install_symlink libexec/"peon-poke" => "peon-poke"
  end

  def caveats
    <<~EOS
      Run `peon-poke setup` to register hooks for detected agents
      (Claude Code, Codex, pi, oh-my-pi). Runtime installs to ~/.peon-poke
      so hook registrations survive upgrades.
    EOS
  end

  test do
    assert_match "names:", shell_output("#{bin}/poke definitely-not-a-pattern 2>&1")
  end
end
