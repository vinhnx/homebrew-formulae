class Vintage < Formula
  desc "A small command-line tool to check outdated Swift Package Manager dependencies."
  homepage "https://github.com/vinhnx/vintage"
  url "https://github.com/vinhnx/vintage.git",
      :tag => "0.2.0", :revision => "ed7bd940c781ec0277b55bb3f12e6971c1baa703"
  head "https://github.com/vinhnx/vintage.git"
  depends_on :xcode => ["10.2", :build]

  def install
    if MacOS::Xcode.version >= "9.0"
      system "swift", "package", "--disable-sandbox", "update"
      system "swift", "build", "-c", "release", "--disable-sandbox"
    else
      ENV.delete("CC") # https://bugs.swift.org/browse/SR-3151
      system "swift", "package", "update"
      system "swift", "build", "-c", "release", "-Xswiftc", "-static-stdlib"
    end

    system "make", "install_bin", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/vintage" "import Foundation\n"
  end
end
