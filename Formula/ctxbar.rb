class Ctxbar < Formula
  desc "Claude Code status line for context, git, and usage limits"
  homepage "https://github.com/AlexBramall/ctxbar"
  url "https://github.com/AlexBramall/ctxbar/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "29b4fe35dd7ed4b897dbee298fc5e4fa4868a7c71c88f8640df60e1ce5653065"
  license "MIT"

  depends_on "jq"

  def install
    bin.install "statusline.sh"
  end

  def caveats
    <<~EOS
      ctxbar does not edit ${CLAUDE_CONFIG_DIR:-$HOME/.claude}/settings.json.
      Add this key to ${CLAUDE_CONFIG_DIR:-$HOME/.claude}/settings.json, then start a new Claude Code session:

          "statusLine": {
            "type": "command",
            "command": "#{opt_bin}/statusline.sh"
          }
    EOS
  end

  test do
    payload = {
      "model"          => { "display_name" => "Opus" },
      "workspace"      => { "current_dir" => "/tmp" },
      "context_window" => {
        "used_percentage"     => 12,
        "context_window_size" => 1_000_000,
        "current_usage"       => { "input_tokens" => 120_000 },
      },
    }.to_json
    assert_match "Opus", pipe_output(bin/"statusline.sh", payload)
  end
end
