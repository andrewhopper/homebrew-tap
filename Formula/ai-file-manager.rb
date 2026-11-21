# Homebrew formula for ai-file-manager (command: afm). Rendered by
# release/render-formula.sh; lives in andrewhopper/homebrew-tap as
# Formula/ai-file-manager.rb.
class AiFileManager < Formula
  desc "Organize files with JSON rules, sidecar photo indexes and local AI search"
  homepage "https://blog.andrewhopper.com/projects/ai-file-manager"
  url "https://github.com/andrewhopper/homebrew-tap/raw/main/packages/ai-file-manager-0.2.0.tgz"
  sha256 "677ce4ac7767fb598f953a5bc14cae5e527f646989f002b4bff53ba414645986"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    pkgshare.install libexec/"lib/node_modules/ai-file-manager/taxonomy.example.json"
  end

  def caveats
    <<~EOS
      Start from the example rules:
        mkdir -p ~/.config/afm
        cp #{opt_pkgshare}/taxonomy.example.json ~/.config/afm/taxonomy.json
        afm --dry-run -v
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/afm --version")
    assert_match version.to_s, shell_output("#{bin}/ai-file-manager --version")
    (testpath/".config/afm").mkpath
    cp pkgshare/"taxonomy.example.json", testpath/".config/afm/taxonomy.json"
    (testpath/"Desktop").mkpath
    touch testpath/"Desktop/invoice_0423.pdf"
    system bin/"afm", "--apply", "--collect", "--classify"
    assert_path_exists testpath/"Desktop/personal.finance.receipts/invoice_0423.pdf"
  end
end
